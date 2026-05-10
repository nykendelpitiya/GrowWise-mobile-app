from pathlib import Path
from datetime import date
from dotenv import load_dotenv

from fastapi import FastAPI, HTTPException, Query, UploadFile, File, Form
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from services.crop_recommendation_service import predict_crop
from services.weather_service import get_weather
from services.fertilizer_water_service import predict_fertilizer_water
from services.schedule_service import create_schedule_notifications
from services.diseases_detection import predict_disease


from routes.today_tip import router as today_tip_router
from routes.notification import router as notification_router
from routes.translate_route import router as translate_router

from scheduler import start_scheduler


BASE_DIR = Path(__file__).resolve().parent
ENV_PATH = BASE_DIR / ".env"
load_dotenv(dotenv_path=ENV_PATH)

app = FastAPI()


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
def start_daily_scheduler():
    start_scheduler()


app.include_router(today_tip_router)
app.include_router(notification_router)
app.include_router(translate_router)


# ================================
# MODELS
# ================================

class CropRequest(BaseModel):
    crop: str
    district: str


class CareRequest(BaseModel):
    user_id: str
    crop: str
    district: str
    planting_date: date
    quantity: int
    schedule_id: str | None = None


# ================================
# ROUTES
# ================================

@app.get("/")
def home():
    return {"message": "GrowWise backend running 🚀"}


@app.post("/predict")
def predict(data: CropRequest):
    try:
        return predict_crop(data.crop, data.district)
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/predict-care")
def predict_care(data: CareRequest):
    try:
        result = predict_fertilizer_water(
            crop=data.crop,
            district=data.district,
            planting_date=data.planting_date,
            quantity=data.quantity,
        )

        try:
            notification_result = create_schedule_notifications(
                user_id=data.user_id,
                crop=result["crop"],
                district=result["district"],
                planting_date=data.planting_date,
                quantity=data.quantity,
                water_total_per_day=result["water_total_per_day"],
                fertilizer_total_per_week=result["fertilizer_total_per_week"],
                splits_per_year=result["schedule"]["splits_per_year"],
                schedule_id=data.schedule_id,
            )

            result["notification_schedule"] = notification_result

        except Exception as e:
            print("⚠️ Notification schedule creation failed:", e)

            result["notification_schedule"] = {
                "success": False,
                "message": "Care recommendation generated, but notification schedule could not be saved.",
                "error": str(e),
            }

        return result

    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/predict-disease")
def predict_disease_route(
    plant: str = Form(...),
    file: UploadFile = File(...),
):
    try:
        allowed_extensions = [".jpg", ".jpeg", ".png", ".webp"]
        filename = file.filename.lower() if file.filename else ""

        if not any(filename.endswith(ext) for ext in allowed_extensions):
            raise HTTPException(
                status_code=400,
                detail="Please upload a valid image file",
            )

        return predict_disease(plant, file.file)

    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/weather")
def weather_by_district(district: str = Query(...)):
    try:
        return get_weather(district)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/weather/{city}")
def weather(city: str):
    try:
        return get_weather(city)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
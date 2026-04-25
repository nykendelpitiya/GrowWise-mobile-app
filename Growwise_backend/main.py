from pathlib import Path
from datetime import date
from dotenv import load_dotenv

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from services.crop_recommendation_service import predict_crop
from services.weather_service import get_weather
from services.fertilizer_water_service import predict_fertilizer_water

# ✅ ROUTES
from routes.today_tip import router as today_tip_router
from routes.notification import router as notification_router

# ✅ SCHEDULER
from scheduler import start_scheduler

# .env load
BASE_DIR = Path(__file__).resolve().parent
ENV_PATH = BASE_DIR / ".env"
load_dotenv(dotenv_path=ENV_PATH)

app = FastAPI()

# ✅ CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ✅ START SCHEDULER
@app.on_event("startup")
def start_daily_scheduler():
    start_scheduler()

# ✅ REGISTER ROUTES
app.include_router(today_tip_router)
app.include_router(notification_router)


# ================================
# MODELS
# ================================

class CropRequest(BaseModel):
    crop: str
    district: str


class CareRequest(BaseModel):
    crop: str
    district: str
    planting_date: date
    quantity: int


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
        return predict_fertilizer_water(
            crop=data.crop,
            district=data.district,
            planting_date=data.planting_date,
            quantity=data.quantity,
        )
    except ValueError as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/weather/{city}")
def weather(city: str):
    try:
        return get_weather(city)
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
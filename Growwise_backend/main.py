from pathlib import Path
from dotenv import load_dotenv

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from services.crop_recommendation_service import predict_crop
from services.weather_service import get_weather

# .env file eka explicitly load karanawa
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


class CropRequest(BaseModel):
    crop: str
    district: str


@app.get("/")
def home():
    return {"message": "GrowWise backend running"}


@app.post("/predict")
def predict(data: CropRequest):
    try:
        return predict_crop(data.crop, data.district)
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
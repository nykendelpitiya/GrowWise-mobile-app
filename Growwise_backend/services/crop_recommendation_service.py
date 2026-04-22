from pathlib import Path
import pandas as pd
import joblib
from tensorflow.keras.models import load_model
from services.weather_service import get_weather

BASE_DIR = Path(__file__).resolve().parent.parent
MODELS_DIR = BASE_DIR / "models" / "crop"
DATA_DIR = BASE_DIR / "data"

# model and preprocessors load
model = load_model(MODELS_DIR / "ann_model.h5")
scaler = joblib.load(MODELS_DIR / "ann_scaler.pkl")
crop_encoder = joblib.load(MODELS_DIR / "crop_encoder.pkl")
district_encoder = joblib.load(MODELS_DIR / "district_encoder.pkl")
soil_encoder = joblib.load(MODELS_DIR / "soil_encoder.pkl")
zone_encoder = joblib.load(MODELS_DIR / "zone_encoder.pkl")

# original dataset load
df_original = pd.read_csv(DATA_DIR / "crop_recommendation_dataset.csv")
df_original.columns = df_original.columns.str.strip()


def normalize_text(value: str) -> str:
    return value.strip().lower().replace("-", " ").replace("_", " ")


def predict_crop(crop: str, district: str):
    crop_input = crop.strip()
    district_input = district.strip()

    filtered = df_original[
        (df_original["Crop"].apply(normalize_text) == normalize_text(crop_input)) &
        (df_original["District"].apply(normalize_text) == normalize_text(district_input))
    ]

    if filtered.empty:
        raise ValueError("Data not available for this crop and district combination")

    # temperature weather API eken gannawa
    weather_data = get_weather(district_input)
    api_temperature = weather_data["temperature"]

    # anith values dataset eken gannawa
    soil = filtered["Soil_type"].mode()[0]
    humidity = float(filtered["Humidity"].mean())
    ph = float(filtered["ph"].mean())
    rainfall = float(filtered["Rainfall"].mean())
    zone = filtered["Zone"].mode()[0]

    # encoder walata original dataset value eka yawanawa
    crop_for_encoder = filtered["Crop"].mode()[0]
    district_for_encoder = filtered["District"].mode()[0]

    input_df = pd.DataFrame([{
        "Soil_type": soil_encoder.transform([soil])[0],
        "Temperature": api_temperature,
        "Humidity": humidity,
        "ph": ph,
        "Rainfall": rainfall,
        "District": district_encoder.transform([district_for_encoder])[0],
        "Zone": zone_encoder.transform([zone])[0],
        "Crop": crop_encoder.transform([crop_for_encoder])[0],
    }])

    input_scaled = scaler.transform(input_df)
    prob = float(model.predict(input_scaled, verbose=0)[0][0] * 100)

    if prob >= 75:
        level = "HIGH"
    elif prob >= 50:
        level = "MEDIUM"
    else:
        level = "LOW"

    suitable = prob >= 50

    if suitable:
        status = "Suitable"
        message = "This crop is suitable for your selected district."
    else:
        status = "Not Suitable"
        message = "This crop is not suitable for your selected district."

    return {
        "crop": crop_for_encoder,
        "district": district_for_encoder,
        "temperature": round(api_temperature, 2),
        "humidity": round(humidity, 2),
        "ph": round(ph, 2),
        "rainfall": round(rainfall, 2),
        "soil_type": soil,
        "zone": zone,
        "percentage": round(prob, 2),
        "level": level,
        "suitable": suitable,
        "status": status,
        "message": message,
    }
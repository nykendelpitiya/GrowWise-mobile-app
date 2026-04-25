from pathlib import Path
import pandas as pd
import joblib
import numpy as np
from tensorflow.keras.models import load_model
from services.weather_service import get_weather

BASE_DIR = Path(__file__).resolve().parent.parent
MODELS_DIR = BASE_DIR / "models" / "care"
DATA_DIR = BASE_DIR / "data"

# Load model and preprocessors
model = load_model(MODELS_DIR / "fertilizer_water_ann_model.h5", compile=False)
scaler_X = joblib.load(MODELS_DIR / "scaler_X.pkl")
scaler_y = joblib.load(MODELS_DIR / "scaler_y.pkl")

district_encoder = joblib.load(MODELS_DIR / "district_encoder.pkl")
zone_encoder = joblib.load(MODELS_DIR / "zone_encoder.pkl")
crop_encoder = joblib.load(MODELS_DIR / "crop_encoder.pkl")
soil_encoder = joblib.load(MODELS_DIR / "soil_encoder.pkl")

# Original dataset load
df_original = pd.read_csv(DATA_DIR / "fertilizer_water_dataset.csv")
df_original.columns = df_original.columns.str.strip()


def normalize_text(value: str) -> str:
    return value.strip().lower().replace("-", " ").replace("_", " ")


def predict_fertilizer_water(crop: str, district: str, planting_date, quantity: int):
    crop_input = crop.strip()
    district_input = district.strip()

    filtered = df_original[
        (df_original["Crop"].apply(normalize_text) == normalize_text(crop_input))
        & (df_original["District"].apply(normalize_text) == normalize_text(district_input))
    ]

    if filtered.empty:
        raise ValueError("Data not available for this crop and district combination")

    # Weather API eken temperature gannawa
    weather_data = get_weather(district_input)
    api_temperature = float(weather_data["temperature"])

    # Dataset eken anith values gannawa
    ph = float(filtered["ph"].mean())
    rainfall = float(filtered["Rainfall"].mean())
    humidity = float(filtered["Humidity"].mean())
    zone = filtered["Zone"].mode()[0]
    crop_value = filtered["Crop"].mode()[0]
    district_value = filtered["District"].mode()[0]
    soil = filtered["Soil_type"].mode()[0]

    # Exact training feature order
    X = np.array([[
        ph,
        rainfall,
        api_temperature,
        humidity,
        district_encoder.transform([district_value])[0],
        zone_encoder.transform([zone])[0],
        crop_encoder.transform([crop_value])[0],
        soil_encoder.transform([soil])[0],
    ]])

    # Scale input
    X_scaled = scaler_X.transform(X)

    # Predict
    prediction_scaled = model.predict(X_scaled, verbose=0)

    # Inverse transform output
    prediction = scaler_y.inverse_transform(prediction_scaled)[0]

    N_week, P2O5_week, K2O_week, water_day, split_year = prediction

    # Safety
    N_week = max(0.0, float(N_week))
    P2O5_week = max(0.0, float(P2O5_week))
    K2O_week = max(0.0, float(K2O_week))
    water_day = max(0.0, float(water_day))
    split_year = max(1, int(round(float(split_year))))

    # Quantity-based totals
    total_N_week = N_week * quantity
    total_P2O5_week = P2O5_week * quantity
    total_K2O_week = K2O_week * quantity
    total_water_day = water_day * quantity

    # Simple schedule message
    schedule_lines = [
        "Start fertilizer application after planting and continue weekly monitoring.",
        f"Split fertilizer applications across the year about {split_year} times.",
        "Adjust water daily based on rainfall and field moisture.",
    ]

    return {
        "crop": crop_value,
        "district": district_value,
        "planting_date": str(planting_date),
        "quantity": quantity,
        "temperature": round(api_temperature, 2),
        "humidity": round(humidity, 2),
        "ph": round(ph, 2),
        "rainfall": round(rainfall, 2),
        "soil_type": soil,
        "zone": zone,

        "fertilizer_per_plant_per_week": {
            "N": round(N_week, 3),
            "P2O5": round(P2O5_week, 3),
            "K2O": round(K2O_week, 3),
        },

        "fertilizer_total_per_week": {
            "N": round(total_N_week, 3),
            "P2O5": round(total_P2O5_week, 3),
            "K2O": round(total_K2O_week, 3),
        },

        "water_per_plant_per_day": round(water_day, 3),
        "water_total_per_day": round(total_water_day, 3),

        "schedule": {
            "splits_per_year": split_year,
            "lines": schedule_lines,
            "note": (
                f"Start fertilizer application after planting. "
                f"Apply fertilizer in about {split_year} splits per year "
                f"and adjust water daily based on rainfall and field moisture."
            ),
        },
    }
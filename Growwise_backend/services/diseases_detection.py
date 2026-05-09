from pathlib import Path
from typing import Dict, List

import numpy as np
from PIL import Image
from tensorflow.keras.models import load_model
from tensorflow.keras.applications.resnet50 import preprocess_input


BASE_DIR = Path(__file__).resolve().parent.parent
MODELS_DIR = BASE_DIR / "models" / "diseases"


# ================================
# PLANT VERIFICATION CONFIG
# ================================

VERIFICATION_MODEL_PATH = (
    MODELS_DIR / "PlantVerification" / "plant_verification_resnet50_best.h5"
)

VERIFICATION_IMAGE_SIZE = (380, 380)

VERIFICATION_CLASSES = [
    "ArecaNut",
    "Cinnamon",
    "Pepper",
    "Tea",
    "Unknown",
]


# ================================
# DISEASE MODEL CONFIG
# ================================

MODEL_CONFIG = {
    "tea": {
        "model_path": MODELS_DIR / "Tea" / "tea_resnet50_best.h5",
        "image_size": (380, 380),
        "classes": [
            "Brown Blight",
            "Gray Blight",
            "Healthy",
            "Red Spot",
        ],
    },
    "cinnamon": {
        "model_path": MODELS_DIR / "Cinnamon" / "cinnamon_resnet50_best.h5",
        "image_size": (380, 380),
        "classes": [
            "Dry Leaf",
            "Healthy",
            "Leaf Spot",
        ],
    },
    "pepper": {
        "model_path": MODELS_DIR / "Pepper" / "pepper_resnet50_best.h5",
        "image_size": (380, 380),
        "classes": [
            "Healthy",
            "Leaf Blight",
            "Yellow Mottle Virus",
        ],
    },
    "arecanut": {
        "model_path": MODELS_DIR / "ArecaNut" / "arecanut_resnet50_best.h5",
        "image_size": (380, 380),
        "classes": [
            "Healthy",
            "Leaf Spot",
            "Yellow Leaf",
        ],
    },
}


# ================================
# LOAD MODELS ONCE
# ================================

verification_model = None

if VERIFICATION_MODEL_PATH.exists():
    verification_model = load_model(VERIFICATION_MODEL_PATH)
else:
    print(f"⚠️ Verification model not found: {VERIFICATION_MODEL_PATH}")


LOADED_MODELS = {}

for plant_key, config in MODEL_CONFIG.items():
    model_path = config["model_path"]

    if model_path.exists():
        LOADED_MODELS[plant_key] = load_model(model_path)
    else:
        print(f"⚠️ Model not found for {plant_key}: {model_path}")


# ================================
# HELPERS
# ================================

def normalize_plant_name(plant: str) -> str:
    return (
        plant.strip()
        .lower()
        .replace(" ", "")
        .replace("_", "")
        .replace("-", "")
    )


def clean_class_name(name: str) -> str:
    return (
        name.replace("_", " ")
        .replace("-", " ")
        .strip()
        .title()
    )


def preprocess_for_resnet(image: Image.Image, image_size):
    image = image.convert("RGB").resize(image_size)
    image_array = np.array(image).astype(np.float32)
    image_array = np.expand_dims(image_array, axis=0)
    image_array = preprocess_input(image_array)
    return image_array


def predict_plant_verification(image: Image.Image) -> Dict:
    if verification_model is None:
        raise ValueError("Plant verification model is not loaded")

    image_array = preprocess_for_resnet(image, VERIFICATION_IMAGE_SIZE)

    prediction = verification_model.predict(image_array, verbose=0)[0]

    class_index = int(np.argmax(prediction))
    confidence = float(prediction[class_index] * 100)

    verified_plant = VERIFICATION_CLASSES[class_index]

    return {
        "verified_plant": verified_plant,
        "verified_plant_key": normalize_plant_name(verified_plant),
        "verification_confidence": round(confidence, 2),
        "verification_class_index": class_index,
    }


def predict_with_disease_model(plant_key: str, image: Image.Image) -> Dict:
    config = MODEL_CONFIG[plant_key]
    model = LOADED_MODELS.get(plant_key)

    if model is None:
        raise ValueError(f"{plant_key} model is not loaded")

    image_array = preprocess_for_resnet(image, config["image_size"])

    prediction = model.predict(image_array, verbose=0)[0]

    class_index = int(np.argmax(prediction))
    confidence = float(prediction[class_index] * 100)

    class_names: List[str] = config["classes"]
    disease_name = clean_class_name(class_names[class_index])

    return {
        "plant": plant_key,
        "disease": disease_name,
        "confidence": round(confidence, 2),
        "class_index": class_index,
    }


# ================================
# MAIN FUNCTION
# ================================

def predict_disease(plant: str, image_file):
    selected_plant_key = normalize_plant_name(plant)

    if selected_plant_key not in MODEL_CONFIG:
        raise ValueError(
            "Invalid plant. Please select Tea, Cinnamon, Pepper, or ArecaNut."
        )

    if selected_plant_key not in LOADED_MODELS:
        raise ValueError(f"Model not available for {plant}.")

    original_image = Image.open(image_file).convert("RGB")

    verification_result = predict_plant_verification(original_image)

    print("🔍 Verification Result:", verification_result)
    print("✅ Selected Plant:", selected_plant_key)

    verified_plant = verification_result["verified_plant"]
    verified_plant_key = verification_result["verified_plant_key"]
    verification_confidence = verification_result["verification_confidence"]

    if verified_plant_key == "unknown":
        return {
            "success": False,
            "plant": plant,
            "verified_plant": verified_plant,
            "verification_confidence": verification_confidence,
            "disease": "Invalid Image",
            "message": "Please upload a valid leaf image.",
        }

    if verification_confidence < 30:
        return {
            "success": False,
            "plant": plant,
            "verified_plant": verified_plant,
            "verification_confidence": verification_confidence,
            "disease": "Not Detected",
            "message": "Please upload a clear plant leaf image.",
        }

    if verified_plant_key != selected_plant_key:
        return {
            "success": False,
            "plant": plant,
            "verified_plant": verified_plant,
            "verification_confidence": verification_confidence,
            "disease": "Wrong Plant",
            "message": f"Please upload a {plant} leaf image.",
        }

    result = predict_with_disease_model(selected_plant_key, original_image)

    print("🦠 Disease Result:", result)

    confidence = result["confidence"]

    if confidence < 40:
        return {
            "success": False,
            "plant": plant,
            "verified_plant": verified_plant,
            "verification_confidence": verification_confidence,
            "disease": "Not Detected",
            "confidence": confidence,
            "message": "Disease could not be detected clearly. Please upload a clearer leaf image.",
        }

    return {
        "success": True,
        "plant": plant,
        "verified_plant": verified_plant,
        "verification_confidence": verification_confidence,
        "disease": result["disease"],
        "confidence": confidence,
        "message": result["disease"],
    }
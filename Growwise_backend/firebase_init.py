from firebase_admin import credentials, initialize_app, firestore
from pathlib import Path

# Base directory
BASE_DIR = Path(__file__).resolve().parent

# ✅ YOUR EXACT FILE NAME
KEY_PATH = BASE_DIR / "growwise-app-9478f-firebase-adminsdk-fbsvc-56e9cbb501.json"

# Initialize Firebase
cred = credentials.Certificate(str(KEY_PATH))
initialize_app(cred)

# Firestore DB
db = firestore.client()
import os
import random
import requests
from datetime import datetime, timezone
from fastapi import APIRouter, HTTPException, Query
from dotenv import load_dotenv
from firebase_init import db

load_dotenv()

router = APIRouter()

OPENWEATHER_API_KEY = os.getenv("OPENWEATHER_API_KEY")


def pick_tip(tips):
    return random.choice(tips)



def check_today_schedule(user_id: str):
    today_start = datetime.now(timezone.utc).replace(
        hour=0, minute=0, second=0, microsecond=0
    )
    today_end = today_start.replace(hour=23, minute=59, second=59)

    notifications = (
        db.collection("notifications")
        .where("userId", "==", user_id)
        .stream()
    )

    has_water = False
    has_fertilizer = False

    for doc in notifications:
        data = doc.to_dict()

        scheduled_at = data.get("scheduledAt")
        if not scheduled_at:
            continue

        
        if not (today_start <= scheduled_at <= today_end):
            continue

        notification_type = str(data.get("type", "")).lower()

        if notification_type == "water":
            has_water = True

        if notification_type == "fertilizer":
            has_fertilizer = True

    return has_water, has_fertilizer


@router.get("/today-tip/{city}")
def get_today_tip(city: str, user_id: str = Query(...)):
    try:
        if not OPENWEATHER_API_KEY:
            raise HTTPException(
                status_code=500,
                detail="OPENWEATHER_API_KEY not found",
            )

        
        url = "https://api.openweathermap.org/data/2.5/weather"

        response = requests.get(
            url,
            params={
                "q": f"{city},LK",
                "appid": OPENWEATHER_API_KEY,
                "units": "metric",
            },
            timeout=10,
        )

        res = response.json()

        if response.status_code != 200:
            raise HTTPException(
                status_code=response.status_code,
                detail=res.get("message", "Weather API error"),
            )

        temp = float(res["main"]["temp"])
        humidity = int(res["main"]["humidity"])

        condition = res["weather"][0]["main"]
        description = res["weather"][0].get("description", "")

        condition_lower = condition.lower()
        description_lower = description.lower()

        rain_data = res.get("rain", {})
        rain_1h = float(rain_data.get("1h", 0))
        rain_3h = float(rain_data.get("3h", 0))

        is_rain = (
            "rain" in condition_lower
            or "rain" in description_lower
            or "drizzle" in condition_lower
            or "drizzle" in description_lower
            or rain_1h > 0
            or rain_3h > 0
        )

        
        has_water, has_fertilizer = check_today_schedule(user_id)

       

        if is_rain:
            title = "Weather Alert"

            if has_water:
                message = "Rain expected. Check soil before watering."
            else:
                message = pick_tip([
                    "Rain expected. Avoid extra watering.",
                    "Keep plants safe from waterlogging.",
                ])

            alert = "rain"

        elif has_fertilizer:
            title = "Today Tip"

            if humidity >= 85:
                message = "Soil is wet. Delay fertilizer if needed."
            elif temp >= 32:
                message = "Apply fertilizer early morning or evening."
            else:
                message = "Good day to apply fertilizer."

            alert = "normal"

        elif has_water:
            title = "Today Tip"

            if humidity >= 85:
                message = "High humidity. Avoid overwatering today."
            elif temp >= 32:
                message = "Water plants early morning or evening."
            else:
                message = "Check soil moisture before watering."

            alert = "normal"

        elif humidity >= 85:
            title = "Today Tip"
            message = pick_tip([
                "High humidity. Watch for fungal diseases.",
                "Keep air flow around plants today.",
            ])
            alert = "normal"

        elif temp >= 32:
            title = "Today Tip"
            message = pick_tip([
                "Hot weather. Check water levels frequently.",
                "Avoid plant stress during peak heat.",
            ])
            alert = "normal"

        else:
            title = "Today Tip"
            message = pick_tip([
                "Monitor your plants daily.",
                "Check soil moisture regularly.",
                "Remove weak leaves for healthy growth.",
            ])
            alert = "normal"

        return {
            "title": title,
            "message": message,
            "alert": alert,
            "city": city,
            "temperature": round(temp, 2),
            "humidity": humidity,
            "condition": condition,
            "description": description,
            "rain_1h": rain_1h,
            "rain_3h": rain_3h,
            "has_water_today": has_water,
            "has_fertilizer_today": has_fertilizer,
        }

    except HTTPException:
        raise

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
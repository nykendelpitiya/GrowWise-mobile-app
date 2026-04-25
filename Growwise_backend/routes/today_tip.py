import os
import requests
from fastapi import APIRouter, HTTPException
from dotenv import load_dotenv

load_dotenv()

router = APIRouter()

OPENWEATHER_API_KEY = os.getenv("OPENWEATHER_API_KEY")


@router.get("/today-tip/{city}")
def get_today_tip(city: str):
    try:
        if not OPENWEATHER_API_KEY:
            raise HTTPException(
                status_code=500,
                detail="OPENWEATHER_API_KEY not found in .env file",
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

        if is_rain:
            title = "Weather Alert"
            message = (
                "Rain is expected today. Avoid extra watering and check soil "
                "moisture before plant care."
            )
            alert = "rain"

        elif humidity >= 80:
            title = "Today Tip"
            message = (
                "High humidity today. Check leaves and stems for fungal "
                "disease signs."
            )
            alert = "normal"

        elif temp >= 32:
            title = "Today Tip"
            message = (
                "High temperature today. Water plants early morning or evening."
            )
            alert = "normal"

        else:
            title = "Today Tip"
            message = (
                "Weather is suitable today. Continue normal plant care and "
                "monitor soil moisture."
            )
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
        }

    except HTTPException:
        raise

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
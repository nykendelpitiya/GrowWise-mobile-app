import os
from pathlib import Path

import requests
from dotenv import load_dotenv

# .env file eka explicitly load karanawa
BASE_DIR = Path(__file__).resolve().parent.parent
ENV_PATH = BASE_DIR / ".env"
load_dotenv(dotenv_path=ENV_PATH)


def get_weather(city: str):
    api_key = os.getenv("OPENWEATHER_API_KEY")

    if not api_key:
        raise Exception("OPENWEATHER_API_KEY not found in .env file")

    if not city or city.strip() == "":
        raise Exception("City name is required")

    city_clean = city.strip()

    url = (
        f"https://api.openweathermap.org/data/2.5/weather"
        f"?q={city_clean},LK&appid={api_key}&units=metric"
    )

    try:
        response = requests.get(url, timeout=10)

        if response.status_code != 200:
            try:
                error_data = response.json()
                message = error_data.get("message", "Unknown error")
            except Exception:
                message = "Unknown error"

            raise Exception(f"Weather API error: {message}")

        data = response.json()

        return {
            "city": data.get("name", city_clean),
            "temperature": round(float(data["main"]["temp"]), 2),
            "humidity": round(float(data["main"]["humidity"]), 2),
            "condition": data["weather"][0]["main"],
        }

    except requests.exceptions.Timeout:
        raise Exception("Weather API request timeout")
    except requests.exceptions.ConnectionError:
        raise Exception("No internet connection")
    except Exception as e:
        raise Exception(str(e))
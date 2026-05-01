import requests
import sys
import json

def fetch_weather(zip_code):
    """
    Fetches weather data from wttr.in for a given zip code.
    Returns JSON formatted data.
    """
    url = f"https://wttr.in/{zip_code}?format=j1"
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        data = response.json()
        
        # Extract relevant fields for our database
        current = data['current_condition'][0]
        region = data['nearest_area'][0]['areaName'][0]['value']
        
        result = {
            "region": region,
            "temp_f": current['temp_F'],
            "condition": current['weatherDesc'][0]['value'],
            "humidity": current['humidity'],
            "zip": zip_code
        }
        return result
    except Exception as e:
        return {"error": str(e), "zip": zip_code}

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(json.dumps({"error": "No zip code provided"}))
        sys.exit(1)
        
    zip_code = sys.argv[1]
    weather_data = fetch_weather(zip_code)
    print(json.dumps(weather_data))

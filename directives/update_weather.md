# Directive: Update Weather Data

## Goal

Periodically fetch weather data for the current technician locations and update the local database to ensure the dashboard remains "Fresh".

## Frequency

- Every 30 minutes during business hours (8 AM - 6 PM).
- On demand when the technician switches locations.

## Inputs

- Current Zip Codes from `StartingPoints` or `Sites`.

## Tools/Scripts

- `execution/fetch_weather_wttr.py`

## Logic

1. Query the database for active sites or the technician's starting point.
2. Extract zip codes.
3. For each unique zip code, run `execution/fetch_weather_wttr.py`.
4. Parse the JSON output.
5. Update the `WeatherSnapshot` table in `app_database.dart` (via a bridge tool).

## Edge Cases

- **No Internet**: Fallback to the last cached snapshot. Do not overwrite with error data.
- **Invalid Zip**: Log error and skip.
- **Rate Limit**: If `wttr.in` rate limits, back off for 5 minutes.

## Desired Output

- Updated `WeatherSnapshot` records in the database.
- A log entry in `.tmp/weather_update_log.txt`.

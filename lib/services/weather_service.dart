import 'dart:convert';
import 'package:http/http.dart' as http;
import '../util/log.dart';

class WeatherService {
  /// Fetch weather by zip code using wttr.in API (simple, no API key required)
  /// Returns weather data or null if fetch fails
  static Future<WeatherData?> fetchWeatherByZip(String zipCode) async {
    try {
      Log.info('WeatherService: Fetching weather for zip code: $zipCode');

      // wttr.in API - simple, no API key needed
      // Format: https://wttr.in/{zip}?format=j1
      final url = Uri.parse('https://wttr.in/$zipCode?format=j1');

      final response = await http.get(
        url,
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        try {
          // Decode JSON without unsafe cast
          final decoded = json.decode(response.body);

          if (decoded is! Map<String, dynamic>) {
            Log.error('WeatherService: Invalid JSON response - not a Map');
            return null;
          }

          final data = decoded;

          // Parse wttr.in JSON response
          final currentConditions = data['current_condition'];
          final nearestAreas = data['nearest_area'];

          if (currentConditions is List && currentConditions.isNotEmpty) {
            final firstCondition = currentConditions[0];

            if (firstCondition is! Map<String, dynamic>) {
              Log.error('WeatherService: current_condition[0] is not a Map');
              return null;
            }

            final current = firstCondition;
            final location = (nearestAreas is List && nearestAreas.isNotEmpty)
                ? (nearestAreas[0] is Map<String, dynamic>
                    ? nearestAreas[0] as Map<String, dynamic>
                    : null)
                : null;

            // Safely extract temperature
            final tempFValue = current['temp_F'];
            int tempF = 72;
            if (tempFValue is num) {
              tempF = tempFValue.toInt();
            } else if (tempFValue != null) {
              tempF = int.tryParse(tempFValue.toString()) ?? 72;
            }

            // Safely extract condition
            final weatherDesc = current['weatherDesc'];
            String condition = 'Clear';
            if (weatherDesc is List && weatherDesc.isNotEmpty) {
              final firstDesc = weatherDesc[0];
              if (firstDesc is Map) {
                final value = firstDesc['value'];
                if (value != null) {
                  final conditionStr = value.toString().trim();
                  if (conditionStr.isNotEmpty) {
                    condition = conditionStr;
                  }
                }
              }
            }

            // Safely extract region
            String region = 'Zip $zipCode';
            if (location != null) {
              final areaName = location['areaName'];
              final regionData = location['region'];

              if (areaName is List && areaName.isNotEmpty) {
                final firstArea = areaName[0];
                if (firstArea is Map) {
                  final value = firstArea['value'];
                  if (value != null) {
                    final regionStr = value.toString().trim();
                    if (regionStr.isNotEmpty) {
                      region = regionStr;
                    }
                  }
                }
              } else if (regionData is List && regionData.isNotEmpty) {
                final firstRegion = regionData[0];
                if (firstRegion is Map) {
                  final value = firstRegion['value'];
                  if (value != null) {
                    final regionStr = value.toString().trim();
                    if (regionStr.isNotEmpty) {
                      region = regionStr;
                    }
                  }
                }
              }
            }

            Log.info(
                'WeatherService: Successfully fetched weather - $condition, $tempF°F');

            return WeatherData(
              region: region,
              temperature: tempF,
              condition: condition,
            );
          } else {
            Log.error(
                'WeatherService: Invalid response structure - missing or empty current_condition');
            if (response.body.isNotEmpty) {
              final bodyPreview = response.body.length > 500 
                  ? response.body.substring(0, 500) 
                  : response.body;
              Log.error('WeatherService: Response body: $bodyPreview');
            } else {
              Log.error('WeatherService: Response body is empty');
            }
          }
        } catch (e, stackTrace) {
          Log.error('WeatherService: Error parsing JSON response: $e');
          Log.error('WeatherService: Stack trace: $stackTrace');
          return null;
        }
      } else {
        Log.error('WeatherService: API returned status ${response.statusCode}');
        if (response.body.isNotEmpty) {
          final bodyPreview = response.body.length > 200 
              ? response.body.substring(0, 200) 
              : response.body;
          Log.error('WeatherService: Response body: $bodyPreview');
        }
      }
    } catch (e) {
      Log.error('WeatherService: Error fetching weather: $e');
    }

    return null;
  }

  /// Alternative: Fetch weather using OpenWeatherMap (requires API key)
  /// Uncomment and configure if you prefer OpenWeatherMap
  /*
  static Future<WeatherData?> fetchWeatherByZipOpenWeather(String zipCode, String apiKey) async {
    try {
      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?zip=$zipCode,us&appid=$apiKey&units=imperial'
      );
      
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final tempF = (data['main']?['temp'] as num?)?.round() ?? 72;
        final condition = data['weather']?[0]?['main'] ?? 'Clear';
        final region = data['name'] ?? 'Zip $zipCode';
        
        return WeatherData(
          region: region,
          temperature: tempF,
          condition: condition,
        );
      }
    } catch (e) {
      Log.error('WeatherService: Error fetching from OpenWeatherMap: $e');
    }
    
    return null;
  }
  */
}

class WeatherData {
  final String region;
  final int temperature;
  final String condition;

  WeatherData({
    required this.region,
    required this.temperature,
    required this.condition,
  });
}

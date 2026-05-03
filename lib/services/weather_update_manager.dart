import 'dart:async';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import 'weather_service.dart';
import '../util/log.dart';

class WeatherUpdateManager {
  final AppDatabase db;
  final bool Function()? isRemoteAllowed;
  Timer? _timer;
  bool _isUpdating = false;

  WeatherUpdateManager(this.db, {this.isRemoteAllowed});

  void start() {
    Log.info('WeatherUpdateManager: Starting auto-update service...');
    // Initial update after a short delay
    Future.delayed(const Duration(seconds: 10), () => updateNow());
    
    // Schedule periodic updates every 30 minutes
    _timer = Timer.periodic(const Duration(minutes: 30), (timer) {
      updateNow();
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
    Log.info('WeatherUpdateManager: Stopped auto-update service.');
  }

  Future<void> updateNow() async {
    if (_isUpdating) return;
    final allow = isRemoteAllowed;
    if (allow != null && !allow()) {
      Log.info(
        'WeatherUpdateManager: Skipping remote fetch (no network interface).',
      );
      return;
    }
    _isUpdating = true;

    try {
      final latest = await db.getLatestWeather();
      final zipCode = latest?.zipCode ?? '78217'; // Default to San Antonio
      final region = latest?.region ?? 'San Antonio, TX';

      Log.info('WeatherUpdateManager: Auto-updating weather for $zipCode ($region)...');

      final weatherData = await WeatherService.fetchWeatherByZip(zipCode);

      if (weatherData != null) {
        await db.insertWeather(
          WeatherSnapshotCompanion.insert(
            region: weatherData.region.isNotEmpty && weatherData.region != 'Zip $zipCode' 
                ? weatherData.region 
                : region,
            temperature: weatherData.temperature,
            condition: weatherData.condition,
            fetchedAt: DateTime.now(),
            source: 'auto-api',
            zipCode: Value(zipCode),
          ),
        );
        Log.info('WeatherUpdateManager: Weather updated successfully.');
      } else {
        Log.warn('WeatherUpdateManager: Failed to fetch weather data.');
      }
    } catch (e) {
      Log.error('WeatherUpdateManager: Error during auto-update: $e');
    } finally {
      _isUpdating = false;
    }
  }
}

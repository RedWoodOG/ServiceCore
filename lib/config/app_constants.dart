/// Application-wide constants for easy demo customization
class AppConstants {
  // Map Configuration
  static const double defaultMapLat = 29.531;
  static const double defaultMapLng = -98.432;
  static const double defaultMapZoom = 10.0;
  static const double mapMinZoom = 8.0;
  static const double mapMaxZoom = 18.0;

  // Demo Data (for MVP demonstration)
  static const int demoUserId = 1; // Default user ID for demo
  static const String demoUserName = "Demo Technician";
  static const String demoUserRole = "Senior Field Tech";

  // App Metadata
  static const String appVersion = "1.0.0-alpha";
  static const String appName = "Portal Offline";

  // Routing Configuration
  static const int pmRouteMaxSites = 5;
  static const String pmRouteAlgorithm = 'farthest_first';
}

/// FSC-Portal Application Layer
///
/// This barrel file exports all application services, errors, and boot components.
/// UI code should import from here rather than individual files.
///
/// Usage:
/// ```dart
/// import 'package:fsc_portal/application/application.dart';
/// ```
library;

// Errors
export 'errors/app_failure.dart';
export 'errors/result.dart';

// Services
export 'services/work_order_service.dart';
export 'services/location_service.dart';
export 'services/equipment_service.dart';
export 'services/knowledge_service.dart';
export 'services/import_service.dart';
export 'services/document_service.dart';
export 'services/note_service.dart';
export 'services/announcement_service.dart';

// Boot
export 'boot/boot_state.dart';
export 'boot/boot_service.dart';

// Note: BootScreen is in lib/features/boot/boot_screen.dart
// Full boot integration requires refactoring main.dart startup

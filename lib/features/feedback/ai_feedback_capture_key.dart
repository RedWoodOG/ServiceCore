import 'package:flutter/widgets.dart';

/// [RepaintBoundary] key for the main authenticated shell (see [MainNavigationScreen]).
/// Used to rasterize the current UI for AI feedback exports.
final GlobalKey aiFeedbackPortalCaptureKey = GlobalKey(
  debugLabel: 'aiFeedbackPortalCapture',
);

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'ai_feedback_capture_key.dart';
import 'feedback_export_bundle.dart';

class FeedbackCaptureService {
  /// Renders the subtree behind [aiFeedbackPortalCaptureKey] to PNG bytes.
  static Future<FeedbackCapturePayload?> capturePortal({
    required BuildContext context,
    double? pixelRatio,
  }) async {
    final boundary = aiFeedbackPortalCaptureKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) {
      return null;
    }

    final dpr = pixelRatio ?? MediaQuery.devicePixelRatioOf(context);
    if (!boundary.debugNeedsPaint && boundary.size == Size.zero) {
      return null;
    }

    ui.Image image;
    try {
      image = await boundary.toImage(pixelRatio: dpr);
    } catch (_) {
      return null;
    }

    final pixelWidth = image.width;
    final pixelHeight = image.height;
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    if (byteData == null) return null;

    final logicalSize = boundary.size;
    return FeedbackCapturePayload(
      pngBytes: byteData.buffer.asUint8List(),
      logicalWidth: logicalSize.width,
      logicalHeight: logicalSize.height,
      pixelWidth: pixelWidth,
      pixelHeight: pixelHeight,
      devicePixelRatio: dpr,
    );
  }
}

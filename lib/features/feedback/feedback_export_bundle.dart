import 'dart:convert';
import 'dart:typed_data';

/// One user-drawn region on the captured screenshot (logical Flutter layout coords).
class FeedbackRegion {
  FeedbackRegion({
    required this.id,
    required this.rectLogical,
    required this.note,
  });

  final String id;
  final RectLogical rectLogical;
  final String note;

  Map<String, dynamic> toJson() => {
        'id': id,
        'note': note,
        'rectLogical': rectLogical.toJson(),
      };
}

class RectLogical {
  const RectLogical({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });

  final double left;
  final double top;
  final double width;
  final double height;

  Map<String, dynamic> toJson() => {
        'left': left,
        'top': top,
        'width': width,
        'height': height,
      };

  /// Same rectangle expressed in PNG pixel coordinates (for vision models).
  RectLogical toPixels({
    required double scaleX,
    required double scaleY,
  }) {
    return RectLogical(
      left: left * scaleX,
      top: top * scaleY,
      width: width * scaleX,
      height: height * scaleY,
    );
  }
}

/// Raster + layout metadata from a single capture.
class FeedbackCapturePayload {
  FeedbackCapturePayload({
    required this.pngBytes,
    required this.logicalWidth,
    required this.logicalHeight,
    required this.pixelWidth,
    required this.pixelHeight,
    required this.devicePixelRatio,
  });

  final Uint8List pngBytes;
  final double logicalWidth;
  final double logicalHeight;
  final int pixelWidth;
  final int pixelHeight;
  final double devicePixelRatio;

  double get scaleX => pixelWidth / logicalWidth;

  double get scaleY => pixelHeight / logicalHeight;

  Map<String, dynamic> toManifestJson({
    required List<FeedbackRegion> regions,
    required String appVersion,
  }) {
    return {
      'schemaVersion': 1,
      'purpose':
          'Pair this JSON with the PNG of the same basename when sending screenshots to an AI assistant (e.g. Cursor). Regions are UI defects or change requests.',
      'appVersion': appVersion,
      'logicalLayout': {
        'width': logicalWidth,
        'height': logicalHeight,
      },
      'imagePixels': {
        'width': pixelWidth,
        'height': pixelHeight,
      },
      'devicePixelRatio': devicePixelRatio,
      'annotations': regions.map((r) {
        final px = r.rectLogical.toPixels(scaleX: scaleX, scaleY: scaleY);
        return {
          'id': r.id,
          'note': r.note,
          'rectLogical': r.rectLogical.toJson(),
          'rectPixels': px.toJson(),
        };
      }).toList(),
    };
  }

  String manifestJsonString({
    required List<FeedbackRegion> regions,
    required String appVersion,
  }) =>
      JsonEncoder.withIndent('  ').convert(
        toManifestJson(regions: regions, appVersion: appVersion),
      );
}

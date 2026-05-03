import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'feedback_export_bundle.dart';

const String _readme = '''
FSC Portal — AI feedback exports
=================================

Each capture produces two files with the same basename:
  *.png  — screenshot of the app
  *.json — machine-readable rectangles + your notes (for coding assistants)

When asking an AI to fix the UI, attach BOTH the PNG and the JSON (or paste
the JSON text). The JSON includes coordinates in both "logical" Flutter
layout units and PNG pixels so the model can align your notes with the image.

This folder is on your machine only (not uploaded automatically).
''';

class FeedbackDiskWriter {
  static Future<({String pngPath, String jsonPath, String folderPath})> write({
    required FeedbackCapturePayload payload,
    required List<FeedbackRegion> regions,
    required String appVersion,
  }) async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(root.path, 'FSC_Portal_ai_feedback'));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final stamp = DateTime.now().toUtc().toIso8601String().replaceAll(':', '-');
    final stem = 'feedback_$stamp';
    final pngPath = p.join(dir.path, '$stem.png');
    final jsonPath = p.join(dir.path, '$stem.json');

    await File(pngPath).writeAsBytes(payload.pngBytes);
    await File(jsonPath).writeAsString(
      payload.manifestJsonString(regions: regions, appVersion: appVersion),
    );

    final readme = File(p.join(dir.path, 'README.txt'));
    if (!await readme.exists()) {
      await readme.writeAsString(_readme);
    }

    return (pngPath: pngPath, jsonPath: jsonPath, folderPath: dir.path);
  }
}

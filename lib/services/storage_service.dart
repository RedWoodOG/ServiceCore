import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import '../util/log.dart';

enum StorageCategory {
  sitePhoto,
  receipt,
  chatAttachment,
  manual,
}

class StorageService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<Directory> _getDirectory(StorageCategory category) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    String subDirName;
    
    switch (category) {
      case StorageCategory.sitePhoto:
        subDirName = 'site_photos';
        break;
      case StorageCategory.receipt:
        subDirName = 'receipts';
        break;
      case StorageCategory.chatAttachment:
        subDirName = 'chat_attachments';
        break;
      case StorageCategory.manual:
        subDirName = 'manuals';
        break;
    }

    final dir = Directory(path.join(appDocDir.path, subDirName));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Pick a photo from Camera or Gallery and save it to secure storage
  Future<String?> pickAndSavePhoto({
    required StorageCategory category,
    required bool useCamera,
  }) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: useCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 80, // Textures are heavy, 80% is good balance
      );

      if (pickedFile == null) return null;

      final saveDir = await _getDirectory(category);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(pickedFile.path)}';
      final savedPath = path.join(saveDir.path, fileName);

      await File(pickedFile.path).copy(savedPath);
      Log.info('Photo saved to: $savedPath');
      
      return savedPath;
    } catch (e) {
      Log.error('Error picking/saving photo: $e');
      return null;
    }
  }

  /// Pick a generic file (PDF, text, etc) and save it
  Future<String?> pickAndSaveFile({
    required StorageCategory category,
    List<String>? allowedExtensions,
  }) async {
    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: allowedExtensions != null ? FileType.custom : FileType.any,
        allowedExtensions: allowedExtensions,
      );

      if (result == null || result.files.single.path == null) return null;

      final originalPath = result.files.single.path!;
      final saveDir = await _getDirectory(category);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${result.files.single.name}';
      final savedPath = path.join(saveDir.path, fileName);

      await File(originalPath).copy(savedPath);
      Log.info('File saved to: $savedPath');

      return savedPath;
    } catch (e) {
      Log.error('Error picking/saving file: $e');
      return null;
    }
  }

  /// Save a file from an existing path (e.g. download or temp)
  Future<String?> saveFile(File sourceFile, StorageCategory category) async {
    try {
      final saveDir = await _getDirectory(category);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(sourceFile.path)}';
      final savedPath = path.join(saveDir.path, fileName);

      await sourceFile.copy(savedPath);
      Log.info('File moved to storage: $savedPath');
      
      return savedPath;
    } catch (e) {
      Log.error('Error saving file: $e');
      return null;
    }
  }
}

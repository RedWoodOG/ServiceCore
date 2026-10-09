import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'log.dart';

/// Resolution of user-file paths (attachments, receipts, models) that stay valid
/// across app updates.
///
/// Absolute paths must never be persisted. On iOS the application container is
/// re-created with a fresh UUID on every app update, so an absolute path stored
/// yesterday points nowhere today; Android scoped storage and Windows profile
/// moves have the same failure mode, less often. Paths are therefore stored
/// **relative to the documents root** and re-joined at read time.
///
/// Call [init] once during startup, before any resolution happens. After that
/// [toStorable] and [resolveSync] are synchronous, so widget `build` methods do
/// not have to await anything.
class AppPaths {
  AppPaths._();

  /// Marker segment that all app-owned user files live under. Kept as the
  /// historical name deliberately: renaming it orphans existing installs.
  static const String appDirName = 'portal_offline';

  static Directory? _documentsRoot;

  /// Resolves and caches the documents root. Safe to call more than once.
  static Future<void> init() async {
    _documentsRoot ??= await getApplicationDocumentsDirectory();
    Log.info('AppPaths: documents root ${_documentsRoot!.path}');
  }

  /// Overrides the documents root. Tests only — lets the pure path logic run
  /// without a platform channel behind [getApplicationDocumentsDirectory].
  @visibleForTesting
  static void debugSetRoot(Directory root) => _documentsRoot = root;

  static Directory get documentsRoot {
    final root = _documentsRoot;
    if (root == null) {
      throw StateError('AppPaths.init() must be awaited before use.');
    }
    return root;
  }

  /// Directory for app-owned user files, created if missing.
  static Future<Directory> appDir(List<String> segments) async {
    final dir =
        Directory(p.joinAll([documentsRoot.path, appDirName, ...segments]));
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Converts an absolute path into the form that should be persisted.
  ///
  /// Paths under the documents root become root-relative. Anything outside it
  /// (an external volume, a user-chosen location) is returned unchanged — those
  /// are not ours to re-root.
  static String toStorable(String absolutePath) {
    final rootPath = documentsRoot.path;
    if (!p.isWithin(rootPath, absolutePath)) return absolutePath;
    return p.relative(absolutePath, from: rootPath);
  }

  /// Resolves a persisted path back to an absolute one.
  ///
  /// Handles three cases:
  ///  * relative — the current format; joined onto the documents root
  ///  * absolute and present — a legacy row on a container that has not moved
  ///  * absolute and missing — a legacy row whose container *has* moved; the
  ///    path is re-rooted from [appDirName] onto the current documents root
  ///
  /// Returns the best candidate. The caller still has to handle a missing file.
  static String resolveSync(String storedPath) {
    if (storedPath.isEmpty) return storedPath;
    final rootPath = documentsRoot.path;

    if (!p.isAbsolute(storedPath)) {
      return p.join(rootPath, storedPath);
    }
    if (File(storedPath).existsSync()) {
      return storedPath;
    }
    return _reRoot(storedPath, rootPath) ?? storedPath;
  }

  static File resolveFile(String storedPath) => File(resolveSync(storedPath));

  /// Rebuilds a stale absolute path by finding [appDirName] in it and re-joining
  /// everything from there onto the current root. Returns null if the path does
  /// not run through our directory.
  static String? _reRoot(String stalePath, String rootPath) {
    final parts = p.split(stalePath);
    final index = parts.lastIndexOf(appDirName);
    if (index == -1) return null;
    return p.joinAll([rootPath, ...parts.sublist(index)]);
  }
}

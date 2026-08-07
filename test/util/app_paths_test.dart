import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:servicecore/util/app_paths.dart';

void main() {
  late Directory tempRoot;

  setUp(() {
    tempRoot = Directory.systemTemp.createTempSync('servicecore_paths_');
    AppPaths.debugSetRoot(tempRoot);
  });

  tearDown(() {
    if (tempRoot.existsSync()) tempRoot.deleteSync(recursive: true);
  });

  group('toStorable', () {
    test('makes a path under the documents root root-relative', () {
      final abs = p.join(tempRoot.path, AppPaths.appDirName, 'expenses', '7', 'r.jpg');
      expect(
        AppPaths.toStorable(abs),
        p.join(AppPaths.appDirName, 'expenses', '7', 'r.jpg'),
      );
    });

    test('leaves a path outside the documents root untouched', () {
      final outside = p.join(Directory.systemTemp.path, 'elsewhere', 'r.jpg');
      expect(AppPaths.toStorable(outside), outside);
    });
  });

  group('resolveSync', () {
    test('joins a relative path onto the current root', () {
      final stored = p.join(AppPaths.appDirName, 'work_orders', '3', 'photo.png');
      expect(AppPaths.resolveSync(stored), p.join(tempRoot.path, stored));
    });

    test('returns an absolute legacy path that still exists', () {
      final dir = Directory(p.join(tempRoot.path, AppPaths.appDirName, 'sites', '2'))
        ..createSync(recursive: true);
      final file = File(p.join(dir.path, 'doc.pdf'))..writeAsStringSync('x');
      expect(AppPaths.resolveSync(file.path), file.path);
    });

    test('re-roots a stale absolute path onto the current root', () {
      // Simulates an iOS container UUID change: the row still holds the path
      // handed out by the previous install, which no longer exists.
      final stale = p.join(
        '/var/mobile/Containers/Data/Application/OLD-UUID/Documents',
        AppPaths.appDirName,
        'expenses',
        '4',
        'receipt.jpg',
      );
      expect(
        AppPaths.resolveSync(stale),
        p.join(tempRoot.path, AppPaths.appDirName, 'expenses', '4', 'receipt.jpg'),
      );
    });

    test('leaves a stale absolute path alone when it is not ours', () {
      const foreign = '/some/other/app/file.jpg';
      expect(AppPaths.resolveSync(foreign), foreign);
    });

    test('passes an empty path straight through', () {
      expect(AppPaths.resolveSync(''), '');
    });
  });
}

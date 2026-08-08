import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:servicecore/main.dart';

void main() {
  // This is the Flutter scaffold's default smoke test. It has never run: until
  // recently it imported `package:portal_offline/main.dart`, a package name that
  // does not match pubspec.yaml, so the file could not compile and the failure
  // was invisible.
  //
  // Now that it compiles, it fails honestly: PortalOfflineApp reads
  // ThemeProvider (main.dart:310) plus AppDatabase, AuthProvider,
  // NavigationState, EvaState and NetworkReachabilityNotifier, all supplied by
  // the MultiProvider that main() builds. Pumping the widget bare throws
  // ProviderNotFoundException, and BootService then reaches for the filesystem
  // through path_provider, which has no implementation in a unit test.
  //
  // Making it meaningful needs a real harness: an in-memory AppDatabase, the
  // provider tree extracted from main() so tests and production share one
  // definition, and channel mocks for path_provider and flutter_secure_storage.
  // That is worth building — it is the only test that would exercise startup —
  // but it is a task in itself, not a line change.
  //
  // Skipped rather than deleted so the gap stays visible, and rather than
  // asserted-around so it does not pretend to cover startup.
  testWidgets('App launches successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const PortalOfflineApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  }, skip: true);
}

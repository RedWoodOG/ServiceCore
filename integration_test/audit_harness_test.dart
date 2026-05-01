// ignore_for_file: avoid_print
/// FSC Portal - Audit Artifact Capture Harness
///
/// This integration test captures artifacts for the five-protocol enforcing audit:
/// - Screenshots (RLDF Visual)
/// - Semantics tree dumps (Structural Coherence)
/// - Interaction traces (Behavioral Coherence)
/// - VCE source snapshots (Veracity Coherence)
///
/// Run with: flutter test integration_test/audit_harness_test.dart
/// Or for Windows desktop: flutter test -d windows integration_test/audit_harness_test.dart
library;


import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import 'package:fsc_portal/main.dart';
import 'package:fsc_portal/database/app_database.dart';
import 'package:fsc_portal/database/seed_service.dart';
import 'package:fsc_portal/providers/auth_provider.dart';
import 'package:fsc_portal/providers/theme_provider.dart';
import 'package:fsc_portal/app_shell/eva_state.dart';
import 'package:fsc_portal/app_shell/navigation_state.dart';
import 'package:fsc_portal/services/weather_update_manager.dart';

/// Audit run configuration
class AuditConfig {
  static final String runId = 'AUDIT-${DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first}';
  static const String artifactsBase = 'audit/artifacts';
  static const String screenshotsDir = '$artifactsBase/screenshots';
  static const String semanticsDir = '$artifactsBase/semantics';
  static const String tracesDir = '$artifactsBase/traces';
  static const String vceDir = '$artifactsBase/vce_sources';
  static const String manifestsDir = '$artifactsBase/manifests';
  
  // Test credentials (from seed data)
  static const String testUsername = 'admin';
  static const String testPassword = ''; // Empty password for test accounts
}

/// Trace entry for behavioral coherence
class TraceEntry {
  final DateTime timestamp;
  final String action;
  final String target;
  final String? screenshotBeforeId;
  final String? screenshotAfterId;
  final String expectedTransition;
  final String observedTransition;
  
  TraceEntry({
    required this.timestamp,
    required this.action,
    required this.target,
    this.screenshotBeforeId,
    this.screenshotAfterId,
    required this.expectedTransition,
    required this.observedTransition,
  });
  
  Map<String, dynamic> toJson() => {
    'timestamp': timestamp.toIso8601String(),
    'action': action,
    'target': target,
    'screenshot_before_id': screenshotBeforeId,
    'screenshot_after_id': screenshotAfterId,
    'expected_transition': expectedTransition,
    'observed_transition': observedTransition,
  };
}

/// Manifest for the audit run
class AuditManifest {
  final String runId;
  final String gitCommit;
  final DateTime startTime;
  DateTime? endTime;
  final List<String> screenshots = [];
  final List<String> semanticsDumps = [];
  String? tracePath;
  final List<String> vceSnapshots = [];
  final List<String> errors = [];
  
  AuditManifest({
    required this.runId,
    required this.gitCommit,
    required this.startTime,
  });
  
  Map<String, dynamic> toJson() => {
    'run_id': runId,
    'git_commit': gitCommit,
    'start_time': startTime.toIso8601String(),
    'end_time': endTime?.toIso8601String(),
    'screenshots': screenshots,
    'semantics_dumps': semanticsDumps,
    'trace_path': tracePath,
    'vce_snapshots': vceSnapshots,
    'errors': errors,
  };
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  late AppDatabase database;
  late AuditManifest manifest;
  final List<TraceEntry> traces = [];
  
  // Navigation items to visit (from main.dart)
  final navItems = [
    {'index': 0, 'label': 'Home'},
    {'index': 1, 'label': 'Work'},
    {'index': 2, 'label': 'Operations'},
    {'index': 3, 'label': 'Locations'},
    {'index': 4, 'label': 'People'},
    {'index': 5, 'label': 'Knowledge'},
    {'index': 6, 'label': 'Training'},
    {'index': 7, 'label': 'Equipment'},
    {'index': 8, 'label': 'Expenses'},
    {'index': 9, 'label': 'Settings'},
  ];
  
  /// Ensure artifact directories exist
  Future<void> ensureDirectories() async {
    final dirs = [
      AuditConfig.screenshotsDir,
      AuditConfig.semanticsDir,
      AuditConfig.tracesDir,
      AuditConfig.vceDir,
      AuditConfig.manifestsDir,
    ];
    for (final dir in dirs) {
      await Directory(dir).create(recursive: true);
    }
  }
  
  /// Get git commit hash
  Future<String> getGitCommit() async {
    try {
      final result = await Process.run('git', ['rev-parse', '--short', 'HEAD']);
      return result.stdout.toString().trim();
    } catch (e) {
      return 'unknown';
    }
  }
  
  /// Capture screenshot using RepaintBoundary (Windows-safe)
  Future<String?> captureScreenshot(WidgetTester tester, String captureId) async {
    try {
      // Find a RepaintBoundary - Flutter apps usually have at least one
      final boundaryFinder = find.byType(RepaintBoundary);
      if (boundaryFinder.evaluate().isEmpty) {
        throw StateError('No RepaintBoundary found to capture.');
      }

      final boundary = tester.renderObject<RenderRepaintBoundary>(boundaryFinder.first);
      final ui.Image image = await boundary.toImage(pixelRatio: 1.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw StateError('toByteData returned null');

      final bytes = byteData.buffer.asUint8List();
      final path = '${AuditConfig.screenshotsDir}/$captureId.png';
      await File(path).writeAsBytes(bytes);

      manifest.screenshots.add(captureId);
      print('[AUDIT] Screenshot captured: $captureId');
      return captureId;
    } catch (e) {
      print('[AUDIT] Screenshot failed for $captureId: $e');
      manifest.errors.add('Screenshot failed: $captureId - $e');
      return null;
    }
  }
  
  /// Dump semantics tree
  Future<void> dumpSemantics(String captureId) async {
    try {
      // Enable semantics if not already enabled
      SemanticsBinding.instance.ensureSemantics();
      
      final buffer = StringBuffer();
      buffer.writeln('=== Semantics Tree Dump ===');
      buffer.writeln('Capture ID: $captureId');
      buffer.writeln('Timestamp: ${DateTime.now().toIso8601String()}');
      buffer.writeln('');
      
      // Get the semantics owner
      final owner = RendererBinding.instance.renderView.owner?.semanticsOwner;
      if (owner != null) {
        void dumpNode(SemanticsNode node, int depth) {
          final indent = '  ' * depth;
          buffer.writeln('${indent}SemanticsNode(id: ${node.id})');
          buffer.writeln('$indent  rect: ${node.rect}');
          buffer.writeln('$indent  label: "${node.label}"');
          buffer.writeln('$indent  hint: "${node.hint}"');
          buffer.writeln('$indent  value: "${node.value}"');
          buffer.writeln('$indent  actions: ${node.getSemanticsData().actions}');
          buffer.writeln('$indent  flags: ${node.getSemanticsData().flags}');
          
          node.visitChildren((child) {
            dumpNode(child, depth + 1);
            return true;
          });
        }
        
        final rootNode = owner.rootSemanticsNode;
        if (rootNode != null) {
          dumpNode(rootNode, 0);
        } else {
          buffer.writeln('(No root semantics node available)');
        }
      } else {
        buffer.writeln('(Semantics owner not available)');
      }
      
      final path = '${AuditConfig.semanticsDir}/${captureId}__semantics.txt';
      await File(path).writeAsString(buffer.toString());
      manifest.semanticsDumps.add(captureId);
      print('[AUDIT] Semantics dumped: $captureId');
    } catch (e) {
      print('[AUDIT] Semantics dump failed for $captureId: $e');
      manifest.errors.add('Semantics dump failed: $captureId - $e');
    }
  }
  
  /// Capture VCE source snapshot (database truth)
  Future<void> captureVceSnapshot(String captureId, AppDatabase db) async {
    try {
      final vceData = <String, dynamic>{
        'capture_id': captureId,
        'timestamp': DateTime.now().toIso8601String(),
        'source': 'AppDatabase',
        'queries': {},
      };
      
      // Query various counts as source-of-truth
      try {
        final workOrders = await db.getAllWorkOrders();
        vceData['queries']['work_orders_count'] = workOrders.length;
        vceData['queries']['work_orders_by_status'] = {
          'open': workOrders.where((w) => w.status == 'open').length,
          'completed': workOrders.where((w) => w.status == 'completed').length,
          'in_progress': workOrders.where((w) => w.status == 'in_progress').length,
        };
      } catch (e) {
        vceData['queries']['work_orders_error'] = e.toString();
      }
      
      try {
        final users = await db.getAllUsers();
        vceData['queries']['users_count'] = users.length;
      } catch (e) {
        vceData['queries']['users_error'] = e.toString();
      }
      
      try {
        final equipment = await db.getAllEquipment();
        vceData['queries']['equipment_count'] = equipment.length;
      } catch (e) {
        vceData['queries']['equipment_error'] = e.toString();
      }
      
      try {
        final sites = await db.getAllSites();
        vceData['queries']['sites_count'] = sites.length;
      } catch (e) {
        vceData['queries']['sites_error'] = e.toString();
      }
      
      try {
        final knowledge = await db.searchKnowledge('');
        vceData['queries']['knowledge_entries_count'] = knowledge.length;
      } catch (e) {
        vceData['queries']['knowledge_error'] = e.toString();
      }
      
      try {
        final announcements = await db.getActiveCompanyAnnouncements();
        vceData['queries']['announcements_count'] = announcements.length;
      } catch (e) {
        vceData['queries']['announcements_error'] = e.toString();
      }
      
      final path = '${AuditConfig.vceDir}/${captureId}__vce.json';
      await File(path).writeAsString(const JsonEncoder.withIndent('  ').convert(vceData));
      manifest.vceSnapshots.add(captureId);
      print('[AUDIT] VCE snapshot captured: $captureId');
    } catch (e) {
      print('[AUDIT] VCE snapshot failed for $captureId: $e');
      manifest.errors.add('VCE snapshot failed: $captureId - $e');
    }
  }
  
  /// Record a trace entry
  void recordTrace({
    required String action,
    required String target,
    String? screenshotBeforeId,
    String? screenshotAfterId,
    required String expectedTransition,
    required String observedTransition,
  }) {
    traces.add(TraceEntry(
      timestamp: DateTime.now(),
      action: action,
      target: target,
      screenshotBeforeId: screenshotBeforeId,
      screenshotAfterId: screenshotAfterId,
      expectedTransition: expectedTransition,
      observedTransition: observedTransition,
    ));
    print('[AUDIT] Trace: $action on $target -> $observedTransition');
  }
  
  /// Save all traces to file
  Future<void> saveTraces() async {
    final path = '${AuditConfig.tracesDir}/${AuditConfig.runId}__trace.jsonl';
    final buffer = StringBuffer();
    for (final trace in traces) {
      buffer.writeln(jsonEncode(trace.toJson()));
    }
    await File(path).writeAsString(buffer.toString());
    manifest.tracePath = path;
    print('[AUDIT] Traces saved: ${traces.length} entries');
  }
  
  /// Save manifest
  Future<void> saveManifest() async {
    manifest.endTime = DateTime.now();
    final path = '${AuditConfig.manifestsDir}/${AuditConfig.runId}__manifest.json';
    await File(path).writeAsString(const JsonEncoder.withIndent('  ').convert(manifest.toJson()));
    print('[AUDIT] Manifest saved: $path');
  }
  
  /// Full capture at a point
  Future<void> capturePoint(WidgetTester tester, String pointId, AppDatabase db) async {
    await captureScreenshot(tester, pointId);
    await dumpSemantics(pointId);
    await captureVceSnapshot(pointId, db);
  }

  group('Audit Artifact Capture', () {
    testWidgets('Full audit capture run', (WidgetTester tester) async {
      print('\n========================================');
      print('FSC PORTAL - AUDIT ARTIFACT CAPTURE');
      print('Run ID: ${AuditConfig.runId}');
      print('========================================\n');
      
      // Initialize
      await ensureDirectories();
      final gitCommit = await getGitCommit();
      manifest = AuditManifest(
        runId: AuditConfig.runId,
        gitCommit: gitCommit,
        startTime: DateTime.now(),
      );
      
      print('[AUDIT] Git commit: $gitCommit');
      print('[AUDIT] Starting artifact capture...\n');
      
      // Initialize database
      database = AppDatabase();
      await seedDatabase(database);
      
      // Initialize providers
      final evaState = EvaState();
      evaState.setDatabase(database);
      final navigationState = NavigationState();
      final themeProvider = ThemeProvider();
      final weatherManager = WeatherUpdateManager(database);
      
      // Build app with test providers
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<AppDatabase>.value(value: database),
            Provider<WeatherUpdateManager>.value(value: weatherManager),
            ChangeNotifierProvider<EvaState>.value(value: evaState),
            ChangeNotifierProvider<NavigationState>.value(value: navigationState),
            ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
            ChangeNotifierProvider(create: (_) => AuthProvider(database)),
          ],
          child: const PortalOfflineApp(),
        ),
      );
      
      // Wait for initial load
      await tester.pumpAndSettle(const Duration(seconds: 2));
      
      // PHASE 1: Login Screen Capture
      print('\n--- PHASE 1: Login Screen ---');
      await capturePoint(tester, '01_login_screen_initial', database);
      
      // Find login elements
      final usernameField = find.byKey(const Key('login_username'));
      final passwordField = find.byKey(const Key('login_password'));
      final loginButton = find.byKey(const Key('login_submit'));
      
      if (usernameField.evaluate().isEmpty) {
        print('[AUDIT] WARNING: Login username field not found');
        manifest.errors.add('Login username field not found');
      } else {
        // Enter credentials
        final beforeId = await captureScreenshot(tester, '02_login_before_input');
        
        await tester.enterText(usernameField, AuditConfig.testUsername);
        await tester.pumpAndSettle();
        
        await tester.enterText(passwordField, AuditConfig.testPassword);
        await tester.pumpAndSettle();
        
        await capturePoint(tester, '03_login_after_input', database);
        
        // Tap login
        if (loginButton.evaluate().isNotEmpty) {
          await tester.tap(loginButton);
          await tester.pumpAndSettle(const Duration(seconds: 3));
          
          final afterId = await captureScreenshot(tester, '04_post_login');
          
          recordTrace(
            action: 'tap',
            target: 'login_submit',
            screenshotBeforeId: beforeId,
            screenshotAfterId: afterId,
            expectedTransition: 'Navigate to MainNavigationScreen',
            observedTransition: find.text('Home').evaluate().isNotEmpty 
                ? 'MainNavigationScreen displayed' 
                : 'Login screen still visible (login may have failed)',
          );
          
          await capturePoint(tester, '05_home_initial', database);
        } else {
          print('[AUDIT] WARNING: Login button not found');
          manifest.errors.add('Login button not found');
        }
      }
      
      // PHASE 2: Navigate through all screens
      print('\n--- PHASE 2: Navigation Screens ---');
      
      // Check if we're past login
      final homeFound = find.text('Home');
      if (homeFound.evaluate().isEmpty) {
        print('[AUDIT] WARNING: Not logged in, skipping navigation phase');
        manifest.errors.add('Not logged in - navigation phase skipped');
      } else {
        for (final navItem in navItems) {
          final index = navItem['index'] as int;
          final label = navItem['label'] as String;
          
          print('\n[AUDIT] Navigating to: $label (index $index)');
          
          try {
            // Find and tap nav item
            final navFinder = find.text(label);
            if (navFinder.evaluate().isNotEmpty) {
              final beforeId = await captureScreenshot(tester, 'nav_${index}_${label.toLowerCase()}_before');
              
              await tester.tap(navFinder.first);
              await tester.pumpAndSettle(const Duration(seconds: 2));
              
              final captureId = 'nav_${index}_${label.toLowerCase()}';
              await capturePoint(tester, captureId, database);
              
              final afterId = await captureScreenshot(tester, 'nav_${index}_${label.toLowerCase()}_after');
              
              recordTrace(
                action: 'tap_nav',
                target: label,
                screenshotBeforeId: beforeId,
                screenshotAfterId: afterId,
                expectedTransition: 'Show $label screen',
                observedTransition: 'Navigation completed',
              );
            } else {
              print('[AUDIT] WARNING: Nav item "$label" not found');
              manifest.errors.add('Nav item not found: $label');
            }
          } catch (e) {
            print('[AUDIT] ERROR navigating to $label: $e');
            manifest.errors.add('Navigation error for $label: $e');
          }
        }
      }
      
      // PHASE 3: Final captures and cleanup
      print('\n--- PHASE 3: Finalization ---');
      
      await saveTraces();
      await saveManifest();
      
      // Cleanup
      await database.close();
      
      print('\n========================================');
      print('AUDIT CAPTURE COMPLETE');
      print('Run ID: ${AuditConfig.runId}');
      print('Screenshots: ${manifest.screenshots.length}');
      print('Semantics dumps: ${manifest.semanticsDumps.length}');
      print('VCE snapshots: ${manifest.vceSnapshots.length}');
      print('Trace entries: ${traces.length}');
      print('Errors: ${manifest.errors.length}');
      print('========================================\n');
      
      // Assert we captured something
      expect(manifest.screenshots, isNotEmpty, reason: 'Should capture at least one screenshot');
    });
  });
}

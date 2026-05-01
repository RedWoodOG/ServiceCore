import 'package:flutter/material.dart';

import '../../application/boot/boot_service.dart';
import '../../application/boot/boot_state.dart';
import '../../theme/app_theme.dart';

/// Boot screen that shows during app startup.
///
/// Displays boot progress, and if boot fails, shows safe mode UI
/// with diagnostics and recovery options.
class BootScreen extends StatefulWidget {
  const BootScreen({
    super.key,
    required this.bootService,
    required this.onBootComplete,
  });

  final BootService bootService;
  final VoidCallback onBootComplete;

  @override
  State<BootScreen> createState() => _BootScreenState();
}

class _BootScreenState extends State<BootScreen> {
  @override
  void initState() {
    super.initState();
    widget.bootService.addListener(_onBootStateChanged);
    _startBoot();
  }

  @override
  void dispose() {
    widget.bootService.removeListener(_onBootStateChanged);
    super.dispose();
  }

  void _onBootStateChanged() {
    if (mounted) {
      setState(() {});
      
      // Check if boot completed successfully
      if (widget.bootService.state is BootComplete) {
        widget.onBootComplete();
      }
    }
  }

  Future<void> _startBoot() async {
    await widget.bootService.boot();
  }

  Future<void> _attemptRecovery({bool resetDatabase = false}) async {
    await widget.bootService.recover(resetDatabase: resetDatabase);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.bootService.state;

    return Scaffold(
      backgroundColor: AppPalette.deepBlack,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: switch (state) {
            BootNotStarted() => _buildLoading('Initializing...'),
            BootCheckingFilesystem() => _buildLoading('Checking filesystem...'),
            BootOpeningDatabase() => _buildLoading('Opening database...'),
            BootRunningMigrations(:final fromVersion, :final toVersion) =>
              _buildLoading('Migrating database ($fromVersion → $toVersion)...'),
            BootCheckingIntegrity() => _buildLoading('Checking integrity...'),
            BootSeedingData() => _buildLoading('Preparing data...'),
            BootInitializingServices() => _buildLoading('Starting services...'),
            BootComplete() => _buildLoading('Ready!'),
            BootSafeMode(:final error, :final diagnostics) =>
              _buildSafeMode(error, diagnostics),
          },
        ),
      ),
    );
  }

  Widget _buildLoading(String message) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppPalette.fscRoyalBlue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.security,
            color: Colors.white,
            size: 48,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'FSC Portal',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 32),
        CircularProgressIndicator(
          valueColor: const AlwaysStoppedAnimation<Color>(AppPalette.fscRoyalBlue),
        ),
        const SizedBox(height: 16),
        Text(
          message,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSafeMode(Object error, BootDiagnostics diagnostics) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Error icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppPalette.alertRed.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppPalette.alertRed, width: 2),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppPalette.alertRed,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Safe Mode',
            style: TextStyle(
              color: AppPalette.alertRed,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The application encountered a problem during startup.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Error details
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppPalette.darkGrey,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppPalette.alertRed.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Error:',
                  style: TextStyle(
                    color: AppPalette.alertRed,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  error.toString(),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Diagnostics
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppPalette.darkGrey,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Diagnostics:',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                _buildDiagnosticRow('Database Path', diagnostics.dbPath),
                _buildDiagnosticRow('Database Exists', diagnostics.dbExists ? 'Yes' : 'No'),
                _buildDiagnosticRow('Database Size', '${(diagnostics.dbSizeBytes / 1024).toStringAsFixed(1)} KB'),
                _buildDiagnosticRow('Writable', diagnostics.dbWritable ? 'Yes' : 'No'),
                if (diagnostics.dbVersion != null)
                  _buildDiagnosticRow('Schema Version', diagnostics.dbVersion.toString()),
                if (diagnostics.integrityCheckPassed != null)
                  _buildDiagnosticRow('Integrity Check', diagnostics.integrityCheckPassed! ? 'Passed' : 'Failed'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Recovery options
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _attemptRecovery(resetDatabase: false),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white54),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showResetConfirmation(),
                  icon: const Icon(Icons.delete_forever),
                  label: const Text('Reset DB'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.alertRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDiagnosticRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 11,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppPalette.darkGrey,
        title: const Text(
          'Reset Database?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will delete all local data and create a fresh database. '
          'A backup of the current database will be created first.\n\n'
          'This action cannot be undone.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _attemptRecovery(resetDatabase: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPalette.alertRed,
            ),
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../../services/newsletter_import_service.dart';
import '../../theme/app_theme.dart';
import '../../database/app_database.dart';

class ImportNewsletterSheet extends StatefulWidget {
  const ImportNewsletterSheet({super.key});

  @override
  State<ImportNewsletterSheet> createState() => _ImportNewsletterSheetState();
}

class _ImportNewsletterSheetState extends State<ImportNewsletterSheet> {
  bool _isImporting = false;
  String? _selectedFilePath;
  String? _errorMessage;
  int? _announcementsCreated;

  Future<void> _pickAndImportPdf() async {
    // Capture context-dependent values before any async operations
    final db = context.read<AppDatabase>();
    final messenger = ScaffoldMessenger.of(context);
    final successColor = Theme.of(context).extension<StatusColors>()!.success;

    setState(() {
      _isImporting = true;
      _errorMessage = null;
      _announcementsCreated = null;
    });

    try {
      // Pick PDF file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result == null || result.files.isEmpty) {
        setState(() {
          _isImporting = false;
        });
        return;
      }

      final filePath = result.files.single.path;
      if (filePath == null) {
        setState(() {
          _isImporting = false;
          _errorMessage = 'Could not get file path';
        });
        return;
      }

      setState(() {
        _selectedFilePath = filePath;
      });

      // Import using service
      final service = NewsletterImportService(db);
      final count = await service.importFromPdf(filePath);

      setState(() {
        _isImporting = false;
        _announcementsCreated = count;
      });

      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content:
                Text('✓ Imported $count announcement(s) • Feed updating...'),
            backgroundColor: successColor,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isImporting = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.upload_file,
                    color: theme.colorScheme.primary, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Import Newsletter',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(Icons.close,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Instructions
            Text(
              'Select a PDF newsletter file to import announcements into the company feed.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 24),

            // File path display
            if (_selectedFilePath != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.dividerColor),
                ),
                child: Row(
                  children: [
                    Icon(Icons.description,
                        color: theme.colorScheme.primary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _selectedFilePath!.split('\\').last,
                        style: theme.textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Error message
            if (_errorMessage != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.colorScheme.error),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline,
                        color: theme.colorScheme.error, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Success message
            if (_announcementsCreated != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .extension<StatusColors>()!
                      .success
                      .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color:
                          Theme.of(context).extension<StatusColors>()!.success),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: Theme.of(context)
                            .extension<StatusColors>()!
                            .success,
                        size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Successfully created $_announcementsCreated announcement(s)',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context)
                              .extension<StatusColors>()!
                              .success,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Import button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isImporting ? null : _pickAndImportPdf,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isImporting
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.onSurface),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.upload_file,
                              color: theme.colorScheme.onSurface),
                          const SizedBox(width: 8),
                          Text(
                            'Select PDF File',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            // Quick import button (if file path was provided)
            if (_selectedFilePath != null && _announcementsCreated == null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isImporting
                      ? null
                      : () async {
                          try {
                            // Capture context-dependent values before async
                            final db = context.read<AppDatabase>();
                            final navigator = Navigator.of(context);
                            final messenger = ScaffoldMessenger.of(context);
                            final successColor = Theme.of(context)
                                .extension<StatusColors>()!
                                .success;

                            setState(() {
                              _isImporting = true;
                              _errorMessage = null;
                            });

                            final service = NewsletterImportService(db);
                            final count =
                                await service.importFromPdf(_selectedFilePath!);

                            setState(() {
                              _isImporting = false;
                              _announcementsCreated = count;
                            });

                            if (mounted) {
                              navigator.pop(true); // Return true to refresh
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '✓ Imported $count announcement(s) • Feed updating...'),
                                  backgroundColor: successColor,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          } catch (e) {
                            setState(() {
                              _isImporting = false;
                              _errorMessage = e.toString();
                            });
                          }
                        },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: theme.colorScheme.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Import from Selected File',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/application.dart';

class CreateAnnouncementSheet extends StatefulWidget {
  const CreateAnnouncementSheet({super.key});

  @override
  State<CreateAnnouncementSheet> createState() => _CreateAnnouncementSheetState();
}

class _CreateAnnouncementSheetState extends State<CreateAnnouncementSheet> {
  final _formKey = GlobalKey<FormState>();
  String _category = 'general';
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _actionLabelController = TextEditingController();

  final Map<String, IconData> _categoryIcons = {
    'general': Icons.info_outline,
    'hr': Icons.people_outline,
    'safety': Icons.health_and_safety,
    'fleet': Icons.local_shipping,
  };

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _actionLabelController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    // Rule B: Use AnnouncementService instead of direct DB writes
    final announcementService = context.read<AnnouncementService>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final result = await announcementService.create(CreateAnnouncement(
      category: _category,
      title: _titleController.text,
      body: _bodyController.text,
      actionLabel: _actionLabelController.text.isEmpty ? null : _actionLabelController.text,
    ));

    if (!mounted) return;

    switch (result) {
      case Ok():
        navigator.pop(true); // Return true to indicate success
        messenger.showSnackBar(
          const SnackBar(
            content: Text('✓ Announcement posted • Feed updating...'),
            duration: Duration(seconds: 2),
          ),
        );
      case Err(failure: final f):
        messenger.showSnackBar(
          SnackBar(
            content: Text('Error: ${f.message}'),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Fit content
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'New Announcement',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Category Selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _categoryIcons.entries.map((entry) {
                  final isSelected = _category == entry.key;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: FilterChip(
                      selected: isSelected,
                      label: Text(entry.key.toUpperCase()),
                      avatar: Icon(entry.value, size: 16, color: isSelected ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                      onSelected: (selected) {
                        setState(() => _category = entry.key);
                      },
                      checkmarkColor: theme.colorScheme.onSurface,
                      selectedColor: theme.colorScheme.primary,
                      backgroundColor: theme.scaffoldBackgroundColor,
                      labelStyle: TextStyle(
                        color: isSelected ? theme.colorScheme.onSurface : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Title Input
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Headline',
                hintText: 'e.g. Winter Weather Advisory',
                prefixIcon: Icon(Icons.title),
              ),
              validator: (value) => value == null || value.isEmpty ? 'Please enter a headline' : null,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Body Input
            TextFormField(
              controller: _bodyController,
              decoration: const InputDecoration(
                labelText: 'Message Body',
                hintText: 'Full details of the announcement...',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.notes),
              ),
              maxLines: 4,
              validator: (value) => value == null || value.isEmpty ? 'Please enter message details' : null,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Action Label (Optional)
            TextFormField(
              controller: _actionLabelController,
              decoration: const InputDecoration(
                labelText: 'Action Button Label (Optional)',
                hintText: 'e.g. VIEW POLICY, ACKNOWLEDGE',
                prefixIcon: Icon(Icons.touch_app),
              ),
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.send),
                label: const Text('POST ANNOUNCEMENT'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onSurface,
                ),
              ),
            ),
            // Add padding for keyboard if needed, though this is usually handled by Scaffold
            Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom)),
          ],
        ),
      ),
    );
  }
}

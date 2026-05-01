import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../database/app_database.dart';
import '../../application/application.dart';

class NewNoteSheet extends StatefulWidget {
  const NewNoteSheet({super.key});

  @override
  State<NewNoteSheet> createState() => _NewNoteSheetState();
}

class _NewNoteSheetState extends State<NewNoteSheet> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  String _selectedNoteType = 'general';
  int? _selectedSiteId;
  int? _selectedWorkOrderId;
  List<Site> _sites = [];
  List<WorkOrder> _workOrders = [];

  @override
  void initState() {
    super.initState();
    _loadSitesAndWorkOrders();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadSitesAndWorkOrders() async {
    final db = context.read<AppDatabase>();
    final sites = await db.getAllSites();
    final workOrders = await db.getAllWorkOrders();

    if (mounted) {
      setState(() {
        _sites = sites;
        _workOrders = workOrders.where((wo) => wo.status == 'open').toList();
        // Default to first site if available
        if (_sites.isNotEmpty && _selectedSiteId == null) {
          _selectedSiteId = _sites.first.id;
        }
      });
    }
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedSiteId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a site'), backgroundColor: Colors.red),
      );
      return;
    }

    // Rule B: Use NoteService instead of direct DB writes
    final noteService = context.read<NoteService>();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final result = await noteService.create(CreateNote(
      siteId: _selectedSiteId!,
      noteType: _selectedNoteType,
      noteText: _noteController.text.trim(),
      workOrderId: _selectedWorkOrderId,
    ));

    if (!mounted) return;

    switch (result) {
      case Ok():
        navigator.pop();
        messenger.showSnackBar(
          const SnackBar(
            content: Text('✓ Note saved successfully'),
            backgroundColor: Colors.green,
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
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Icon(Icons.note_add,
                        color: theme.colorScheme.primary, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'New Note',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
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
              ),
              Divider(color: theme.dividerColor, height: 1),
              // Form
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    children: [
                      // Note Type
                      Text(
                        'Note Type',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(
                              value: 'general', label: Text('General')),
                          ButtonSegment(value: 'poi', label: Text('POI')),
                          ButtonSegment(
                              value: 'warning', label: Text('Warning')),
                        ],
                        selected: {_selectedNoteType},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            _selectedNoteType = newSelection.first;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      // Site Selection
                      Text(
                        'Site *',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        initialValue: _selectedSiteId,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                        ),
                        dropdownColor: theme.colorScheme.surface,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        items: _sites.map((site) {
                          return DropdownMenuItem(
                            value: site.id,
                            child: Text(site.branchName),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedSiteId = value;
                            // Clear work order if site changes
                            _selectedWorkOrderId = null;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      // Work Order Selection (Optional)
                      Text(
                        'Work Order (Optional)',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        initialValue: _selectedWorkOrderId,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          hintText: 'None',
                          hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        dropdownColor: theme.colorScheme.surface,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        items: [
                          const DropdownMenuItem<int>(
                            value: null,
                            child: Text('None'),
                          ),
                          ..._workOrders.map((wo) {
                            return DropdownMenuItem(
                              value: wo.id,
                              child: Text(
                                  'WO-${wo.id}: ${wo.descriptionOfWork ?? "No description"}'),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedWorkOrderId = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      // Note Text
                      Text(
                        'Note Text *',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _noteController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          hintText: 'Enter your note...',
                          hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter note text';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveNote,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Save Note',
                            style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

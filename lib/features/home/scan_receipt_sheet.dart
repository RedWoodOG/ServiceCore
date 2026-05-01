import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../application/application.dart';
import '../../database/app_database.dart';

class ScanReceiptSheet extends StatefulWidget {
  const ScanReceiptSheet({super.key});

  @override
  State<ScanReceiptSheet> createState() => _ScanReceiptSheetState();
}

class _ScanReceiptSheetState extends State<ScanReceiptSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _vendorController = TextEditingController();
  final _notesController = TextEditingController();

  XFile? _selectedImage;
  String? _selectedCategory;
  DateTime? _receiptDate;
  int? _selectedSiteId;
  int? _selectedWorkOrderId;
  List<Site> _sites = [];
  List<WorkOrder> _workOrders = [];

  final List<String> _categories = [
    'Fuel',
    'Meals',
    'Supplies',
    'Tools',
    'Parts',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _receiptDate = DateTime.now();
    _loadSitesAndWorkOrders();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _vendorController.dispose();
    _notesController.dispose();
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
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null && mounted) {
        setState(() {
          _selectedImage = image;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error picking image: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _saveReceipt() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select or take a photo'),
            backgroundColor: Colors.red),
      );
      return;
    }

    // Capture context values before async gap (Rule B: use services)
    final documentService = context.read<DocumentService>();
    final noteService = context.read<NoteService>();
    final messenger = ScaffoldMessenger.of(context);

    // Validate: need at least a site for receipts
    if (_selectedSiteId == null && _selectedWorkOrderId == null) {
      messenger.showSnackBar(
        const SnackBar(
            content: Text('Please select a site or work order'),
            backgroundColor: Colors.orange),
      );
      // Allow saving anyway - document will be orphaned but still accessible
    }

    try {
      // Use DocumentService to attach receipt photo
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final result = await documentService.attachDocument(AttachDocument(
        sourceFilePath: _selectedImage!.path,
        fileName: 'receipt_$timestamp',
        workOrderId: _selectedWorkOrderId,
        siteId: _selectedSiteId,
      ));

      switch (result) {
        case Err(failure: final f):
          messenger.showSnackBar(
            SnackBar(content: Text('Error: ${f.message}'), backgroundColor: Colors.red),
          );
          return;
        case Ok():
          break; // Continue to save notes
      }

      // Save metadata as note if provided (Rule B: use NoteService)
      if (_amountController.text.isNotEmpty ||
          _vendorController.text.isNotEmpty ||
          _notesController.text.isNotEmpty) {
        final noteText = StringBuffer();
        if (_amountController.text.isNotEmpty) {
          noteText.writeln('Amount: \$${_amountController.text}');
        }
        if (_vendorController.text.isNotEmpty) {
          noteText.writeln('Vendor: ${_vendorController.text}');
        }
        if (_selectedCategory != null) {
          noteText.writeln('Category: $_selectedCategory');
        }
        if (_receiptDate != null) {
          noteText.writeln('Date: ${_receiptDate!.toString().split(' ')[0]}');
        }
        if (_notesController.text.isNotEmpty) {
          noteText.writeln('Notes: ${_notesController.text}');
        }

        // Use NoteService for metadata note
        if (_selectedSiteId != null) {
          final noteResult = await noteService.create(CreateNote(
            siteId: _selectedSiteId!,
            noteType: 'general',
            noteText: noteText.toString(),
            workOrderId: _selectedWorkOrderId,
          ));
          // Log but don't fail if note creation fails - receipt photo already saved
          if (noteResult case Err(failure: final f)) {
            messenger.showSnackBar(
              SnackBar(
                content: Text('Note saved but metadata failed: ${f.message}'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      }

      if (mounted) {
        Navigator.pop(context);
        messenger.showSnackBar(
          const SnackBar(
            content: Text('✓ Receipt saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
              content: Text('Error saving receipt: $e'),
              backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _receiptDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child!,
        );
      },
    );
    if (picked != null && mounted) {
      setState(() {
        _receiptDate = picked;
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
      child: DraggableScrollableSheet(
        initialChildSize: 0.8,
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
                    Icon(Icons.camera_alt,
                        color: theme.colorScheme.primary, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Scan Receipt',
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
                      // Image Picker
                      Text(
                        'Receipt Photo *',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _pickImage(ImageSource.camera),
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Take Photo'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                                side: BorderSide(color: theme.dividerColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _pickImage(ImageSource.gallery),
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Choose from Gallery'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                                side: BorderSide(color: theme.dividerColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_selectedImage != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_selectedImage!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                          label: const Text('Remove Photo',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ],
                      const SizedBox(height: 24),
                      // Amount
                      Text(
                        'Amount',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          prefixText: '\$ ',
                          hintText: '0.00',
                          hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      const SizedBox(height: 16),
                      // Category
                      Text(
                        'Category',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedCategory,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          hintText: 'Select category',
                          hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        dropdownColor: theme.colorScheme.surface,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        items: _categories.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Text(cat),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Date
                      Text(
                        'Receipt Date',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: _selectDate,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _receiptDate != null
                                    ? '${_receiptDate!.year}-${_receiptDate!.month.toString().padLeft(2, '0')}-${_receiptDate!.day.toString().padLeft(2, '0')}'
                                    : 'Select date',
                                style: TextStyle(
                                  color: _receiptDate != null
                                      ? theme.colorScheme.onSurface
                                      : theme.colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                ),
                              ),
                              Icon(Icons.calendar_today,
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                  size: 20),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Vendor
                      Text(
                        'Vendor/Merchant',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _vendorController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          hintText: 'Store name',
                          hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      const SizedBox(height: 16),
                      // Site (Optional)
                      Text(
                        'Site (Optional)',
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
                          ..._sites.map((site) {
                            return DropdownMenuItem(
                              value: site.id,
                              child: Text(site.branchName),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedSiteId = value;
                            _selectedWorkOrderId = null;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      // Work Order (Optional)
                      if (_selectedSiteId != null) ...[
                        Text(
                          'Work Order (Optional)',
                          style: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7),
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
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7)),
                          ),
                          dropdownColor: theme.colorScheme.surface,
                          style: TextStyle(color: theme.colorScheme.onSurface),
                          items: [
                            const DropdownMenuItem<int>(
                              value: null,
                              child: Text('None'),
                            ),
                            ..._workOrders
                                .where((wo) => wo.siteId == _selectedSiteId)
                                .map((wo) {
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
                        const SizedBox(height: 16),
                      ],
                      // Notes
                      Text(
                        'Notes',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _notesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          hintText: 'Additional notes...',
                          hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      const SizedBox(height: 32),
                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveReceipt,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Save Receipt',
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

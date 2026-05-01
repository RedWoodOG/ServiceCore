import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../../application/application.dart';
import '../../database/app_database.dart';
import '../../config/app_constants.dart';

class CreateWorkOrderSheet extends StatefulWidget {
  const CreateWorkOrderSheet({super.key});

  @override
  State<CreateWorkOrderSheet> createState() => _CreateWorkOrderSheetState();
}

class _CreateWorkOrderSheetState extends State<CreateWorkOrderSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _specialInstructionsController = TextEditingController();
  final _internalNotesController = TextEditingController();
  final _assignedTechnicianController = TextEditingController();
  final _customerReferenceController = TextEditingController();
  final _internalReferenceController = TextEditingController();
  final _checklistController = TextEditingController();

  int? _selectedClientId;
  int? _selectedSiteId;
  String _selectedStatus = 'open';
  String? _selectedPriority;
  List<Site> _sites = [];
  List<Client> _clients = [];
  List<EquipmentData> _availableEquipment = [];
  List<int> _selectedEquipmentIds = [];
  final List<XFile> _selectedPhotos = [];
  final List<File> _selectedDocuments = [];
  Site? _selectedSite;
  Client? _selectedClient;
  bool _isLoading = false;
  bool _showAddEquipmentForm = false;
  bool _showAddLocationForm = false;

  // New location form fields
  final _newLocationBranchNameController = TextEditingController();
  final _newLocationAddressController = TextEditingController();
  final _newLocationLatitudeController = TextEditingController();
  final _newLocationLongitudeController = TextEditingController();
  final _newLocationRegionController = TextEditingController();

  // New equipment form fields
  final _newEquipmentTypeController = TextEditingController();
  final _newEquipmentManufacturerController = TextEditingController();
  final _newEquipmentModelController = TextEditingController();
  final _newEquipmentSerialController = TextEditingController();
  bool _newEquipmentUnderWarranty = false;
  bool _newEquipmentUnderServiceContract = false;

  final List<String> _statusOptions = ['open', 'on_hold', 'completed'];
  final List<String> _priorityOptions = [
    'low',
    'normal',
    'medium',
    'high',
    'urgent'
  ];

  @override
  void initState() {
    super.initState();
    _loadSites();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _specialInstructionsController.dispose();
    _internalNotesController.dispose();
    _assignedTechnicianController.dispose();
    _customerReferenceController.dispose();
    _internalReferenceController.dispose();
    _checklistController.dispose();
    _newEquipmentTypeController.dispose();
    _newEquipmentManufacturerController.dispose();
    _newEquipmentModelController.dispose();
    _newEquipmentSerialController.dispose();
    _newLocationBranchNameController.dispose();
    _newLocationAddressController.dispose();
    _newLocationLatitudeController.dispose();
    _newLocationLongitudeController.dispose();
    _newLocationRegionController.dispose();
    super.dispose();
  }

  Future<void> _loadSites() async {
    final db = context.read<AppDatabase>();
    final clients = await db.getAllClients();

    if (mounted) {
      setState(() {
        _clients = clients;
        // Default to first client if available
        if (_clients.isNotEmpty && _selectedClientId == null) {
          _selectedClientId = _clients.first.id;
          _selectedClient = _clients.first;
          _loadSitesForClient(_selectedClientId!);
        }
      });
    }
  }

  Future<void> _loadSitesForClient(int clientId) async {
    final db = context.read<AppDatabase>();
    final sites = await db.getSitesByClient(clientId);

    if (mounted) {
      setState(() {
        _sites = sites;
        _selectedSiteId = null;
        _selectedSite = null;
        _availableEquipment = [];
        _selectedEquipmentIds = [];
        // Default to first site if available
        if (_sites.isNotEmpty && _selectedSiteId == null) {
          _selectedSiteId = _sites.first.id;
          _selectedSite = _sites.first;
          _loadEquipmentForSite(_selectedSiteId!);
        }
      });
    }
  }

  Future<void> _loadEquipmentForSite(int siteId) async {
    final db = context.read<AppDatabase>();
    final equipment = await db.getEquipmentBySite(siteId);

    if (mounted) {
      setState(() {
        _availableEquipment = equipment;
        _selectedEquipmentIds = []; // Reset selection when site changes
      });
    }
  }

  Future<void> _saveWorkOrder() async {
    // Capture context-dependent values before any async operations
    final db = context.read<AppDatabase>();
    final messenger = ScaffoldMessenger.of(context);
    final locationService = context.read<LocationService>();
    final workOrderService = context.read<WorkOrderService>();
    final equipmentService = context.read<EquipmentService>();
    final documentService = context.read<DocumentService>();

    if (!_formKey.currentState!.validate()) return;
    if (_selectedClientId == null) {
      messenger.showSnackBar(
        const SnackBar(
            content: Text('Please select a company'),
            backgroundColor: Colors.red),
      );
      return;
    }

    // Create new location if form is shown
    int? finalSiteId = _selectedSiteId;
    if (_showAddLocationForm) {
      if (_newLocationBranchNameController.text.trim().isEmpty ||
          _newLocationAddressController.text.trim().isEmpty ||
          _newLocationRegionController.text.trim().isEmpty) {
        messenger.showSnackBar(
          const SnackBar(
              content: Text('Please fill in Branch Name, Address, and Region'),
              backgroundColor: Colors.red),
        );
        return;
      }

      // Parse lat/lon if provided, otherwise use default coordinates from AppConstants
      double lat = AppConstants.defaultMapLat;
      double lon = AppConstants.defaultMapLng;

      final latText = _newLocationLatitudeController.text.trim();
      final lonText = _newLocationLongitudeController.text.trim();

      if (latText.isNotEmpty) {
        final parsedLat = double.tryParse(latText);
        if (parsedLat != null && parsedLat >= -90 && parsedLat <= 90) {
          lat = parsedLat;
        }
      }

      if (lonText.isNotEmpty) {
        final parsedLon = double.tryParse(lonText);
        if (parsedLon != null && parsedLon >= -180 && parsedLon <= 180) {
          lon = parsedLon;
        }
      }

      // Use LocationService instead of direct DB write
      final siteResult = await locationService.create(CreateSite(
        clientId: _selectedClientId!,
        branchName: _newLocationBranchNameController.text.trim(),
        address: _newLocationAddressController.text.trim(),
        latitude: lat,
        longitude: lon,
        region: _newLocationRegionController.text.trim(),
      ));

      switch (siteResult) {
        case Ok(value: final id):
          finalSiteId = id;
        case Err(failure: final f):
          messenger.showSnackBar(
            SnackBar(content: Text('Error creating location: ${f.message}'), backgroundColor: Colors.red),
          );
          return;
      }
    }

    if (finalSiteId == null) {
      messenger.showSnackBar(
        const SnackBar(
            content: Text('Please select or add a location'),
            backgroundColor: Colors.red),
      );
      return;
    }

    final int siteId = finalSiteId; // Non-nullable for use below

    setState(() {
      _isLoading = true;
    });

    try {
      // Combine special instructions and checklist into description if description is empty
      String? finalDescription = _descriptionController.text.trim();
      if (finalDescription.isEmpty) {
        final parts = <String>[];
        if (_specialInstructionsController.text.trim().isNotEmpty) {
          parts.add(
              'Special Instructions: ${_specialInstructionsController.text.trim()}');
        }
        if (_checklistController.text.trim().isNotEmpty) {
          parts.add('Checklist:\n${_checklistController.text.trim()}');
        }
        finalDescription = parts.isEmpty ? null : parts.join('\n\n');
      } else {
        // Append special instructions and checklist if description exists
        final parts = <String>[finalDescription];
        if (_specialInstructionsController.text.trim().isNotEmpty) {
          parts.add(
              '\n\nSpecial Instructions: ${_specialInstructionsController.text.trim()}');
        }
        if (_checklistController.text.trim().isNotEmpty) {
          parts.add('\n\nChecklist:\n${_checklistController.text.trim()}');
        }
        finalDescription = parts.join('');
      }

      // Combine internal reference into internal notes
      String? finalInternalNotes = _internalNotesController.text.trim();
      if (_internalReferenceController.text.trim().isNotEmpty) {
        final refNote =
            'Internal Reference: ${_internalReferenceController.text.trim()}';
        finalInternalNotes = finalInternalNotes.isEmpty
            ? refNote
            : '$refNote\n\n$finalInternalNotes';
      }

      // Use WorkOrderService instead of direct DB write
      final woResult = await workOrderService.create(CreateWorkOrder(
        siteId: siteId,
        status: _selectedStatus,
        priority: _selectedPriority,
        descriptionOfWork: finalDescription,
        internalNotes: finalInternalNotes.isEmpty ? null : finalInternalNotes,
        assignedTechnician: _assignedTechnicianController.text.trim().isEmpty
            ? null
            : _assignedTechnicianController.text.trim(),
      ));

      int workOrderId;
      switch (woResult) {
        case Ok(value: final id):
          workOrderId = id;
        case Err(failure: final f):
          if (mounted) {
            messenger.showSnackBar(
              SnackBar(content: Text('Error creating work order: ${f.message}'), backgroundColor: Colors.red),
            );
          }
          return;
      }

      // Create new equipment if any was added
      final newEquipmentIds = <int>[];
      if (_showAddEquipmentForm &&
          _newEquipmentTypeController.text.trim().isNotEmpty) {
        // Use EquipmentService instead of direct DB write
        final eqResult = await equipmentService.create(CreateEquipment(
          siteId: siteId,
          equipmentType: _newEquipmentTypeController.text.trim(),
          manufacturer: _newEquipmentManufacturerController.text.trim().isEmpty
              ? null
              : _newEquipmentManufacturerController.text.trim(),
          model: _newEquipmentModelController.text.trim().isEmpty
              ? null
              : _newEquipmentModelController.text.trim(),
          serialNumber: _newEquipmentSerialController.text.trim().isEmpty
              ? null
              : _newEquipmentSerialController.text.trim(),
          underWarranty: _newEquipmentUnderWarranty,
          underServiceContract: _newEquipmentUnderServiceContract,
        ));

        switch (eqResult) {
          case Ok(value: final id):
            newEquipmentIds.add(id);
          case Err(failure: final f):
            // Non-fatal - log but continue
            debugPrint('Warning: Failed to create equipment: ${f.message}');
        }
      }

      // Link selected equipment to work order (including newly created)
      // Note: linkEquipment is a query helper, not yet a service method
      for (final equipmentId in [
        ..._selectedEquipmentIds,
        ...newEquipmentIds
      ]) {
        await db.linkEquipmentToWorkOrder(workOrderId, equipmentId);
      }

      // Save photos/documents using DocumentService
      for (final photo in _selectedPhotos) {
        final result = await documentService.attachPhoto(AttachPhoto(
          sourceFilePath: photo.path,
          workOrderId: workOrderId,
          siteId: siteId,
        ));
        if (result case Err(failure: final f)) {
          debugPrint('Warning: Failed to attach photo: ${f.message}');
        }
      }

      for (final doc in _selectedDocuments) {
        final docName = path.basename(doc.path);
        final result = await documentService.attachDocument(AttachDocument(
          sourceFilePath: doc.path,
          fileName: docName,
          workOrderId: workOrderId,
          siteId: siteId,
        ));
        if (result case Err(failure: final f)) {
          debugPrint('Warning: Failed to attach document: ${f.message}');
        }
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_showAddLocationForm
                ? '✓ New location added and work order created successfully'
                : '✓ Work order created successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error creating work order: $e'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
        initialChildSize: 0.85,
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
                    Icon(Icons.work_outline,
                        color: theme.colorScheme.primary, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Create Work Order',
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
                      // Client Selection (Required)
                      Text(
                        'Company/Client *',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<int>(
                        initialValue: _selectedClientId,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          hintText: 'Select a company',
                          hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        dropdownColor: theme.colorScheme.surface,
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        items: _clients.map((client) {
                          return DropdownMenuItem(
                            value: client.id,
                            child: Text(client.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedClientId = value;
                            _selectedClient = _clients
                                .cast<Client?>()
                                .firstWhere((c) => c!.id == value,
                                    orElse: () => null);
                            _selectedSiteId = null;
                            _selectedSite = null;
                            _showAddLocationForm = false;
                            if (value != null) {
                              _loadSitesForClient(value);
                            }
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a company';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      // Site Selection (Required)
                      Text(
                        'Location/Branch *',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      if (!_showAddLocationForm) ...[
                        DropdownButtonFormField<int>(
                          initialValue: _selectedSiteId,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: theme.scaffoldBackgroundColor,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: theme.dividerColor),
                            ),
                            hintText: _selectedClientId == null
                                ? 'Select company first'
                                : _sites.isEmpty
                                    ? 'No locations found'
                                    : 'Select a location',
                            hintStyle: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7)),
                          ),
                          dropdownColor: theme.colorScheme.surface,
                          style: TextStyle(color: theme.colorScheme.onSurface),
                          items: _sites.map((site) {
                            return DropdownMenuItem(
                              value: site.id,
                              child: Text(site.branchName),
                            );
                          }).toList(),
                          onChanged: _selectedClientId == null
                              ? null
                              : (value) {
                                  setState(() {
                                    _selectedSiteId = value;
                                    _selectedSite = _sites
                                        .cast<Site?>()
                                        .firstWhere((s) => s!.id == value,
                                            orElse: () => null);
                                    if (value != null) {
                                      _loadEquipmentForSite(value);
                                    }
                                  });
                                },
                          validator: (value) {
                            if (!_showAddLocationForm && value == null) {
                              return 'Please select or add a location';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        if (_selectedClientId != null)
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _showAddLocationForm = true;
                                _selectedSiteId = null;
                                _selectedSite = null;
                              });
                            },
                            icon: const Icon(Icons.add_location),
                            label: const Text('Add New Location'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.primary,
                              side: BorderSide(color: theme.dividerColor),
                            ),
                          ),
                      ] else ...[
                        // Add New Location Form
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: theme.colorScheme.primary, width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'New Location Details',
                                    style: TextStyle(
                                      color: theme.colorScheme.primary,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  IconButton(
                                    icon: const Icon(Icons.close, size: 20),
                                    onPressed: () {
                                      setState(() {
                                        _showAddLocationForm = false;
                                        _newLocationBranchNameController
                                            .clear();
                                        _newLocationAddressController.clear();
                                        _newLocationLatitudeController.clear();
                                        _newLocationLongitudeController.clear();
                                        _newLocationRegionController.clear();
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              // Branch Name
                              TextFormField(
                                controller: _newLocationBranchNameController,
                                decoration: InputDecoration(
                                  labelText: 'Branch Name *',
                                  filled: true,
                                  fillColor: theme.colorScheme.surface,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: theme.dividerColor),
                                  ),
                                ),
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface),
                                validator: (value) {
                                  if (_showAddLocationForm &&
                                      (value == null || value.trim().isEmpty)) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              // Address
                              TextFormField(
                                controller: _newLocationAddressController,
                                decoration: InputDecoration(
                                  labelText: 'Address *',
                                  filled: true,
                                  fillColor: theme.colorScheme.surface,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: theme.dividerColor),
                                  ),
                                ),
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface),
                                validator: (value) {
                                  if (_showAddLocationForm &&
                                      (value == null || value.trim().isEmpty)) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              // Latitude & Longitude
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          _newLocationLatitudeController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration: InputDecoration(
                                        labelText: 'Latitude',
                                        filled: true,
                                        fillColor: theme.colorScheme.surface,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: theme.dividerColor),
                                        ),
                                        hintText: '29.424 (optional)',
                                        helperText:
                                            'Can be updated later from map',
                                      ),
                                      style: TextStyle(
                                          color: theme.colorScheme.onSurface),
                                      validator: (value) {
                                        if (_showAddLocationForm &&
                                            value != null &&
                                            value.trim().isNotEmpty) {
                                          final lat = double.tryParse(value);
                                          if (lat == null ||
                                              lat < -90 ||
                                              lat > 90) {
                                            return 'Invalid';
                                          }
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          _newLocationLongitudeController,
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                              decimal: true),
                                      decoration: InputDecoration(
                                        labelText: 'Longitude',
                                        filled: true,
                                        fillColor: theme.colorScheme.surface,
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: theme.dividerColor),
                                        ),
                                        hintText: '-98.493 (optional)',
                                        helperText:
                                            'Can be updated later from map',
                                      ),
                                      style: TextStyle(
                                          color: theme.colorScheme.onSurface),
                                      validator: (value) {
                                        if (_showAddLocationForm &&
                                            value != null &&
                                            value.trim().isNotEmpty) {
                                          final lon = double.tryParse(value);
                                          if (lon == null ||
                                              lon < -180 ||
                                              lon > 180) {
                                            return 'Invalid';
                                          }
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Helper text and button
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Tip: Coordinates can be added later from the Locations map view',
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.4),
                                        fontSize: 11,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              // Region
                              TextFormField(
                                controller: _newLocationRegionController,
                                decoration: InputDecoration(
                                  labelText: 'Region *',
                                  filled: true,
                                  fillColor: theme.colorScheme.surface,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: theme.dividerColor),
                                  ),
                                  hintText: 'North, South, Central, etc.',
                                ),
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface),
                                validator: (value) {
                                  if (_showAddLocationForm &&
                                      (value == null || value.trim().isEmpty)) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.3)),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline,
                                        size: 16,
                                        color: theme.colorScheme.primary),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Coordinates are optional. If not provided, they will default to the map center. You can update them later from the Locations map view by selecting the site and editing its coordinates.',
                                        style: TextStyle(
                                          color: theme.colorScheme.onSurface,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      // Status Selection (Required)
                      Text(
                        'Status *',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      SegmentedButton<String>(
                        segments: _statusOptions.map((status) {
                          return ButtonSegment<String>(
                            value: status,
                            label:
                                Text(status.replaceAll('_', ' ').toUpperCase()),
                          );
                        }).toList(),
                        selected: {_selectedStatus},
                        onSelectionChanged: (Set<String> newSelection) {
                          setState(() {
                            _selectedStatus = newSelection.first;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      // Priority Selection (Optional)
                      Text(
                        'Priority',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedPriority,
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
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('None'),
                          ),
                          ..._priorityOptions.map((priority) {
                            return DropdownMenuItem(
                              value: priority,
                              child: Text(priority.toUpperCase()),
                            );
                          }),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedPriority = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      // Customer Information Display (Read-only)
                      if (_selectedClient != null &&
                          (!_showAddLocationForm && _selectedSite != null)) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Customer Information',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Customer: ${_selectedClient!.name}',
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                    fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Site: ${_selectedSite!.branchName}',
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                    fontSize: 12),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Address: ${_selectedSite!.address}',
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ] else if (_selectedClient != null &&
                          _showAddLocationForm) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: theme.colorScheme.primary, width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New Location for:',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Customer: ${_selectedClient!.name}',
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                    fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      // Description of Work (Optional)
                      Text(
                        'Description of Work *',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          hintText: 'Describe the work to be performed...',
                          hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      const SizedBox(height: 24),
                      // Special Instructions (Optional)
                      Text(
                        'Special Instructions',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _specialInstructionsController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          hintText:
                              'Special instructions for the technician...',
                          hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      const SizedBox(height: 24),
                      // Checklist (Optional)
                      Text(
                        'Checklist',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _checklistController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          hintText: 'Enter checklist items (one per line)...',
                          hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      const SizedBox(height: 24),
                      // Equipment Selection (Optional)
                      Text(
                        'Equipment (Optional)',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      if (_availableEquipment.isNotEmpty) ...[
                        Container(
                          constraints: const BoxConstraints(maxHeight: 150),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _availableEquipment.length,
                            itemBuilder: (context, index) {
                              final eq = _availableEquipment[index];
                              final isSelected =
                                  _selectedEquipmentIds.contains(eq.id);
                              return CheckboxListTile(
                                title: Text(
                                  '${eq.equipmentType} - ${eq.serialNumber ?? "No S/N"}',
                                  style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                      fontSize: 12),
                                ),
                                subtitle: eq.model != null
                                    ? Text(
                                        '${eq.manufacturer ?? ""} ${eq.model}',
                                        style: TextStyle(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.7),
                                            fontSize: 10),
                                      )
                                    : null,
                                value: isSelected,
                                onChanged: (value) {
                                  setState(() {
                                    if (value == true) {
                                      _selectedEquipmentIds.add(eq.id);
                                    } else {
                                      _selectedEquipmentIds.remove(eq.id);
                                    }
                                  });
                                },
                                activeColor: theme.colorScheme.primary,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      // Add New Equipment Button
                      OutlinedButton.icon(
                        onPressed: () {
                          setState(() {
                            _showAddEquipmentForm = !_showAddEquipmentForm;
                            if (!_showAddEquipmentForm) {
                              // Clear form when hiding
                              _newEquipmentTypeController.clear();
                              _newEquipmentManufacturerController.clear();
                              _newEquipmentModelController.clear();
                              _newEquipmentSerialController.clear();
                              _newEquipmentUnderWarranty = false;
                              _newEquipmentUnderServiceContract = false;
                            }
                          });
                        },
                        icon: Icon(
                            _showAddEquipmentForm ? Icons.remove : Icons.add),
                        label: Text(_showAddEquipmentForm
                            ? 'Cancel Add Equipment'
                            : 'Add New Equipment'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: theme.colorScheme.primary,
                          side: BorderSide(color: theme.dividerColor),
                        ),
                      ),
                      // New Equipment Form
                      if (_showAddEquipmentForm) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.scaffoldBackgroundColor,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: theme.colorScheme.primary, width: 2),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'New Equipment Details',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              // Equipment Type
                              TextFormField(
                                controller: _newEquipmentTypeController,
                                decoration: InputDecoration(
                                  labelText: 'Equipment Type *',
                                  filled: true,
                                  fillColor: theme.colorScheme.surface,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: theme.dividerColor),
                                  ),
                                ),
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface),
                              ),
                              const SizedBox(height: 12),
                              // Manufacturer
                              TextFormField(
                                controller: _newEquipmentManufacturerController,
                                decoration: InputDecoration(
                                  labelText: 'Manufacturer',
                                  filled: true,
                                  fillColor: theme.colorScheme.surface,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: theme.dividerColor),
                                  ),
                                ),
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface),
                              ),
                              const SizedBox(height: 12),
                              // Model
                              TextFormField(
                                controller: _newEquipmentModelController,
                                decoration: InputDecoration(
                                  labelText: 'Model',
                                  filled: true,
                                  fillColor: theme.colorScheme.surface,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: theme.dividerColor),
                                  ),
                                ),
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface),
                              ),
                              const SizedBox(height: 12),
                              // Serial Number
                              TextFormField(
                                controller: _newEquipmentSerialController,
                                decoration: InputDecoration(
                                  labelText: 'Serial Number',
                                  filled: true,
                                  fillColor: theme.colorScheme.surface,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide:
                                        BorderSide(color: theme.dividerColor),
                                  ),
                                ),
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface),
                              ),
                              const SizedBox(height: 12),
                              // Warranty & Service Contract
                              Row(
                                children: [
                                  Expanded(
                                    child: CheckboxListTile(
                                      title: const Text('Under Warranty',
                                          style: TextStyle(fontSize: 12)),
                                      value: _newEquipmentUnderWarranty,
                                      onChanged: (value) {
                                        setState(() {
                                          _newEquipmentUnderWarranty =
                                              value ?? false;
                                        });
                                      },
                                      activeColor: theme.colorScheme.primary,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                  Expanded(
                                    child: CheckboxListTile(
                                      title: const Text(
                                          'Under Service Contract',
                                          style: TextStyle(fontSize: 12)),
                                      value: _newEquipmentUnderServiceContract,
                                      onChanged: (value) {
                                        setState(() {
                                          _newEquipmentUnderServiceContract =
                                              value ?? false;
                                        });
                                      },
                                      activeColor: theme.colorScheme.primary,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      // Assigned Technician (Optional)
                      Text(
                        'Assigned Technician',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _assignedTechnicianController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          hintText: 'Technician name',
                          hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      const SizedBox(height: 24),
                      // Customer Reference / P.O. (Optional)
                      Text(
                        'Customer Reference / P.O.',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _customerReferenceController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          hintText: 'Customer PO number or reference...',
                          hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      const SizedBox(height: 24),
                      // Internal Reference (Optional)
                      Text(
                        'Internal Reference',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _internalReferenceController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          hintText: 'Internal reference number...',
                          hintStyle: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        ),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                      ),
                      const SizedBox(height: 24),
                      // Photos & Documents
                      Text(
                        'Photos & Documents (Optional)',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                    source: ImageSource.camera);
                                if (image != null && mounted) {
                                  setState(() {
                                    _selectedPhotos.add(image);
                                  });
                                }
                              },
                              icon: const Icon(Icons.camera_alt),
                              label: const Text('Take Photo'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                                side: BorderSide(color: theme.dividerColor),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery);
                                if (image != null && mounted) {
                                  setState(() {
                                    _selectedPhotos.add(image);
                                  });
                                }
                              },
                              icon: const Icon(Icons.photo_library),
                              label: const Text('Choose Photo'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                                side: BorderSide(color: theme.dividerColor),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (_selectedPhotos.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              _selectedPhotos.asMap().entries.map((entry) {
                            final index = entry.key;
                            final photo = entry.value;
                            return Stack(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border:
                                        Border.all(color: theme.dividerColor),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      File(photo.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: -4,
                                  right: -4,
                                  child: IconButton(
                                    icon: const Icon(Icons.close,
                                        size: 16, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _selectedPhotos.removeAt(index);
                                      });
                                    },
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                      const SizedBox(height: 24),
                      // Internal Notes (Optional)
                      Text(
                        'Internal Notes',
                        style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _internalNotesController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.scaffoldBackgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: theme.dividerColor),
                          ),
                          hintText: 'Internal notes (not visible to client)...',
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
                          onPressed: _isLoading ? null : _saveWorkOrder,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        theme.colorScheme.onSurface),
                                  ),
                                )
                              : Text(
                                  'Create Work Order',
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

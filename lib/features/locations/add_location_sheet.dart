import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../application/application.dart';
import '../../database/app_database.dart';
import '../../widgets/glass_card.dart';

class AddLocationSheet extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;
  final VoidCallback onLocationAdded;

  const AddLocationSheet({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    required this.onLocationAdded,
  });

  @override
  State<AddLocationSheet> createState() => _AddLocationSheetState();
}

class _AddLocationSheetState extends State<AddLocationSheet> {
  final _formKey = GlobalKey<FormState>();
  final _branchNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _regionController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  List<Client> _clients = [];
  int? _selectedClientId;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLatitude != null) {
      _latitudeController.text = widget.initialLatitude!.toStringAsFixed(6);
    }
    if (widget.initialLongitude != null) {
      _longitudeController.text = widget.initialLongitude!.toStringAsFixed(6);
    }
    _loadClients();
  }

  @override
  void dispose() {
    _branchNameController.dispose();
    _addressController.dispose();
    _regionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _loadClients() async {
    final db = context.read<AppDatabase>();
    final clients = await db.getAllClients();
    if (mounted) {
      setState(() {
        _clients = clients;
        if (_clients.isNotEmpty) {
          _selectedClientId = _clients.first.id;
        }
      });
    }
  }

  Future<void> _saveLocation() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedClientId == null) return;

    setState(() => _isSaving = true);

    // Capture context values before async gap
    final locationService = context.read<LocationService>();
    final messenger = ScaffoldMessenger.of(context);
    final theme = Theme.of(context);

    double lat = widget.initialLatitude ?? 29.531;
    double lon = widget.initialLongitude ?? -98.432;

    final latText = _latitudeController.text.trim();
    final lonText = _longitudeController.text.trim();

    if (latText.isNotEmpty) {
      final parsed = double.tryParse(latText);
      if (parsed != null && parsed >= -90 && parsed <= 90) lat = parsed;
    }
    if (lonText.isNotEmpty) {
      final parsed = double.tryParse(lonText);
      if (parsed != null && parsed >= -180 && parsed <= 180) lon = parsed;
    }

    // Use LocationService instead of direct DB write
    final result = await locationService.create(CreateSite(
      clientId: _selectedClientId!,
      branchName: _branchNameController.text.trim(),
      address: _addressController.text.trim(),
      latitude: lat,
      longitude: lon,
      region: _regionController.text.trim(),
    ));

    if (!mounted) return;

    switch (result) {
      case Ok():
        widget.onLocationAdded();
        Navigator.of(context).pop();
        messenger.showSnackBar(
          SnackBar(
            content: const Text('Location added'),
            backgroundColor: theme.colorScheme.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      case Err(:final failure):
        setState(() => _isSaving = false);
        messenger.showSnackBar(
          SnackBar(
            content: Text('Error: ${failure.message}'),
            backgroundColor: theme.colorScheme.error,
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
        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.4),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: GlassCard(
        borderRadius: 24,
        padding: const EdgeInsets.all(28),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.add_location_alt,
                          color: theme.colorScheme.primary, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Location',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'New site will appear on all maps',
                            style: TextStyle(
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Client picker
                _buildLabel('Company *', theme),
                const SizedBox(height: 6),
                DropdownButtonFormField<int>(
                  initialValue: _selectedClientId,
                  decoration: _inputDecoration(theme, 'Select company'),
                  dropdownColor: theme.colorScheme.surface,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  items: _clients.map((c) {
                    return DropdownMenuItem(value: c.id, child: Text(c.name));
                  }).toList(),
                  onChanged: (v) => setState(() => _selectedClientId = v),
                  validator: (v) => v == null ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Branch name
                _buildLabel('Branch Name *', theme),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _branchNameController,
                  decoration: _inputDecoration(theme, 'e.g. Main Branch #1234'),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Address
                _buildLabel('Address *', theme),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _addressController,
                  decoration:
                      _inputDecoration(theme, '123 Main St, San Antonio, TX'),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Region
                _buildLabel('Region *', theme),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _regionController,
                  decoration: _inputDecoration(theme, 'e.g. San Antonio'),
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 16),

                // Coordinates row
                _buildLabel('Coordinates (optional)', theme),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _latitudeController,
                        decoration: _inputDecoration(theme, 'Latitude'),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _longitudeController,
                        decoration: _inputDecoration(theme, 'Longitude'),
                        style: TextStyle(color: theme.colorScheme.onSurface),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: true),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Tip: Leave blank to use the default map center. You can drag the pin later.',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 28),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _isSaving ? null : _saveLocation,
                    icon: _isSaving
                        ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: theme.colorScheme.onPrimary,
                            ),
                          )
                        : const Icon(Icons.check),
                    label: Text(_isSaving ? 'Saving...' : 'Add Location'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      foregroundColor: theme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, ThemeData theme) {
    return Text(
      text,
      style: TextStyle(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  InputDecoration _inputDecoration(ThemeData theme, String hint) {
    return InputDecoration(
      filled: true,
      fillColor: theme.colorScheme.surface.withValues(alpha: 0.5),
      hintText: hint,
      hintStyle: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.3)),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.dividerColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    );
  }
}

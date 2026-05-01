import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../database/app_database.dart';
import '../../theme/app_theme.dart';
import '../../widgets/glass_card.dart';

class UserDetailsDialog extends StatefulWidget {
  final User user;

  const UserDetailsDialog({super.key, required this.user});

  @override
  State<UserDetailsDialog> createState() => _UserDetailsDialogState();
}

class _UserDetailsDialogState extends State<UserDetailsDialog> {
  late User _user;
  bool _isEditing = false;

  // Controllers
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  late TextEditingController _bioController;
  late TextEditingController _passwordController;
  late TextEditingController _roleController;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _initializeControllers();
  }

  void _initializeControllers() {
    _fullNameController = TextEditingController(text: _user.fullName);
    _emailController = TextEditingController(text: _user.email);
    _phoneController = TextEditingController(text: _user.phoneNumber);
    _locationController = TextEditingController(text: _user.location);
    _bioController = TextEditingController(text: _user.bio);
    _passwordController = TextEditingController(text: _user.password);
    _roleController = TextEditingController(text: _user.role);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    _passwordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  Future<void> _saveUser() async {
    // Capture context-dependent values before async operation
    final db = context.read<AppDatabase>();
    final messenger = ScaffoldMessenger.of(context);
    final primaryColor = Theme.of(context).colorScheme.primary;
    final errorColor = Theme.of(context).colorScheme.error;

    final updatedUser = UsersCompanion(
      id: drift.Value(_user.id),
      fullName: drift.Value(_fullNameController.text),
      email: drift.Value(_emailController.text),
      role: drift.Value(_roleController.text),
      phoneNumber: drift.Value(
          _phoneController.text.isEmpty ? null : _phoneController.text),
      location: drift.Value(
          _locationController.text.isEmpty ? null : _locationController.text),
      bio:
          drift.Value(_bioController.text.isEmpty ? null : _bioController.text),
      password: drift.Value(_passwordController.text),
    );

    try {
      await db.updateUser(updatedUser);

      // Reload user after update
      final refreshedUser = await db.getUserById(_user.id);

      if (mounted && refreshedUser != null) {
        setState(() {
          _user = refreshedUser;
          _isEditing = false;
        });
        messenger.showSnackBar(
          SnackBar(
            content: const Text('Profile synchronized successfully'),
            backgroundColor: primaryColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(
            content: Text('Synchronization failed: $e'),
            backgroundColor: errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
      child: GlassCard(
        padding: const EdgeInsets.all(40),
        borderRadius: 24,
        activeBorderColor:
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        child: SizedBox(
          width: 550,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 40),
              _buildDetailsGrid(),
              const SizedBox(height: 32),
              _buildBioSection(),
              const SizedBox(height: 40),
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Hero(
          tag: 'avatar_${_user.id}',
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.5)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Center(
              child: Text(
                _user.fullName.isNotEmpty ? _user.fullName[0] : 'U',
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Theme.of(context).colorScheme.onPrimary),
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isEditing)
                _buildTextField(_fullNameController, 'FULL NAME',
                    isHeadline: true)
              else
                Text(
                  _user.fullName,
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium
                      ?.copyWith(fontSize: 28, letterSpacing: -0.5),
                ),
              const SizedBox(height: 4),
              if (_isEditing)
                _buildTextField(_roleController, 'PRIMARY ROLE')
              else
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    _user.role.toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: _buildDetailItem('Username', _user.username,
                    isEditable: false)),
            Expanded(
                child: _buildDetailItem('Email Address', _user.email,
                    controller: _emailController)),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
                child: _buildDetailItem(
                    'Contact Phone', _user.phoneNumber ?? 'None',
                    controller: _phoneController)),
            Expanded(
                child: _buildDetailItem(
                    'Active Duty Station', _user.location ?? 'In Field',
                    controller: _locationController)),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailItem(String label, String value,
      {TextEditingController? controller, bool isEditable = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 8),
        if (_isEditing && isEditable && controller != null)
          _buildTextField(controller, null)
        else
          Text(
            value,
            style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 15,
                fontWeight: FontWeight.w500),
          ),
      ],
    );
  }

  Widget _buildBioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXPERT PROFILE & BIO',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            fontSize: 10,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),
        if (_isEditing)
          _buildTextField(_bioController, null, maxLines: 3)
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.05)),
            ),
            child: Text(
              _user.bio ?? 'Technical expert profile not yet drafted.',
              style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
                  height: 1.5,
                  fontSize: 14),
            ),
          ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('DISMISS',
              style: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                  letterSpacing: 1.2)),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            if (_isEditing) {
              _saveUser();
            } else {
              setState(() => _isEditing = true);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: _isEditing
                ? Theme.of(context).extension<StatusColors>()!.success
                : Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            _isEditing ? 'COMMIT CHANGES' : 'EDIT PROFILE',
            style:
                const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String? label,
      {bool isHeadline = false, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontSize: isHeadline ? 24 : 14,
        fontWeight: isHeadline ? FontWeight.bold : FontWeight.normal,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            fontSize: 10),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color:
                    Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1))),
        focusedBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.primary)),
      ),
    );
  }
}

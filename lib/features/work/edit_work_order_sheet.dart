import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' hide Column;
import '../../database/app_database.dart';
import '../../services/work_order_workflow_service.dart';
import '../../theme/app_theme.dart';
import '../../util/log.dart';
import '../../util/error_handler.dart';

class EditWorkOrderSheet extends StatefulWidget {
  final WorkOrder workOrder;

  const EditWorkOrderSheet({super.key, required this.workOrder});

  @override
  State<EditWorkOrderSheet> createState() => _EditWorkOrderSheetState();
}

class _EditWorkOrderSheetState extends State<EditWorkOrderSheet> {
  late TextEditingController _descriptionController;
  late TextEditingController _notesController;
  late TextEditingController _reasonController;
  late TextEditingController _resolutionController;

  String? _selectedStatus;
  String? _selectedPriority;
  String? _selectedTechnician;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.workOrder.descriptionOfWork ?? '',
    );
    _notesController = TextEditingController(
      text: widget.workOrder.internalNotes ?? '',
    );
    _resolutionController = TextEditingController(
      text: widget.workOrder.resolution ?? '',
    );
    _reasonController = TextEditingController();
    _selectedStatus = widget.workOrder.status;
    _selectedPriority = widget.workOrder.priority;
    _selectedTechnician = widget.workOrder.assignedTechnician;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _notesController.dispose();
    _reasonController.dispose();
    _resolutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = context.watch<AppDatabase>();
    final workflowService = WorkOrderWorkflowService(db);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        final builderTheme = Theme.of(context);
        return Container(
          decoration: BoxDecoration(
            color: builderTheme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: builderTheme.colorScheme.onSurface.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              _buildHeader(context, builderTheme),

              // Error message
              if (_errorMessage != null) _buildErrorBanner(),

              // Form
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildStatusSection(workflowService, builderTheme),
                    const SizedBox(height: 24),
                    _buildPriorityDropdown(builderTheme),
                    const SizedBox(height: 16),
                    _buildTechnicianDropdown(db, builderTheme),
                    const SizedBox(height: 16),
                    _buildDescriptionField(builderTheme),
                    const SizedBox(height: 16),
                    _buildNotesField(builderTheme),
                    const SizedBox(height: 16),
                    if (_selectedStatus == 'completed' ||
                        _selectedStatus == 'closed')
                      _buildResolutionField(builderTheme),
                    if (_selectedStatus == 'completed' ||
                        _selectedStatus == 'closed')
                      const SizedBox(height: 16),
                    if (_selectedStatus != widget.workOrder.status)
                      _buildReasonField(builderTheme),
                  ],
                ),
              ),

              // Actions
              _buildActions(context, db, workflowService, builderTheme),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.dividerColor, width: 1)),
      ),
      child: Row(
        children: [
          Icon(Icons.edit, color: theme.colorScheme.primary, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Edit Work Order', style: theme.textTheme.titleMedium),
                Text(
                  'WO-${widget.workOrder.id}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.close,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner() {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppLayout.radiusSM),
        border: Border.all(color: theme.colorScheme.error),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: theme.colorScheme.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.error),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 20, color: theme.colorScheme.error),
            onPressed: () => setState(() => _errorMessage = null),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusSection(
      WorkOrderWorkflowService workflowService, ThemeData theme) {
    final canChangeStatus = _selectedStatus != null &&
        _selectedStatus != widget.workOrder.status &&
        workflowService.canTransition(
          widget.workOrder.status,
          _selectedStatus!,
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Status',
          style:
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedStatus,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppLayout.radiusSM),
            ),
            filled: true,
            fillColor: theme.scaffoldBackgroundColor,
          ),
          dropdownColor: theme.colorScheme.surface,
          style: theme.textTheme.bodyMedium,
          items: _getStatusOptions(workflowService, theme),
          onChanged: (value) {
            setState(() {
              _selectedStatus = value;
              _errorMessage = null;
            });
          },
        ),
        if (_selectedStatus != widget.workOrder.status) ...[
          const SizedBox(height: 8),
          if (canChangeStatus)
            _buildStatusChangeInfo()
          else
            _buildInvalidTransitionWarning(),
        ],
      ],
    );
  }

  List<DropdownMenuItem<String>> _getStatusOptions(
    WorkOrderWorkflowService workflowService,
    ThemeData theme,
  ) {
    final allStatuses = [
      'draft',
      'open',
      'assigned',
      'in_progress',
      'on_hold',
      'completed',
      'closed',
      'cancelled',
    ];

    return allStatuses.map((status) {
      final isValid = status == widget.workOrder.status ||
          workflowService.canTransition(widget.workOrder.status, status);

      return DropdownMenuItem(
        value: status,
        enabled: isValid,
        child: Row(
          children: [
            _getStatusIcon(status),
            const SizedBox(width: 8),
            Text(
              _formatStatus(status),
              style: TextStyle(
                color: isValid
                    ? theme.colorScheme.onSurface
                    : theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
            if (!isValid) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.block,
                size: 16,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ],
          ],
        ),
      );
    }).toList();
  }

  Widget _getStatusIcon(String status) {
    IconData icon;
    Color color;

    switch (status) {
      case 'draft':
        icon = Icons.edit_note;
        color = Colors.grey;
        break;
      case 'open':
        icon = Icons.folder_open;
        color = Colors.blue;
        break;
      case 'assigned':
        icon = Icons.person_add;
        color = Colors.purple;
        break;
      case 'in_progress':
        icon = Icons.play_circle;
        color = Colors.orange;
        break;
      case 'on_hold':
        icon = Icons.pause_circle;
        color = Colors.red;
        break;
      case 'completed':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'closed':
        icon = Icons.lock;
        color = Colors.grey.shade700;
        break;
      case 'cancelled':
        icon = Icons.cancel;
        color = Colors.red.shade900;
        break;
      default:
        icon = Icons.help;
        color = Colors.grey;
    }

    return Icon(icon, color: color, size: 20);
  }

  Widget _buildStatusChangeInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppLayout.radiusSM),
        border: Border.all(color: Colors.blue),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Status will change from ${_formatStatus(widget.workOrder.status)} to ${_formatStatus(_selectedStatus!)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue,
                    fontSize: 13,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvalidTransitionWarning() {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppLayout.radiusSM),
        border: Border.all(color: theme.colorScheme.error),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: theme.colorScheme.error, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Invalid status transition. Cannot change from ${_formatStatus(widget.workOrder.status)} to ${_formatStatus(_selectedStatus!)}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityDropdown(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Priority',
          style:
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: _selectedPriority,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppLayout.radiusSM),
            ),
            filled: true,
            fillColor: theme.scaffoldBackgroundColor,
          ),
          dropdownColor: theme.colorScheme.surface,
          style: theme.textTheme.bodyMedium,
          items: ['low', 'normal', 'high', 'urgent']
              .map(
                (priority) => DropdownMenuItem(
                  value: priority,
                  child: Row(
                    children: [
                      _getPriorityIcon(priority),
                      const SizedBox(width: 8),
                      Text(_formatStatus(priority)),
                    ],
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedPriority = value;
            });
          },
        ),
      ],
    );
  }

  Widget _getPriorityIcon(String priority) {
    IconData icon;
    Color color;

    switch (priority) {
      case 'low':
        icon = Icons.arrow_downward;
        color = Colors.green;
        break;
      case 'normal':
        icon = Icons.remove;
        color = Colors.blue;
        break;
      case 'high':
        icon = Icons.arrow_upward;
        color = Colors.orange;
        break;
      case 'urgent':
        icon = Icons.warning;
        color = Colors.red;
        break;
      default:
        icon = Icons.help;
        color = Colors.grey;
    }

    return Icon(icon, color: color, size: 18);
  }

  Widget _buildTechnicianDropdown(AppDatabase db, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Assigned Technician',
          style:
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        FutureBuilder<List<User>>(
          future: db.getAllUsers(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }

            final technicians = snapshot.data!
                .where((u) => u.role == 'tech' || u.role == 'admin')
                .toList();

            return DropdownButtonFormField<String>(
              initialValue: _selectedTechnician,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppLayout.radiusSM),
                ),
                filled: true,
                fillColor: theme.scaffoldBackgroundColor,
              ),
              dropdownColor: theme.colorScheme.surface,
              style: theme.textTheme.bodyMedium,
              items: [
                DropdownMenuItem(
                  value: null,
                  child: Text(
                    'Unassigned',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ),
                ...technicians.map(
                  (tech) => DropdownMenuItem(
                    value: tech.username,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: theme.colorScheme.primary,
                          child: Text(
                            tech.fullName[0].toUpperCase(),
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(tech.fullName),
                      ],
                    ),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedTechnician = value;
                });
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildDescriptionField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description of Work *',
          style:
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          maxLines: 4,
          maxLength: 1000,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Describe the work to be performed...',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppLayout.radiusSM),
            ),
            filled: true,
            fillColor: theme.scaffoldBackgroundColor,
            counterText: '${_descriptionController.text.length}/1000',
            counterStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 12,
            ),
          ),
          onChanged: (value) => setState(() {}),
        ),
      ],
    );
  }

  Widget _buildNotesField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Internal Notes',
          style:
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          maxLines: 3,
          maxLength: 500,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Add any internal notes...',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppLayout.radiusSM),
            ),
            filled: true,
            fillColor: theme.scaffoldBackgroundColor,
          ),
        ),
      ],
    );
  }

  Widget _buildResolutionField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Resolution',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_selectedStatus == 'completed')
              Text(
                ' *',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _resolutionController,
          maxLines: 3,
          maxLength: 500,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'How was the issue resolved?',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppLayout.radiusSM),
            ),
            filled: true,
            fillColor: theme.scaffoldBackgroundColor,
          ),
        ),
      ],
    );
  }

  Widget _buildReasonField(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reason for Status Change *',
          style:
              theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _reasonController,
          maxLines: 2,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Why is the status being changed?',
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppLayout.radiusSM),
            ),
            filled: true,
            fillColor: theme.scaffoldBackgroundColor,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(
    BuildContext context,
    AppDatabase db,
    WorkOrderWorkflowService workflowService,
    ThemeData theme,
  ) {
    final hasChanges = _hasChanges();
    final isValid = _validateForm();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(top: BorderSide(color: theme.dividerColor, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isSubmitting ? null : () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: theme.dividerColor),
                foregroundColor: theme.colorScheme.onSurface,
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: (hasChanges && isValid && !_isSubmitting)
                  ? () => _saveChanges(context, db, workflowService)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onSurface,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSubmitting
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.onSurface),
                      ),
                    )
                  : const Text('Save Changes'),
            ),
          ),
        ],
      ),
    );
  }

  bool _hasChanges() {
    return _descriptionController.text !=
            (widget.workOrder.descriptionOfWork ?? '') ||
        _notesController.text != (widget.workOrder.internalNotes ?? '') ||
        _resolutionController.text != (widget.workOrder.resolution ?? '') ||
        _selectedStatus != widget.workOrder.status ||
        _selectedPriority != widget.workOrder.priority ||
        _selectedTechnician != widget.workOrder.assignedTechnician;
  }

  bool _validateForm() {
    if (_descriptionController.text.trim().isEmpty) return false;
    if (_selectedStatus != widget.workOrder.status &&
        _reasonController.text.trim().isEmpty) {
      return false;
    }
    if (_selectedStatus == 'completed' &&
        _resolutionController.text.trim().isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> _saveChanges(
    BuildContext context,
    AppDatabase db,
    WorkOrderWorkflowService workflowService,
  ) async {
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      // Wrap save operation with retry logic
      await ErrorHandler.retryOperation(
        operation: () async {
          await db.transaction(() async {
            // Handle status change separately if needed
            if (_selectedStatus != null &&
                _selectedStatus != widget.workOrder.status) {
              await ErrorHandler.withTimeout(
                operation: () => workflowService.transitionStatus(
                  workOrder: widget.workOrder,
                  newStatus: _selectedStatus!,
                  userId: 1, // TODO: Get current user ID from context
                  reason: _reasonController.text.trim(),
                  notes: _notesController.text.trim(),
                ),
                timeout: const Duration(seconds: 10),
                operationName: 'Status Transition',
              );
            }

            // Update other fields
            final updatedCompanion = WorkOrdersCompanion(
              id: Value(widget.workOrder.id),
              siteId: Value(widget.workOrder.siteId),
              descriptionOfWork: Value(_descriptionController.text.trim()),
              internalNotes: Value(_notesController.text.trim()),
              resolution: Value(_resolutionController.text.trim()),
              priority: Value(_selectedPriority),
              assignedTechnician: Value(_selectedTechnician),
              version: Value(widget.workOrder.version),
            );

            final success = await db.updateWorkOrderWithLock(updatedCompanion);

            if (!success) {
              throw ConcurrentModificationException(
                'Work order was modified by another user',
              );
            }

            // Audit log for field changes (if no status change)
            if (_selectedStatus == widget.workOrder.status) {
              await db.into(db.workOrderAuditLog).insert(
                    WorkOrderAuditLogCompanion.insert(
                      workOrderId: widget.workOrder.id,
                      userId: 1, // TODO: Current user ID
                      action: 'update',
                      changeReason: const Value('User edited work order'),
                    ),
                  );
            }
          });
        },
        maxAttempts: 3,
        operationName: 'Save Work Order',
      );

      // Success handling
      if (context.mounted) {
        final successTheme = Theme.of(context);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Work order updated successfully'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'View',
              textColor: successTheme.colorScheme.onSurface,
              onPressed: () {
                // TODO: Navigate to detail view
              },
            ),
          ),
        );
      }
    } on InvalidStatusTransitionException catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isSubmitting = false;
      });
    } on ConcurrentModificationException catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isSubmitting = false;
      });

      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) {
            final theme = Theme.of(context);
            return AlertDialog(
              backgroundColor: theme.colorScheme.surface,
              title: Text(
                'Conflict Detected',
                style: theme.textTheme.titleMedium,
              ),
              content: Text(e.toString(), style: theme.textTheme.bodyMedium),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close dialog
                    Navigator.pop(context); // Close sheet
                  },
                  child: const Text('Refresh'),
                ),
              ],
            );
          },
        );
      }
    } on ValidationException catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isSubmitting = false;
      });
    } catch (e, stackTrace) {
      Log.error('Error saving work order: $e', e, stackTrace);
      setState(() {
        _errorMessage = 'An unexpected error occurred. Please try again.';
        _isSubmitting = false;
      });
    }
  }

  String _formatStatus(String status) {
    return status.split('_').map((word) {
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}

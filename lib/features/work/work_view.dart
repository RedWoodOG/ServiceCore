import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../database/app_database.dart';
import '../../theme/app_theme.dart';
import '../../models/work_order_enums.dart';
import 'package:intl/intl.dart';
import 'create_work_order_sheet.dart';
import 'edit_work_order_sheet.dart';
import 'work_order_status_badge.dart';
import '../../widgets/glass_card.dart';

class WorkView extends StatefulWidget {
  const WorkView({super.key});

  @override
  State<WorkView> createState() => _WorkViewState();
}

class _WorkViewState extends State<WorkView> {
  // Pagination State
  final List<WorkOrderWithDetails> _pagedItems = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  static const int _pageSize = 20;
  final ScrollController _scrollController = ScrollController();

  String _filterStatus = StatusFilter.all;

  @override
  void initState() {
    super.initState();
    _loadData(refresh: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMore) {
        _loadData();
      }
    }
  }

  Future<void> _loadData({bool refresh = false}) async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      if (refresh) {
        _pagedItems.clear();
        _currentPage = 0;
        _hasMore = true;
      }
    });

    try {
      final db = context.read<AppDatabase>();

      final newItems = await db.getWorkOrdersWithDetailsPaged(
        limit: _pageSize,
        offset: _currentPage * _pageSize,
        status: _filterStatus,
      );

      if (!mounted) return;

      setState(() {
        if (newItems.length < _pageSize) {
          _hasMore = false;
        }
        _pagedItems.addAll(newItems);
        _currentPage++;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      // In production use Logger
      debugPrint('Error loading paged work orders: $e');
    }
  }

  void _updateFilter(String status) {
    if (_filterStatus != status) {
      setState(() {
        _filterStatus = status;
      });
      _loadData(refresh: true);
    }
  }

  /// Statuses that accept no further change at all. `completed` is not one of
  /// them: the workflow allows completed -> in_progress, so the edit sheet must
  /// stay reachable to reopen the job.
  bool _isFullyLockedStatus(String status) {
    const locked = {'closed', 'cancelled'};
    return locked.contains(status.toLowerCase());
  }

  bool _areFieldsLockedStatus(String status) {
    const locked = {'completed', 'closed', 'cancelled'};
    return locked.contains(status.toLowerCase());
  }

  Color _getStatusColor(String status, BuildContext context) {
    final theme = Theme.of(context);
    final parsedStatus = WorkOrderStatusX.fromDbValue(status);
    switch (parsedStatus) {
      case WorkOrderStatus.open:
        return theme.colorScheme.primary;
      case WorkOrderStatus.onHold:
        return Theme.of(context).extension<StatusColors>()!.warning;
      case WorkOrderStatus.completed:
        return Theme.of(context).extension<StatusColors>()!.success;
      case WorkOrderStatus.draft:
        return theme.colorScheme.onSurface.withValues(alpha: 0.7);
    }
  }

  Color _getColorFromString(String colorName, BuildContext context) {
    final theme = Theme.of(context);
    switch (colorName.toLowerCase()) {
      case 'blue':
        return AppColors.pinClientBlue;
      case 'red':
        return AppColors.pinClientRed;
      case 'yellow':
        return AppColors.pinClientAmber;
      default:
        return theme.colorScheme.onSurface.withValues(alpha: 0.7);
    }
  }

  String _getPriorityLabel(String? priority) {
    if (priority == null) return '';
    return priority.toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Work Orders'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: theme.dividerColor)),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create Work Order',
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const CreateWorkOrderSheet(),
              ).then((_) {
                // Refresh the list after creating a work order
                _loadData(refresh: true);
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
        child: Column(
          children: [
            // Filter chips
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: theme.colorScheme.surface,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(StatusFilter.labelFor(StatusFilter.all),
                        StatusFilter.all),
                    const SizedBox(width: 8),
                    _buildFilterChip(WorkOrderStatus.open.label,
                        WorkOrderStatus.open.dbValue),
                    const SizedBox(width: 8),
                    _buildFilterChip(WorkOrderStatus.onHold.label,
                        WorkOrderStatus.onHold.dbValue),
                    const SizedBox(width: 8),
                    _buildFilterChip(WorkOrderStatus.completed.label,
                        WorkOrderStatus.completed.dbValue),
                  ],
                ),
              ),
            ),
            // Work orders list
            Expanded(
              child: _pagedItems.isEmpty && !_isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.work_outline,
                            size: 64,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.7),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No work orders found',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      itemCount: _pagedItems.length + (_isLoading ? 1 : 0),
                      padding: const EdgeInsets.all(16),
                      itemBuilder: (context, index) {
                        if (index == _pagedItems.length) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        final theme = Theme.of(context);
                        final item = _pagedItems[index];
                        final workOrder = item.workOrder;
                        final site = item.site;
                        final client = item.client;
                        final equipment = item.equipment;

                        final clientColor = _getColorFromString(
                          client.themeColor,
                          context,
                        );
                        final statusColor =
                            _getStatusColor(workOrder.status, context);

                        return Stack(
                          children: [
                            GlassCard(
                              margin: const EdgeInsets.only(bottom: 12),
                              // Active border for active status
                              activeBorderColor: workOrder.status ==
                                      WorkOrderStatus.open.dbValue
                                  ? theme.colorScheme.primary
                                      .withValues(alpha: 0.3)
                                  : null,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: statusColor.withValues(
                                              alpha: 0.1),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          border: Border.all(
                                            color: statusColor.withValues(
                                                alpha: 0.3),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: statusColor.withValues(
                                                alpha: 0.1,
                                              ),
                                              blurRadius: 8,
                                              spreadRadius: -2,
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          workOrder.status.toUpperCase(),
                                          style: TextStyle(
                                            color: statusColor,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                color: statusColor.withValues(
                                                  alpha: 0.5,
                                                ),
                                                blurRadius: 4,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (workOrder.priority != null) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .extension<StatusColors>()!
                                                .warning
                                                .withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                            border: Border.all(
                                              color: Theme.of(context)
                                                  .extension<StatusColors>()!
                                                  .warning
                                                  .withValues(alpha: 0.3),
                                            ),
                                          ),
                                          child: Text(
                                            _getPriorityLabel(
                                              workOrder.priority,
                                            ),
                                            style: TextStyle(
                                              color: Theme.of(context)
                                                  .extension<StatusColors>()!
                                                  .warning,
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                      const Spacer(),
                                      Text(
                                        'WO-${workOrder.id}',
                                        style: TextStyle(
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ...[
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on,
                                          size: 16,
                                          color: clientColor,
                                        ),
                                        const SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            site.branchName,
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.onSurface,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      client.name,
                                      style: TextStyle(
                                        color: clientColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                  if (workOrder.descriptionOfWork != null &&
                                      workOrder
                                          .descriptionOfWork!.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(
                                      workOrder.descriptionOfWork!,
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.7),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                  if (equipment.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Wrap(
                                      spacing: 8,
                                      children: equipment.map((eq) {
                                        return Chip(
                                          label: Text(
                                            '${eq.equipmentType} ${eq.serialNumber ?? ""}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                            ),
                                          ),
                                          backgroundColor:
                                              theme.scaffoldBackgroundColor,
                                          labelStyle: TextStyle(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.7),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      if (workOrder.assignedTechnician !=
                                          null) ...[
                                        Icon(
                                          Icons.person,
                                          size: 14,
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.5),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          workOrder.assignedTechnician!,
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface
                                                .withValues(alpha: 0.5),
                                            fontSize: 12,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                      ],
                                      Icon(
                                        Icons.calendar_today,
                                        size: 14,
                                        color: theme.colorScheme.onSurface
                                            .withValues(alpha: 0.5),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        DateFormat(
                                          'MMM d, y',
                                        ).format(workOrder.createdAt),
                                        style: TextStyle(
                                          color: theme.colorScheme.onSurface
                                              .withValues(alpha: 0.5),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ), // Column
                            ), // GlassCard
                            // PHASE 1: Status badge overlay
                            Positioned(
                              top: 12,
                              right: 12,
                              child: WorkOrderStatusBadge(
                                status: workOrder.status,
                                small: true,
                              ),
                            ),

                            // Edit overlay. Hidden only for fully-locked states;
                            // a completed job still opens, to reopen or close it.
                            Positioned(
                              bottom: 12,
                              right: 12,
                              child: _isFullyLockedStatus(workOrder.status)
                                  ? const SizedBox.shrink()
                                  : IconButton(
                                      icon: Icon(
                                        _areFieldsLockedStatus(workOrder.status)
                                            ? Icons.lock_open
                                            : Icons.edit,
                                        color: theme.colorScheme.primary,
                                        size: 20,
                                      ),
                                      tooltip: _areFieldsLockedStatus(
                                              workOrder.status)
                                          ? 'Reopen or Close Work Order'
                                          : 'Edit Work Order',
                                      style: IconButton.styleFrom(
                                        backgroundColor: theme
                                            .colorScheme.surface
                                            .withValues(
                                          alpha: 0.9,
                                        ),
                                        padding: const EdgeInsets.all(8),
                                      ),
                                      onPressed: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) =>
                                              EditWorkOrderSheet(
                                            workOrder: workOrder,
                                          ),
                                        ).then((_) {
                                          _loadData(refresh: true);
                                        });
                                      },
                                    ),
                            ),
                          ], // Stack children
                        ); // Stack
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final theme = Theme.of(context);
    final isSelected = _filterStatus == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          _updateFilter(value);
        }
      },
      selectedColor: theme.colorScheme.primary,
      labelStyle: TextStyle(
        color: isSelected
            ? theme.colorScheme.onSurface
            : theme.colorScheme.onSurface.withValues(alpha: 0.7),
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../database/app_database.dart';
import 'equipment_card.dart';
import 'equipment_detail_sheet.dart';

class EquipmentHomeView extends StatefulWidget {
  const EquipmentHomeView({super.key});

  @override
  State<EquipmentHomeView> createState() => _EquipmentHomeViewState();
}

class _EquipmentHomeViewState extends State<EquipmentHomeView> {
  String _searchQuery = '';
  String _selectedType = 'All';
  List<String> _equipmentTypes = ['All'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final db = context.watch<AppDatabase>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: StreamBuilder<List<EquipmentData>>(
          stream: db.watchAllEquipment(),
          builder: (context, snapshot) {
            final count = snapshot.hasData ? snapshot.data!.length : 0;
            return Text('Equipment${count > 0 ? ' ($count items)' : ''}');
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
        ),
        child: Column(
          children: [
            // Search and Filter Bar
            Container(
              padding: const EdgeInsets.all(16),
              color: theme.colorScheme.surface.withValues(alpha: 0.5),
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    style: TextStyle(color: theme.colorScheme.onSurface),
                    decoration: InputDecoration(
                      hintText:
                          'Search by serial number, model, manufacturer...',
                      hintStyle: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                      prefixIcon: Icon(Icons.search,
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: theme.dividerColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: theme.colorScheme.primary, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  // Equipment Type Filter
                  StreamBuilder<List<String>>(
                    stream: db.watchDistinctEquipmentTypes(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                        final types = ['All', ...snapshot.data!];
                        if (types.length != _equipmentTypes.length) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            setState(() {
                              _equipmentTypes = types;
                            });
                          });
                        }
                      }
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _equipmentTypes.map((type) {
                            final isSelected = _selectedType == type;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(type),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    _selectedType = type;
                                  });
                                },
                                selectedColor: theme.colorScheme.primary,
                                checkmarkColor: theme.colorScheme.onSurface,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? theme.colorScheme.onSurface
                                      : theme.colorScheme.onSurface
                                          .withValues(alpha: 0.7),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Equipment List
            Expanded(
              child: StreamBuilder<List<EquipmentData>>(
                stream: db.watchAllEquipment(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline,
                              size: 64, color: theme.colorScheme.error),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading equipment',
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                      ),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inventory_2_outlined,
                              size: 64,
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                          const SizedBox(height: 16),
                          Text(
                            'No equipment found',
                            style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.4),
                                fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  var equipment = snapshot.data!;

                  // Apply type filter
                  if (_selectedType != 'All') {
                    equipment = equipment
                        .where((e) => e.equipmentType == _selectedType)
                        .toList();
                  }

                  // Apply search filter
                  if (_searchQuery.isNotEmpty) {
                    equipment = equipment.where((e) {
                      return (e.serialNumber
                                  ?.toLowerCase()
                                  .contains(_searchQuery) ??
                              false) ||
                          (e.model?.toLowerCase().contains(_searchQuery) ??
                              false) ||
                          (e.manufacturer
                                  ?.toLowerCase()
                                  .contains(_searchQuery) ??
                              false) ||
                          e.equipmentType.toLowerCase().contains(_searchQuery);
                    }).toList();
                  }

                  if (equipment.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 64,
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.4)),
                          const SizedBox(height: 16),
                          Text(
                            'No equipment matches your search',
                            style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.4),
                                fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: equipment.length,
                    itemBuilder: (context, index) {
                      final item = equipment[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: EquipmentCard(
                          equipment: item,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (context) =>
                                  EquipmentDetailSheet(equipment: item),
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

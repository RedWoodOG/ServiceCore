import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../database/app_database.dart';
import '../../theme/app_theme.dart';

class OperationsView extends StatefulWidget {
  const OperationsView({super.key});

  @override
  State<OperationsView> createState() => _OperationsViewState();
}

class _OperationsViewState extends State<OperationsView> {
  int? _selectedClientId;
  int _selectedTab = 0; // 0 = Clients, 1 = Equipment

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final db = context.watch<AppDatabase>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: theme.dividerColor, width: 1),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.settings,
                        color: theme.colorScheme.primary, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'Operations',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    // Filter dropdown (only show for Clients tab)
                    if (_selectedTab == 0)
                      SizedBox(
                        width: 200,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: FutureBuilder<List<Client>>(
                            future: db.getAllClients(),
                            builder: (context, snapshot) {
                              final builderTheme = Theme.of(context);
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text(
                                  'Loading clients...',
                                  style: TextStyle(
                                      color: builderTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.7)),
                                  overflow: TextOverflow.ellipsis,
                                );
                              }
                              if (snapshot.hasError) {
                                return Text(
                                  'Error loading clients',
                                  style:
                                      TextStyle(color: theme.colorScheme.error),
                                  overflow: TextOverflow.ellipsis,
                                );
                              }
                              if (!snapshot.hasData) {
                                return Text(
                                  'No clients',
                                  style: TextStyle(
                                      color: builderTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.7)),
                                  overflow: TextOverflow.ellipsis,
                                );
                              }
                              final clients = snapshot.data!;
                              return DropdownButton<int?>(
                                value: _selectedClientId,
                                hint: Text(
                                  'All Clients',
                                  style: TextStyle(
                                      color: builderTheme.colorScheme.onSurface
                                          .withValues(alpha: 0.7)),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                underline: const SizedBox(),
                                isExpanded: true,
                                items: [
                                  const DropdownMenuItem<int?>(
                                    value: null,
                                    child: Text('All Clients',
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  ...clients.map((client) {
                                    return DropdownMenuItem<int?>(
                                      value: client.id,
                                      child: Text(client.name,
                                          overflow: TextOverflow.ellipsis),
                                    );
                                  }),
                                ],
                                onChanged: (int? value) {
                                  setState(() {
                                    _selectedClientId = value;
                                  });
                                },
                                dropdownColor: builderTheme.colorScheme.surface,
                                style: TextStyle(
                                    color: builderTheme.colorScheme.onSurface),
                              );
                            },
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                // Tabs
                Row(
                  children: [
                    _buildTab('Clients', 0, Icons.business),
                    const SizedBox(width: 8),
                    _buildTab('Equipment', 1, Icons.inventory),
                  ],
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: _selectedTab == 0
                ? (_selectedClientId == null
                    ? _buildClientsList(db)
                    : _buildClientDetails(db, _selectedClientId!))
                : _buildEquipmentList(db),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, IconData icon) {
    final theme = Theme.of(context);
    final isSelected = _selectedTab == index;
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedTab = index;
            if (index == 1) {
              _selectedClientId =
                  null; // Clear client selection when switching to Equipment
            }
          });
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.2)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color:
                  isSelected ? theme.colorScheme.primary : theme.dividerColor,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 20,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.7)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEquipmentList(AppDatabase db) {
    return StreamBuilder<List<EquipmentData>>(
      stream: db.watchAllEquipment(),
      builder: (context, snapshot) {
        final theme = Theme.of(context);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:
                  CircularProgressIndicator(color: theme.colorScheme.primary));
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    color: theme.colorScheme.error, size: 48),
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
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                const SizedBox(height: 16),
                Text(
                  'No equipment found',
                  style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
              ],
            ),
          );
        }

        final equipment = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: equipment.length,
          itemBuilder: (context, index) {
            final eq = equipment[index];
            return FutureBuilder<Site?>(
              future: db.getSiteById(eq.siteId),
              builder: (context, siteSnapshot) {
                final site = siteSnapshot.data;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.build,
                          color: theme.colorScheme.primary, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              eq.equipmentType,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (eq.model != null || eq.manufacturer != null)
                              Text(
                                [eq.manufacturer, eq.model]
                                    .where((e) => e != null && e.isNotEmpty)
                                    .join(' '),
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                    fontSize: 12),
                              ),
                            if (eq.serialNumber != null &&
                                eq.serialNumber!.isNotEmpty)
                              Text(
                                'S/N: ${eq.serialNumber}',
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.7),
                                    fontSize: 11),
                              ),
                            if (site != null)
                              Text(
                                'Location: ${site.branchName}',
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.4),
                                    fontSize: 11),
                              ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (eq.underWarranty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.green.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Warranty',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          if (eq.underServiceContract)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Contract',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildClientsList(AppDatabase db) {
    return FutureBuilder<List<Client>>(
      future: db.getAllClients(),
      builder: (context, snapshot) {
        final theme = Theme.of(context);
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: theme.colorScheme.primary),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline,
                    color: theme.colorScheme.error, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Error loading clients',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                  textAlign: TextAlign.center,
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
                Icon(Icons.business,
                    size: 64,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                const SizedBox(height: 16),
                Text(
                  'No clients found',
                  style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
              ],
            ),
          );
        }

        final clients = snapshot.data!;

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: clients.length,
          itemBuilder: (context, index) {
            final client = clients[index];
            return FutureBuilder<List<Site>>(
              future: db.getSitesByClient(client.id),
              builder: (context, sitesSnapshot) {
                final sitesCount =
                    sitesSnapshot.hasData ? sitesSnapshot.data!.length : 0;
                return _buildClientCard(client, sitesCount);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildClientCard(Client client, int sitesCount) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.dividerColor),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: _getClientColor(client.themeColor).withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.business,
            color: _getClientColor(client.themeColor),
            size: 24,
          ),
        ),
        title: Text(
          client.name,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on,
                    size: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                const SizedBox(width: 4),
                Text(
                  '$sitesCount ${sitesCount == 1 ? 'location' : 'locations'}',
                  style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Theme: ${client.themeColor}',
              style: TextStyle(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  fontSize: 12),
            ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        onTap: () {
          setState(() {
            _selectedClientId = client.id;
          });
        },
      ),
    );
  }

  Widget _buildClientDetails(AppDatabase db, int clientId) {
    return FutureBuilder<Client?>(
      future: db.getClientById(clientId),
      builder: (context, clientSnapshot) {
        final theme = Theme.of(context);
        if (clientSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: theme.colorScheme.primary),
          );
        }

        if (!clientSnapshot.hasData || clientSnapshot.data == null) {
          return Center(
            child: Text('Client not found',
                style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
          );
        }

        final client = clientSnapshot.data!;

        return Column(
          children: [
            // Back button and client header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(color: theme.dividerColor, width: 1),
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back,
                        color: theme.colorScheme.onSurface),
                    onPressed: () {
                      setState(() {
                        _selectedClientId = null;
                      });
                    },
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getClientColor(client.themeColor)
                          .withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.business,
                      color: _getClientColor(client.themeColor),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          client.name,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Client Details',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Sites list
            Expanded(
              child: FutureBuilder<List<Site>>(
                future: db.getSitesByClient(clientId),
                builder: (context, sitesSnapshot) {
                  if (sitesSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                          color: theme.colorScheme.primary),
                    );
                  }

                  if (!sitesSnapshot.hasData || sitesSnapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.location_off,
                              size: 64,
                              color:
                                  theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                          const SizedBox(height: 16),
                          Text(
                            'No locations found for this client',
                            style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7)),
                          ),
                        ],
                      ),
                    );
                  }

                  final sites = sitesSnapshot.data!;

                  return ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: sites.length,
                    itemBuilder: (context, index) {
                      final site = sites[index];
                      return _buildSiteCard(site);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSiteCard(Site site) {
    return FutureBuilder<List<EquipmentData>>(
      future: context.read<AppDatabase>().getEquipmentBySite(site.id),
      builder: (context, equipmentSnapshot) {
        final theme = Theme.of(context);
        final equipment = equipmentSnapshot.hasData
            ? equipmentSnapshot.data!
            : <EquipmentData>[];
        final activeEquipment = equipment.where((e) => e.active).toList();

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on,
                      color: theme.colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      site.branchName,
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                site.address,
                style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.map,
                      size: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                  const SizedBox(width: 4),
                  Text(
                    'Region: ${site.region}',
                    style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on,
                      size: 16,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                  const SizedBox(width: 4),
                  Text(
                    '${site.latitude.toStringAsFixed(4)}, ${site.longitude.toStringAsFixed(4)}',
                    style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontSize: 12),
                  ),
                ],
              ),
              // Equipment Section
              if (activeEquipment.isNotEmpty) ...[
                const SizedBox(height: 12),
                Divider(color: theme.dividerColor, height: 1),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.build,
                        size: 16, color: theme.colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      'Equipment (${activeEquipment.length})',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ...activeEquipment.take(3).map((eq) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(Icons.circle,
                            size: 6,
                            color:
                                theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${eq.equipmentType}${eq.serialNumber != null ? " - ${eq.serialNumber}" : ""}',
                            style: TextStyle(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                                fontSize: 11),
                          ),
                        ),
                        if (eq.underWarranty)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .extension<StatusColors>()!
                                  .success
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'W',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .extension<StatusColors>()!
                                      .success,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        if (eq.underServiceContract) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'SC',
                              style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
                if (activeEquipment.length > 3)
                  Text(
                    '...and ${activeEquipment.length - 3} more',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      fontSize: 10,
                    ),
                  ),
              ] else ...[
                const SizedBox(height: 12),
                Divider(color: theme.dividerColor, height: 1),
                const SizedBox(height: 8),
                Text(
                  'No equipment at this location',
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    fontSize: 11,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Color _getClientColor(String? themeColor) {
    final theme = Theme.of(context);
    if (themeColor == null) return theme.colorScheme.primary;
    switch (themeColor.toLowerCase()) {
      case 'blue':
        return AppColors.pinClientBlue;
      case 'red':
        return AppColors.pinClientRed;
      case 'yellow':
        return AppColors.pinClientAmber;
      default:
        return theme.colorScheme.primary;
    }
  }
}

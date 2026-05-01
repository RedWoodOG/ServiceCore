import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../database/app_database.dart';
import '../../theme/app_theme.dart';
import '../../config/app_constants.dart';
import '../../util/log.dart';
import '../../widgets/glass_card.dart';
import 'site_detail_sheet.dart';
import 'add_location_sheet.dart';

class LocationsView extends StatefulWidget {
  const LocationsView({super.key});

  @override
  State<LocationsView> createState() => _LocationsViewState();
}

class _LocationsViewState extends State<LocationsView> {
  List<Site> sites = [];
  List<StartingPoint> startingPoints = [];
  Map<int, Client> clientsMap = {};
  bool _isLoading = true;

  bool isPMMode = false;
  StartingPoint? selectedStartingPoint;
  List<LatLng> routePath = [];

  final MapController mapController = MapController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final db = context.read<AppDatabase>();

      final loadedSites = await db.getAllSites();
      final loadedStartingPoints = await db.getAllStartingPoints();
      final loadedClients = await db.getAllClients();

      final Map<int, Client> clientMap = {};
      for (var client in loadedClients) {
        clientMap[client.id] = client;
      }

      if (mounted) {
        setState(() {
          sites = loadedSites;
          startingPoints = loadedStartingPoints;
          clientsMap = clientMap;
          _isLoading = false;

          if (startingPoints.isNotEmpty) {
            selectedStartingPoint = startingPoints.first;
          }
        });
      }
    } catch (e, stackTrace) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading locations: ${e.toString()}'),
            backgroundColor: Theme.of(context).colorScheme.error,
            duration: const Duration(seconds: 5),
          ),
        );
      }
      Log.error('LocationsView: Error loading data: $e');
      Log.error('Stack trace: $stackTrace');
    }
  }

  Color _getColorFromString(String colorName, BuildContext context) {
    final theme = Theme.of(context);
    switch (colorName.toLowerCase()) {
      case 'blue':
        return AppColors.pinNorthwind;
      case 'red':
        return AppColors.pinGulfCoast;
      case 'yellow':
        return AppColors.pinLoneStar;
      default:
        return theme.colorScheme.onSurface.withValues(alpha: 0.7);
    }
  }

  double _calculateDistance(
      double lat1, double lon1, double lat2, double lon2) {
    const Distance distance = Distance();
    return distance.as(
        LengthUnit.Meter, LatLng(lat1, lon1), LatLng(lat2, lon2));
  }

  void _calculatePMRoute() {
    if (selectedStartingPoint == null || sites.isEmpty) {
      setState(() {
        routePath = [];
      });
      return;
    }

    final startLat = selectedStartingPoint!.latitude;
    final startLon = selectedStartingPoint!.longitude;

    Site? farthestSite;
    double maxDistance = 0;

    for (var site in sites) {
      final distance = _calculateDistance(
        startLat,
        startLon,
        site.latitude,
        site.longitude,
      );
      if (distance > maxDistance) {
        maxDistance = distance;
        farthestSite = site;
      }
    }

    if (farthestSite == null) {
      setState(() {
        routePath = [];
      });
      return;
    }

    final List<Site> remainingSites =
        sites.where((s) => s.id != farthestSite!.id).toList();
    remainingSites.sort((a, b) {
      final distA = _calculateDistance(
        farthestSite!.latitude,
        farthestSite.longitude,
        a.latitude,
        a.longitude,
      );
      final distB = _calculateDistance(
        farthestSite.latitude,
        farthestSite.longitude,
        b.latitude,
        b.longitude,
      );
      return distA.compareTo(distB);
    });

    final closestSites = remainingSites.take(5).toList();

    List<LatLng> path = [
      LatLng(startLat, startLon),
      LatLng(farthestSite.latitude, farthestSite.longitude),
    ];

    for (var site in closestSites) {
      path.add(LatLng(site.latitude, site.longitude));
    }

    setState(() {
      routePath = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          if (_isLoading)
            Center(
                child:
                    CircularProgressIndicator(color: theme.colorScheme.primary))
          else
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: LatLng(
                    AppConstants.defaultMapLat, AppConstants.defaultMapLng),
                initialZoom: AppConstants.defaultMapZoom,
                minZoom: AppConstants.mapMinZoom,
                maxZoom: AppConstants.mapMaxZoom,
              ),
              children: [
                TileLayer(
                  urlTemplate: Theme.of(context).brightness == Brightness.dark
                      ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                      : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.example.portal_offline',
                ),
                if (isPMMode && routePath.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePath,
                        strokeWidth: 5.0,
                        color: AppPalette.purpleAccent.withValues(alpha: 0.7),
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    ...startingPoints.map((sp) => Marker(
                          point: LatLng(sp.latitude, sp.longitude),
                          width: 50,
                          height: 50,
                          child: _buildHomeMarker(sp),
                        )),
                    ...sites.map((site) {
                      final client = clientsMap[site.clientId];
                      final color = client != null
                          ? _getColorFromString(client.themeColor, context)
                          : theme.colorScheme.onSurface.withValues(alpha: 0.7);

                      return Marker(
                        point: LatLng(site.latitude, site.longitude),
                        width: 100,
                        height: 100,
                        child: _buildSiteMarker(site, color),
                      );
                    }),
                  ],
                ),
              ],
            ),
          Positioned(
            top: 24,
            right: 24,
            child: _buildControlPanel(),
          ),
          Positioned(
            bottom: 24,
            left: 24,
            child: _buildLegend(),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: () {
                final center = mapController.camera.center;
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => AddLocationSheet(
                    initialLatitude: center.latitude,
                    initialLongitude: center.longitude,
                    onLocationAdded: () => _loadData(),
                  ),
                );
              },
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              child: const Icon(Icons.add_location_alt),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHomeMarker(StartingPoint sp) {
    final theme = Theme.of(context);
    final isSelected = selectedStartingPoint?.id == sp.id;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.pinStartPoint
                : theme.colorScheme.surface.withValues(alpha: 0.4),
            shape: BoxShape.circle,
            border: Border.all(color: theme.colorScheme.onSurface, width: 2),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                        color: AppColors.pinStartPoint.withValues(alpha: 0.5),
                        blurRadius: 10,
                        spreadRadius: 2)
                  ]
                : null,
          ),
          child: Icon(Icons.home, color: theme.colorScheme.onSurface, size: 24),
        ),
      ],
    );
  }

  Widget _buildSiteMarker(Site site, Color color) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => SiteDetailSheet(
            site: site,
            onSiteUpdated: () => _loadData(),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurface,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: color.withValues(alpha: 0.5),
                    blurRadius: 8,
                    spreadRadius: 2)
              ],
            ),
            child: Icon(Icons.location_on, color: color, size: 32),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Text(
              site.branchName,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel() {
    final theme = Theme.of(context);
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isPMMode
                      ? theme.colorScheme.primary.withValues(alpha: 0.2)
                      : theme.colorScheme.surface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.route_outlined,
                  color: isPMMode
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Optimization',
                    style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'PM Route Planning',
                    style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        fontSize: 11),
                  ),
                ],
              ),
              const SizedBox(width: 24),
              Switch(
                value: isPMMode,
                onChanged: (value) {
                  setState(() => isPMMode = value);
                  if (value) {
                    _calculatePMRoute();
                  } else {
                    setState(() => routePath = []);
                  }
                },
                activeThumbColor: theme.colorScheme.primary,
              ),
            ],
          ),
          if (isPMMode && startingPoints.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.dividerColor),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<StartingPoint>(
                  value: selectedStartingPoint,
                  dropdownColor: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  icon: Icon(Icons.arrow_drop_down,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                  items: startingPoints.map((sp) {
                    return DropdownMenuItem(
                      value: sp,
                      child: Text(
                        sp.name,
                        style: TextStyle(
                            color: theme.colorScheme.onSurface, fontSize: 13),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => selectedStartingPoint = value);
                    if (isPMMode) _calculatePMRoute();
                  },
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLegend() {
    final theme = Theme.of(context);
    return GlassCard(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'MAP LEGEND',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          _legendItem(AppColors.pinStartPoint, 'Service Hubs'),
          _legendItem(AppColors.pinNorthwind, 'Northwind Sites'),
          _legendItem(AppColors.pinLoneStar, 'Lone Star Bank'),
          _legendItem(AppColors.pinGulfCoast, 'Gulf Coast Bank'),
          if (isPMMode)
            _legendItem(AppPalette.purpleAccent, 'Optimized Service Route'),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 4,
                    spreadRadius: 1)
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: 12,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

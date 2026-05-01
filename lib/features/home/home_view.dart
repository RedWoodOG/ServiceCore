import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/news_card.dart';
import '../../widgets/news_feed.dart';
import '../../theme/app_theme.dart';
import '../../database/app_database.dart';
import '../../app_shell/navigation_state.dart';
import 'create_announcement_sheet.dart';
import 'new_note_sheet.dart';
import 'scan_receipt_sheet.dart';
import '../../widgets/glass_card.dart';
import '../admin/knowledge_import_screen.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  TrafficSnapshotData? _traffic;

  @override
  void initState() {
    super.initState();
    _loadTrafficData();
  }

  Future<void> _loadTrafficData() async {
    final db = context.read<AppDatabase>();
    final traffic = await db.getLatestTraffic();

    if (mounted) {
      setState(() {
        _traffic = traffic;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(color: theme.scaffoldBackgroundColor),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 1100;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 48),
                  if (isWide)
                    _buildWideLayout(context)
                  else
                    _buildNarrowLayout(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWideLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main Dashboard Area
        Expanded(
          flex: 7,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildMorningBriefing(context),
              const SizedBox(height: 32),
              _buildKpiRow(context),
              const SizedBox(height: 48),
              const NewsFeedWidget(),
              const SizedBox(height: 48),
              _buildCompanyFeedSection(context),
            ],
          ),
        ),
        const SizedBox(width: 48),
        // Tactical Sidebar
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTacticalShortcuts(context),
              const SizedBox(height: 48),
              _buildStatusPanel(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNarrowLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMorningBriefing(context),
        const SizedBox(height: 32),
        _buildKpiRow(context),
        const SizedBox(height: 48),
        _buildTacticalShortcuts(context),
        const SizedBox(height: 48),
        const NewsFeedWidget(),
        const SizedBox(height: 48),
        _buildStatusPanel(context),
        const SizedBox(height: 48),
        _buildCompanyFeedSection(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Hero(
          tag: 'portal_logo',
          child: Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child:
                Icon(Icons.bolt, color: theme.colorScheme.onPrimary, size: 32),
          ),
        ),
        const SizedBox(width: 20),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "FIELD SERVICE PORTAL",
                style: theme.textTheme.displaySmall?.copyWith(
                  fontSize: 24,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.w900,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppPalette.successGreen,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      "OPERATIONAL STATE: SECURE",
                      style: TextStyle(
                        color: Theme.of(context)
                            .extension<StatusColors>()!
                            .success
                            .withValues(alpha: 0.8),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        _buildSearchButton(),
        const SizedBox(width: 16),
        _buildProfileCircle(),
      ],
    );
  }

  Widget _buildSearchButton() {
    final theme = Theme.of(context);
    return GlassCard(
      borderRadius: 12,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.search,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6), size: 18),
          const SizedBox(width: 12),
          Text(
            "Quick Search (CTRL + K)",
            style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCircle() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        shape: BoxShape.circle,
      ),
      child: CircleAvatar(
        radius: 20,
        backgroundColor: theme.colorScheme.surface,
        child: Icon(
          Icons.person_outline,
          size: 24,
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildMorningBriefing(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<WeatherSnapshotData?>(
      stream: context.read<AppDatabase>().watchLatestWeather(),
      builder: (context, snapshot) {
        final weather = snapshot.data;
        final trafficCondition = _traffic?.conditionLabel ?? "Nominal";

        return GlassCard(
          padding: const EdgeInsets.all(32),
          borderRadius: 24,
          child: Row(
            children: [
              // Weather Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ATMOSPHERIC CONDITIONS",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          _getWeatherIcon(weather?.condition),
                          color: Colors.orangeAccent,
                          size: 40,
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${weather?.temperature ?? '--'}°F",
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                weather?.condition.toUpperCase() ??
                                    "SYNCHRONIZING...",
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                height: 80,
                width: 1,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.15),
                margin: const EdgeInsets.symmetric(horizontal: 40),
              ),
              // Logistic Status
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "LOGISTIC FEEDBACK",
                      style: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.navigation_outlined,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "TRAFFIC: ${trafficCondition.toUpperCase()}",
                                style: TextStyle(
                                  color:
                                      trafficCondition.toLowerCase().contains(
                                                'heavy',
                                              )
                                          ? Colors.redAccent
                                          : Theme.of(context)
                                              .extension<StatusColors>()!
                                              .success,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                _traffic?.routeLabel ??
                                    "SCANNING FIRST STOP...",
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKpiRow(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: StreamBuilder<int>(
            stream: context.read<AppDatabase>().watchOpenCallsCount(),
            builder: (context, snapshot) => _buildKpiTile(
              context,
              "ACTIVE DEPLOYMENTS",
              snapshot.hasData ? snapshot.data!.toString() : "0",
              Icons.assignment_turned_in_outlined,
              theme.colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: StreamBuilder<int>(
            stream: context.read<AppDatabase>().watchCompletedCallsCount(),
            builder: (context, snapshot) => _buildKpiTile(
              context,
              "COMPLETED MISSIONS",
              snapshot.hasData ? snapshot.data!.toString() : "0",
              Icons.verified_outlined,
              Theme.of(context).extension<StatusColors>()!.success,
            ),
          ),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: StreamBuilder<int>(
            stream: context.read<AppDatabase>().watchWeeklyCallsCount(),
            builder: (context, snapshot) => _buildKpiTile(
              context,
              "WEEKLY THROUGHPUT",
              snapshot.hasData ? snapshot.data!.toString() : "0",
              Icons.leaderboard_outlined,
              Colors.purpleAccent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKpiTile(
    BuildContext context,
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 20,
      activeBorderColor: color.withValues(alpha: 0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, color: color, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 2,
            width: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTacticalShortcuts(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "TACTICAL UTILITIES",
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true,
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.4,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildActionTile(
              context,
              Icons.qr_code_scanner,
              "SCAN RECEIPTS",
              theme.colorScheme.primary,
              () => _handleScanReceipt(context),
            ),
            _buildActionTile(
              context,
              Icons.edit_note,
              "INTEL ENTRY",
              Colors.orangeAccent,
              () => _handleNewNote(context),
            ),
            _buildActionTile(
              context,
              Icons.map_outlined,
              "THEATRE MAP",
              Colors.greenAccent,
              () => _handleMapView(context),
            ),
            _buildActionTile(
              context,
              Icons.terminal,
              "AGENT TOOLS",
              Colors.blueGrey,
              () => _handleKnowledgeImport(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionTile(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return GlassCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      borderRadius: 16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPanel(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "MISSION DURATION",
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            fontSize: 11,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        GlassCard(
          padding: const EdgeInsets.all(24),
          borderRadius: 20,
          child: Column(
            children: [
              _buildStatusRow("MISSION START", "08:00 AM",
                  Theme.of(context).extension<StatusColors>()!.success),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Divider(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.15)),
              ),
              _buildStatusRow("ESTIMATED END", "05:00 PM",
                  theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              const SizedBox(height: 24),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 0.65,
                  backgroundColor:
                      theme.colorScheme.onSurface.withValues(alpha: 0.15),
                  color: theme.colorScheme.primary,
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusRow(String label, String value, Color valueColor) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.38),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyFeedSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCompanyFeedHeader(context),
        const SizedBox(height: 24),
        _buildCompanyFeedList(context),
      ],
    );
  }

  Widget _buildCompanyFeedHeader(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          "CORPORATE INTEL",
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.0,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(
            Icons.add_circle_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          onPressed: () => _handlePostAnnouncement(context),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            "ACCESS ARCHIVE",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyFeedList(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<List<CompanyAnnouncement>>(
      stream: context.read<AppDatabase>().watchActiveCompanyAnnouncements(),
      builder: (context, snapshot) {
        final announcements = snapshot.data ?? [];
        if (announcements.isEmpty) {
          return Text(
            "NO ACTIVE TRANSMISSIONS",
            style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                fontSize: 12),
          );
        }

        return SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: announcements.length,
            itemBuilder: (context, index) {
              final item = announcements[index];
              return Container(
                width: 340,
                margin: const EdgeInsets.only(right: 20),
                child: NewsCard(
                  title: item.title,
                  body: item.body,
                  icon: _getIconForCategory(item.category),
                  accentColor: _getColorForCategory(item.category),
                  actionLabel: item.actionLabel ?? "REVIEW",
                  onAction: () => _handleAnnouncementAction(context, item),
                ),
              );
            },
          ),
        );
      },
    );
  }

  IconData _getWeatherIcon(String? condition) {
    final c = condition?.toLowerCase() ?? "";
    if (c.contains('cloud')) return Icons.cloud_outlined;
    if (c.contains('rain')) return Icons.umbrella_outlined;
    if (c.contains('sun') || c.contains('clear')) {
      return Icons.wb_sunny_outlined;
    }
    return Icons.wb_cloudy_outlined;
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'hr':
        return Icons.security_outlined;
      case 'safety':
        return Icons.warning_amber_outlined;
      case 'fleet':
        return Icons.local_shipping_outlined;
      default:
        return Icons.info_outline;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'hr':
        return Colors.blueAccent;
      case 'safety':
        return Colors.redAccent;
      case 'fleet':
        return Colors.orangeAccent;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  void _handleScanReceipt(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ScanReceiptSheet(),
    );
  }

  void _handleNewNote(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const NewNoteSheet(),
    );
  }

  void _handleMapView(BuildContext context) =>
      context.read<NavigationState>().navigateToLocations();

  void _handleKnowledgeImport(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const KnowledgeImportScreen()),
    );
  }

  void _handlePostAnnouncement(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateAnnouncementSheet(),
    );
  }

  Future<void> _handleAnnouncementAction(
    BuildContext context,
    CompanyAnnouncement announcement,
  ) async {
    final db = context.read<AppDatabase>();
    if (announcement.category == 'safety') {
      await db.updateAnnouncementAcknowledged(announcement.id, true);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('TRANSMISSION ACKNOWLEDGED')),
        );
      }
    }
  }
}

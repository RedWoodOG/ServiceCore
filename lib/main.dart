import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'database/app_database.dart';
import 'database/seed_service.dart';
import 'features/home/home_view.dart';
import 'features/locations/locations_view.dart';
import 'features/work/work_view.dart';
import 'features/operations/operations_view.dart';
import 'features/people/people_view.dart';
import 'features/people/user_details_dialog.dart';
import 'features/knowledge/knowledge_home_view.dart';
import 'features/settings/settings_view.dart';
import 'features/auth/login_screen.dart';
import 'features/boot/boot_screen.dart';
import 'theme/app_theme.dart';
import 'app_shell/portal_shell.dart';
import 'app_shell/eva_state.dart';
import 'app_shell/navigation_state.dart';
import 'scripts/fix_starting_points.dart';
import 'util/log.dart';
import 'services/weather_update_manager.dart';
import 'features/continuing_education/continuing_education_home_view.dart';
import 'features/equipment/equipment_home_view.dart';
import 'features/expenses/expenses_home_view.dart';
import 'providers/theme_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/network_reachability_notifier.dart';

// PHASE 2: Security Services
import 'services/auth_service.dart';
import 'services/encryption_service.dart';

// Application Layer - Services
import 'application/application.dart';

// FLO messaging disabled
// import 'features/chat/services/portal_chat_service.dart';
// import 'features/chat/chat_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Catch and log all errors
  FlutterError.onError = (FlutterErrorDetails details) {
    Log.error('Flutter Error: ${details.exception}');
    Log.error('Stack: ${details.stack}');
    FlutterError.presentError(details);
  };

  // Global error boundary - catches all unhandled errors
  ErrorWidget.builder = (FlutterErrorDetails details) {
    Log.error('ErrorWidget shown: ${details.exception}');
    return Material(
      color: AppPalette.deepBlack,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppPalette.darkGrey,
            border: Border.all(color: AppPalette.alertRed, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, color: AppPalette.alertRed, size: 48),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Please restart the application',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  };

  // PHASE 2: Security services initialization
  // NOTE: Windows SID auto-authentication DISABLED to force login screen
  // Users must now login via LoginScreen with username/password
  User? currentUser;
  AuthService? authService;
  EncryptionService? encryptionService;

  try {
    Log.info('=== PHASE 2: Initializing Security Services ===');

    // Temporary database for auth (will be replaced with encrypted one)
    final tempDb = AppDatabase();

    // Initialize auth service (DO NOT auto-authenticate)
    authService = AuthService(tempDb);

    // LOGIN: DISABLED - Windows SID auto-auth removed to force login screen
    // currentUser = await authService.authenticateWindowsUser();

    // Initialize encryption service
    encryptionService = EncryptionService(authService);

    // Derive and verify keys (doesn't encrypt yet, just prepares)
    final keyFingerprint = await encryptionService.getKeyFingerprint();
    Log.info(
      'Encryption ready (Key fingerprint: ${keyFingerprint.substring(0, 16)}...)',
    );

    await tempDb.close();

    Log.info('=== PHASE 2: Security services initialized (login required) ===');
  } catch (e, stackTrace) {
    Log.error(
      'PHASE 2: Security initialization failed (non-fatal)',
      e,
      stackTrace,
    );
    Log.warn('Continuing with standard authentication...');
    // CRITICAL: Don't fail app startup - graceful degradation
    currentUser = null;
    authService = null;
    encryptionService = null;
  }

  // Initialize database
  final database = AppDatabase();

  // Debug: Print database path (for troubleshooting)
  try {
    final dbFolder = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dbFolder.path, 'fsc_portal_dev.sqlite');
    Log.info('Database path: $dbPath');
  } catch (e) {
    Log.info('Could not determine database path: $e');
  }

  // Seed the database with demo data
  try {
    await seedDatabase(database);
  } catch (e, stackTrace) {
    Log.error('Error seeding database: $e');
    Log.error('Stack: $stackTrace');
    // Continue anyway - app might work with existing data
  }

  // Fix starting point coordinates (one-time update for existing databases)
  try {
    await fixStartingPointCoordinates(database);
  } catch (e) {
    // Silently fail if coordinates already correct or points don't exist
    Log.info('Note: Starting point coordinates check: $e');
  }

  final networkReachability = NetworkReachabilityNotifier();
  await networkReachability.init();

  // Initialize EVA state
  final evaState = EvaState();
  evaState.setDatabase(database);

  // Initialize Navigation state
  final navigationState = NavigationState();

  // Initialize Theme Provider
  final themeProvider = ThemeProvider();

  // Initialize and start Weather Update Manager (skips HTTP when offline)
  final weatherManager = WeatherUpdateManager(
    database,
    isRemoteAllowed: () => networkReachability.isOnline,
  );
  weatherManager.start();

  // PHASE 2: Provenance service disabled (requires active login session)
  // Will be initialized after successful login via AuthProvider
  // if (authService != null && currentUser != null) {
  //   provenanceService = ProvenanceService(database, authService);
  // }

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        Provider<WeatherUpdateManager>.value(value: weatherManager),
        ChangeNotifierProvider<EvaState>.value(value: evaState),
        ChangeNotifierProvider<NavigationState>.value(value: navigationState),
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider<NetworkReachabilityNotifier>.value(
          value: networkReachability,
        ),
        // LOGIN: AuthProvider for session management
        ChangeNotifierProvider(create: (_) => AuthProvider(database)),
        // PHASE 2: Security services (nullable - graceful degradation)
        if (currentUser != null) Provider<User>.value(value: currentUser),
        if (authService != null)
          Provider<AuthService>.value(value: authService),
        if (encryptionService != null)
          Provider<EncryptionService>.value(value: encryptionService),
        // Application Layer Services (Tune-Up Contract Rule B)
        ProxyProvider2<AppDatabase, AuthProvider, WorkOrderService>(
          update: (_, db, auth, __) => WorkOrderService(
            db: db,
            currentUser: auth.currentUser,
          ),
        ),
        ProxyProvider2<AppDatabase, AuthProvider, ExpenseService>(
          update: (_, db, auth, __) => ExpenseService(
            db: db,
            currentUser: auth.currentUser,
          ),
        ),
        ProxyProvider2<AppDatabase, AuthProvider, LocationService>(
          update: (_, db, auth, __) => LocationService(
            db: db,
            currentUser: auth.currentUser,
          ),
        ),
        ProxyProvider2<AppDatabase, AuthProvider, EquipmentService>(
          update: (_, db, auth, __) => EquipmentService(
            db: db,
            currentUser: auth.currentUser,
          ),
        ),
        ProxyProvider2<AppDatabase, AuthProvider, KnowledgeService>(
          update: (_, db, auth, __) => KnowledgeService(
            db: db,
            currentUser: auth.currentUser,
          ),
        ),
        ProxyProvider2<AppDatabase, AuthProvider, ImportService>(
          update: (_, db, auth, __) => ImportService(
            db: db,
            currentUser: auth.currentUser,
          ),
        ),
        ProxyProvider2<AppDatabase, AuthProvider, DocumentService>(
          update: (_, db, auth, __) => DocumentService(
            db: db,
            currentUser: auth.currentUser,
          ),
        ),
        ProxyProvider2<AppDatabase, AuthProvider, NoteService>(
          update: (_, db, auth, __) => NoteService(
            db: db,
            currentUser: auth.currentUser,
          ),
        ),
        ProxyProvider2<AppDatabase, AuthProvider, AnnouncementService>(
          update: (_, db, auth, __) => AnnouncementService(
            db: db,
            currentUser: auth.currentUser,
          ),
        ),
      ],
      child: const PortalOfflineApp(),
    ),
  );
}

class PortalOfflineApp extends StatefulWidget {
  const PortalOfflineApp({super.key});

  @override
  State<PortalOfflineApp> createState() => _PortalOfflineAppState();
}

class _PortalOfflineAppState extends State<PortalOfflineApp> {
  final BootService _bootService = BootService();
  bool _bootComplete = false;

  @override
  void initState() {
    super.initState();
    _runBootCheck();
  }

  @override
  void dispose() {
    _bootService.dispose();
    super.dispose();
  }

  Future<void> _runBootCheck() async {
    final state = await _bootService.boot();
    if (mounted) {
      setState(() {
        _bootComplete = state is BootComplete;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'FSC Portal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      // Rule C: Boot is a state machine - show BootScreen during startup
      home: _bootComplete
          ? const AuthenticationGate()
          : BootScreen(
              bootService: _bootService,
              onBootComplete: () {
                if (mounted) {
                  setState(() => _bootComplete = true);
                }
              },
            ),
    );
  }
}

/// Authentication Gate - Decides whether to show login screen or main app
///
/// CRITICAL SECURITY BEHAVIOR:
/// - ALWAYS shows LoginScreen on app startup
/// - Even if session exists, user must enter password
/// - "Remember me" only auto-fills username, never bypasses login
class AuthenticationGate extends StatelessWidget {
  const AuthenticationGate({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    // Show loading spinner while checking session
    if (authProvider.isLoading) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text('Loading...', style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      );
    }

    // ALWAYS show LoginScreen if not authenticated
    // This ensures login screen appears EVERY time the app starts
    if (!authProvider.isAuthenticated) {
      return LoginScreen();
    }

    // Show main app only if authenticated (after successful login)
    return const MainNavigationScreen();
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    // LOGIN: Get current user from AuthProvider (no longer hardcoded to ID 1)
    final authProvider = context.read<AuthProvider>();
    if (mounted) {
      setState(() {
        _currentUser = authProvider.currentUser;
      });
    }
  }

  final List<Widget> _screens = [
    const HomeView(),
    const WorkView(),
    const OperationsView(), // Operations - connected to local database
    const LocationsView(),
    const PeopleView(),
    const KnowledgeHomeView(), // Knowledge Base
    const ContinuingEducationHomeView(), // NEW
    const EquipmentHomeView(), // NEW
    const ExpensesHomeView(), // NEW
    const SettingsView(), // Settings
    // FLO messaging disabled
  ];

  final List<Map<String, dynamic>> _navItems = [
    {'icon': Icons.home, 'label': 'Home'},
    {'icon': Icons.work, 'label': 'Work'},
    {'icon': Icons.settings, 'label': 'Operations'},
    {'icon': Icons.location_on, 'label': 'Locations'},
    {'icon': Icons.people, 'label': 'People'},
    {'icon': Icons.library_books, 'label': 'Knowledge'},
    {'icon': Icons.school, 'label': 'Training'}, // NEW - Continuing Education
    {'icon': Icons.inventory, 'label': 'Equipment'}, // NEW - Equipment
    {'icon': Icons.receipt_long, 'label': 'Expenses'}, // NEW - Expenses
    {'icon': Icons.settings_applications, 'label': 'Settings'},

    // FLO messaging disabled
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 600;
        final navigationState = context.watch<NavigationState>();
        final selectedIndex = navigationState.selectedIndex;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: isMobile
              ? Column(
                  children: [
                    _ConnectivityStatusBar(compact: true),
                    Expanded(
                      child: PortalShell(child: _screens[selectedIndex]),
                    ),
                  ],
                )
              : Row(
                  children: [
                    // Sidebar Navigation
                    Container(
                      width: AppLayout.sidebarWidth,
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        children: [
                          // Logo/Brand
                          Container(
                            padding: const EdgeInsets.all(24),
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/logo.webp',
                                  height: AppLayout.logoSize,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: AppLayout.logoSize,
                                      height: AppLayout.logoSize,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        borderRadius: BorderRadius.circular(
                                          AppLayout.radiusMD,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.bolt,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        size: AppIcons.sizeMD,
                                      ),
                                    );
                                  },
                                ),
                                const SizedBox(width: 12),
                                Builder(
                                  builder: (context) => Text(
                                    'Portal',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Theme.of(context).dividerColor,
                            height: 1,
                          ),
                          // Navigation Items
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              itemCount: _navItems.length,
                              itemBuilder: (context, index) {
                                final item = _navItems[index];
                                final isSelected = selectedIndex == index;
                                return _buildNavItem(
                                  icon: item['icon'],
                                  label: item['label'],
                                  isSelected: isSelected,
                                  onTap: () {
                                    navigationState.navigateTo(index);
                                  },
                                );
                              },
                            ),
                          ),
                          Divider(
                            color: Theme.of(context).dividerColor,
                            height: 1,
                          ),
                          const _ConnectivityStatusBar(compact: false),
                          Divider(
                            color: Theme.of(context).dividerColor,
                            height: 1,
                          ),
                          // User Profile
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                if (_currentUser != null) {
                                  await showDialog(
                                    context: context,
                                    builder: (context) =>
                                        UserDetailsDialog(user: _currentUser!),
                                  );
                                  _loadUser();
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration:
                                          AppComponents.userAvatarDecoration,
                                      child: Center(
                                        child: Text(
                                          _currentUser?.fullName.isNotEmpty ==
                                                  true
                                              ? _currentUser!.fullName[0]
                                              : 'A',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            _currentUser?.fullName ??
                                                'Loading...',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                    fontWeight:
                                                        FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            _currentUser?.role.toUpperCase() ??
                                                'OFFLINE',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .onSurface
                                                        .withValues(alpha: 0.5)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.nights_stay,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.5),
                                      size: AppIcons.sizeMD,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // LOGIN: Logout Button
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () async {
                                // Capture context-dependent values before any async operations
                                final navigator = Navigator.of(context);
                                final authProvider =
                                    context.read<AuthProvider>();

                                // Confirm logout
                                final confirmed = await showDialog<bool>(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: const Text('Logout'),
                                    content: const Text(
                                      'Are you sure you want to logout?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(dialogContext, true),
                                        child: const Text('Logout'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirmed == true && mounted) {
                                  await authProvider.logout();

                                  // Navigate back to login screen
                                  if (mounted) {
                                    navigator.pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface
                                          .withValues(alpha: 0.5),
                                      size: AppIcons.sizeMD,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      'Logout',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withValues(alpha: 0.5),
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Main Content
                    Expanded(
                      child: PortalShell(child: _screens[selectedIndex]),
                    ),
                  ],
                ),
          bottomNavigationBar: isMobile
              ? Builder(
                  builder: (context) {
                    final theme = Theme.of(context);
                    return BottomNavigationBar(
                      items: _navItems
                          .take(5)
                          .map(
                            (item) => BottomNavigationBarItem(
                              icon: Icon(item['icon']),
                              label: item['label'],
                            ),
                          )
                          .toList(),
                      currentIndex: selectedIndex >= 5 ? 0 : selectedIndex,
                      onTap: (index) {
                        navigationState.navigateTo(index);
                      },
                      backgroundColor: theme.scaffoldBackgroundColor,
                      selectedItemColor: theme.colorScheme.primary,
                      unselectedItemColor:
                          theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      type: BottomNavigationBarType.fixed,
                    );
                  },
                )
              : null,
        );
      },
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      icon,
                      color: isSelected
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      size: AppLayout.navIconSize,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isSelected
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Sidebar / mobile strip: shows interface-level online vs offline for hybrid UX.
class _ConnectivityStatusBar extends StatelessWidget {
  const _ConnectivityStatusBar({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkReachabilityNotifier>(
      builder: (context, net, _) {
        final theme = Theme.of(context);
        final onlineColor = theme.colorScheme.primary;
        final muted = theme.colorScheme.onSurface.withValues(alpha: 0.55);

        if (compact) {
          return Material(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.35,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                children: [
                  Icon(
                    net.isOnline
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_off_outlined,
                    size: 18,
                    color: net.isOnline ? onlineColor : muted,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      net.isOnline
                          ? 'Online — live updates'
                          : 'Offline — local only',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
          child: Material(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.25,
            ),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  Icon(
                    net.isOnline
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_off_outlined,
                    size: 20,
                    color: net.isOnline ? onlineColor : muted,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          net.isOnline ? 'Online' : 'Offline',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          net.isOnline
                              ? 'Live updates (e.g. weather) can run'
                              : 'Work orders & data stay local',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: muted,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

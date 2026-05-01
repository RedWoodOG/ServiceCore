// Updated main.dart with proper login flow
// Replace your existing main() and MyApp

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/app_database.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'features/auth/login_screen.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database
  final database = AppDatabase();

  // Seed database if needed
  // await seedDatabase(database);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        ChangeNotifierProvider(create: (_) => AuthProvider(database)),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        // ... your other providers ...
      ],
      child: const FSCPortalApp(),
    ),
  );
}

class FSCPortalApp extends StatelessWidget {
  const FSCPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      title: 'FSC Portal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      home: const AuthenticationGate(),
    );
  }
}

/// Authentication Gate - Decides to show login or main app
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
              Text(
                'Loading...',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
        ),
      );
    }

    // Show login screen if not authenticated
    // ALWAYS show login screen on startup (even if remembered)
    if (!authProvider.isAuthenticated) {
      return const LoginScreen();
    }

    // Show main app if authenticated
    return const MainNavigationScreen(); // Your existing main screen
  }
}

// Note: Keep your existing MainNavigationScreen class
// Just make sure it can access the current user via:
// final authProvider = context.read<AuthProvider>();
// final currentUser = authProvider.currentUser;

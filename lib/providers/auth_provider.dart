import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/app_database.dart';

/// Authentication Provider - Manages user session
///
/// KEY BEHAVIOR: ALWAYS shows login screen on startup
/// - "Remember me" only auto-fills username
/// - Password is ALWAYS required
/// - No auto-login (security requirement)
class AuthProvider extends ChangeNotifier {
  final AppDatabase database;

  User? _currentUser;
  bool _isAuthenticated = false;
  bool _isLoading = true;

  AuthProvider(this.database) {
    _checkExistingSession();
  }

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;

  /// Check if user has existing session
  /// NOTE: This does NOT auto-login - it only restores session state
  /// The AuthenticationGate will ALWAYS show LoginScreen regardless
  Future<void> _checkExistingSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;

      if (isLoggedIn) {
        final userId = prefs.getInt('current_user_id');
        if (userId != null) {
          final user = await database.getUserById(userId);
          if (user != null) {
            _currentUser = user;
            _isAuthenticated = true;
          }
        }
      }
    } catch (e) {
      debugPrint('Error checking session: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login with username and password
  Future<bool> login(String username, String password, {bool rememberMe = false}) async {
    try {
      final user = await database.getUserByUsername(username);

      if (user == null) {
        return false;
      }

      // Password validation (plaintext comparison - TODO: add hashing in production)
      if (user.password.isNotEmpty && user.password != password) {
        return false;
      }

      // Save session
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('current_user_id', user.id);
      await prefs.setBool('is_logged_in', true);

      if (rememberMe) {
        await prefs.setInt('remembered_user_id', user.id);
        await prefs.setString('remembered_username', user.username);
      } else {
        // Clear remember me if unchecked
        await prefs.remove('remembered_user_id');
        await prefs.remove('remembered_username');
      }

      _currentUser = user;
      _isAuthenticated = true;
      notifyListeners();

      return true;
    } catch (e) {
      debugPrint('Login error: $e');
      return false;
    }
  }

  /// Logout current user
  /// NOTE: Keeps "remember me" username for auto-fill on next login
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('current_user_id');
      await prefs.setBool('is_logged_in', false);
      // Keep remembered_user_id for auto-fill

      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }

  /// Check if user should be remembered (for auto-filling username)
  Future<String?> getRememberedUsername() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('remembered_username');
    } catch (e) {
      return null;
    }
  }

  /// Clear remember me data (user manually unchecked "Remember me")
  Future<void> clearRememberedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('remembered_user_id');
      await prefs.remove('remembered_username');
    } catch (e) {
      debugPrint('Clear remembered user error: $e');
    }
  }
}

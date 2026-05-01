import 'dart:io';
import 'package:drift/drift.dart';
import '../database/app_database.dart';
import '../util/log.dart';

class AuthService {
  final AppDatabase db;

  AuthService(this.db);

  /// Get current Windows user SID (Security Identifier)
  /// Simplified implementation using environment variables as fallback
  String getWindowsSID() {
    try {
      // Try PowerShell command for reliable SID retrieval
      final result = Process.runSync('powershell', [
        '-Command',
        '[System.Security.Principal.WindowsIdentity]::GetCurrent().User.Value',
      ]);

      if (result.exitCode == 0) {
        final sid = result.stdout.toString().trim();
        if (sid.isNotEmpty && sid.startsWith('S-1-5-')) {
          Log.info('Windows SID resolved: $sid');
          return sid;
        }
      }

      Log.warn('PowerShell SID resolution failed, using fallback');
    } catch (e) {
      Log.warn('SID resolution via PowerShell failed: $e');
    }

    // Fallback: Generate deterministic ID from username + computer
    return _generateFallbackSID();
  }

  /// Generate deterministic fallback SID
  String _generateFallbackSID() {
    final username = Platform.environment['USERNAME'] ?? 'Unknown';
    final computer = Platform.environment['COMPUTERNAME'] ?? 'Unknown';
    final domain = Platform.environment['USERDOMAIN'] ?? 'WORKGROUP';

    // Create pseudo-SID format for consistency
    final hash = '$domain\\$username@$computer'.hashCode.abs();
    final fallbackSid = 'S-1-5-21-FALLBACK-$hash';

    Log.info('Using fallback SID: $fallbackSid');
    return fallbackSid;
  }

  /// Get current Windows username
  String getWindowsUsername() {
    try {
      // Use environment variable (most reliable)
      final username = Platform.environment['USERNAME'];
      if (username != null && username.isNotEmpty) {
        return username;
      }

      Log.warn('USERNAME environment variable not found');
      return 'Unknown User';
    } catch (e, stackTrace) {
      Log.error('Failed to get Windows username', e, stackTrace);
      return 'Unknown User';
    }
  }

  /// Get machine GUID from Windows registry (via PowerShell)
  String getMachineGUID() {
    try {
      // Use PowerShell to read registry
      final result = Process.runSync('powershell', [
        '-Command',
        'Get-ItemPropertyValue -Path "HKLM:\\SOFTWARE\\Microsoft\\Cryptography" -Name MachineGuid',
      ]);

      if (result.exitCode == 0) {
        final guid = result.stdout.toString().trim();
        if (guid.isNotEmpty) {
          Log.info('Machine GUID resolved: $guid');
          return guid;
        }
      }

      Log.warn('PowerShell registry read failed, using fallback');
    } catch (e) {
      Log.warn('Machine GUID resolution failed: $e');
    }

    return _generateFallbackMachineId();
  }

  /// Generate fallback machine ID if registry unavailable
  String _generateFallbackMachineId() {
    // Use computer name from environment
    final computer = Platform.environment['COMPUTERNAME'] ?? 'UNKNOWN';
    return 'MACHINE-$computer';
  }

  /// Get or create user based on Windows SID
  Future<User> authenticateWindowsUser() async {
    final sid = getWindowsSID();
    final username = getWindowsUsername();

    Log.info('Authenticating Windows user: $username (SID: $sid)');

    // Check if user exists with this SID
    var user = await db.getUserBySID(sid);

    if (user == null) {
      // Create new user from Windows identity
      Log.info('Creating new user from Windows identity: $username');

      final userId = await db
          .into(db.users)
          .insert(
            UsersCompanion.insert(
              username: username,
              fullName: username, // Can be updated later in settings
              email: '$username@local',
              role: 'tech', // Default role, admin can change
              windowsSid: Value(sid),
              lastLoginAt: Value(DateTime.now()),
              loginCount: const Value(1),
            ),
          );

      user = await db.getUserById(userId);

      if (user == null) {
        throw Exception('Failed to create user after insert');
      }
    } else {
      // Update login tracking
      Log.info('User found: ${user.fullName} (ID: ${user.id})');

      await db
          .update(db.users)
          .replace(
            user.copyWith(
              lastLoginAt: Value(DateTime.now()),
              loginCount: user.loginCount + 1,
            ),
          );

      // Reload user with updated data
      user = await db.getUserBySID(sid);
    }

    Log.info(
      'User authenticated: ${user!.fullName} (ID: ${user.id}, Login #${user.loginCount})',
    );
    return user;
  }

  /// Check if current user is admin
  Future<bool> isCurrentUserAdmin() async {
    try {
      final user = await authenticateWindowsUser();
      return user.role == 'admin';
    } catch (e) {
      return false;
    }
  }

  /// Check if user is member of Windows Administrators group
  bool isWindowsAdmin() {
    try {
      // Use PowerShell to check admin group membership
      final result = Process.runSync('powershell', [
        '-Command',
        '([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)',
      ]);

      if (result.exitCode == 0) {
        final isAdmin = result.stdout.toString().trim().toLowerCase() == 'true';
        Log.info('Windows admin check: $isAdmin');
        return isAdmin;
      }

      Log.warn('Admin check failed, assuming false');
      return false;
    } catch (e, stackTrace) {
      Log.error('Failed to check Windows admin status', e, stackTrace);
      return false;
    }
  }
}

# Login System Documentation

## Overview

A complete login system was implemented to replace the hardcoded User ID 1 authentication and Windows SID auto-login. The system requires users to log in with a username on every app launch.

**Status**: Development Mode (Password validation DISABLED)

---

## Files Created

### 1. `lib/providers/auth_provider.dart`
**Purpose**: Manages user authentication state and session

**Key Methods**:
- `login(username, password, rememberMe)` - Authenticates user
- `logout()` - Clears session, keeps "remember me" data
- `getRememberedUsername()` - Returns saved username for auto-fill
- `clearRememberedUser()` - Removes saved username

**Session Storage** (SharedPreferences):
- `current_user_id` - Currently logged in user ID
- `is_logged_in` - Session active flag
- `remembered_user_id` - Saved user ID for "remember me"
- `remembered_username` - Saved username for auto-fill

### 2. `lib/features/auth/login_screen.dart`
**Purpose**: Login UI with username/password fields

**Features**:
- Username and password input fields
- "Remember me" checkbox (auto-fills username only)
- Error message display
- Loading state during login
- Auto-fills username from previous session if "Remember me" was checked

### 3. Modified: `lib/main.dart`
**Changes**:
- Added `AuthProvider` to providers
- Added `AuthenticationGate` widget as app entry point
- Disabled Windows SID auto-authentication (line 104)
- Updated `MainNavigationScreen._loadUser()` to use `AuthProvider`
- Added logout button in sidebar

---

## Authentication Flow

```
App Launch
    ↓
AuthenticationGate checks AuthProvider.isLoading
    ↓
Shows "Loading..." spinner
    ↓
AuthProvider._checkExistingSession() completes
    ↓
Checks AuthProvider.isAuthenticated
    ↓
If FALSE → LoginScreen shown
    ↓
User enters username + password (any password works in dev)
    ↓
AuthProvider.login() validates username
    ↓
Session saved to SharedPreferences
    ↓
MainNavigationScreen shown
```

---

## Modified Feature Files (Updated to use AuthProvider)

| File | Line | Changed From | Changed To |
|------|------|-------------|------------|
| `features/home/new_note_sheet.dart` | ~62 | `db.getUserById(1)` | `authProvider.currentUser` |
| `features/home/scan_receipt_sheet.dart` | ~97 | `db.getUserById(1)` | `authProvider.currentUser` |
| `features/work/create_work_order_sheet.dart` | ~211 | `db.getUserById(1)` | `authProvider.currentUser` |
| `features/chat/chat_view.dart` | ~184 | `db.getUserById(1)` | `authProvider.currentUser` |
| `main.dart` | ~268 | `db.getUserById(1)` | `authProvider.currentUser` |

---

## Development Mode Settings

### Password Validation DISABLED

**Location 1**: `lib/providers/auth_provider.dart:56`
```dart
// CURRENT (Development):
final passwordValid = true;

// TODO: Production - Enable password verification:
// final passwordValid = user.password == hashPassword(password);
```

**Location 2**: `lib/features/auth/login_screen.dart:58`
```dart
// CURRENT (Development):
final passwordValid = true; // TEMPORARY

// TODO: Production - Enable password verification:
// import 'package:crypto/crypto.dart';
// final hashedInput = sha256.convert(utf8.encode(password)).toString();
// final passwordValid = user.password == hashedInput;
```

### How to Login (Development Mode)

1. Run the app
2. Enter **any username from the database** (e.g., `jwhite`)
3. Enter **any password** (literally anything - validation is disabled)
4. Check "Remember me" to auto-fill username next time
5. Click Login

### To Find Available Usernames
```powershell
sqlite3 "C:\Users\jwhit\OneDrive\Documents\fsc_portal_dev.sqlite" "SELECT username, full_name, role FROM users;"
```

---

## Production Readiness Checklist

### Required Before Production Deployment

- [ ] **Implement password hashing**
  - Add `bcrypt` or `argon2` package
  - Hash passwords during user creation
  - Verify hashes during login

- [ ] **Add password setup/reset flow**
  - Users currently have empty passwords
  - Need way to set initial passwords
  - Need password reset mechanism

- [ ] **Enable password validation**
  - Uncomment/replace `final passwordValid = true;` in both files

- [ ] **Secure session storage**
  - Replace `SharedPreferences` with `flutter_secure_storage`
  - Encrypt session data

- [ ] **Add login attempt tracking**
  - Log failed login attempts
  - Implement account lockout after N failed attempts

- [ ] **Add session expiry**
  - Implement timeout after inactivity
  - Force re-login after session expires

- [ ] **Add audit logging**
  - Track all login/logout events
  - Track failed authentication attempts

---

## Security Notes

### What Works Currently
- ✅ Login screen ALWAYS shows on startup
- ✅ Cannot bypass login screen
- ✅ Username validation (must exist in database)
- ✅ Session management
- ✅ Logout functionality
- ✅ "Remember me" for username only

### What Does NOT Work (Intentionally for Development)
- ❌ Password validation (accepts any password)
- ❌ Failed login attempt tracking
- ❌ Account lockout
- ❌ Session expiry

### Known Limitations
- Passwords are stored empty in database (need setup flow)
- Session data in SharedPreferences (not encrypted)
- No rate limiting on login attempts
- No multi-factor authentication

---

## Database Schema (No Changes Required)

The login system uses the EXISTING `Users` table:

```sql
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL,
  role TEXT NOT NULL,
  password TEXT DEFAULT '',           -- Used for future password validation
  windows_sid TEXT,                   -- No longer used for auto-login
  last_login_at INTEGER,
  login_count INTEGER DEFAULT 0
);
```

**No new tables were created.**
**No schema migrations were required.**

---

## Troubleshooting

### Login screen never shows
- Verify `home: const AuthenticationGate()` in MaterialApp (main.dart:221)
- Check that AuthProvider is in MultiProvider (main.dart:190)

### "User not found" error
- Run: `sqlite3 "path/to/database.sqlite" "SELECT username FROM users;"`
- Use exact username from database (case-sensitive)

### Password always fails
- Verify `final passwordValid = true;` is NOT commented out
- Check both auth_provider.dart and login_screen.dart

### Username not auto-filling
- Verify "Remember me" was checked during previous login
- Check SharedPreferences is working: `shared_preferences: ^2.2.2` in pubspec.yaml

### After logout, still logged in
- Clear app data or SharedPreferences manually
- Check `authProvider.logout()` is being called

---

## Future Enhancements (Optional)

- [ ] Biometric authentication (fingerprint/face)
- [ ] "Keep me logged in" option (longer sessions)
- [ ] Multi-user support (fast user switching)
- [ ] Last login display on login screen
- [ ] Password strength meter
- [ ] Two-factor authentication
- [ ] LDAP/Active Directory integration
- [ ] SSO support

---

## Questions?

Refer to:
- `lib/providers/auth_provider.dart` - Session management logic
- `lib/features/auth/login_screen.dart` - UI implementation
- `lib/main.dart` - App entry point and AuthenticationGate

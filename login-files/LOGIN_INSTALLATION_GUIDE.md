# Login System Installation Guide

## What This Adds

1. ✅ **Proper login screen** on startup
2. ✅ **Username/password authentication**
3. ✅ **"Remember me" checkbox** (optional)
4. ✅ **Always shows login** (no auto-login)
5. ✅ **Session management**
6. ✅ **Logout functionality**

---

## Step 1: Verify Dependencies

Make sure these are in `pubspec.yaml`:

```yaml
dependencies:
  provider: ^6.1.1
  shared_preferences: ^2.2.2
```

Run:
```powershell
cd "H:\FSC_Portal\FSC-Portal"
flutter pub get
```

---

## Step 2: Create Auth Provider

**Create file:**
```
H:\FSC_Portal\FSC-Portal\lib\providers\auth_provider.dart
```

**Copy contents from:** `auth_provider.dart`

---

## Step 3: Create Login Screen

**Create file:**
```
H:\FSC_Portal\FSC-Portal\lib\features\auth\login_screen.dart
```

**Copy contents from:** `login_screen.dart`

**IMPORTANT:** Update this line in login_screen.dart:
```dart
// Line ~107 - Replace MainApp with your actual main screen
Navigator.of(context).pushReplacement(
  MaterialPageRoute(
    builder: (context) => const MainNavigationScreen(), // ← YOUR SCREEN
  ),
);
```

---

## Step 4: Update main.dart

**Option A: Full Replacement**
Replace your entire `main()` function and `MyApp` class with the code from `main_with_login.dart`.

**Option B: Manual Update** (if you have custom setup)

1. Add AuthProvider to your providers:
```dart
ChangeNotifierProvider(create: (_) => AuthProvider(database)),
```

2. Change your `home:` in MaterialApp:
```dart
MaterialApp(
  // ...
  home: const AuthenticationGate(), // ← Changed from MainNavigationScreen
);
```

3. Add the AuthenticationGate widget (copy from main_with_login.dart)

---

## Step 5: Update MainNavigationScreen

In your `_MainNavigationScreenState` class, replace the `_loadUser()` method:

**OLD CODE (remove this):**
```dart
Future<void> _loadUser() async {
  final db = context.read<AppDatabase>();
  final user = await db.getUserById(1); // ← HARDCODED!
  if (mounted && user != null) {
    setState(() {
      _currentUser = user;
    });
  }
}
```

**NEW CODE (add this):**
```dart
Future<void> _loadUser() async {
  final authProvider = context.read<AuthProvider>();
  if (mounted) {
    setState(() {
      _currentUser = authProvider.currentUser;
    });
  }
}
```

---

## Step 6: Add Logout Button

Add a logout button to your sidebar (optional):

```dart
// In your sidebar, after the user profile section:
ListTile(
  leading: const Icon(Icons.logout),
  title: const Text('Logout'),
  onTap: () async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.logout();
    
    if (mounted) {
      // Navigate back to login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  },
),
```

---

## Step 7: Test Users

Your existing database should have users. Test with:

**Username:** `jwhite` (or any username from your Users table)
**Password:** Any password (password check disabled for now)

**To see available users**, run in PowerShell:
```powershell
sqlite3 "C:\Users\jwhit\OneDrive\Documents\fsc_portal_dev.sqlite" "SELECT username, full_name, role FROM users;"
```

---

## How It Works

### First Launch:
1. App starts → Shows loading
2. Checks for session → None found
3. Shows login screen

### Login:
1. User enters username/password
2. Checks database
3. If valid → Creates session
4. If "Remember Me" → Saves username
5. Navigates to main app

### Next Launch:
1. App starts → Shows loading
2. Checks session → **ALWAYS shows login**
3. Username auto-filled if remembered

### Logout:
1. Click logout button
2. Clears session
3. Returns to login screen

---

## What "Remember Me" Does

- ✅ **Auto-fills username** on next login
- ❌ **Does NOT auto-login** (still requires password)
- ❌ **Does NOT skip login screen**

If you want auto-login (skip login screen):
- Tell me and I'll add that option

---

## Customization Options

### Want auto-login when remembered?
Change in `auth_provider.dart`:
```dart
// In _checkExistingSession(), also check:
final rememberedUserId = prefs.getInt('remembered_user_id');
```

### Want to require password verification?
In `auth_provider.dart`, replace:
```dart
// Line ~53
final passwordValid = true; // TEMPORARY

// With:
final passwordValid = user.password == password; // Or use hashing
```

---

## Testing Checklist

1. ☐ Run app → Should show login screen
2. ☐ Enter wrong username → Should show error
3. ☐ Enter correct username → Should login
4. ☐ Check "Remember me" → Logout → Username auto-filled
5. ☐ Don't check "Remember me" → Logout → Username empty
6. ☐ Close app completely → Reopen → Should show login again

---

## Troubleshooting

**Login screen never shows:**
- Check that you updated the MaterialApp `home:` to AuthenticationGate

**"User not found" error:**
- Run the sqlite3 command above to see available usernames

**App crashes on login:**
- Check that AuthProvider is in your MultiProvider

**Username not auto-filling:**
- Check SharedPreferences is in pubspec.yaml
- Verify "Remember me" was checked

---

## Need Help?

Tell me which step isn't working and I'll debug it with you.

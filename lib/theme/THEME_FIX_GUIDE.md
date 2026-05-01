# Theme Fix Installation Guide

## What This Fixes

1. ✅ **Light theme now uses white backgrounds** (not dark)
2. ✅ **Dark theme stays as it is** (working correctly)
3. ✅ **Proper text contrast** in both themes
4. ✅ **Working theme toggle** that persists
5. ✅ **FSC brand colors** from your logo

---

## Step 1: Add Dependency

Add to `pubspec.yaml`:

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

## Step 2: Replace Theme File

**Replace** your existing file:
```
H:\FSC_Portal\FSC-Portal\lib\theme\app_theme.dart
```

With the new fixed version:
```
app_theme_fixed.dart
```

---

## Step 3: Add Theme Provider

**Create new file:**
```
H:\FSC_Portal\FSC-Portal\lib\providers\theme_provider.dart
```

**Copy** `theme_provider.dart` contents into it.

---

## Step 4: Add Theme Toggle Widget

**Create new file:**
```
H:\FSC_Portal\FSC-Portal\lib\widgets\theme_toggle_button.dart
```

**Copy** `theme_toggle_button.dart` contents into it.

---

## Step 5: Update main.dart

**Find your `main.dart`** and wrap your app with the provider:

```dart
import 'package:provider/provider.dart';
import 'providers/theme_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'FSC Portal',
      theme: AppTheme.lightTheme,      // ← Light theme
      darkTheme: AppTheme.darkTheme,   // ← Dark theme
      themeMode: themeProvider.themeMode, // ← Switches between them
      home: YourHomePage(),
    );
  }
}
```

---

## Step 6: Add Toggle to Sidebar

In your sidebar widget, add the toggle button:

```dart
import 'widgets/theme_toggle_button.dart';

// In your sidebar build method:
Column(
  children: [
    // ... your existing nav items ...
    
    const Divider(),
    
    // Add theme toggle
    const ThemeToggleButton(),
    
    // ... rest of sidebar ...
  ],
)
```

---

## Step 7: Test

1. Run the app
2. Click the theme toggle button
3. Should switch between:
   - **Dark**: Black background, white text
   - **Light**: White background, dark text
4. Toggle persists when you restart

---

## What Changed

### Light Theme Now Has:
- ✅ White backgrounds (`#FFFFFF`)
- ✅ Light gray surfaces (`#F5F7FA`)
- ✅ Dark text for readability (`#1A1D1F`)
- ✅ FSC Royal Blue accents (`#1E4FA0`)
- ✅ Proper borders (`#E0E4E8`)

### Dark Theme Kept:
- ✅ Deep black backgrounds (`#121212`)
- ✅ Dark gray cards (`#1E1E1E`)
- ✅ White text (`#FFFFFF`)
- ✅ Blue accents

---

## If It Doesn't Work

1. **Check pubspec.yaml** has the dependencies
2. **Run** `flutter pub get`
3. **Verify** imports in main.dart
4. **Rebuild** the app completely

---

## Need Help?

Tell me which step failed and I'll help you fix it.

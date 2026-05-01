# How to Launch Portal Offline

## Quick Launch (Easiest)

### In Cursor/VS Code:

1. **Open the project folder** in Cursor:
   - File → Open Folder
   - Navigate to: `H:\FSC_Portal\Offline-Portal`
   - Click "Select Folder"

2. **Press F5** (or click the Run button in the top right)

3. **Select "Portal Offline (Windows)"** from the dropdown if prompted

4. The app will build and launch automatically!

---

## Alternative: Command Line

If you have Flutter in your PATH:

```powershell
cd H:\FSC_Portal\Offline-Portal
flutter run -d windows
```

---

## Troubleshooting

### "Flutter not found"
- Make sure Flutter is installed
- Add Flutter to your PATH, or
- Use the Cursor/VS Code method (F5) - it will find Flutter automatically if the Flutter extension is installed

### "No devices found"
- Make sure you're on Windows
- The app should automatically target Windows desktop

### Build errors
- Run `flutter pub get` first
- Make sure all dependencies are installed

---

## What Happens When You Launch

1. Flutter will compile the Dart code
2. Build the Windows executable
3. Launch the app in a new window
4. You'll see the Portal Offline interface with:
   - Sidebar navigation
   - Home dashboard
   - EVA panel (collapsed on the right)
   - All features ready to demo!

---

**Ready to go! Just press F5 in Cursor!** 🚀

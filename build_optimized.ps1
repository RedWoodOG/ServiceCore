# Flutter Optimized Build Script
# Usage: ./build_optimized.ps1

Write-Host "--- Starting Optimized Android Build for Offline-Portal ---" -ForegroundColor Cyan

# 1. Clean
Write-Host "[1/4] Cleaning previous builds..."
flutter clean

# 2. Get Dependencies
Write-Host "[2/4] Fetching dependencies..."
flutter pub get

# 3. Code Generation
Write-Host "[3/4] Running code generation (Drift)..."
flutter pub run build_runner build --delete-conflicting-outputs

# 4. Build Optimized APKs
Write-Host "[4/4] Building Optimized APKs..."
flutter build apk --release --split-per-abi --obfuscate --split-debug-info=./debug-info

Write-Host "Build Complete!" -ForegroundColor Green
Write-Host "APKs are located in: build/app/outputs/flutter-apk/" -ForegroundColor White

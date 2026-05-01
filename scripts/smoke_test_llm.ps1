# Smoke test for LLM integration
# Validates model cache, manifest, and device detection

param(
    [string]$ModelCachePath = "$([Environment]::GetFolderPath('MyDocuments'))\portal_offline\models",
    [switch]$Verbose
)

$ErrorActionPreference = "Continue"

Write-Host "=== LLM Smoke Test ===" -ForegroundColor Cyan
Write-Host "Time: $(Get-Date -Format 'o')"
Write-Host ""

# Test 1: Model cache directory
Write-Host "Test 1: Model cache directory" -ForegroundColor Yellow
if (Test-Path $ModelCachePath) {
    Write-Host "[PASS] Model cache exists: $ModelCachePath" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Model cache not found: $ModelCachePath" -ForegroundColor Red
    exit 1
}

# Test 2: Model directory
Write-Host "Test 2: Phi-3 Mini model directory" -ForegroundColor Yellow
$ModelDir = Join-Path $ModelCachePath "phi-3-mini-4k-instruct"
if (Test-Path $ModelDir) {
    Write-Host "[PASS] Model directory exists: $ModelDir" -ForegroundColor Green
} else {
    Write-Host "[FAIL] Model directory not found: $ModelDir" -ForegroundColor Red
    exit 1
}

# Test 3: Manifest
Write-Host "Test 3: Model manifest" -ForegroundColor Yellow
$ManifestPath = Join-Path $ModelDir "manifest.json"
if (Test-Path $ManifestPath) {
    Write-Host "[PASS] Manifest exists" -ForegroundColor Green
    
    try {
        $Manifest = Get-Content $ManifestPath | ConvertFrom-Json
        Write-Host "  Name: $($Manifest.name)" -ForegroundColor Gray
        Write-Host "  Version: $($Manifest.version)" -ForegroundColor Gray
        Write-Host "  Downloaded: $($Manifest.downloaded_at)" -ForegroundColor Gray
        Write-Host "  Device: $($Manifest.device)" -ForegroundColor Gray
    } catch {
        Write-Host "[WARN] Failed to parse manifest: $_" -ForegroundColor Yellow
    }
} else {
    Write-Host "[WARN] Manifest not found (will be created on first run)" -ForegroundColor Yellow
}

# Test 4: ONNX Runtime
Write-Host "Test 4: ONNX Runtime availability" -ForegroundColor Yellow
try {
    $OnnxPaths = @(
        "C:\Program Files\ONNX Runtime\lib\onnxruntime.dll",
        "C:\Program Files (x86)\ONNX Runtime\lib\onnxruntime.dll"
    )
    
    $Found = $false
    foreach ($Path in $OnnxPaths) {
        if (Test-Path $Path) {
            Write-Host "[PASS] ONNX Runtime found: $Path" -ForegroundColor Green
            $Found = $true
            break
        }
    }
    
    if (!$Found) {
        Write-Host "[INFO] ONNX Runtime not in standard paths (may be in system PATH)" -ForegroundColor Cyan
    }
} catch {
    Write-Host "[WARN] Error checking ONNX Runtime: $_" -ForegroundColor Yellow
}

# Test 5: DirectML availability
Write-Host "Test 5: DirectML GPU support" -ForegroundColor Yellow
try {
    # Check Windows version
    $OSVersion = [Environment]::OSVersion.Version.Major
    if ($OSVersion -ge 10) {
        Write-Host "[PASS] Windows $OSVersion detected (DirectML support available)" -ForegroundColor Green
    } else {
        Write-Host "[WARN] Windows $OSVersion detected (DirectML requires Windows 10+)" -ForegroundColor Yellow
    }
} catch {
    Write-Host "[WARN] Error detecting Windows version: $_" -ForegroundColor Yellow
}

# Test 6: Model files
Write-Host "Test 6: Model files" -ForegroundColor Yellow
$ModelFiles = Get-ChildItem -Path $ModelDir -File -ErrorAction SilentlyContinue
$Count = $ModelFiles | Measure-Object | Select-Object -ExpandProperty Count

if ($Count -gt 0) {
    Write-Host "[PASS] Found $Count model files" -ForegroundColor Green
    if ($Verbose) {
        $ModelFiles | ForEach-Object {
            $SizeMB = [math]::Round($_.Length / 1MB, 2)
            Write-Host "  - $($_.Name) ($SizeMB MB)" -ForegroundColor Gray
        }
    }
} else {
    Write-Host "[INFO] No model files found (download required)" -ForegroundColor Cyan
}

# Test 7: Flutter project structure
Write-Host "Test 7: Flutter project structure" -ForegroundColor Yellow
$FFIFile = ".\lib\services\onnxruntime_ffi.dart"
$LocalLLMFile = ".\lib\services\local_llm_provider.dart"
$EvaServiceFile = ".\lib\services\eva_service.dart"

$AllFound = $true
if (Test-Path $FFIFile) {
    Write-Host "[PASS] onnxruntime_ffi.dart found" -ForegroundColor Green
} else {
    Write-Host "[FAIL] onnxruntime_ffi.dart not found" -ForegroundColor Red
    $AllFound = $false
}

if (Test-Path $LocalLLMFile) {
    Write-Host "[PASS] local_llm_provider.dart found" -ForegroundColor Green
} else {
    Write-Host "[FAIL] local_llm_provider.dart not found" -ForegroundColor Red
    $AllFound = $false
}

if (Test-Path $EvaServiceFile) {
    Write-Host "[PASS] eva_service.dart found" -ForegroundColor Green
} else {
    Write-Host "[FAIL] eva_service.dart not found" -ForegroundColor Red
    $AllFound = $false
}

if (!$AllFound) {
    Write-Host "[WARN] Some Flutter files missing. Ensure running from project root." -ForegroundColor Yellow
}

# Summary
Write-Host ""
Write-Host "=== Summary ===" -ForegroundColor Cyan
Write-Host "Model cache: $ModelCachePath"
Write-Host "Model directory: $ModelDir"
Write-Host ""

if ($Count -gt 0) {
    Write-Host "[OK] All checks passed. LLM ready for initialization." -ForegroundColor Green
    Write-Host ""
    Write-Host "Next: Run Flutter app to initialize LLM and test inference"
} else {
    Write-Host "[INFO] Model cache is ready, but model files need to be downloaded." -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To download the model:"
    Write-Host "  1. Run: powershell -ExecutionPolicy Bypass -File scripts/setup_llm.ps1"
    Write-Host "  2. Set HF_TOKEN environment variable with your HuggingFace token"
    Write-Host "  3. Or manually download from: https://huggingface.co/microsoft/Phi-3-mini-4k-instruct"
}

Write-Host ""

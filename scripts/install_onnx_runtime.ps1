# ONNX Runtime GenAI Installation Script for FSC Portal
# Downloads and sets up ONNX Runtime with DirectML support for Phi-3 inference

param(
    [string]$Version = "0.6.0",
    [string]$InstallPath = "$PSScriptRoot\..\onnxruntime",
    [switch]$Force
)

$ErrorActionPreference = "Stop"

Write-Host "=== ONNX Runtime GenAI Installation ===" -ForegroundColor Cyan
Write-Host "Version: $Version" -ForegroundColor Yellow
Write-Host "Install Path: $InstallPath" -ForegroundColor Yellow
Write-Host ""

# Create install directory
if (Test-Path $InstallPath) {
    if ($Force) {
        Write-Host "Removing existing installation..." -ForegroundColor Yellow
        Remove-Item -Path $InstallPath -Recurse -Force
    } else {
        Write-Host "Installation directory already exists. Use -Force to reinstall." -ForegroundColor Yellow
        exit 0
    }
}

New-Item -ItemType Directory -Path $InstallPath -Force | Out-Null

# Download URLs for ONNX Runtime GenAI with DirectML
$packageName = "onnxruntime-genai-directml-$Version-win-x64"
$downloadUrl = "https://github.com/microsoft/onnxruntime-genai/releases/download/v$Version/$packageName.zip"
$zipPath = Join-Path $env:TEMP "$packageName.zip"

Write-Host "Downloading ONNX Runtime GenAI from:" -ForegroundColor Cyan
Write-Host $downloadUrl -ForegroundColor White
Write-Host ""

try {
    # Download package
    Invoke-WebRequest -Uri $downloadUrl -OutFile $zipPath -UseBasicParsing
    Write-Host "Download complete." -ForegroundColor Green
    
    # Extract package
    Write-Host "Extracting package..." -ForegroundColor Cyan
    Expand-Archive -Path $zipPath -DestinationPath $InstallPath -Force
    
    # Move contents up one level (if needed)
    $extractedDir = Join-Path $InstallPath $packageName
    if (Test-Path $extractedDir) {
        Get-ChildItem -Path $extractedDir | Move-Item -Destination $InstallPath -Force
        Remove-Item -Path $extractedDir -Force
    }
    
    Write-Host "Extraction complete." -ForegroundColor Green
    
    # Verify DLLs exist
    $requiredDlls = @(
        "onnxruntime.dll",
        "onnxruntime-genai.dll"
    )
    
    Write-Host ""
    Write-Host "Verifying installation..." -ForegroundColor Cyan
    
    $missing = @()
    foreach ($dll in $requiredDlls) {
        $dllPath = Join-Path $InstallPath "lib\$dll"
        if (-not (Test-Path $dllPath)) {
            # Try alternate location
            $dllPath = Join-Path $InstallPath $dll
            if (-not (Test-Path $dllPath)) {
                $missing += $dll
            }
        }
        
        if (Test-Path $dllPath) {
            Write-Host "  ✓ Found: $dll" -ForegroundColor Green
        }
    }
    
    if ($missing.Count -gt 0) {
        Write-Host ""
        Write-Host "WARNING: Missing DLLs:" -ForegroundColor Yellow
        foreach ($dll in $missing) {
            Write-Host "  ✗ $dll" -ForegroundColor Red
        }
        Write-Host ""
        Write-Host "Installation may be incomplete. Verify package contents." -ForegroundColor Yellow
    }
    
    # Clean up
    if (Test-Path $zipPath) {
        Remove-Item -Path $zipPath -Force
    }
    
    Write-Host ""
    Write-Host "=== Installation Complete ===" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "1. Run the model conversion script: .\scripts\convert_phi3_to_onnx.py" -ForegroundColor White
    Write-Host "2. Build the Flutter app: flutter build windows --release" -ForegroundColor White
    Write-Host "3. The DLLs will be automatically copied to the build output" -ForegroundColor White
    Write-Host ""
    Write-Host "ONNX Runtime location: $InstallPath" -ForegroundColor Yellow
    
} catch {
    Write-Host ""
    Write-Host "ERROR: Installation failed" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    Write-Host ""
    Write-Host "Please try manually downloading from:" -ForegroundColor Yellow
    Write-Host $downloadUrl -ForegroundColor White
    exit 1
}

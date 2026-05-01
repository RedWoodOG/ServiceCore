# Setup script for Phi-3 Mini LLM model
# Downloads model from HuggingFace and validates installation

param(
    [string]$ModelCachePath = "$([Environment]::GetFolderPath('MyDocuments'))\portal_offline\models",
    [switch]$ForceDownload,
    [switch]$SkipValidation
)

$ErrorActionPreference = "Stop"

# Model metadata
$ModelName = "phi-3-mini-4k-instruct"
$ModelVersion = "onnx-int4"
$HuggingFaceRepo = "microsoft/Phi-3-mini-4k-instruct"
$ModelFileName = "model.onnx"

Write-Host "=== FSC Portal LLM Setup ===" -ForegroundColor Cyan
Write-Host "Model: $ModelName ($ModelVersion)"
Write-Host "Cache Directory: $ModelCachePath"
Write-Host ""

# Create cache directory
if (!(Test-Path $ModelCachePath)) {
    Write-Host "Creating model cache directory..." -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $ModelCachePath -Force | Out-Null
    Write-Host "[OK] Cache directory created" -ForegroundColor Green
}

# Model path
$ModelDir = Join-Path $ModelCachePath $ModelName
$ModelPath = Join-Path $ModelDir $ModelFileName
$ManifestPath = Join-Path $ModelDir "manifest.json"

# Check if model already exists
if ((Test-Path $ModelPath) -and !$ForceDownload) {
    Write-Host "[OK] Model already exists at: $ModelPath" -ForegroundColor Green
    
    if (Test-Path $ManifestPath) {
        Write-Host "[OK] Manifest found" -ForegroundColor Green
    } else {
        Write-Host "[WARN] Manifest not found, creating..." -ForegroundColor Yellow
        $Manifest = @{
            name = $ModelName
            version = $ModelVersion
            huggingface_repo = $HuggingFaceRepo
            downloaded_at = (Get-Date -Format 'o')
            device = "auto"
        }
        $Manifest | ConvertTo-Json | Set-Content -Path $ManifestPath
        Write-Host "[OK] Manifest created" -ForegroundColor Green
    }
} else {
    # Model needs to be downloaded
    Write-Host "Downloading Phi-3 Mini model from HuggingFace..." -ForegroundColor Yellow
    
    # Create model directory
    if (!(Test-Path $ModelDir)) {
        New-Item -ItemType Directory -Path $ModelDir -Force | Out-Null
    }
    
    # HuggingFace model URL (ONNX int4 quantized version)
    # This would normally download from HuggingFace, but requires authentication
    # For now, provide instructions
    Write-Host ""
    Write-Host "[WARN] Model download requires HuggingFace authentication" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Option 1: Manual Download (Recommended for first-time setup)" -ForegroundColor Cyan
    Write-Host "  1. Visit: https://huggingface.co/$HuggingFaceRepo" -ForegroundColor Gray
    Write-Host "  2. Download the ONNX int4 quantized model files" -ForegroundColor Gray
    Write-Host "  3. Extract to: $ModelDir" -ForegroundColor Gray
    Write-Host ""
    
    Write-Host "Option 2: Automated Download (requires HF_TOKEN)" -ForegroundColor Cyan
    Write-Host "  1. Set environment variable: `$env:HF_TOKEN = '<your-token>'" -ForegroundColor Gray
    Write-Host "  2. Run this script again" -ForegroundColor Gray
    Write-Host ""
    
    # Check for HF_TOKEN
    if ($env:HF_TOKEN) {
        Write-Host "HF_TOKEN detected, attempting automated download..." -ForegroundColor Yellow
        
        try {
            # Use huggingface-hub CLI if available
            $HFHubAvailable = $null -ne (Get-Command huggingface-cli -ErrorAction SilentlyContinue)
            
            if ($HFHubAvailable) {
                Write-Host "Using huggingface-cli..." -ForegroundColor Gray
                & huggingface-cli download $HuggingFaceRepo --local-dir $ModelDir --local-dir-use-symlinks False
                Write-Host "[OK] Model downloaded successfully" -ForegroundColor Green
            } else {
                Write-Host "huggingface-cli not found. Install with: pip install huggingface-hub" -ForegroundColor Yellow
            }
        } catch {
            Write-Host "[ERROR] Download failed: $_" -ForegroundColor Red
            Write-Host "Please download manually from HuggingFace" -ForegroundColor Yellow
            exit 1
        }
    } else {
        Write-Host "Skipping automated download (no HF_TOKEN). Please download manually." -ForegroundColor Yellow
    }
    
    # Create manifest
    $Manifest = @{
        name = $ModelName
        version = $ModelVersion
        huggingface_repo = $HuggingFaceRepo
        downloaded_at = (Get-Date -Format 'o')
        device = "auto"
    }
    $Manifest | ConvertTo-Json | Set-Content -Path $ManifestPath
    Write-Host "[OK] Manifest created" -ForegroundColor Green
}

# Validation
if (!$SkipValidation) {
    Write-Host ""
    Write-Host "=== Validation ===" -ForegroundColor Cyan
    
    # Check model directory exists
    if (Test-Path $ModelDir) {
        Write-Host "[OK] Model directory exists" -ForegroundColor Green
    } else {
        Write-Host "[ERROR] Model directory not found" -ForegroundColor Red
        exit 1
    }
    
    # Check manifest exists
    if (Test-Path $ManifestPath) {
        Write-Host "[OK] Manifest exists" -ForegroundColor Green
        $Manifest = Get-Content $ManifestPath | ConvertFrom-Json
        Write-Host "  Name: $($Manifest.name)" -ForegroundColor Gray
        Write-Host "  Version: $($Manifest.version)" -ForegroundColor Gray
        Write-Host "  Downloaded: $($Manifest.downloaded_at)" -ForegroundColor Gray
    } else {
        Write-Host "[WARN] Manifest not found" -ForegroundColor Yellow
    }
    
    # Check for model files
    $ModelFiles = Get-ChildItem -Path $ModelDir -File -ErrorAction SilentlyContinue | Measure-Object
    if ($ModelFiles.Count -gt 0) {
        Write-Host "[OK] Model files found ($($ModelFiles.Count) files)" -ForegroundColor Green
    } else {
        Write-Host "[WARN] No model files found in directory" -ForegroundColor Yellow
        Write-Host "  Please download model files manually" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "=== Setup Complete ===" -ForegroundColor Green
Write-Host "Model cache path: $ModelCachePath"
Write-Host "Next steps:"
Write-Host "  1. Ensure model files are in: $ModelDir"
Write-Host "  2. Run Flutter app to test LLM initialization"
Write-Host "  3. Check debug logs for device detection (DirectML or CPU)"
Write-Host ""

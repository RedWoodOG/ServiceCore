# Phi-3 LLM Setup Guide for FSC Portal

**Version:** 1.0.0  
**Date:** February 2026  
**Status:** Development  

---

## Overview

This guide walks through the complete setup of Phi-3-mini-4k-instruct local LLM for EVA intelligence in FSC Portal. The setup enables on-device AI inference with DirectML GPU acceleration.

---

## Prerequisites

### System Requirements

**Minimum:**
- Windows 10/11 (64-bit)
- 8GB RAM
- 5GB free disk space
- Intel/AMD CPU (AVX2 support)

**Recommended:**
- Windows 11 (64-bit)
- 16GB+ RAM
- 10GB free disk space
- DirectX 12 compatible GPU with 4GB+ VRAM
- Modern Intel/AMD CPU

### Software Requirements

1. **Python 3.9+** (for model conversion)
   ```powershell
   python --version  # Should be 3.9 or higher
   ```

2. **PowerShell 7+** (for installation scripts)
   ```powershell
   $PSVersionTable.PSVersion  # Should be 7.0+
   ```

3. **Git** (to clone model)
   ```powershell
   git --version
   ```

4. **Flutter SDK** (already installed for FSC Portal)
   ```powershell
   flutter --version
   ```

---

## Installation Steps

### Step 1: Clone the Phi-3 Model

The model should already be cloned, but if not:

```powershell
cd H:\FSC_Portal\FSC-Portal
git clone https://huggingface.co/microsoft/Phi-3-mini-4k-instruct
```

**Model files:**
- Total size: ~8GB
- Includes: PyTorch weights, tokenizer, config files

---

### Step 2: Install ONNX Runtime with GenAI Extension

Run the installation script:

```powershell
cd H:\FSC_Portal\FSC-Portal
.\scripts\install_onnx_runtime.ps1
```

**What this does:**
- Downloads ONNX Runtime GenAI v0.6.0
- Extracts to `H:\FSC_Portal\FSC-Portal\onnxruntime\`
- Verifies DirectML support

**Verify installation:**
```powershell
ls .\onnxruntime\lib\
# Should see: onnxruntime.dll, onnxruntime-genai.dll
```

---

### Step 3: Install Python Dependencies

Install required Python packages for model conversion:

```powershell
pip install onnxruntime-genai optimum[onnxruntime] transformers torch
```

**Package sizes:**
- torch: ~2GB
- transformers: ~500MB
- optimum: ~200MB
- onnxruntime-genai: ~100MB

---

### Step 4: Convert Phi-3 to ONNX GenAI Format

Run the conversion script:

```powershell
cd H:\FSC_Portal\FSC-Portal
python .\scripts\convert_phi3_to_onnx.py --quantize int4
```

**Options:**
- `--quantize int4`: Reduces model size to ~750MB (recommended)
- `--quantize int8`: ~1.5GB model size
- No quantization: ~2.4GB model size (FP16)

**Expected output:**
```
=== Phi-3 Model Conversion to ONNX GenAI ===
Source: H:\FSC_Portal\FSC-Portal\Phi-3-mini-4k-instruct
Output: H:\FSC_Portal\FSC-Portal\models\phi-3-mini-4k-onnx
Quantization: int4

📦 Step 1: Exporting model to ONNX format...
   This may take several minutes...
   ✓ ONNX export complete

📄 Step 2: Copying tokenizer files...
   ✓ Tokenizer saved

🔧 Step 3: Converting to ONNX GenAI format...
   [Manual step required - see below]

✓ Model manifest created
```

**Important:** The conversion script will indicate a manual step is required to complete the GenAI format conversion using the ONNX GenAI model builder tool. For now, the ONNX model will work for basic testing.

---

### Step 5: Verify Model Files

Check that all required files are present:

```powershell
ls .\models\phi-3-mini-4k-onnx\
```

**Required files:**
- `model.onnx` or `model.onnx.data` (ONNX model)
- `tokenizer.json` (tokenizer)
- `tokenizer_config.json` (tokenizer config)
- `special_tokens_map.json` (special tokens)
- `model_manifest.json` (metadata)

---

### Step 6: Configure Model Paths

The configuration is already set in `assets/config/model_config.json`. Verify the paths:

```json
{
  "paths": {
    "model_cache_dir": "%DOCUMENTS%/fsc_portal/models",
    "model_name_in_cache": "phi-3-mini-4k-instruct-onnx",
    "fallback_paths": [
      "./models/phi-3-mini-4k-onnx",
      "./Phi-3-mini-4k-instruct"
    ]
  }
}
```

The app will automatically search for the model in:
1. User documents: `C:\Users\{username}\Documents\fsc_portal\models\phi-3-mini-4k-instruct-onnx\`
2. Project directory: `H:\FSC_Portal\FSC-Portal\models\phi-3-mini-4k-onnx\`
3. Model clone: `H:\FSC_Portal\FSC-Portal\Phi-3-mini-4k-instruct\`

---

### Step 7: Build Flutter App with ONNX Runtime

Update the Windows build configuration to bundle ONNX Runtime DLLs:

```powershell
cd H:\FSC_Portal\FSC-Portal
flutter build windows --release
```

**Manual DLL copy (temporary until CMakeLists updated):**
```powershell
# Copy ONNX Runtime DLLs to build output
Copy-Item .\onnxruntime\lib\*.dll .\build\windows\x64\runner\Release\
```

---

### Step 8: Test LLM Integration

Run the app and test EVA:

```powershell
flutter run -d windows
```

**Test queries:**
1. Open EVA panel (right sidebar)
2. Try: "Hello EVA" (should get greeting)
3. Try: "How do I replace a lock?" (should search knowledge base)
4. Check console for LLM initialization messages

**Expected console output:**
```
[INFO] LocalLLMProvider initialized (device: gpu)
[INFO] Model found in cache: C:\Users\...\fsc_portal\models\phi-3-mini-4k-onnx
[INFO] EVA: LLM provider initialized (available: true)
[INFO] EVA: Processing query: "Hello EVA"
```

---

## Configuration

### Model Settings

Edit `assets/config/model_config.json` to adjust:

**Inference settings:**
```json
"inference_settings": {
  "max_tokens": 200,        # Max response length
  "temperature": 0.3,       # Creativity (0.0-1.0)
  "top_p": 0.9,            # Nucleus sampling
  "top_k": 40,             # Top-k sampling
  "repetition_penalty": 1.1 # Avoid repetition
}
```

**Device preferences:**
```json
"device_preferences": {
  "prefer_directml": true,  # Use GPU if available
  "fallback_to_cpu": true,  # CPU if GPU fails
  "cpu_threads": 4          # CPU thread count
}
```

---

## Troubleshooting

### Model Not Found

**Symptom:** "Model not found in any configured paths"

**Solutions:**
1. Verify model files exist: `ls .\models\phi-3-mini-4k-onnx\`
2. Check conversion completed successfully
3. Try copying model to documents directory:
   ```powershell
   Copy-Item -Recurse .\models\phi-3-mini-4k-onnx "$env:USERPROFILE\Documents\fsc_portal\models\"
   ```

---

### ONNX Runtime DLL Not Found

**Symptom:** "Could not find onnxruntime.dll"

**Solutions:**
1. Re-run installation: `.\scripts\install_onnx_runtime.ps1 -Force`
2. Manually copy DLLs to build directory:
   ```powershell
   Copy-Item .\onnxruntime\lib\*.dll .\build\windows\x64\runner\Release\
   ```
3. Add ONNX Runtime to system PATH (not recommended)

---

### DirectML Initialization Failed

**Symptom:** "DirectML execution provider append failed, using CPU"

**Solutions:**
1. Update GPU drivers to latest version
2. Verify DirectX 12 support: `dxdiag`
3. Check GPU has sufficient VRAM (4GB+ recommended)
4. CPU fallback is automatic - performance will be slower

---

### Slow Inference (< 1 token/sec)

**Possible causes:**
1. Running on CPU instead of GPU
2. Model not quantized (using FP16)
3. Insufficient RAM/VRAM

**Solutions:**
1. Enable DirectML: Set `prefer_directml: true` in config
2. Re-convert model with INT4 quantization: `--quantize int4`
3. Close other applications to free memory
4. Reduce `max_tokens` in config (e.g., 100 instead of 200)

---

### Python Dependencies Failed to Install

**Symptom:** "pip install" errors for torch/transformers

**Solutions:**
1. Upgrade pip: `python -m pip install --upgrade pip`
2. Use specific versions:
   ```powershell
   pip install torch==2.1.0 transformers==4.35.0 optimum==1.14.0
   ```
3. Try installing without CUDA:
   ```powershell
   pip install torch --index-url https://download.pytorch.org/whl/cpu
   ```

---

## Performance Benchmarks

### Expected Performance

**INT4 Quantized Model:**
- **CPU (Intel i7-12700):** 5-10 tokens/sec
- **GPU (RTX 3060):** 25-40 tokens/sec
- **GPU (RTX 4090):** 60-100 tokens/sec

**FP16 Model:**
- **CPU:** 2-5 tokens/sec
- **GPU (RTX 3060):** 15-25 tokens/sec
- **GPU (RTX 4090):** 40-70 tokens/sec

**Response times:**
- Simple queries: 1-3 seconds
- Complex queries with RAG context: 3-7 seconds

---

## Advanced Configuration

### Custom Model Path

To use a different model location:

1. Edit `assets/config/model_config.json`:
   ```json
   "paths": {
     "model_cache_dir": "D:/CustomModels",
     "model_name_in_cache": "phi-3-custom"
   }
   ```

2. Copy model to custom location:
   ```powershell
   Copy-Item -Recurse .\models\phi-3-mini-4k-onnx D:\CustomModels\phi-3-custom\
   ```

---

### Disable LLM (Use Keyword Search Only)

Edit `assets/config/model_config.json`:

```json
"feature_flags": {
  "enable_llm": false
}
```

EVA will fall back to keyword-based search from knowledge base.

---

## Next Steps

1. **Test thoroughly:** Try various query types (troubleshooting, procedures, specs)
2. **Monitor performance:** Check CPU/GPU usage, response times
3. **Tune settings:** Adjust temperature, max_tokens based on quality/speed trade-off
4. **Collect feedback:** Note any hallucinations or incorrect responses
5. **Iterate:** Update system prompts in config if needed

---

## Resources

- **ONNX Runtime GenAI:** https://github.com/microsoft/onnxruntime-genai
- **Phi-3 Model Card:** https://huggingface.co/microsoft/Phi-3-mini-4k-instruct
- **DirectML:** https://learn.microsoft.com/en-us/windows/ai/directml/dml-intro
- **FSC Portal Docs:** ./EVA_LLM_INTEGRATION.md

---

## Support

For issues or questions:
1. Check this guide's Troubleshooting section
2. Review console logs for error messages
3. Contact: [redacted-email]

---

**Last Updated:** February 2026  
**Author:** AI Implementation Assistant  
**Status:** Initial Setup Guide

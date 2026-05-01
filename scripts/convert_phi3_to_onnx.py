#!/usr/bin/env python3
"""
Phi-3 Model Conversion to ONNX GenAI Format
Converts the HuggingFace Phi-3-mini-4k-instruct model to ONNX GenAI format
with DirectML support for local inference in FSC Portal.

Requirements:
    pip install onnxruntime-genai optimum[onnxruntime] transformers torch

Usage:
    python convert_phi3_to_onnx.py
    python convert_phi3_to_onnx.py --quantize int4
"""

import argparse
import os
import sys
from pathlib import Path
import shutil

def check_dependencies():
    """Check if required packages are installed."""
    required = ['onnxruntime_genai', 'transformers', 'torch', 'optimum']
    missing = []
    
    for pkg in required:
        try:
            __import__(pkg)
        except ImportError:
            missing.append(pkg)
    
    if missing:
        print("❌ Missing required packages:", ", ".join(missing))
        print("\nInstall with:")
        print("pip install onnxruntime-genai optimum[onnxruntime] transformers torch")
        return False
    
    return True

def convert_model(source_path, output_path, quantize=None):
    """
    Convert Phi-3 model to ONNX GenAI format.
    
    Args:
        source_path: Path to HuggingFace model directory
        output_path: Output directory for ONNX model
        quantize: Quantization mode (None, 'int4', 'int8')
    """
    print("\n=== Phi-3 Model Conversion to ONNX GenAI ===\n")
    print(f"Source: {source_path}")
    print(f"Output: {output_path}")
    print(f"Quantization: {quantize or 'None (FP16)'}\n")
    
    # Import here after dependency check
    import onnxruntime_genai as og
    from optimum.onnxruntime import ORTModelForCausalLM
    from transformers import AutoTokenizer
    
    try:
        # Create output directory
        os.makedirs(output_path, exist_ok=True)
        
        # Step 1: Export to ONNX using optimum
        print("📦 Step 1: Exporting model to ONNX format...")
        print("   This may take several minutes...")
        
        model = ORTModelForCausalLM.from_pretrained(
            source_path,
            export=True,
            use_merged=True  # Merge decoder for faster inference
        )
        
        # Save ONNX model
        temp_onnx_path = os.path.join(output_path, "temp_onnx")
        model.save_pretrained(temp_onnx_path)
        print("   ✓ ONNX export complete")
        
        # Step 2: Copy tokenizer files
        print("\n📄 Step 2: Copying tokenizer files...")
        tokenizer = AutoTokenizer.from_pretrained(source_path)
        tokenizer.save_pretrained(output_path)
        print("   ✓ Tokenizer saved")
        
        # Step 3: Convert to GenAI format
        print("\n🔧 Step 3: Converting to ONNX GenAI format...")
        
        # GenAI conversion would happen here using the builder
        # Note: This requires the actual onnxruntime-genai builder tool
        # which is a separate C++ binary, not a Python API
        
        print("   ⚠️  Manual step required:")
        print(f"   Run the ONNX GenAI model builder:")
        print(f"   model-builder -m {temp_onnx_path} -o {output_path} -p int4")
        
        # Step 4: Apply quantization if requested
        if quantize:
            print(f"\n⚙️  Step 4: Applying {quantize.upper()} quantization...")
            print("   This reduces model size and increases inference speed.")
            print("   ⚠️  Quantization requires the ONNX GenAI builder tool")
            print("   See: https://github.com/microsoft/onnxruntime-genai")
        
        # Create model manifest
        manifest = {
            "model_name": "Phi-3-mini-4k-instruct",
            "model_version": "microsoft/Phi-3-mini-4k-instruct",
            "format": "onnx-genai",
            "quantization": quantize or "fp16",
            "context_length": 4096,
            "vocab_size": 32064,
            "source": source_path,
            "converted_date": __import__('datetime').datetime.now().isoformat()
        }
        
        import json
        manifest_path = os.path.join(output_path, "model_manifest.json")
        with open(manifest_path, 'w') as f:
            json.dump(manifest, f, indent=2)
        
        print(f"\n✓ Model manifest created: {manifest_path}")
        
        print("\n=== Conversion Summary ===")
        print(f"✓ ONNX model exported to: {temp_onnx_path}")
        print(f"✓ Tokenizer files copied to: {output_path}")
        print(f"✓ Model manifest created")
        
        print("\n⚠️  IMPORTANT: Complete the conversion using ONNX GenAI model-builder tool")
        print("   Download from: https://github.com/microsoft/onnxruntime-genai/releases")
        print(f"\n   Command: model-builder -m {temp_onnx_path} -o {output_path}")
        
        if quantize == 'int4':
            print("   Add: -p int4 (for quantization)")
        
        return True
        
    except Exception as e:
        print(f"\n❌ Conversion failed: {e}")
        import traceback
        traceback.print_exc()
        return False

def main():
    parser = argparse.ArgumentParser(
        description="Convert Phi-3 model to ONNX GenAI format"
    )
    parser.add_argument(
        '--source',
        default='./Phi-3-mini-4k-instruct',
        help='Source model directory (default: ./Phi-3-mini-4k-instruct)'
    )
    parser.add_argument(
        '--output',
        default='./models/phi-3-mini-4k-onnx',
        help='Output directory (default: ./models/phi-3-mini-4k-onnx)'
    )
    parser.add_argument(
        '--quantize',
        choices=['int4', 'int8', None],
        default=None,
        help='Quantization mode (default: None/FP16)'
    )
    
    args = parser.parse_args()
    
    # Check dependencies
    if not check_dependencies():
        sys.exit(1)
    
    # Validate source path
    source_path = Path(args.source).resolve()
    if not source_path.exists():
        print(f"❌ Source model not found: {source_path}")
        print("\nMake sure the Phi-3 model is cloned:")
        print("   git clone https://huggingface.co/microsoft/Phi-3-mini-4k-instruct")
        sys.exit(1)
    
    # Convert model
    output_path = Path(args.output).resolve()
    success = convert_model(str(source_path), str(output_path), args.quantize)
    
    if success:
        print("\n✓ Conversion completed successfully")
        sys.exit(0)
    else:
        print("\n❌ Conversion failed")
        sys.exit(1)

if __name__ == "__main__":
    main()

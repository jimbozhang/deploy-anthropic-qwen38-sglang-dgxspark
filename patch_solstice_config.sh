#!/bin/bash
# Patch DavidAU Heretic NVFP4 model config (quantized by Solstice-AI) for sglang.
# - Sets architectures to Qwen3_5ForConditionalGeneration (sglang's model code path)
# - Sets language_model_only to true (no vision processing)
#
# Run once after downloading the model.

MODEL_ROOT="$HOME/pretrained"
MODEL="Solstice-AI/Qwen3.8-27B-TURBO-Fable-Cold-Fusion-735-882-Heretic-Uncensored-NM-DAU-NVFP4"
CONFIG="$MODEL_ROOT/$MODEL/config.json"

if [ ! -f "$CONFIG" ]; then
  echo "Error: $CONFIG not found"
  exit 1
fi

docker run --rm -v "$MODEL_ROOT:/models" lmsysorg/sglang:dev-qwen38-27b-dflash2 python3 -c "
import json
p = '/models/$MODEL/config.json'
with open(p) as f: d = json.load(f)

changed = False

# Fix architecture for sglang's model code path
if d.get('architectures') != ['Qwen3_5ForConditionalGeneration']:
    d['architectures'] = ['Qwen3_5ForConditionalGeneration']
    changed = True

# Ensure text_config has full_attention_interval
tc = d.get('text_config', {})
if 'full_attention_interval' not in tc:
    tc['full_attention_interval'] = 4
    d['text_config'] = tc
    changed = True

# Set language_model_only to skip vision processing
if d.get('language_model_only') is not True:
    d['language_model_only'] = True
    changed = True

if changed:
    with open(p, 'w') as f: json.dump(d, f, indent=2)
    print('Config patched for sglang.')
else:
    print('Config already patched.')
"
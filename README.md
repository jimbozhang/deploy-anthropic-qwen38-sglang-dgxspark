# Deploy Qwen3.8-27B on DGX Spark

Serve [Qwen3.8-27B](https://huggingface.co/RadixArk/Qwen3.8-27B-NVFP4) (NVFP4 + [DFlash2](https://huggingface.co/z-lab/Qwen3.8-27B-DFlash2) speculative decoding) via [sglang](https://github.com/sgl-project/sglang) and use it as the Claude Code backend.

## 1. Download Models

```bash
export MODEL_ROOT=~/pretrained

pip install huggingface_hub

huggingface-cli download RadixArk/Qwen3.8-27B-NVFP4 \
  --local-dir $MODEL_ROOT/RadixArk/Qwen3.8-27B-NVFP4

huggingface-cli download z-lab/Qwen3.8-27B-DFlash2 \
  --local-dir $MODEL_ROOT/z-lab/Qwen3.8-27B-DFlash2
```

## 2. Pull Docker Image

```bash
docker pull lmsysorg/sglang:dev-qwen38-27b-dflash2
```

## 3. Start the Server

```bash
./start.sh
```

Wait until the log shows `The server is fired up and ready to roll!`, then verify:

```bash
curl http://localhost:8000/v1/models
```

## 4. Configure for Claude Code

Copy `settings.json` to your Claude Code settings, replacing `192.168.31.51` with your server's LAN IP.

> **Important:** When using Claude Code, set effort to `medium` or `low`. The `high`/`xhigh` levels are not compatible with this model's chat template.
>
> ```bash
> claude --effort medium
> ```

## 5. Stop the Server

```bash
./stop.sh
```

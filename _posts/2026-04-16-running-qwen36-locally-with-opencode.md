---
layout: post
title: Running Qwen3.6 Locally with OpenCode
date: '2026-04-16 18:00:00'
category: local-ai
lang: en
---

Running Qwen3.6-35B-A3B locally on an M3 Max with LM Studio and OpenCode.
`~49.5tk/s`, ~`240ms` warmed TTFT. Open weights, open source tools, local
inference.

<!--end-excerpt-->

## The Sovereign AI Stack

Running AI locally is not just a technical exercise. It is a statement of
sovereignty.

When you send your code, your thoughts, your data to a cloud API, you are
outsourcing trust to a third party. You are giving up custody. Bitcoin taught
us that not your keys, not your coins. The same principle applies to AI. Not
your model, not your privacy.

AI inference providers and API routers present a concrete threat. A recent
paper, "Your Agent Is Mine"
([arXiv:2604.08407v1](https://arxiv.org/abs/2604.08407v1)), documents how AI
API routers operate as application-layer proxies with full plaintext access to
every in-flight JSON payload. The researchers found routers actively injecting
malicious code into tool calls, stealing credentials, and draining crypto
wallets. These intermediaries can exfiltrate secrets and modify tool calls,
effectively transforming the AI pipeline into a remote code execution vector.
Running locally eliminates this entire attack surface.

Open source tools run locally by default. OpenCode, Qwen3.6, LM Studio. No API
quotas or terms of service to worry about.

I set out to run Qwen3.6-35B-A3B locally with OpenCode. The results exceeded my
expectations.

## The Model: Qwen3.6-35B-A3B

Qwen3.6-35B-A3B is Alibaba's hybrid-thinking model family. It has 35 billion
total parameters but only 3 billion active at any given time. This makes it
efficient without sacrificing capability.

The model excels at agentic coding tasks, supports 256K context across 201
languages, and runs on consumer hardware with the right quantization.

I am using the Unsloth Dynamic 2.0 quantized variant. Specifically
`Qwen3.6-35B-A3B-UD-Q5_K_M.gguf`. The Q5_K_M quantization brings the model to
roughly 23GB RAM while preserving quality. This matters because 48GB of unified
memory on my M3 Max left room for the OS, Zed (Editor), LM Studio, and a
browser.

The Unsloth Dynamic 2.0 approach calibrates quantization on real-world use-case
datasets and upcasts important layers. The result is significantly better
quality than static quantization at the same bit rate.

## Performance Results

I ran three tests to measure performance. The results are consistent and solid.

| Metric | Run 1 (cold) | Run 2 | Run 3 | Average |
| -------- | ------------- | ------- | ------- | --------- |
| TTFT | 980ms | 259ms | 239ms | 493ms |
| Tk/s | 49.2 | 49.6 | 49.8 | 49.5 |
| Latency | 40636ms | 40310ms | 40129ms | 40358ms |

The throughput is extremely consistent at `~49.5 tk/s`. No variance. The model
is stable.

For context, Claude Sonnet 4.6 averages `~45 tk/s` on OpenRouter ([performance
data](https://openrouter.ai/anthropic/claude-sonnet-4.6/performance)). Running
a 35B model locally at `~49.5 tk/s` is on par with a top-tier cloud model.

Cold start TTFT hits `980ms`, which is expected. Once warmed up, it drops to
`~240ms`.

What surprised me most is the quality and speed at a reasonable memory
footprint. The model also keeps the M3 Max at a reasonable 60C during this
session. No maxed out cooling fans.

## Hardware & LM Studio Setup

I am running on an Apple M3 Max with 48GB of unified memory. The model fits
comfortably.

Unlike running other dense models, this one doesn't make the laptop fly. The M3
Max stays at a reasonable 60C during this session. No maxed out cooling fans.

I use LM Studio as the inference engine. The parameters below follow Unsloth's
recommendations for Qwen3.6 thinking mode on precise coding tasks ([Unsloth
Qwen3.6
Guide](https://unsloth.ai/docs/models/qwen3.6#llama-server-serving-and-openais-completion-library)).

**Model Settings:**

| Parameter | Value |
| ----------- | ------- |
| Temperature | 0.6 |
| Top P | 0.95 |
| Top K | 20 |
| Min P | 0 |
| Repeat Penalty | disabled |
| Presence Penalty | disabled |

**Context & Offload:**

| Parameter | Value |
| ----------- | ------- |
| Context Length | 130,000 (model supports 262,144) |
| GPU Offload | 40 |
| CPU Thread Pool Size | 16 |
| Evaluation Batch Size | 2048 |
| Max Concurrent Predictions | 1 |
| Unified KV Cache | enabled |
| Offload KV Cache to GPU Memory | enabled |
| Keep Model in Memory | enabled |
| Try mmap() | enabled |
| Number of Experts | 8 |
| Flash Attention | enabled |
| K Cache Quantization | Q5_0 |
| V Cache Quantization | Q5_0 |

The batch size of `2048` and Flash Attention keep performance high. The unified
KV cache and GPU offload ensure the model stays responsive. I set context to
130K instead of the full 262K to preserve headroom.

## Connecting to OpenCode

OpenCode uses a providers configuration file to manage local and remote model
connections. Here is the full provider block I added for LM Studio:

```jsonc
{
  // ... other configs
  "provider": {
    // .. other providers
    "lmstudio": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "LM Studio",
      "options": {
        "baseURL": "http://localhost:1234/v1"
      },
      "models": {
        "qwen3.6-35b-a3b": {
          "name": "Qwen3.6 35B A3B UD@gguf-Q5_K_M",
          // optional but useful so OpenCode knowns when to compact
          "limit": {
            "context": 130000,
            "output": 32768
          },
          // optional: test to see what works best for you (reasoning =
          // slower but better responses)
          "reasoning": true,
          // optional: only needed if you plan to send imgs to your coding agent
          "modalities": {
            "input": ["image", "text"],
            "output": ["text"]
          }
        }
      }
    }
  }
}
```

A few notes on the config:

- **context: 130000** matches the LM Studio setting. Keep these aligned to
avoid context overflow issues.
- **output: 32768** gives enough room for long code generation tasks. Unsloth
recommends 32,768 tokens for most queries.
- **reasoning: true** enables the hybrid-thinking mode. This is what gives
Qwen3.6 its chain-of-thought behavior.
- **modalities** includes image input for vision tasks.

### Auto-generating the Model List

LM Studio exposes a local API at `http://localhost:1234/api/v1/models`. I wrote
a script to fetch the model list and generate the providers config
automatically.

The script lives at `~/.config/scripts/_gen-lmstudio-model.sh`. You can find it
on GitHub Gist:
[johnnyasantoss/_gen-lmstudio-model.sh](https://gist.github.com/johnnyasantoss/a5200046eca87dba2bafc8b670a4c946).

It uses only `jq`, `node`, and `bash`. No dependencies to install.

The script fetches models from the LM Studio API, filters for LLM types, and
generates a provider JSON block. It supports two modes:

- **Merge mode** (default): Merges fetched models with your existing config,
preserving any custom settings you have added.
- **Reset mode** (`--reset`): Replaces the models field entirely with the API
response.

Both modes support `--dry-run` to preview changes before applying them.

The script parses display names, formats, and quantization info from the API to
build readable model identifiers. A `deep-merge.js` helper handles the JSON
merging logic.

Run it whenever you add or remove models in LM Studio. The config stays in sync.

## Results & Takeaways

The performance is solid. `~49.5tk/s` with near-zero variance. Warmed TTFT
around `240ms`. Predictable latency for a 35B model running locally on Apple
Silicon.

Running locally means the model, the parameters, and the context all stay on
your machine. No API calls to external services.

Open weights, open source tools, local inference. This is the stack for
individual sovereignty in AI.

I plan to experiment with [LLamaBarn](https://github.com/ggml-org/LlamaBarn)
next. But for now, [LM Studio](https://lmstudio.ai/) +
[OpenCode](https://opencode.ai/) +
[Qwen3.6](https://huggingface.co/unsloth/Qwen3.6-35B-A3B-GGUF) is a setup I am
happy with.

---

This post was written with the help of Qwen3.6-35B-A3B and OpenCode.

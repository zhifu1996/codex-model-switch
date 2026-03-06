# Codex Model Switch

A CLI tool for quickly switching Codex CLI default models. It reads provider info from `~/.codex/config.toml`, reads API key from `~/.codex/auth.json` (or env), fetches available models from your configured endpoint, and updates the selected model in `~/.codex/config.toml`.

## Features

- Automatically fetches available models from provider endpoints
- Reads current config from `~/.codex/config.toml`
- Supports model switch by:
  - Interactive menu
  - Index number
  - Direct model id (`--set`)
- Displays the current model with `*`
- Supports JSON output for tooling (`--list-json`)

## Prerequisites

- Python 3.11+ (or Python 3.10 with `tomli`)
- Codex CLI configured in:
  - `~/.codex/config.toml`
  - `~/.codex/auth.json`

## Installation

```bash
git clone https://github.com/zhifu1996/codex-model-switch.git
cd codex-model-switch
chmod +x codex-model-switch install.sh uninstall.sh
./install.sh
source ~/.bashrc
```

This will:

- Install executable to `~/.local/bin/.codex-model-switch-bin`
- Install uninstall script to `~/.local/bin/codex-model-switch-uninstall`
- Add `codex-model-switch` shell function to `~/.bashrc`
- Ensure `~/.local/bin` is in PATH

## Usage

### Interactive Mode

```bash
codex-model-switch
```

### Command Line Mode

```bash
codex-model-switch --list
codex-model-switch --list-json
codex-model-switch 10
codex-model-switch --set gpt-5.3-codex
codex-model-switch --show-config
codex-model-switch --help
```

### Command Options

| Option | Description |
|---|---|
| `--list` | List models in text format |
| `--list-json` | List models in JSON format |
| `INDEX` | Switch to model by index |
| `--set MODEL_ID` | Switch to explicit model id |
| `--provider NAME` | Override provider from config |
| `--show-config` | Print resolved config and key source |

## Config Requirements

`~/.codex/config.toml` should include:

```toml
model_provider = "cliproxyapi"
model = "gpt-5.3-codex"

[model_providers.cliproxyapi]
name = "cliproxyapi"
base_url = "https://your-endpoint/v1"
wire_api = "responses"
```

`~/.codex/auth.json` example:

```json
{
  "OPENAI_API_KEY": "your-api-key"
}
```

## How It Works

1. Reads provider and base URL from `~/.codex/config.toml`
2. Resolves API key from provider-specific env vars and `~/.codex/auth.json`
3. Tries common model endpoints (e.g. `/models`, `/v1/models`, `/api/provider/.../models`)
4. Parses model list and displays sorted categories
5. Writes selected model back to the top-level `model = "..."` in `~/.codex/config.toml`

## Uninstall

```bash
codex-model-switch-uninstall
```

This removes:

- `~/.local/bin/.codex-model-switch-bin`
- `~/.local/bin/codex-model-switch-uninstall`
- Optional `~/.codex/tools/model-list.json` and `~/.codex/tools/model.json`
- Shell function from `~/.bashrc`

## Notes

- Uninstall does not modify `~/.codex/config.toml` or `~/.codex/auth.json`.
- If `codex-model-switch` command is not found, run `source ~/.bashrc` and retry.

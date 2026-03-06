# Codex Model Switch

A CLI tool for quickly switching Codex CLI default models. Automatically fetches available models from your configured provider endpoint in `~/.codex/config.toml`.

## Features

- Automatically fetches available models from your API
- Two-column display with alphabetical sorting (same interaction style as `claude-model-switch`)
- Highlights currently selected model
- Batch operations (custom model input, refresh list, sync script)
- Supports command line switching by index
- Supports script sync/update functionality
- Can auto-generate Codex tool definitions in `~/.codex/tools`

## Screenshot

```text
============================================================
             Codex CLI Model Switch
============================================================

API: https://your-endpoint

Current Configuration:
  Main Model (model):                gpt-5.3-codex
  Provider (model_provider):         cliproxyapi
  Wire API:                          responses

--- GPT/Codex Models (12) ---
1. gpt-5                             7. gpt-5.1-codex-mini
2. gpt-5-codex                       8. gpt-5.2
...

--- Google Gemini Models (6) ---
13. gemini-2.5-flash                 16. gemini-3-flash-preview
...

--- Batch Operations ---
  [a] Custom model name input
  [r] Refresh model list
  [u] Sync scripts to ~/.local/bin
  [q] Quit
```

## Prerequisites

- Python 3.7+
- Codex CLI configured with:
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

- Install the script to `~/.local/bin/.codex-model-switch-bin`
- Add `codex-model-switch` shell function to `~/.bashrc`
- Ensure `~/.local/bin` is in your PATH

## Configuration

The tool reads configuration from `~/.codex/config.toml` and auth from `~/.codex/auth.json`.

Example `~/.codex/config.toml`:

```toml
model_provider = "cliproxyapi"
model = "gpt-5.3-codex"

[model_providers.cliproxyapi]
name = "cliproxyapi"
base_url = "https://your-endpoint/v1"
wire_api = "responses"
```

Example `~/.codex/auth.json`:

```json
{
  "OPENAI_API_KEY": "your-api-key"
}
```

## Usage

### Interactive Mode

```bash
codex-model-switch
```

### Menu Options

| Key | Action |
|-----|--------|
| Number | Select a model, then confirm switch |
| [m] | Set main model (model) via submenu |
| [a] | Enter custom model name |
| [r] | Refresh model list from API |
| [u] | Sync script to `~/.local/bin` |
| [q] | Quit |

### Command Line Options

```bash
codex-model-switch --list        # List all models (JSON format)
codex-model-switch 3             # Switch to model #3
codex-model-switch --set gpt-5   # Switch by model id
codex-model-switch --update      # Sync scripts to ~/.local/bin
codex-model-switch --show-config # Show resolved config
codex-model-switch --help        # Show help
```

## Updating Scripts

After modifying project files, sync to `~/.local/bin`:

```bash
cd /path/to/codex-model-switch
./codex-model-switch --update
# or
./install.sh
```

## Usage from Codex CLI

The first time you run `codex-model-switch`, it automatically installs two tool files to `~/.codex/tools`:

- `model-list.json` - List all available models with index numbers
- `model.json` - Switch model by index number

Restart Codex CLI after first run to ensure tool changes are picked up.

## Auth Key Resolution

Priority order:

1. Provider-specific environment variables
2. Provider-specific keys in `~/.codex/auth.json`
3. Any `*_API_KEY` / `*_AUTH_TOKEN` in `~/.codex/auth.json`
4. Fallback environment variables

## Uninstall

```bash
codex-model-switch-uninstall
```

This will remove:

- `~/.local/bin/.codex-model-switch-bin`
- `~/.local/bin/codex-model-switch-uninstall`
- `~/.codex/tools/model-list.json`
- `~/.codex/tools/model.json`
- Shell function from `~/.bashrc`

## License

MIT License

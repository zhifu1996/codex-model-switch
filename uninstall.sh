#!/bin/bash
# Codex Model Switch Uninstaller

echo "=========================================="
echo "       Codex Model Switch Uninstaller"
echo "=========================================="
echo ""

SCRIPT_PATH="$HOME/.local/bin/.codex-model-switch-bin"
UNINSTALL_SCRIPT="$HOME/.local/bin/codex-model-switch-uninstall"
TOOLS_DIR="$HOME/.codex/tools"
BASHRC="$HOME/.bashrc"
FUNC_MARKER="# Codex Model Switch - shell wrapper"

echo "The following will be removed:"
echo "  1. $SCRIPT_PATH"
echo "  2. $UNINSTALL_SCRIPT"
echo "  3. $TOOLS_DIR/model-list.json (if exists)"
echo "  4. $TOOLS_DIR/model.json (if exists)"
echo "  5. Shell function 'codex-model-switch' from ~/.bashrc"
echo ""

files_to_delete=()
if [ -f "$SCRIPT_PATH" ]; then
    files_to_delete+=("$SCRIPT_PATH")
fi
if [ -f "$UNINSTALL_SCRIPT" ]; then
    files_to_delete+=("$UNINSTALL_SCRIPT")
fi

has_func=false
if grep -q "$FUNC_MARKER" "$BASHRC" 2>/dev/null; then
    has_func=true
fi

if [ ${#files_to_delete[@]} -eq 0 ] && [ ! -f "$TOOLS_DIR/model-list.json" ] && [ ! -f "$TOOLS_DIR/model.json" ] && [ "$has_func" = false ]; then
    echo "No files found to delete."
    exit 0
fi

read -p "Confirm deletion? (y/n): " confirm
if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
    echo "Cancelled."
    exit 0
fi

for file in "${files_to_delete[@]}"; do
    rm -f "$file"
    echo "Deleted: $file"
done

# Delete optional Codex tools
if [ -f "$TOOLS_DIR/model-list.json" ]; then
    rm -f "$TOOLS_DIR/model-list.json"
    echo "Deleted: $TOOLS_DIR/model-list.json"
fi
if [ -f "$TOOLS_DIR/model.json" ]; then
    rm -f "$TOOLS_DIR/model.json"
    echo "Deleted: $TOOLS_DIR/model.json"
fi

# Remove shell function from bashrc
if [ "$has_func" = true ]; then
    # Remove function block (from marker line to closing brace)
    sed -i "/$FUNC_MARKER/,/^}/d" "$BASHRC"
    # Remove any trailing empty lines that might be left
    sed -i '/^$/N;/^\n$/d' "$BASHRC"
    echo "Removed shell function 'codex-model-switch' from ~/.bashrc"
fi

if [ -f "$HOME/.bash_aliases" ]; then
    if grep -q "codex-model-switch" "$HOME/.bash_aliases"; then
        echo ""
        echo "Found related aliases in ~/.bash_aliases:"
        grep "codex-model-switch" "$HOME/.bash_aliases"
        read -p "Delete these alias lines? (y/n): " confirm_alias
        if [ "$confirm_alias" = "y" ] || [ "$confirm_alias" = "Y" ]; then
            sed -i '/codex-model-switch/d' "$HOME/.bash_aliases"
            echo "Removed aliases from ~/.bash_aliases."
        fi
    fi
fi

echo ""
echo "Uninstall complete!"
echo ""
echo "Note:"
echo "  - ~/.codex/config.toml and ~/.codex/auth.json were not modified."
echo "  - Run 'source ~/.bashrc' to reload your shell."

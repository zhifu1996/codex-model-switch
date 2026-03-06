# Codex Model Switch 使用文档

## 简介

Codex Model Switch 是一个交互式工具，用于快速切换 Codex CLI 的默认模型。整体交互布局参考 `claude-model-switch`，包括两列模型展示、分组菜单和批量操作区。

## 特性

- 自动从 API 获取可用模型列表
- 两列显示与当前模型高亮
- 支持交互模式、按编号切换、按模型名直接设置
- 支持脚本同步更新到 `~/.local/bin`
- 自动生成 `~/.codex/tools` 下的工具配置

## 安装

```bash
cd /path/to/codex-model-switch
chmod +x codex-model-switch install.sh uninstall.sh
./install.sh
source ~/.bashrc
```

安装脚本会：

- 安装脚本到 `~/.local/bin/.codex-model-switch-bin`
- 安装卸载脚本 `codex-model-switch-uninstall`
- 在 `~/.bashrc` 添加 `codex-model-switch` shell 函数
- 确保 `~/.local/bin` 在 PATH 中

## 使用方法

### 交互模式

```bash
codex-model-switch
```

### 命令行模式

```bash
codex-model-switch --list          # 列出所有模型（JSON 格式）
codex-model-switch 3               # 切换到第 3 个模型
codex-model-switch --set gpt-5     # 直接设置模型名
codex-model-switch --update        # 同步脚本到 ~/.local/bin
codex-model-switch --show-config   # 显示当前解析配置
codex-model-switch --help          # 显示帮助
```

## 主界面说明

```text
============================================================
             Codex CLI Model Switch
============================================================

API: https://your-endpoint

Current Configuration:
  Main Model (model):                gpt-5.3-codex
  Provider (model_provider):         cliproxyapi
  Wire API:                          responses

--- GPT/Codex Models (...) ---
... 两列展示 ...

--- Batch Operations ---
  [a] Custom model name input
  [r] Refresh model list
  [u] Sync scripts to ~/.local/bin
  [q] Quit
```

## 配置文件要求

`~/.codex/config.toml` 至少需要：

```toml
model_provider = "cliproxyapi"
model = "gpt-5.3-codex"

[model_providers.cliproxyapi]
name = "cliproxyapi"
base_url = "https://your-endpoint/v1"
wire_api = "responses"
```

`~/.codex/auth.json` 示例：

```json
{
  "OPENAI_API_KEY": "your-api-key"
}
```

## 更新脚本

修改项目文件后，同步到 `~/.local/bin`：

```bash
cd /path/to/codex-model-switch
./codex-model-switch --update
# 或
./install.sh
```

## 卸载

```bash
codex-model-switch-uninstall
```

卸载脚本会删除：

- `~/.local/bin/.codex-model-switch-bin`
- `~/.local/bin/codex-model-switch-uninstall`
- `~/.codex/tools/model-list.json`
- `~/.codex/tools/model.json`
- `~/.bashrc` 中的 shell 函数

## 常见问题

### Q: 为什么获取不到模型列表？

检查：

1. `~/.codex/config.toml` 里的 `base_url` 是否可访问
2. `~/.codex/auth.json` 中 token 是否有效
3. 网络与 DNS 是否正常

### Q: 如何确认当前读取到的配置？

```bash
codex-model-switch --show-config
```

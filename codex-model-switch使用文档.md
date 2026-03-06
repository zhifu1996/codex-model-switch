# Codex Model Switch 使用文档

## 简介

Codex Model Switch 是一个交互式工具，用于快速切换 Codex CLI 的默认模型。它会读取 `~/.codex/config.toml` 和 `~/.codex/auth.json`，自动获取可用模型列表，并将选中的模型写回配置文件。

## 特性

- 自动从 API 获取可用模型列表
- 支持交互式切换、按编号切换、按模型名直接切换
- 支持 JSON 列表输出（便于脚本集成）
- 自动高亮当前模型
- 兼容多种模型列表接口路径

## 安装

```bash
cd /path/to/codex-model-switch
chmod +x codex-model-switch install.sh uninstall.sh
./install.sh
source ~/.bashrc
```

安装脚本会：

- 安装主脚本到 `~/.local/bin/.codex-model-switch-bin`
- 安装卸载脚本到 `~/.local/bin/codex-model-switch-uninstall`
- 在 `~/.bashrc` 中添加 `codex-model-switch` shell 函数
- 确保 `~/.local/bin` 在 PATH 中

## 使用方法

### 交互模式

```bash
codex-model-switch
```

### 命令行模式

```bash
codex-model-switch --list
codex-model-switch --list-json
codex-model-switch 10
codex-model-switch --set gpt-5.3-codex
codex-model-switch --show-config
codex-model-switch --help
```

## 配置要求

`~/.codex/config.toml` 至少包含：

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

## 工作原理

1. 从 `~/.codex/config.toml` 读取 provider 和 `base_url`
2. 从环境变量或 `~/.codex/auth.json` 解析 API key
3. 自动尝试常见模型列表接口路径
4. 解析模型列表后展示并支持切换
5. 更新 `~/.codex/config.toml` 顶层的 `model = "..."` 字段

## 卸载

```bash
codex-model-switch-uninstall
```

卸载脚本会删除：

- `~/.local/bin/.codex-model-switch-bin`
- `~/.local/bin/codex-model-switch-uninstall`
- 可选 `~/.codex/tools/model-list.json` / `model.json`
- `~/.bashrc` 中的 `codex-model-switch` shell 函数

## 常见问题

### Q: 为什么拉取不到模型列表？

先检查：

1. `~/.codex/config.toml` 中 provider 和 `base_url` 是否正确
2. `~/.codex/auth.json` 中 API key 是否有效
3. 网络是否可访问对应 `base_url`

### Q: 如何查看当前解析到的配置？

```bash
codex-model-switch --show-config
```

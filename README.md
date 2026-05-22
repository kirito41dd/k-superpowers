# K Superpowers

这是我自用的 Superpowers fork，用来沉淀个人化的 agent 工作流、skills 定制和项目记忆规则。

本仓库不面向上游贡献，也不使用上游 marketplace 发布链路。默认安装方式以 git 或本地路径为主。

## 当前定制重点

- `using-superpowers`：增加预热型请求判断。“熟悉规范 / 熟悉模块 / 先看项目 / 等我给需求”只读取上下文并等待，不进入 brainstorming。
- `brainstorming`：明确 preparation-only requests 不是触发条件。
- `CLAUDE.md`：只保留项目记忆规则，后续用于放个人 fork 的 agent 提示。
- `.ai/memory/`：记录本 fork 的长期决策、约定、坑点和术语。
- `docs/skills-overview.zh.md`：中文梳理每个 skill 的核心思想、流程和 `description` 注入效果。

## OpenCode 安装

### Git 安装

在全局或项目级 `opencode.json` 中加入：

```json
{
  "plugin": ["k-superpowers@git+https://github.com/kirito41dd/k-superpowers.git"]
}
```

保存后重启 OpenCode。

验证方式：开启新会话后问：

```text
Tell me about your superpowers
```

### 本地开发安装

如果要直接使用当前 checkout：

```json
{
  "plugin": ["file:///Users/kirito/my/k-superpowers"]
}
```

也可以用普通路径，取决于 OpenCode 当前版本对 plugin path 的支持：

```json
{
  "plugin": ["/Users/kirito/my/k-superpowers"]
}
```

保存后重启 OpenCode。运行中的 OpenCode 不会热加载插件和 skill 变更。

## OpenCode 更新

Git-backed plugin 可能被 OpenCode、Bun 或 lockfile/cache 固定到旧 commit。

如果更新没有生效：

1. 重启 OpenCode。
2. 清理 OpenCode package cache 或重新安装 plugin。
3. 如需固定版本，可在 git spec 后追加分支、tag 或 commit：

```json
{
  "plugin": ["k-superpowers@git+https://github.com/kirito41dd/k-superpowers.git#main"]
}
```

## Codex app 本地市场安装

Codex app 使用本仓库作为本地 marketplace。添加本地市场时填写仓库根目录：

```text
/Users/kirito/my/k-superpowers
```

不要填写 `marketplace.json` 文件路径。Codex app 会读取：

```text
/Users/kirito/my/k-superpowers/.agents/plugins/marketplace.json
```

当前 marketplace 暴露的插件是：

```text
k-superpowers@k-superpowers-dev
```

安装后可用 CLI 验证：

```bash
codex plugin list | grep k-superpowers
```

预期能看到：

```text
k-superpowers@k-superpowers-dev  installed, enabled  5.1.0
```

本地 marketplace 的结构是：

```text
.agents/plugins/marketplace.json
plugins/k-superpowers -> ..
.codex-plugin/plugin.json
skills/
```

如果 Codex app 显示市场已添加但列表为空，先重启 Codex app，再搜索 `k-superpowers` 或 `K Superpowers`。也可以直接运行：

```bash
codex plugin add k-superpowers@k-superpowers-dev
```

## 其它生态

Claude Code、Cursor、Gemini 等 marketplace manifest 目前保留上游形态，暂不作为本 fork 的主要安装方式。Codex app 已支持本地 marketplace 安装，但不走上游发布链路。

如果后续需要支持某个生态，再单独梳理对应发布方式和 manifest 命名，不做批量重命名。

## 项目记忆

新会话先读 `.ai/memory/index.md`，再按任务需要读取相关记忆文件。

写入长期记忆前必须先确认，避免把临时偏好误写成长期规则。

## 参考

- 上游项目：<https://github.com/obra/superpowers>
- OpenCode 文档：<https://opencode.ai/docs/>

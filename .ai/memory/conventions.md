# 项目约定

<!-- SUMMARY
覆盖范围：项目特定的代码风格、命名规则、目录结构、流程约定
条目数：4
最近更新：2026-05-21
高频标签：#skills #memory #eval #personalization #brainstorming #opencode #install
-->

## 说明

- 仅记录项目特定约定，不记录语言通用规范。
- 用户明确纠正过的做法优先记录。
- 与通用规范冲突时，项目约定优先。

## 写入格式

```
## YYYY-MM-DD 一句话约定标题

- **约定**：具体规则
- **理由**：为什么这么定
- **反例**：错误写法示范（可选）
- **正例**：正确写法示范
- **范围**：影响哪些模块 / 文件类型
```

---

## 2026-05-21 优先维护 OpenCode 安装链路

- **约定**：本 fork 的安装引导优先维护 OpenCode 的 git-backed plugin 和本地路径安装；Claude Code、Codex、Cursor、Gemini 等 marketplace manifest 暂不作为主要安装方式，不做批量重命名。
- **理由**：这是自用 fork，当前主要在 OpenCode 使用；全生态改名会引入发布、manifest、测试和 marketplace 维护成本。
- **反例**：一次性把 `.claude-plugin`、`.codex-plugin`、`.cursor-plugin`、`gemini-extension.json` 全部改名但没有对应发布链路。
- **正例**：README 明确推荐 `k-superpowers@git+https://github.com/kirito41dd/k-superpowers.git` 和 `file:///Users/kirito/my/k-superpowers`。
- **范围**：`README.md`, `docs/README.opencode.md`, `.opencode/INSTALL.md`, `package.json`

## 2026-05-21 预热型请求不触发 brainstorming

- **约定**：当用户说“熟悉开发规范 / 熟悉模块 / 先看项目 / 等我给需求”等预热型请求时，只读取相关上下文并等待后续需求，不触发 `brainstorming`，不问设计问题，不写 spec/plan。
- **理由**：用户经常先要求 agent 熟悉上下文，需求稍后才给；过早进入脑暴会打断工作流。
- **反例**：用户说“熟悉 xx，然后我给你需求”后立即提出方案、追问需求澄清或创建设计文档。
- **正例**：读取指定规范或模块，简要总结关键点，然后等待明确的 build/change/fix 请求。
- **范围**：`skills/using-superpowers/SKILL.md`, `skills/brainstorming/SKILL.md`

## 2026-05-21 Skill 正文变更必须先评估

- **约定**：修改 `skills/*/SKILL.md` 前必须使用 `writing-skills` 的 RED-GREEN-REFACTOR 思路，先构造压力场景和基线失败，再改正文并复测。
- **理由**：skill 是行为塑造内容，不是普通 prose；未经评估的措辞调整可能改变 agent 行为并被 upstream 拒绝。
- **反例**：为了“更清晰”直接重写 Red Flags、rationalization table 或 `human partner` 语气。
- **正例**：先记录某个实际失败场景，再做最小文案调整，并保存 before/after eval 结果。
- **范围**：`skills/*/SKILL.md`, `skills/*/*.md` 中会影响 agent 行为的内容。

## 2026-05-21 项目记忆采用渐进式披露

- **约定**：新会话或任务开始只读 `.ai/memory/index.md`，按当前任务关键词再读取相关记忆文件；不要一次性读取整个 `.ai/memory/`。
- **理由**：避免长期记忆造成上下文膨胀，同时保留可追溯的项目历史。
- **正例**：准备改 skill 时先读 `index.md`，再按索引读 `conventions.md` 和 `gotchas.md`。
- **范围**：`.ai/memory/*`, `CLAUDE.md`

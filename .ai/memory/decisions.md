# 技术决策记录

<!-- SUMMARY
覆盖范围：架构决策、技术选型、废弃方案（ADR 风格）
条目数：3
最近更新：2026-05-21
高频标签：#memory #fork #personalization #opencode #install
-->

## 写入格式（ADR 风格）

```
## YYYY-MM-DD 一句话决策标题

- **背景**：为什么需要做这个决策
- **选项**：考虑过哪些方案（A/B/C）
- **决策**：最终选择的方案
- **理由**：为什么选这个，放弃其他的原因
- **影响**：影响的模块 / 文件
- **状态**：已实施 / 试验中 / [DEPRECATED 原因]
```

---

## 2026-05-21 OpenCode 使用 k-superpowers git 安装

- **背景**：用户将 fork 命名为 `k-superpowers`，并明确这是自用版本，需要安装引导指向自己的 fork，而不是上游 marketplace。
- **选项**：继续使用上游 `superpowers` 安装说明；全生态重命名并发布 marketplace；只维护 OpenCode 的 git/local 安装链路。
- **决策**：根 `package.json` 改名为 `k-superpowers`，README 和 OpenCode 安装文档使用 `k-superpowers@git+https://github.com/kirito41dd/k-superpowers.git`；本地开发安装使用 `file:///Users/kirito/my/k-superpowers`。
- **理由**：当前主要使用 OpenCode，git-backed plugin 足够满足自用；其它生态 marketplace 需要额外发布流程，暂不扩大范围。
- **影响**：`package.json`, `README.md`, `docs/README.opencode.md`, `.opencode/INSTALL.md`
- **状态**：已实施。

## 2026-05-21 个人 fork 不面向上游贡献

- **背景**：用户明确表示本仓库是个人 fork，用于定制属于自己的 Superpowers，不打算提交给上游。
- **选项**：保留上游贡献规范；把上游规范移到参考文档；让 `CLAUDE.md` 只承载个人 fork 的运行提示和记忆规则。
- **决策**：`CLAUDE.md` 当前只保留项目记忆机制；后续如需新增提示，也只放 skill 定制相关内容。
- **理由**：上游 PR 规范对个人 fork 日常工作是噪音，会干扰 agent 判断；个人 fork 更需要稳定记录自定义行为偏好。
- **影响**：`CLAUDE.md`, `skills/*/SKILL.md`, `.ai/memory/*`
- **状态**：已实施。

## 2026-05-21 安装项目级 AI 记忆系统

- **背景**：用户希望后续持续微调个人 fork，需要项目级长期记忆记录需求、约定、坑点和术语，避免每次重新建立上下文。
- **选项**：只写中文总览文档；使用 `/Users/kirito/wk/ai-memory-template` 的 `.ai/memory/` 渐进式披露模板；把记忆写进全局 CLAUDE 配置。
- **决策**：在本项目内创建 `.ai/memory/`，并在项目 `CLAUDE.md` 追加项目记忆机制入口。
- **理由**：项目级记忆跟随仓库，适合 fork 内部演进；渐进式披露避免每次加载所有历史；不污染全局配置。
- **影响**：`.ai/memory/*`, `CLAUDE.md`
- **状态**：已实施。

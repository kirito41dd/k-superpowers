# 术语表

<!-- SUMMARY
覆盖范围：项目特定名词、业务黑话、内部缩写
条目数：4
最近更新：2026-05-21
-->

## 写入格式

```
## 术语名（缩写）

- **定义**：一句话解释
- **上下文**：在什么场景下使用
- **相关**：关联的其他术语 / 模块 / 文件
- **首次出现**：YYYY-MM-DD
```

---

## Behavior-shaping content

- **定义**：会直接改变 agent 决策、纪律或工作流的 skill 内容。
- **上下文**：修改 `SKILL.md`、Red Flags、rationalization table、流程图和强制语句时使用。
- **相关**：`writing-skills`, `verification-before-completion`, `test-driven-development`
- **首次出现**：2026-05-21

## Harness

- **定义**：承载 agent 和 skill 运行的宿主环境，例如 Claude Code、Codex、OpenCode、Cursor。
- **上下文**：新增平台支持、worktree 管理、skill 自动触发验收时使用。
- **相关**：`using-superpowers`, `using-git-worktrees`, `.github/PULL_REQUEST_TEMPLATE.md`
- **首次出现**：2026-05-21

## Human partner

- **定义**：Superpowers 原文中刻意使用的用户称呼，强调 agent 与人类协作而不是替代。
- **上下文**：skill 正文、PR 审查要求、行为语气相关内容。
- **相关**：`CLAUDE.md`, `skills/*/SKILL.md`
- **首次出现**：2026-05-21

## Skill

- **定义**：可复用的技术、流程、模式或参考指南，用于在特定触发场景下约束 agent 行为。
- **上下文**：`skills/<name>/SKILL.md` 及其支持文件。
- **相关**：`writing-skills`, `using-superpowers`
- **首次出现**：2026-05-21

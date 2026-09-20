# 术语表

<!-- SUMMARY
覆盖范围：项目特定名词、业务黑话、内部缩写
-->

## 写入格式

字段和操作规则见 [policy.md](policy.md)。术语名作标题，日期单独记录；以下仅为格式示例。

```markdown
## 术语名（缩写）
<a id="term-YYYYMMDD-01"></a>

- **状态**：有效
- **范围**：适用业务域 / 模块
- **来源**：用户确认日期与内容 / 业务文档链接
- **标签**：#module-name #business
- **定义**：一句话解释
- **上下文**：在什么场景下使用
- **相关**：关联的其他术语 / 模块 / 文件
- **首次出现**：YYYY-MM-DD
```

---

<!-- 条目：在此行下方按术语名排序 -->

## Behavior-shaping content
<a id="term-20260521-01"></a>

- **状态**：有效
- **范围**：skills 行为指导文本的编辑与审查
- **来源**：迁移前记录：本仓库 commit `94bb0264f83a54d6b5f31af25ebdf433d14f7fc5` 中 `.ai/memory/glossary.md` 的同名条目；原始对话链接未附。
- **标签**：#skills #prompt

- **定义**：会直接改变 agent 决策、纪律或工作流的 skill 内容。
- **上下文**：修改 `SKILL.md`、Red Flags、rationalization table、流程图和强制语句时使用。
- **相关**：`writing-skills`, `verification-before-completion`, `type-driven-verification`
- **首次出现**：2026-05-21

---

## Harness
<a id="term-20260521-02"></a>

- **状态**：有效
- **范围**：Agent 宿主平台与集成语境，不代表本仓库承诺支持全部列举平台
- **来源**：迁移前记录：本仓库 commit `94bb0264f83a54d6b5f31af25ebdf433d14f7fc5` 中 `.ai/memory/glossary.md` 的同名条目；原始对话链接未附。
- **标签**：#skills #install

- **定义**：承载 agent 和 skill 运行的宿主环境，例如 Claude Code、Codex、OpenCode、Cursor。
- **上下文**：新增平台支持、worktree 管理、skill 自动触发验收时使用。
- **相关**：`using-superpowers`, `using-git-worktrees`, `.github/PULL_REQUEST_TEMPLATE.md`
- **首次出现**：2026-05-21

---

## Human partner
<a id="term-20260521-03"></a>

- **状态**：有效
- **范围**：Superpowers 上游用语及历史协作语境
- **来源**：迁移前记录：本仓库 commit `94bb0264f83a54d6b5f31af25ebdf433d14f7fc5` 中 `.ai/memory/glossary.md` 的同名条目；原始对话链接未附。
- **标签**：#skills #fork

- **定义**：Superpowers 原文中刻意使用的用户称呼，强调 agent 与人类协作而不是替代。
- **上下文**：skill 正文、PR 审查要求、行为语气相关内容。
- **相关**：`CLAUDE.md`, `skills/*/SKILL.md`
- **首次出现**：2026-05-21

---

## Skill
<a id="term-20260521-04"></a>

- **状态**：有效
- **范围**：全项目；skill 及其支撑文件
- **来源**：迁移前记录：本仓库 commit `94bb0264f83a54d6b5f31af25ebdf433d14f7fc5` 中 `.ai/memory/glossary.md` 的同名条目；原始对话链接未附。
- **标签**：#skills

- **定义**：可复用的技术、流程、模式或参考指南，用于在特定触发场景下约束 agent 行为。
- **上下文**：`skills/<name>/SKILL.md` 及其支持文件。
- **相关**：`writing-skills`, `using-superpowers`
- **首次出现**：2026-05-21

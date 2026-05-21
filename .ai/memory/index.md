# 项目记忆索引

<!-- SUMMARY
本文件是记忆系统的路标。新会话或任务开始时只读本文件，
根据任务按需加载下方具体文件，不要预读全部记忆。
-->

## 文件清单

| 文件 | 何时读取 | 何时写入 |
|------|---------|---------|
| `requirements.md` | 用户提新需求 / 讨论功能范围 | 需求变更、功能增删 |
| `decisions.md` | 用户问“为什么” / 做技术选型 / 准备改 workflow 哲学 | 确定技术方案、架构决策 |
| `gotchas.md` | 调试 bug / 修改敏感模块前 / 准备向 upstream 提 PR | 遇到非显而易见的坑 |
| `conventions.md` | 写新文档 / 改 skill / 用户纠正风格时 | 用户明确指出项目约定 |
| `glossary.md` | 遇到陌生术语 | 用户使用项目特定名词 |

## 快速索引（按模块）

- Skills 总览 → `docs/skills-overview.zh.md`
- Fork 定制方向 → `decisions.md#2026-05-21-个人-fork-不面向上游贡献`
- OpenCode 安装方式 → `decisions.md#2026-05-21-opencode-使用-k-superpowers-git-安装`
- 生态集成范围 → `conventions.md#2026-05-21-优先维护-opencode-安装链路`
- 预热型请求处理 → `conventions.md#2026-05-21-预热型请求不触发-brainstorming`
- PR/上游贡献规则 → `gotchas.md#2026-05-21-上游-pr-门槛很高`
- Skill 修改纪律 → `conventions.md#2026-05-21-skill-正文变更必须先评估`
- 项目定位 → `requirements.md#2026-05-21-个人-fork-用于后续微调-superpowers-skills`

## 标签索引

- `#skills` → `requirements.md`, `conventions.md`, `glossary.md`
- `#fork` → `requirements.md`, `decisions.md`
- `#personalization` → `decisions.md`, `conventions.md`
- `#opencode` → `decisions.md`, `conventions.md`
- `#install` → `decisions.md`, `conventions.md`
- `#brainstorming` → `conventions.md`
- `#upstream-pr` → `gotchas.md`
- `#memory` → `decisions.md`, `conventions.md`
- `#eval` → `conventions.md`, `gotchas.md`

## 最近热点

- 2026-05-21 优先维护 OpenCode 安装链路 → `conventions.md`
- 2026-05-21 OpenCode 使用 k-superpowers git 安装 → `decisions.md`
- 2026-05-21 预热型请求不触发 brainstorming → `conventions.md`
- 2026-05-21 个人 fork 不面向上游贡献 → `decisions.md`
- 2026-05-21 安装项目级 AI 记忆系统 → `decisions.md`
- 2026-05-21 Skill 正文变更必须先评估 → `conventions.md`
- 2026-05-21 上游 PR 门槛很高 → `gotchas.md`
- 2026-05-21 个人 fork 用于后续微调 Superpowers skills → `requirements.md`

## 归档规则

- 单个记忆文件超过 500 行时，归档最旧的 100 行到 `archive/<year>/<filename>`。
- 标记为 `[DEPRECATED]` 的条目在文件超限时优先归档。
- 读取时默认不加载 `archive/`，除非用户明确要求。

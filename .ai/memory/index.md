# 项目记忆索引

<!-- SUMMARY
本文件提供分类入口和关键条目导航，不枚举全部记忆。
操作规范见 policy.md；各文件中的格式示例不是实际记忆。
-->

## 分类入口

| 文件 | 用途与检索线索 |
|------|----------------|
| [requirements.md](requirements.md) | 需求范围、个人 fork 定位、工作流目标 |
| [decisions.md](decisions.md) | 技术方案、取舍、适用条件和替代关系 |
| [gotchas.md](gotchas.md) | 历史坑点及待核验的上游贡献要求；按状态解释 |
| [conventions.md](conventions.md) | 项目特定约定、注释、验证和安装规则 |
| [feedback.md](feedback.md) | 实际使用中的问题、用户规则与处理进展 |
| [glossary.md](glossary.md) | Skill、Harness 等术语和历史用语 |
| [policy.md](policy.md) | 检索、写入授权、冲突处理和归档规则 |

## 模块与关键条目

- 工作流哲学 | `skills/` | judgment-first、routing → [2026-07-21 Skills 工作流采用 Judgment-First 与有界 Review](decisions.md#dec-20260721-01)；[2026-07-21 把 Agent 当作聪明的智能体](conventions.md#conv-20260721-01)
- Skill 迭代 | `skills/writing-skills/` | 真实反馈、验证成本 → [2026-07-21 Skill 修改采用一次编辑一次自审](conventions.md#conv-20260721-02)；[2026-07-21 Skills 不维护持久测试并停止默认模型验证](decisions.md#dec-20260721-02)
- 日常路由 | `skills/using-superpowers/` | 普通问答、只读准备 → [2026-07-21 日常问答走 No Task Skill 且 Prompt 瘦身不得弱化注释契约](conventions.md#conv-20260721-03)；[2026-05-21 预热型请求不触发 brainstorming](conventions.md#conv-20260521-03)
- 代码质量 | `skills/type-driven-verification/` | Rust 哲学、核心说明 → [2026-07-14 Rust 哲学只评价代码产出并按目标语言能力适配](conventions.md#conv-20260714-01)；[2026-07-15 核心代码说明由 type-driven-verification 单一拥有](conventions.md#conv-20260715-01)；[2026-07-07 Skill 写代码时的注释原则](conventions.md#conv-20260707-01)
- 后端服务 | `skills/type-driven-verification/` | 用例、事务、数据归属 → [2026-08-27 后端业务服务采用用例驱动的事务型应用服务规范](decisions.md#dec-20260827-01)
- 数据库 | `skills/type-driven-verification/` | DDL、migration、sharding → [2026-08-28 后端数据库采用面向在线演进与分片的通用规范](decisions.md#dec-20260828-01)
- 技术评审材料 | `skills/preparing-technical-review/` | 可读性、可行性 → [2026-09-02 技术评审材料难以让非作者快速理解](feedback.md#fb-20260902-01)
- 独立 Review | `skills/requesting-code-review/` | 提交前审查 → [2026-08-27 提交请求可能绕过独立 Review](feedback.md#fb-20260827-01)
- Git 交付 | `skills/finishing-a-development-branch/` | recipe、证据复用 → [2026-08-26 上下文压缩后漏读 PR action recipe](feedback.md#fb-20260826-01)；[2026-08-22 提交阶段重复运行已完成的验证](feedback.md#fb-20260822-01)
- Worktree | `skills/using-git-worktrees/` | submodule、清理 → [2026-08-24 含 submodule 的干净 worktree 被误判为不可清理](feedback.md#fb-20260824-01)
- 研发日志 | `skills/using-superpowers/` | logging、比例化验证 → [2026-08-22 纯日志改动被过度工程化](feedback.md#fb-20260822-02)
- 安装与版本 | `.claude-plugin/`、`.agents/plugins/`、`.opencode/` → [2026-06-10 三条安装链路并列维护，CC 插件命名 k-superpowers](conventions.md#conv-20260610-01)；[2026-05-22 Codex app 本地 marketplace 使用仓库根目录](conventions.md#conv-20260522-01)；[2026-06-25 重要变更必须更新插件版本号](conventions.md#conv-20260625-01)
- 项目定位 | 全项目 | fork、personalization → [2026-05-21 个人 fork 用于后续微调 Superpowers skills](requirements.md#req-20260521-01)；[2026-05-21 个人 fork 不面向上游贡献](decisions.md#dec-20260521-03)
- 项目记忆 | `.ai/memory/`、`CLAUDE.md` | 稳定 ID、来源、授权 → [2026-09-08 升级项目记忆的检索、授权和维护规则](decisions.md#dec-20260908-01)
- Skills 用户向总览 → [工作方式与 Skill 分工](../../docs/skills-overview.zh.md)

历史流程、测试 campaign 和旧安装取舍保留在原分类文件，可按标题、路径和关键词检索；
已替代条目提供替代链接。归档入口见 [archive/README.md](archive/README.md)。

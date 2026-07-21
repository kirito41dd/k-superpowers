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

- Skills 无持久测试、真实使用反馈驱动迭代 → `requirements.md#2026-07-21-skills-仓库移除全部持久测试`, `decisions.md#2026-07-21-skills-不维护持久测试并停止默认模型验证`, `conventions.md#2026-07-21-skill-修改采用一次编辑一次自审`
- GPT-5.6 Prompt 优化、日常问答 No Task Skill 与既有行为保护 → `requirements.md#2026-07-21-gpt-56-prompt-优化须保留既有行为`, `decisions.md#2026-07-21-以最小-skill-路由和行为-eval-落地-gpt-56-prompt-优化`, `conventions.md#2026-07-21-日常问答走-no-task-skill-且-prompt-瘦身不得弱化注释契约`
- SDD Role Prompt 完整保真与 live 随机零读取诊断 → `gotchas.md#2026-07-21-role-prompt-保真不能只查关键字或无边界占位符`, `gotchas.md#2026-07-21-live-reviewer-单次零读取不等于-prompt-结构缺陷`
- Skills 总览 → `docs/skills-overview.zh.md`
- 核心代码说明规则 owner 与 Compact/Inline 覆盖 → `conventions.md#2026-07-15-核心代码说明由-type-driven-verification-单一拥有`
- Skills 瘦身、语言自适应 Rust 工程哲学与 SDD/review 保留范围 → `decisions.md#2026-07-14-研发流程-skills-瘦身并保留语言自适应-rust-工程哲学`, `conventions.md#2026-07-14-rust-哲学只评价代码产出并按目标语言能力适配`
- Compact/Full 主流程、faithful spec/plan 与 Unified Execution Handoff → `decisions.md#2026-07-10-主开发流程增加自动-compactfull-分流与统一-handoff`
- SDD 风险自适应执行、merged reviewer 与 checkpoint commit gate → `decisions.md#2026-07-10-sdd-改为风险自适应执行并合并-task-reviewer`
- Skill 验证命令与代码注释 source-of-truth → `conventions.md#2026-07-08-skill-验证命令与代码注释-source-of-truth`
- SDD reviewer/controller 上游纪律吸收 → `decisions.md#2026-07-08-吸收上游-sdd-reviewer-与-controller-纪律`
- SDD task brief 全局约束与复审路由 → `decisions.md#2026-07-08-强化-sdd-task-brief-全局约束与复审路由`
- Skill 写代码时的注释原则 → `conventions.md#2026-07-07-skill-写代码时的注释原则`
- 上游 v6 SDD 文件交接与进度账本 → `decisions.md#2026-06-26-跟进上游-v6-sdd-文件交接与进度账本`
- 上游 v6 writing-plans 结构增强 → `decisions.md#2026-06-26-跟进上游-v6-writing-plans-结构增强`
- 版本号更新规则 → `conventions.md#2026-06-25-重要变更必须更新插件版本号`
- 外部实现纪律吸收 → `decisions.md#2026-06-25-吸收外部-skills-中强化-agent-写代码的实现纪律`, `conventions.md#2026-06-25-skill-实现纪律吸收边界`
- Fork 定制方向 → `decisions.md#2026-05-21-个人-fork-不面向上游贡献`
- 安装链路收敛 / CC 插件改名 → `decisions.md#2026-06-10-收敛安装链路并将-claude-code-插件改名为-k-superpowers`
- Codex app 本地市场安装 → `decisions.md#2026-05-22-codex-app-使用仓库级本地-marketplace-安装-k-superpowers`
- OpenCode 安装方式 → `decisions.md#2026-05-21-opencode-使用-k-superpowers-git-安装`
- 生态集成范围 → `conventions.md#2026-06-10-三条安装链路并列维护cc-插件命名-k-superpowers`
- Codex app marketplace 目录规则 → `conventions.md#2026-05-22-codex-app-本地-marketplace-使用仓库根目录`
- 预热型请求处理 → `conventions.md#2026-05-21-预热型请求不触发-brainstorming`
- 验证哲学 → `decisions.md#2026-05-26-将-test-driven-development-改名为-type-driven-verification`
- PR/上游贡献规则 → `gotchas.md#2026-05-21-上游-pr-门槛很高`
- Skill 修改纪律 → `conventions.md#2026-05-21-skill-正文变更必须先评估`
- 项目定位 → `requirements.md#2026-05-21-个人-fork-用于后续微调-superpowers-skills`

## 标签索引

- `#skills` → `requirements.md`, `conventions.md`, `glossary.md`
- `#fork` → `requirements.md`, `decisions.md`
- `#personalization` → `decisions.md`, `conventions.md`
- `#codex` → `decisions.md`, `conventions.md`
- `#claude-code` → `decisions.md`, `conventions.md`
- `#opencode` → `decisions.md`, `conventions.md`
- `#install` → `decisions.md`, `conventions.md`
- `#brainstorming` → `conventions.md`
- `#verification` → `decisions.md`, `conventions.md`
- `#type-driven` → `decisions.md`, `conventions.md`
- `#upstream-pr` → `gotchas.md`
- `#memory` → `decisions.md`, `conventions.md`
- `#eval` → `decisions.md`, `conventions.md`, `gotchas.md`
- `#version` → `conventions.md`
- `#comments` → `requirements.md`, `conventions.md`
- `#sdd` → `decisions.md`, `gotchas.md`
- `#routing` → `requirements.md`, `decisions.md`, `conventions.md`
- `#prompt` → `decisions.md`, `conventions.md`, `gotchas.md`
- `#iteration` → `requirements.md`, `decisions.md`, `conventions.md`

## 最近热点

- 2026-07-21 Skills 不维护持久测试并停止默认模型验证 → `requirements.md`, `decisions.md`, `conventions.md`, `gotchas.md`
- 2026-07-21 以最小 Skill 路由落地 GPT-5.6 Prompt 优化 → `requirements.md`, `decisions.md`, `conventions.md`
- 2026-07-21 Live reviewer 单次零读取不等于 Prompt 结构缺陷 → `gotchas.md`
- 2026-07-21 Role Prompt 保真不能只查关键字或无边界占位符 → `gotchas.md`
- 2026-07-15 核心代码说明由 type-driven-verification 单一拥有 → `conventions.md`
- 2026-07-14 研发流程 Skills 瘦身并保留语言自适应 Rust 工程哲学 → `decisions.md`, `conventions.md`
- 2026-07-10 主开发流程增加自动 Compact/Full 分流与统一 Handoff → `decisions.md`
- 2026-07-10 SDD 改为风险自适应执行并合并 Task Reviewer → `decisions.md`
- 2026-07-08 Skill 验证命令与代码注释 source-of-truth → `conventions.md`
- 2026-07-08 吸收上游 SDD reviewer 与 controller 纪律 → `decisions.md`
- 2026-07-08 强化 SDD task brief 全局约束与复审路由 → `decisions.md`
- 2026-07-07 更新 Skill 写代码时的注释原则 → `conventions.md`
- 2026-06-26 跟进上游 v6 SDD 文件交接与进度账本 → `decisions.md`
- 2026-06-26 跟进上游 v6 writing-plans 结构增强 → `decisions.md`
- 2026-06-25 重要变更必须更新插件版本号 → `conventions.md`
- 2026-06-25 吸收外部 skills 中强化 agent 写代码的实现纪律 → `decisions.md`
- 2026-06-25 Skill 实现纪律吸收边界 → `conventions.md`
- 2026-06-10 收敛安装链路并将 Claude Code 插件改名为 k-superpowers → `decisions.md`
- 2026-06-10 三条安装链路并列维护,CC 插件命名 k-superpowers → `conventions.md`
- 2026-06-03 清除 skills 内全部 TDD/RED-GREEN 残留字眼 → `decisions.md`
- 2026-05-26 将 test-driven-development 改名为 type-driven-verification → `decisions.md`
- 2026-05-25 Skill 正文变更改为类型优先、风险驱动验证 → `conventions.md`
- 2026-05-22 Codex app 使用仓库级本地 marketplace 安装 k-superpowers → `decisions.md`
- 2026-05-22 Codex app 本地 marketplace 使用仓库根目录 → `conventions.md`
- 2026-05-21 从强制 TDD 改为类型优先验证 → `decisions.md`
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

# Writing Skills Mode Selection Design

## 背景

`writing-skills` 是通用 skill authoring / editing / verification 手册。它需要保持跨项目通用，不能内置本 fork 的版本号、项目记忆、提交策略或中文总览等项目规则。

当前文档对创建新 skill 的路径描述充分，但对“修改已有 skill”和“只审查/验证 skill”的分流不够明确。实际使用中，agent 可能把已有 skill 优化误读成新建 skill authoring 流程，或者把 synthetic pressure scenario 当成所有高风险修改的唯一 baseline 来源。

## 目标

- 保持 `writing-skills` 的通用定位。
- 增加通用 mode selection：create / edit / verify / review-only。
- 把编辑已有 skill 作为一等通用场景：先理解现有行为，再评估不变量、触发条件、失败模式和验证强度。
- 明确真实用户反馈、生产事故、agent transcript 或 review finding 可以作为 baseline evidence；没有观察证据时，高风险变更仍需要 synthetic pressure scenario。
- 修复 `@graphviz-conventions.dot` 与“不要用 @ force-load”规则冲突。
- 把 deployment 改成遵守当前项目/用户/平台规则，不默认 commit、push 或 PR。

## 非目标

- 不把本 fork 的 `docs/skills-overview.zh.md`、版本号 bump、`.ai/memory/` 规则写进 `writing-skills`。
- 不删除通用 authoring、CSO、frontmatter、目录结构和示例质量指南。
- 不改变 skill description 的触发条件。

## 验证

风险等级：高。变更影响 `writing-skills` 自身的流程分流和 baseline 语义。

Baseline evidence：本次真实反馈指出两个失败模式：

1. 不能把通用 `writing-skills` 项目化。
2. 通用 authoring 定位没问题，但需要更清楚支持优化已有 skill。

验证方式：

- 搜索项目化措辞，确认 skill 正文没有内置本 fork 的 docs、version、memory、commit policy。
- 搜索 `@graphviz`，确认不再使用 `@` force-load 引用。
- 反例推演：
  - 修改已有 workflow skill 时，agent 应先走 edit existing mode，而不是创建新 skill。
  - 新建 skill 时，agent 仍能走 create mode，保留现有 authoring 指南。
  - 高风险变更已有真实事故时，agent 可使用 observed evidence；没有真实 evidence 时仍要做 synthetic pressure scenario。
  - deployment 遵守当前环境规则，不默认 commit/push/PR。

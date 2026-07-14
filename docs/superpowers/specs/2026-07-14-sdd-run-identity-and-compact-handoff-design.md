# SDD 进度头与 Compact Handoff 设计

**Flow:** Compact

## 目标

正式规定实际 SDD 执行中已经使用的 `Run` 进度头，使 Agent 在恢复任务前能够识别
其他开发流程残留，避免错误跳过当前任务；同时消除 Compact plan 到 Unified
Execution Handoff 的状态转换歧义。

## 范围

本次只包含两项行为变更：

1. SDD 使用已有的 `Run` 头判断 `progress.md` 是否属于当前 plan。
2. 忠实的 Compact plan 自审后直接进入 Handoff；Full plan 仍需用户明确批准。

不修改 `sdd-workspace`、`sdd-cleanup`、任务进度格式或 review package。不增加 hash、
branch/worktree identity、commit ancestry、严格 parser、Status 生命周期或恢复状态机。

## 已观察到的现状

真实 SDD 工作区已经生成过以下内容：

```text
Run 2026-07-14 llm-terminal-semantics
...
Phase2 Task 1: complete (...)
```

`Run` 已经提供了人类和 Agent 可读的流程身份。但当前 skill 只规定任务完成行，
没有要求恢复前读取并比较 `Run`，因此实际行为依赖 Agent 临场发挥。

## SDD Progress Header

### 格式

`progress.md` 开头记录：

```text
Run YYYY-MM-DD <run-topic>
```

`run-topic` 应来自当前 plan 的标题、文件名或明确目标，并具有足够区分度，例如
`llm-terminal-semantics`。不能使用 `task`、`implementation` 等宽泛名称。

其他头部信息由模型按上下文自由记录，不纳入本次协议，也不增加格式或状态规则。

任务完成行保持现有 skill 规定的格式和语义，本次不扩展任务标签或解析规则。

### 创建与恢复

运行 `sdd-workspace` 得到目录后，并在创建 todos、读取完成任务或跳过任务之前：

- `progress.md` 不存在：Controller 写入具体的 `Run` 主题，然后开始任务。
- `Run` 主题与当前 plan 明确匹配：可以读取账本并恢复已完成任务。
- `Run` 主题明确属于其他流程：停止启动，向用户展示现有头部和当前 plan，请用户
  决定恢复旧流程、保留或清理产物。
- 缺少 `Run`、主题过于宽泛或上下文不足以判断：按无法确认处理，停止并请求用户
  决定，不能猜测为当前流程。

不匹配或无法确认时，不覆盖 `progress.md`，不运行 cleanup，也不根据任务编号、
日期相同或目录位置相同绕过判断。

成功完成后仍按现有流程运行 `sdd-cleanup`。本次不修改 helper 接口或 cleanup 行为。

## SDD 启动顺序

```text
建立 worktree
  -> 读取 plan 及其 Global Constraints
  -> 运行 sdd-workspace
  -> 创建或判断 Run 进度头
  -> 仅在明确匹配后读取完成任务并创建 todos
  -> pre-flight review
  -> 执行剩余任务
```

`progress.md` 仍然是上下文压缩后的恢复依据，但只有 `Run` 与当前 plan 明确匹配时，
任务完成记录才可用于跳过任务。

## Compact Handoff

状态转换明确为：

```text
Compact: 已批准设计 -> 忠实 spec -> 忠实且通过自审的 plan
         -> Unified Execution Handoff

Full: 已批准设计/spec -> 详细 plan -> 用户明确批准 plan
      -> Unified Execution Handoff
```

`writing-plans` 中 Handoff 的引导语改为：

> 在忠实的 Compact plan 通过自审后，或用户明确批准 Full plan 后，仅提供以下选项：

这不改变授权边界：选择 Handoff 选项前不授权实现；Compact plan 出现实质差异时
仍需返回用户审批；Full 保留独立的 plan approval 和文档 commit 选项。

## 涉及文件

- `skills/subagent-driven-development/SKILL.md`：增加 `Run` 头和恢复前判断规则，调整
  startup 顺序。
- `skills/writing-plans/SKILL.md`：修正 Compact/Full Handoff 引导语。
- `tests/claude-code/`：更新已有 SDD 和 Compact 行为检查，不新增 helper 测试。
- `docs/skills-overview.zh.md`：同步两项流程变化。
- 插件/package manifests 和 README 版本示例：同步 bump patch version。

根据仓库记忆策略，未获得单独确认前不修改项目记忆。

## 验证

使用三个 SDD 代表性场景：

1. 没有 `progress.md` 时，在任务路由前写入具体 `Run` 主题。
2. `Run` 与当前 plan 明确匹配时恢复任务。
3. `Run` 不匹配或无法判断时停止并请求用户决定，不使用已有完成记录。

Compact 检查只验证：忠实 plan 无需第二次批准即可进入 Handoff；Full 仍需明确
批准；Handoff 选择仍是实现和 checkpoint commit 的授权边界。

运行现有确定性 helper suite、相关静态/行为检查、shell 语法、版本一致性、陈旧
引用和 whitespace 检查。Claude integration 不可用时报告 skipped，不能报告 passed。

## 成功标准

- SDD 在判断 `Run` 前不会使用完成记录跳过当前 plan 的任务。
- 其他流程或无法确认的残留会被保留，并交给用户决定。
- 同一运行可以继续使用现有进度。
- 不增加新的 helper、状态机、身份校验或任务格式。
- Compact 不增加重复审批，Full 和全部 Git 授权边界保持不变。

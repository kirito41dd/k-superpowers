# K Superpowers Skills 总览

本文用于维护个人 fork；执行时以各 skill 正文为准。

## 代码产出哲学

Rust 哲学只约束 agent 如何分析领域、设计接口、实现错误/资源边界和选择验证，
不要求 workflow 模仿 Rust。优先使用目标语言可用的类型与窄 API 排除非法状态，
在不可信边界做运行时校验，只为静态系统无法证明的核心语义保留少量测试。
核心结构、函数和抽象在并非自解释时补充必要说明，并避免复述代码的噪音注释。

- Rust：enum/newtype、受控构造、ownership/lifetime、穷尽匹配。
- TypeScript：discriminated union；JSON/API 必须 runtime schema 校验。
- Go：明确 struct/constructor、小 interface、显式 `error`。
- 动态语言：边界 validator、明确数据模型、窄 API 和更多聚焦运行时检查。

`Implementation Design Contract` 在 plan、task brief、implementer report 和 review
间传播领域不变量、非法状态、输入边界、错误/资源模型、剩余 runtime risk 与验证。

## 主流程

```text
using-superpowers
  -> brainstorming (Compact | Full)
  -> writing-plans
  -> Unified Execution Handoff
  -> subagent-driven-development | executing-plans
  -> verification-before-completion
  -> finishing-a-development-branch (仅真实集成/cleanup 决策)
```

- `using-superpowers`：区分 preparation-only、bug 与 change；bug 先 debugging，根因
  明确后仍经过设计批准。
- `brainstorming`：Compact 处理清晰单域需求；Full 处理不确定、不可逆、安全、协议
  或重大兼容性决策。设计批准前禁止实现。
- `writing-plans`：定义 risk、interfaces、实现合同和验证；统一选择 execution、
  workspace 与 checkpoint commit 授权。
- `using-git-worktrees`：cleanup ownership 只能是 manual marker、native handle 或
  unowned，不能按目录名猜测。
- `executing-plans`：Inline 不重新推销 SDD；未提交 review 使用 working-tree package。
- `finishing-a-development-branch`：保留 `git pull`；按 MERGE/PR/KEEP/DISCARD 语义
  action 执行，cleanup 必须证明 ownership。

## SDD 特色

`subagent-driven-development` 保留风险自适应路由：low 由 controller 执行，
medium/high 使用 implementer + 一个 fresh merged reviewer；high/cross-task 追加
final whole-change review。

Task brief、implementer report、review package、progress ledger 继续存放在
`.superpowers/sdd/` 并通过路径交接。Merged reviewer 一次读取 artifact/diff，先
Spec 后 Standards，输出两个独立阻断 verdict；修复后 fresh reviewer 完整复审
两个轴。Progress ledger 用 `Run` topic 标识来源，恢复前必须明确匹配当前 plan；
`task-snapshot` 确定性保护 pre-existing dirty changes 和 commit scope。

## Review 与质量

- `requesting-code-review`：拥有 committed/working-tree source、live/package
  snapshot 和公共 Spec/Standards verdict contract，不为 review 强迫 commit。
- `receiving-code-review`：按 independent、dependent/conflicting、shared-root-cause
  分组；不清楚项只阻断相关工作。
- `systematic-debugging`：先建立会失败/通过的 symptom loop，再提出假设和修复；
  三次失败后停止并检查架构。
- `type-driven-verification`：类型/API 优先，测试只保护剩余 runtime risk。
- `verification-before-completion`：fresh evidence 支持精确 claim；完整运行已选命令
  不等于自动扩大 workspace/matrix。

## 元流程

- `dispatching-parallel-agents`：仅并行无共享状态和顺序依赖的问题域。
- `writing-skills`：先记录 semantic checksum，按行为风险选择静态、反例或行为
  场景验证；一个 coherent campaign 完成后再进入下一个。

所有 description 只描述触发条件，不摘要 workflow。Git commit、push、merge、
PR、amend、force 始终按各自显式授权执行。

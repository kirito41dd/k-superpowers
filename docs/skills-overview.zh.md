# K Superpowers Skills 总览

本文用于维护个人 fork；执行时以各 skill 正文为准。

## 总体哲学

Skills 面向能够理解上下文、权衡风险并持续进化的智能 agent。规则固定目标、owner、
授权、安全边界、material decision 和完成证据，不把自然语言 agent 模拟成解析器或死板
状态机。除真实外部协议外，不冻结 prompt 字节、tool-call 顺序、输出行数或局部实现路径。

交付速度、用户等待时间和模型调用成本是一等产品指标。默认选择可逆、低权限、低
ceremony 的路径；plan、worktree、delegation、review 和更宽验证只有在能降低实际风险
或总延迟时才加入。

## 代码产出哲学

Rust-inspired 哲学只约束 agent 如何设计代码，不要求 workflow 模仿 Rust。优先使用
目标语言的类型、窄 API、可见性和资源模型排除非法状态，并在不可信边界做运行时校验。
测试只保护静态系统无法证明的核心语义与高价值回归。

`type-driven-verification` 提供按需思考问题：领域不变量、非法状态、输入边界、错误/
资源 ownership、剩余 runtime risk 和相称证据。这不是必填表单。非自解释的核心结构、
函数和抽象继续说明 purpose、caller use、不变量、生命周期/资源和协议/状态转换；注释
语言与风格服从项目及邻近文件。核心测试优先通过行为化命名、清晰结构和领域化 fixture
表达所保护的语义契约；只有回归背景、不明显不变量、特殊输入/顺序或关键断言后果无法
自解释时，才补充邻近注释或 assertion message，不要求测试注释覆盖率。

## 主流程

```text
ordinary question -> direct answer (no task skill)
preparation/read-only -> requested non-mutating work -> stop
bug/unexpected behavior -> systematic-debugging

clear approved bounded change
  -> Direct
  -> current workspace + Inline + no commit
  -> focused verification

multi-step change needing durable execution handoff
  -> writing-plans
  -> independent tasks + concrete delegation benefit
       -> ask SDD checkpoint authorization
       -> SDD when selected and authorized
     otherwise
       -> Inline

tightly coupled multi-step change
  -> concise design or internal todo when useful
  -> executing-plans

Direct/Inline code edit
  -> load type-driven-verification for consequential behavior or
     non-self-explanatory core structures/functions/abstractions
  -> controller Spec/Standards self-review
  -> independent two-axis review for nontrivial behavior or bug fixes
```

- `using-superpowers` 只选择当前最小 owner；未来可能相关不是 trigger。
- `brainstorming` 按 Direct/Compact/Full 调整设计深度。只有真实取舍才展示多个方案；
  Full 保护不可逆、安全、协议、迁移和重大兼容性决定，不做逐章节 ceremony。设计批准
  后只在已有明确实现请求时继续，并在编辑前评估一次执行拓扑。
- `writing-plans` 只在跨会话、delegation 或复杂执行需要稳定交接时写持久 plan。安全
  默认无需五选一 handoff；对真正独立且委派收益明确的任务，主动给出 SDD checkpoint
  授权与 Inline no-commit 的简洁选择。
- `executing-plans` 由一个 agent 连续执行批准范围，适应证据和依赖调整局部顺序；
  所有改动做 controller 双轴自审；除纯文档/注释/格式、机械 rename/config 和简单
  自解释 glue 外，非平凡行为与 bug fix 默认独立双轴 review。

## SDD

SDD 只用于真正独立、当前会话可委派且收益明确的任务，并继续要求用户显式授权本计划
local checkpoint commits。该授权不覆盖 push、merge、PR、amend、force、无关工作或
单独 spec/plan commit。

风险与执行按实际效果判断：

- low：controller 直接实现、验证和自审；
- medium：implementer 执行，controller 双轴自审，再由 independent reviewer 审查；
- high：implementer + independent reviewer；
- final review：仅真实跨任务共享接口、共享状态或未验证组合风险。

单个 high task 已完成 task review 后不重复 whole-change review。Task snapshot 和
checkpoint ownership 继续保护用户已有修改与提交边界。Delegated prompts 传播 goal、
inputs、权限、material blockers、质量/验证期望和结果信息，但 controller 可根据平台和
任务调整措辞、读取顺序与工具使用。

## Review

`requesting-code-review` 使用有界生命周期：

```text
Discovery -> frozen finding ledger -> one fix batch -> Closure
          -> PASS | PASS_WITH_FOLLOWUPS | STOPPED_BLOCKED
```

所有改动由 controller 按 Spec / Standards 做一次自审。只有能明确证明属于纯文档/
注释/格式、机械 rename/config 或简单自解释 glue 时才跳过独立 reviewer；非平凡运行时
行为、bug fix、核心逻辑、公共 API、parser、安全权限、持久化/迁移、破坏性 cleanup、
并发、协议/状态机、资源与跨模块行为、证据不足，或用户/批准 plan 明确要求时默认独立
reviewer。分类不确定时选择 review；设计已经明确不等于实现可以免审。

Stable ID、severity、Spec/Standards、issue、impact 和 required fix 保留；不要求精确
行数、首字符或纯文本编码。Minor 与无因果关系的新观察进入 follow-up。Closure 优先
由同一逻辑 reviewer 完成，失败后交还用户，不自动继续 review/fix。

冻结的是 change goal、修改 scope 和 evidence snapshot，不是 reviewer 的只读能力。
Reviewer 可为具体问题读取调用方、邻近实现、项目规范和直接依赖，但不得修改工作区、
扩大 change request 或把无关观察升级为 blocker。Package 只用于跨 context 或需要冻结
snapshot 的场景；scope 使用显式 paths 与 source/base/head，不使用 scope hash。

## Debugging 与 Completion

- `systematic-debugging` 优先建立最小 feedback loop；无法本地复现时，可从 logs、traces、
  dumps 和环境差异提出带置信度的诊断。没有验证不能声称 fixed。连续尝试不再产生信息、
  scope 扩大或证据指向架构决定时停止，不使用固定失败次数。
- `verification-before-completion` 让 claim 与 evidence 对齐。证据可以是命令、编译器/
  类型保证、行为检查、diff inspection、review record 或可靠 artifact；未变化的代码不因
  bookkeeping 或 delegation 机械重跑相同验证。

## 并行与 Skill 迭代

- `dispatching-parallel-agents` 允许共享只读文件和上下文；只禁止冲突写入、顺序依赖、
  一个任务使另一个失效或整合成本高于收益的并行。它负责调查、分析、诊断等通用
  workstream；已有批准 plan、持久 handoff 和 checkpoint ownership 的并行代码实现由
  SDD 负责。
- `writing-skills` 小改动只明确目标和可能回归的不变量；完整合同只用于 routing、权限、
  delegation、review 等高影响行为，并且只记录适用项。
- Skill 修改以真实使用反馈驱动，一次 coherent edit、一次 self-review。仓库不维护持久
  skill tests/evals，也不默认调用模型验证；新非阻断建议进入下一轮。

## 保留的硬边界

- commit、push、merge、PR、amend、force 和外部写需要明确授权；
- destructive discard 需要确认；
- 不覆盖、吸收或清理用户已有修改；
- worktree cleanup 必须证明 ownership；
- material architecture/scope/dependency/public contract/compatibility 交给用户；
- completion claim 必须有相称证据；
- 核心注释、类型/API 优先和有界 review closure 保持。

`finishing-a-development-branch` 仅处理真实 merge/PR/MR/retain/discard/cleanup
决策；创建 review request 时按仓库 provider 路由：简单 GitLab MR 优先使用
push options，GitHub 使用 `gh`，复杂 GitLab 操作使用 `glab` 或 API，浏览器兜底。
base 在开发期间前进时，默认将 feature rebase 到最新 base，再 fast-forward
合入；已发布分支的 force-push 仍需单独授权。
`using-git-worktrees` 继续单一拥有 workspace placement 与 cleanup ownership。

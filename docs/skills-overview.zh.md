# K Superpowers Skills 总览

本文用于维护个人 fork；执行时以各 skill 正文为准。

## 代码产出哲学

Rust 哲学只约束 agent 如何分析领域、设计接口、实现错误/资源边界和选择验证，
不要求 workflow 模仿 Rust。优先使用目标语言可用的类型与窄 API 排除非法状态，
在不可信边界做运行时校验，只为静态系统无法证明的核心语义保留少量测试。
`type-driven-verification` 单一拥有核心代码说明规则：核心结构、函数和抽象在并非
自解释时补充必要说明，注释语言跟随项目与邻近文件，并避免复述代码的噪音注释。

- Rust：enum/newtype、受控构造、ownership/lifetime、穷尽匹配。
- TypeScript：discriminated union；JSON/API 必须 runtime schema 校验。
- Go：明确 struct/constructor、小 interface、显式 `error`。
- 动态语言：边界 validator、明确数据模型、窄 API 和更多聚焦运行时检查。

`Implementation Design Contract` 在 plan、task brief、implementer report 和 review
间传播领域不变量、非法状态、输入边界、错误/资源模型、剩余 runtime risk 与验证。

## 主流程

```text
using-superpowers
  |-- ordinary question -> direct answer (`no task skill`)
  |-- preparation/read-only -> requested read/search work -> stop
  |-- explicit skill/current owner -> selected owner
  |-- bug/failure -> systematic-debugging
  |       |-- diagnosis only -> report -> stop
  |       `-- behavior change required -> brainstorming (Compact | Full)
  |-- approved spec -> writing-plans
  `-- behavior change -> brainstorming (Compact | Full)

approved design -> writing-plans -> Unified Execution Handoff
  -> subagent-driven-development | executing-plans
  -> verification-before-completion
  -> finishing-a-development-branch (仅真实集成/cleanup 决策)
```

- `using-superpowers`：普通问答能由当前知识直接回答时不加载任务 skill，也不增加
  workflow ceremony；`no task skill` 不排斥平台预注入的入口 router。其余请求区分
  preparation-only、read-only、bug 与 change；bug 先 debugging，纯诊断在报告根因后
  停止，只有需要行为修改时才进入设计批准。
- `brainstorming`：Compact 处理清晰单域需求；Full 处理不确定、不可逆、安全、协议
  或重大兼容性决策。设计批准前禁止实现。
- `writing-plans`：定义 risk、interfaces、实现合同和验证；统一选择 execution、
  workspace 与 checkpoint commit 授权。
- `using-git-worktrees`：cleanup ownership 只能是 manual marker、native handle 或
  unowned，不能按目录名猜测。
- `executing-plans`：Inline 不重新推销 SDD；未提交 review 使用 working-tree package。
- `finishing-a-development-branch`：保留 `git pull`；按 MERGE/PR/KEEP/DISCARD 语义
  action 执行，cleanup 必须证明 ownership。

路由只加载当前阶段的最小充分集合：一个当前 process owner，加上当前动作确实需要的
domain owner。未来可能相关不是触发条件，后续阶段和 SDD/Inline 这类互斥路径不会
预加载。Frontmatter description 仍只描述触发条件；本轮只调整已有场景证明存在
误触发或漏触发的项，不做无证据的全量改写。

## SDD 特色

`subagent-driven-development` 保留风险自适应路由：low 由 controller 执行，
medium/high 使用 implementer + 一个 fresh merged reviewer；high 或真实的 cross-task
共享接口、共享状态、未验证组合风险追加 final whole-change review。`writing-plans`
拥有初始 risk 与 Unified Handoff；SDD
只消费这些决定，runtime evidence 只能升级 risk，不能静默降级或重新定义分级。

Unified Handoff 明确拒绝 checkpoint commits 时，SDD 在 dispatch 前显式转入
`executing-plans`；授权缺失或含糊时阻断，不能模拟 commitless SDD。SDD 被选定后，
plan 必须已批准、任务可独立委派、当前会话支持 multi-agent，且 handoff 必须明确授权
本计划的 local checkpoints；这些已选路径的前置条件若缺失或冲突，SDD 即阻断。平台
不支持 multi-agent 时也阻断，不伪造委派或静默 fallback。Checkpoint 授权只覆盖已批准的实现
任务及 review fixes，包括计划内 docs/comments task；不覆盖独立 spec/plan 文档、无关
提交、push、merge、PR、amend 或 force 操作。

Task brief、implementer report、review package、progress ledger 继续存放在
`.superpowers/sdd/` 并通过路径交接。Merged reviewer 一次读取 artifact/diff，先
Spec 后 Standards，输出两个独立阻断 verdict；修复后 fresh reviewer 完整复审
两个轴。Progress ledger 用 `Run` topic 标识来源，恢复前必须明确匹配当前 plan；
`task-snapshot` 确定性保护 pre-existing dirty changes 和 commit scope。
`requesting-code-review` 拥有 package、source/base/head/scope binding、finding 与
verdict 形状，`verification-before-completion` 拥有最终完成证据；SDD controller
只维护运行时状态与失败转移。

## Review 与质量

- `requesting-code-review`：拥有 committed/working-tree source、live/package
  snapshot 和公共 Spec/Standards verdict contract，不为 review 强迫 commit。
- `receiving-code-review`：按 independent、dependent/conflicting、shared-root-cause
  分组；不清楚项只阻断相关工作。
- `systematic-debugging`：先建立会失败/通过的 symptom loop，再提出假设和修复；
  三次失败后停止并检查架构。
- `type-driven-verification`：类型/API 优先，测试只保护剩余 runtime risk，并拥有
  非自解释核心代码的 purpose、caller usage、不变量、生命周期/资源、协议/状态转换
  与项目/邻近文件注释语言合同。`writing-plans` 按引用传播；Inline 在适用时于首次
  代码编辑前消费；SDD low task 由 controller 带入 brief，若发现 runtime/domain
  behavior 则停止直接编辑并先加载 owner。Fresh implementer/reviewer prompt 保持
  自包含，不依赖继承的会话上下文。
- `verification-before-completion`：fresh evidence 支持精确 claim；完整运行已选命令
  不等于自动扩大 workspace/matrix。

## 元流程

- `dispatching-parallel-agents`：仅并行无共享状态和顺序依赖的问题域。
- `writing-skills`：以真实使用中的 failure、friction 或明确需求作为输入，做一个最小
  coherent change 后尽快返回实际使用。不创建持久化测试、fixture、snapshot、eval
  matrix、ablation record 或模型 golden output；除非用户明确要求并接受成本，否则不
  调用模型验证。单次随机输出只作 observation，review 发现的非阻断改进进入后续迭代。

所有 description 只描述触发条件，不摘要 workflow。Git commit、push、merge、PR、
amend、force 始终按各自显式授权执行；验证或 review 本身不扩大授权。

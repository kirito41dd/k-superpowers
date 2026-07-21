# GPT-5.6 Skill Prompt 第二轮优化设计

## Flow

Full

## 状态

Approved on 2026-07-17; no standalone documentation commit; include with the
completed implementation change

## 目标

结合 OpenAI 的 GPT-5.6 prompting guidance，对现有研发流程 skills 做第二轮
行为保持型优化：减少不必要的 skill 加载、重复指令、重复审批和长上下文负担，
同时完整保留当前 Compact/Full、SDD/Inline、Git 授权、风险自适应 review、
类型优先验证和核心代码解释性注释等产品行为。

本设计不以迁移到 GPT-5.6 为前提。最终 skills 继续服务 Codex、Claude Code 和
OpenCode，不依赖 GPT-5.6 专属模型、API 参数或工具能力。

## 背景

OpenAI 的 GPT-5.6 指南给出四项与本项目直接相关的建议：

- 从已工作的 prompt 出发，一次删除一组指令、示例或工具，再重跑相同 eval；
- 每条指令只陈述一次，只保留编码产品要求或修复已测量缺口的示例；
- 把自治和审批边界集中定义，避免重复的 `ask first` 或 `do not mutate` 导致
  不必要的停顿；
- 新模型能从上下文推断更多意图，应优先给出目标、硬约束、授权边界、成功标准，
  并明确只有哪些重要歧义需要询问，而不是规定所有局部步骤。

参考：

- <https://developers.openai.com/api/docs/guides/latest-model?model=gpt-5.6#prompting-best-practices>
- <https://learn.chatgpt.com/docs/build-skills>

本 fork 在 2026-07-14 已把 14 个主 `SKILL.md` 从约 19,771 词压缩到当前约
6,051 词，并建立风险、review、completion、worktree 等 owner。这次不重复
第一次瘦身，而是解决剩余问题：

- `using-superpowers` 的 `every skill with a plausible fit` 仍可能加载多个相邻
  skill；
- 日常问答缺少明确的 `no task skill` 终态；
- 部分关键排除条件只存在于正文，隐式匹配在读取正文前无法使用；
- SDD 主文件约 2,079 词，仍重复风险定义、review schema、完成证据和授权说明；
- implementer prompt 多次表达“有疑问就停”，可能把局部实现判断升级为不必要询问；
- 当前 skill 验证按风险选择强度，但尚未正式定义 prompt ablation 的同场景
  before/after 比较方法。

## 方案选择

### A. Owner 收敛与渐进式瘦身

在现有行为 owner 上继续收敛，逐组修改并复跑相同场景。主 skill 保留状态转换，
独立 subagent prompt 保持自包含。

### B. 全面重写为统一状态机

一次重写主要 workflow，把大部分说明下沉到 references 和 scripts。文本更短，
但触发、授权和恢复行为同时漂移的风险过高。

### C. GPT-5.6 专用 skill 路径

为 GPT-5.6 使用精简 prompt，其他模型保留旧路径。会形成双套契约，并使跨平台
插件行为难以验证。

**决策：采用 A。** 词数与 token 是观察指标，行为正确性是 gate。

## 设计原则

### 三层结构

1. **Discovery**：frontmatter `description` 只表达正向触发、关键排除条件和必要
   前置状态。
2. **Workflow**：主 `SKILL.md` 只保留 entry、独占不变量、状态转换、failure
   transition 和下一 owner。
3. **Execution**：references、subagent prompts 和 scripts 承载阶段细节、自包含
   上下文、机械校验与输出 schema。

### 最小充分 skill 集

Skill 是按需能力，不是每轮必须进入的 workflow。入口路由选择当前阶段完成任务
所需的最小充分集合：

- 一个当前流程 owner；
- 只有当前阶段确实需要的领域 owner；
- 不预加载后续阶段；
- 不同时加载互斥执行路径；
- 用户显式指定的 skill 始终加载；
- hard gate 命中时仍必须加载其 owner。

`using-superpowers` 可作为平台 bootstrap 被加载，但它必须允许立即返回
`no task skill`，且该终态不产生任务 skill 公告、流程 ceremony 或额外约束。
平台强制的 bootstrap disclosure 不由本 spec 覆盖。

### 必要重复不等于 owner 漂移

主 agent caller 只保留 trigger、input、result 和本地 failure transition。独立
subagent 不保证继承父级上下文，因此其 prompt 必须保留完成任务所需的授权、
输出 schema、验证和代码质量要求。不能为了减少词数，让 subagent 自行发现父级
owner 或依赖不可见上下文。

## 必须保持的产品行为

本次修改不得改变以下行为：

- preparation-only 请求不进入设计或实现流程；
- behavior change 在实现前必须经过 Compact 或 Full 设计批准；
- bug、失败和 unexpected behavior 先进入 systematic debugging；
- Compact/Full 分类、material delta 和 spec/plan/implementation 授权相互独立；
- Unified Execution Handoff 继续穷尽 SDD/Inline 与 workspace 选择；
- SDD 继续要求当前 plan 的 local checkpoint commit 授权；拒绝时转 Inline；
- low task 由 controller 直接处理，medium/high 使用 implementer 与一个 merged
  task reviewer；
- Spec 与 Standards verdict 独立阻断，修复后完整复审两个轴；
- 任一 high task，或跨 task 共享接口、共享状态、组合行为产生的 integration risk，
  继续要求 final whole-change review；
- task boundary、dirty overlap、progress run identity、恢复和 cleanup 语义不变；
- review package、worktree provenance 和现有脚本接口不变；
- completion claim 继续要求对应范围的新鲜证据；
- 未经明确授权不 commit、push、merge、建 PR、amend 或 force；
- Rust-inspired、语言自适应的 Implementation Design Contract 不变；
- 测试只保护静态保证无法证明的核心语义和高价值回归，不恢复 blanket TDD。

### 核心代码注释与文档说明

核心代码解释是显式不可回归契约：

- `type-driven-verification` 继续完整拥有核心结构、核心函数和核心抽象的说明原则；
- 非自解释的核心代码应说明 purpose、caller usage、重要 invariant、生命周期或
  资源规则、协议边界和状态转换；
- 注释形式与语言遵循项目指令和邻近文件，不受会话语言覆盖；
- 不添加只复述命名、赋值或明显控制流的噪音注释；
- `writing-plans` 继续要求计划识别需要解释的核心代码；
- implementer prompt 因上下文独立，保留自包含的注释要求；
- task reviewer 与 generic reviewer 继续检查注释质量；
- reviewer 不能按注释数量报 finding，必须指出未解释的具体核心契约及其影响。

这条传播链不得因普通 owner 去重而缩减：

```text
type-driven-verification
  -> writing-plans
  -> executing-plans / SDD low controller
  -> SDD implementer prompt
  -> task reviewer prompt
  -> generic reviewer prompt
```

传播规则：

- plan 含 Implementation Design Contract，或 implementation task 涉及非自解释的
  核心结构、函数或抽象时，Inline executor 与 SDD controller 在代码编辑前必须
  消费 `type-driven-verification`；
- SDD low task 原则上不包含 runtime/domain behavior；若执行中发现此类行为，应按
  现有规则升级并把 owner 契约传给 fresh implementer；
- 纯 docs/comments/mechanical low task 由 task brief 和 controller self-check 传播
  适用的注释要求，不机械加载不适用的领域合同；
- 独立 implementer/reviewer prompt 继续携带完整自包含规则。

## 触发与路由设计

### `no task skill` 终态

入口路由改为：

```text
日常问答 / 通用知识 / 简单解释
  -> no task skill
  -> 直接回答

只读项目分析 / review / 状态检查
  -> 仅在匹配的 skill 提供实质契约或能力时加载
  -> 检查材料并报告；不进入设计或实现

行为变更
  -> brainstorming
  -> writing-plans
  -> SDD | Inline

bug / 失败 / unexpected behavior
  -> systematic-debugging
  -> 根因明确后，只有需要行为修改才进入 brainstorming
```

“存在一个勉强相关的 skill”不足以触发。普通问答能由模型知识直接完成时，不加载
任务 skill。

Preparation-only 与只读项目分析场景只允许平台明确可识别的读取、搜索工具；
`Edit`、`Write`、`NotebookEdit` 等写工具以及无法安全判定为只读的 shell 调用均
fail closed，避免“没有进入 task skill”掩盖实际工作区变更。

### `using-superpowers`

将 `invoke every skill with a plausible fit` 替换为最小充分集合规则。保留：

- 指令优先级；
- preparation-only、bug、change 和 applicable domain/process skill 的 intent
  gate；
- process owner 优先；
- checklist 只追踪适用项；
- change work 进入 platform plan mode 前仍需设计批准。

新增：

- `no task skill` 是合法终态；
- 日常问答不发布任务 skill 使用公告；
- 不预加载后续阶段、相邻 skill 或互斥路径；
- skill 必须对当前任务提供实质契约或能力才算 relevant。

### Description 审计

审计全部 skill description，但只修改存在误触发、漏触发或关键边界后置风险的项。
Description：

- 继续以 `Use when` 开头；
- front-load 核心用例和触发词；
- 可包含关键 `not for` 排除条件；
- 只描述触发边界，不总结 workflow；
- 在被截短时仍尽可能保留核心正向条件。

重点检查：

- `brainstorming` 排除只读熟悉、分析和 review；
- `writing-plans` 要求 approved requirements/spec；
- `subagent-driven-development` 要求 approved plan、独立任务、当前 session 和
  checkpoint commit 授权；
- `executing-plans` 明确 Inline 或无 SDD checkpoint commit；
- `finishing-a-development-branch` 只在真实 integration/cleanup decision 存在时
  触发；
- `type-driven-verification` 不因 planning 引用其契约而误触发纯文档任务；
- 显式 skill 请求不受隐式排除条件影响。

## Owner 收敛

### 去重前的语义统一

当前文案存在三处轻微漂移。实现不得通过“保留任意一边”隐式改变行为，必须先按
以下决策统一：

1. **Risk 以 planning owner 为准。** `writing-plans` 的 `low | medium | high`
   定义是唯一初始分类；migration 属于 high。SDD 不重新分类，只验证 metadata、
   消费等级并根据运行时新证据升级。
2. **Final review 使用统一 cross-task 条件。** 任一 high task 必须 final review；
   多 task 共享接口、共享状态，或组合行为形成不能由单 task 独立证明的风险时也
   必须 final review。不能把条件缩成只有 mutable state，也不能把彼此无关的
   medium tasks 自动升级为 final review。
3. **`doc commits` 指额外 spec/plan 文档提交。** Unified Handoff 不授权单独提交
   spec 或 plan 文档；但已批准 implementation plan 内的 docs/comments task 仍可
   在 SDD checkpoint 授权范围内提交。相关文案改为
   `separate spec/plan document commits`，避免误解为禁止所有文档文件。

### 风险分类

- `writing-plans` 完整定义 `low | medium | high` 和初始分类；
- SDD 不再重复各等级的领域定义，只消费等级、执行对应路由和记录运行时升级；
- 缺失风险仍阻断，运行时风险只允许升级，不能静默降级。

### Implementation Design Contract

- `type-driven-verification` 继续拥有完整设计与验证原则；
- `writing-plans` 保留计划阶段所需字段与适用条件；
- task brief 原样传播；
- implementer report 与 reviewers 保留独立消费者所需的自包含字段和检查。

### Review 协议

- `requesting-code-review` 完整拥有 package、finding、severity、axis 和 verdict
  schema；
- SDD/Inline 只保留调用时机、scope、input mode 和失败后的状态转换；
- reviewer prompt 继续自包含完整输出 schema；
- SDD review dispatch 必须同时传递 source mode、完整 `BASE`/`HEAD` 和 expected
  scope SHA-256；reviewer 将 request 中四项 binding 与 package header 对照，不能只
  依赖 path 集合或 diff 内容推断 source/range/scope 一致；
- 不能把缺失、`FAIL` 或 `CANNOT_VERIFY` 当作通过。

### Completion evidence

- `verification-before-completion` 完整拥有 claim/evidence 规则；
- SDD 只保留角色特有责任：executor 验证 task checkpoint，controller 检查
  report/diff/ownership/verdict，并最终验证 whole change；
- completion owner 的 `ready for commit` 不能被解释为每个 SDD checkpoint commit
  前新增一次独立 review；SDD 现有 verify、checkpoint、package、review 顺序不变；
- bounded verification 继续以计划或项目已有的最小相关命令为准，不能因删掉重复
  说明而扩大到全 workspace、feature 或 platform matrix；
- 删除 SDD 中与 completion owner 同义的通用说服文本。

### Git 授权

- `writing-plans` 的 Unified Handoff 继续定义当前执行的授权；
- SDD 主文件只消费 handoff、处理缺失授权和拒绝路径；
- implementer prompt 继续自包含当前 subagent 的 checkpoint commit 权限与明确
  禁止项；
- 不依赖平台默认 policy 替代跨平台 skill 契约。

## SDD 主流程设计

### 主文件结构

`skills/subagent-driven-development/SKILL.md` 重组为：

1. Entry Preconditions
2. Startup
3. Runtime State
4. Risk Routing
5. Delegated Task Flow
6. Final Review Condition
7. Recovery And Completion
8. References

删除或下沉：

- `Core principle` 等宣传性说明；
- Invocation Budget 表，必要时移入 overview；
- 已由 `writing-plans` 定义的风险含义；
- 已由 `requesting-code-review` 定义的 schema；
- 已由 completion owner 定义的通用证据规则；
- 与正文完全同义的 Red Flags；
- 冗长 model-selection 教学，保留按任务风险和复杂度选择的一条规则；
- 已由 scripts 强制且无需模型判断的机械解释。

预期主文件从约 2,079 词降到约 1,000-1,300 词，但范围仅用于发现异常。若完整
行为契约需要更多文本，不得为达目标继续删除。

### Runtime states

```text
entry
  -> workspace_ready
  -> plan_validated
  -> task_active
     -> low_self_check
     -> delegated_checkpoint -> task_review
  -> task_complete
  -> final_review_required | final_review_not_required
  -> completion_verified
  -> cleanup
```

任何 ownership、授权、plan conflict、missing risk、open verdict 或 verification
failure 都暂停整个 SDD run，保留 artifacts，并在当前问题解决后从记录状态恢复。
不得跳过 blocked task 去派发后续任务，也不得静默 fallback。

### 必须保留的 SDD 行为

- workspace setup 与 baseline verification；
- plan 只读取一次，并提取 global constraints/interfaces；
- pre-flight 一次性报告真实冲突；
- 每 task 的 `TASK_BASE`、scope 和 pre-existing dirty ownership；
- low controller route、medium/high delegated route；
- 原始 task base 在 runtime escalation 后不重置；
- task brief readiness；
- checkpoint SHA/HEAD 与 task-boundary verification；
- batched fix 与 fresh complete two-axis re-review；
- final review 的 high/cross-task 条件；
- run identity、resume、preserve 和 cleanup。

## Subagent prompts

### Implementer prompt

重组为：

```text
Goal
Inputs
Authorized actions
Required behavior
Blocking conditions
Verification
Report schema
```

合并当前多处“遇到不确定就问”。只有以下情况返回 `NEEDS_CONTEXT`：

- acceptance criteria 缺失、冲突或无法从 brief 推导；
- 需要新增 architecture、scope、dependency、public contract 或风险决策；
- 权限不足；
- brief 与项目 source of truth 冲突。

需求明确但当前技术上无法完成时返回 `BLOCKED`。普通局部实现选择遵循计划、项目
模式和最窄 in-scope 假设继续，并在 report 中记录有实质影响的假设。

删除：

- “不会因升级而受罚”等人格或激励性文字；
- 多套同义的停止提醒；
- 重复的泛化质量形容词；
- 已由 report schema 明确覆盖的 self-review 问句。

保留：

- task brief 是需求 source of truth；
- task boundary 与 checkpoint commit 授权；
- focused iteration 与 final task verification；
- Implementation Design Contract；
- 完整核心代码注释要求；
- self-review 的 completeness、scope、设计合同、注释和证据检查；
- `DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED`；
- report 文件与简短返回消息的固定 schema；
- review fix 后重新验证和新 checkpoint，禁止 amend。

### Task reviewer prompt

继续保持独立、自包含，并保留：

- brief、report、review package 输入；
- Spec first、Standards second；
- 双轴独立 verdict；
- concrete finding 的 file/line、issue、impact、required fix；
- Implementation Design Contract 与注释检查；
- 不能只因“没有新增测试”报 finding；
- 只为具体未解疑点运行 focused command；
- task reviewer 继续把 verification 中相关 warning 或无法解释的 noise 作为 finding，
  不因 completion owner 使用更一般的 `relevant warnings` 表述而放宽；
- 不能修改 working tree 或重跑 Git diff。

将“不信任报告”“review scope”“verification evidence”“禁止 broad crawl”等重复说明
合并为一个 `Evidence Boundaries` 小节。

### 状态转换

```text
Implementer
  DONE               -> ownership check -> review
  DONE_WITH_CONCERNS -> controller triage -> review | supply context
  NEEDS_CONTEXT      -> supply context -> redispatch same task
  BLOCKED            -> stronger model | split task | escalate plan

Reviewer
  PASS / PASS        -> task complete
  any FAIL           -> one batched fix -> fresh full two-axis review
  no FAIL, any CANNOT_VERIFY
                      -> controller supplies evidence -> fresh full two-axis review
  missing/invalid verdict
                      -> reject review output -> fresh corrected review
```

一个结果同时包含 `FAIL` 与 `CANNOT_VERIFY` 时，修复 findings、补齐证据后再做一次
完整双轴 review。任何分支都不能只复审失败的单轴。

本次不改变 invocation 数量、review 层数或 commit 模型。

## `writing-skills` 的 Prompt Ablation 协议

`writing-skills` 增加专门的 prompt slimming verification：

1. 记录当前行为契约、目标文件 checksum/word count 和代表性 baseline；
2. 每个 campaign 只移除或改写一组相关指令；
3. 对同一组代表性任务运行 before/after；
4. 比较 task success、required evidence、错误询问、skill routing、turns 和 token；
5. 行为 gate 全部通过后才能接受 token/词数收益；
6. 若出现新 failure class，恢复最小必要规则或改写边界后复审；
7. fresh-agent 检查不可用时标记 skipped，不能记为 passed。

建议 campaign：

1. `using-superpowers` 最小路由与 description；
2. SDD owner 去重和主文件结构；
3. implementer/reviewer prompt；
4. writing-skills ablation 规则及文档同步。

不要求每个 campaign 对应 Git commit；未经授权不得创建 commit。

## 验证设计

### Static invariants

- 所有 frontmatter 有合法 `name` 和 `description`；
- description 以 `Use when` 开头且只描述触发边界；
- owner map 与 callers 不存在冲突定义；
- no-task-skill、hard gates、Git 授权、risk、review 和 completion 状态均有唯一
  可达或阻断结果；
- implementer/reviewer prompt 保留完整注释要求；
- manifests、README 和 overview 按版本约定同步；
- `git diff --check` 通过。

### Trigger scenarios

至少覆盖：

1. 日常知识问答：不加载任务 skill，不发布任务 skill 公告；
2. preparation-only：只读上下文后停止，不触发 brainstorming；
3. 只读项目分析：只加载有实质作用的领域 skill；
4. behavior change：进入 brainstorming；
5. failing test/bug：先 systematic debugging；
6. 已批准 spec：进入 writing-plans；
7. 用户显式点名 skill：即使隐式条件不匹配也能加载并处理；
8. 相邻 skill 都“可能相关”时：只加载当前阶段最小集合；
9. SDD 与 Inline 互斥：handoff 后只加载被选择路径。

Trigger harness 必须同时检查 required skill、forbidden skill、调用顺序和 task skill
总数，不能只让模型复述“我会使用哪个 skill”。显式 skill 请求若在加载 skill 前
已经执行受该 skill 约束的动作，应直接失败，不能只输出 warning。

日常问答的统一断言是 `additional task skill calls = 0`。平台预注入或强制披露的
bootstrap 不计入 task skill call，也不能被测试误判为业务 skill 触发。

### SDD behavior scenarios

保留并更新现有压力场景：

- low under deadline 仍由 controller 执行；
- medium 仍使用一个 merged reviewer；
- high under pressure 仍要求 final review；
- low 实现中发现 runtime behavior 后升级且保留原始 task base；
- checkpoint commit 被拒绝后转 Inline，不模拟 commitless SDD；
- 多 finding 由一个 fixer 批量修复并完整复审；
- missing/foreign/ambiguous progress run 被保留并询问；
- reviewer 缺失一个 verdict 或返回 `CANNOT_VERIFY` 时阻断。

### Subagent ambiguity scenarios

- 局部命名或项目已有模式可决定：implementer 继续，不返回 NEEDS_CONTEXT；
- acceptance criteria 冲突：返回 NEEDS_CONTEXT 并指出冲突文本；
- 要求新增 public contract：停止并升级；
- 技术上无法完成但需求清楚：返回 BLOCKED；
- reviewer finding 修复：新 commit、覆盖验证、完整双轴复审。

Implementer 与 task reviewer prompt 至少各有一组隔离行为场景，不能只依赖 SDD
integration 间接推断。现有测试或 fixture 中的 `Spec + Quality` 必须同步为当前契约
`Spec + Standards`；被用于自动验证的旧 plan fixture 必须补齐当前 risk 与 global
constraints 格式。

### 注释回归场景

- Rust、TypeScript、Go 或动态语言的核心状态/边界设计仍识别需要说明的核心代码；
- implementer 能区分必要解释和噪音注释；
- reviewer 对未解释的核心不变量给出具体 finding；
- reviewer 不按注释数量或“每个函数都要注释”机械报错；
- 注释语言遵循项目与邻近文件，不跟随会话语言强制切换。
- Inline executor 与 SDD low/controller 都能消费适用的注释契约；low task 一旦发现
  runtime/domain behavior 会升级，而不是以 low 路由绕过 owner。

### 指标

行为 gate：

- required scenario 100% 通过；
- 不新增越权动作、错误 skill route、错误完成声明或遗漏注释检查；
- 不增加无实质必要的 blocking question。

观察指标：

- 主 `SKILL.md` 与阶段 prompt 的 word/token count；
- 每个场景加载的 skill 数；
- turn 与 subagent invocation 数；
- before/after 总输入输出 token、延迟和成本（平台可提供时）。

观察指标改善不能抵消行为 gate 失败。GPT-5.6 官方数据只作方向参考，不作为本
项目验收阈值。

### Harness 与平台证据

- 顺序类断言必须使用平台 trace 的 decision turn；同一 assistant turn 内的多个
  tool calls 视为并发，不能用数组序号伪装为“先读后执行”；下一 assistant decision
  前必须已收到前一组 tool results；terminal result 必须唯一且为最后事件，tool use/result
  lifecycle 必须闭合；
- 明确禁止 preamble 的 reviewer/subagent fixed-schema 场景必须校验全部可见
  assistant text，而不只校验最后一条。需要先调用 task skill 的 controller 压力场景
  可显式允许 skill announcement，但 terminal schema 必须在全部 skill results 后独立返回；
- focused command 证据必须把 `tool_use_id` 与已完成的 `tool_result` 内容绑定，并由
  实际输出支持 finding，不能只证明命令字符串出现过；
- scenario contract 冻结所有会影响执行或判断的 prompts、briefs、reports、source、
  tests、scope/package 和 per-case fixture/target/checksum；
- Claude Code 继续使用现有 skill triggering、pressure 和 SDD integration harness；
- OpenCode 至少验证 bootstrap、显式 skill 和可运行的路由行为；不能把仅加载成功
  当作行为通过；
- Codex/GPT-5.6 没有现成 trigger harness 时，使用可用的 fresh-agent 场景并明确
  标记覆盖差距，不伪造等价证据；
- 新增 ablation runner 时必须兼容 macOS 环境，不能新增 GNU-only `timeout`、
  `readlink -f`、`realpath` 或单一 SHA 工具依赖；
- model/auth/provider/quota（包括 payment、rate-limit 与 provider 5xx）不可用时
  required evidence 必须标为 `SKIPPED` 并阻断
  campaign，不能记为 PASS，也不能误报为 harness 实现失败；
- 若暂时复用已有非 portable runner，必须把平台限制记录为 skipped/remaining
  risk，不在本次顺手重构无关测试基础设施。

## 跨平台约束

- `no task skill` 表示无需任务 skill；OpenCode 等平台仍可预注入
  `using-superpowers` bootstrap，不能断言入口文本完全未加载；
- 保留现有平台工具映射：Claude Code、Codex 与 OpenCode 使用各自原生的 skill、
  todo/plan 和 subagent 能力；
- subagent prompt 写成“不依赖继承的会话上下文”，不声称所有平台绝对不继承；
- 平台不支持当前会话 multi-agent 时，SDD 必须走现有不适用/阻断路径，不能假装
  已委派或静默改写 checkpoint/review 模型；
- 共享 skill 正文不加入 GPT-5.6 模型名、reasoning effort、pro mode、PTC 或
  prompt-cache 分支；
- shell helpers 继续遵循当前 macOS Bash、NUL-safe 和 SHA fallback 约束。

## 文件范围

预期修改：

- `skills/using-superpowers/SKILL.md`
- 存在触发问题的 `skills/*/SKILL.md` frontmatter description
- `skills/writing-skills/SKILL.md`
- `skills/writing-plans/SKILL.md`
- `skills/subagent-driven-development/SKILL.md`
- `skills/subagent-driven-development/implementer-prompt.md`
- `skills/subagent-driven-development/task-reviewer-prompt.md`
- 必要时仅做 owner/caller 对齐的 `skills/requesting-code-review/SKILL.md`
- 必要时仅做 caller 对齐的 `skills/verification-before-completion/SKILL.md`
- `tests/skill-triggering/`
- `tests/explicit-skill-requests/`
- `tests/claude-code/test-compact-development-flow.sh`
- `tests/claude-code/test-subagent-driven-development.sh`
- `tests/claude-code/test-subagent-driven-development-integration.sh`
- `tests/claude-code/test-type-driven-behavior.sh`
- 必要的 OpenCode behavior tests；不把纯 plugin-loading test 当作路由证据
- 相关 docs、README 和版本 manifests

实现计划必须列出每个实际修改文件；本列表不授权无条件修改全部文件。

## 范围外

- 改变 Compact/Full、SDD/Inline 或 review 架构；
- 改动 worktree provenance、review-package、task-snapshot 等脚本协议；
- 引入 Programmatic Tool Calling、GPT-5.6 multi-agent 或 pro mode；
- 为不同模型维护两套 skill 正文；
- 修改模型配置、API 参数、reasoning effort 或 prompt caching；
- 重构安装链路、插件目录或 marketplace；
- 扩大 Git 授权；
- 因瘦身删除核心代码注释要求；
- 写入项目记忆，除非用户另行确认。

## Failure transitions

- description 精简导致误触发/漏触发：恢复最小触发词或前置边界，重跑同组场景；
- owner 去重导致 caller 缺少不可见上下文：在独立消费者恢复最小自包含契约；
- implementer 询问减少但开始猜测 material decision：收紧 NEEDS_CONTEXT 条件，
  不恢复泛化“任何疑问都问”；
- token/词数下降但任务完成度或证据下降：拒绝该 ablation；
- 跨模型行为不一致：以完整行为契约为准，使用平台适配 reference，不创建模型
  专属主流程；
- fresh-agent eval 因认证、配额或平台不可用：记录 skipped 和剩余风险，不声称通过；
- 发现现有 spec/项目记忆冲突：停止相关 implementation planning，提交冲突文本给
  用户决策。

## 验收标准

1. 日常问答存在明确且实际可达的 `no task skill` 终态。
2. 当前阶段只加载最小充分 skill 集，显式请求与 hard gate 不受影响。
3. Description 的关键正向和排除条件在读取正文前可用于匹配。
4. SDD 不再重复完整风险、review 和 completion 定义，但所有现有状态与 gate 可达。
5. Implementer 对局部实现判断继续执行，对 material ambiguity 正确升级。
6. Review 双轴、Git 授权、task ownership、恢复和 final review 无回归。
7. Planning、implementation、task review 和 generic review 的核心注释要求全部保留。
8. `writing-skills` 明确定义一次一组的 prompt ablation 与 before/after 证据。
9. 所有适用 static、counterexample 和 fresh-agent behavior checks 通过；不可用项明确
   标为 skipped。
10. 文档、测试和重要变更版本号同步。

## 授权边界

批准本 spec 只表示设计内容可进入 implementation planning。它不授权：

- 提交本 spec；
- 修改现有 skills、tests、docs 或 manifests；
- 创建 implementation commit；
- push、merge、PR 或任何外部写操作。

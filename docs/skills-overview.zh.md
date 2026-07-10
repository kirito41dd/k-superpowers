# Superpowers Skills 中文梳理

本文面向个人 fork 的后续微调使用，重点记录每个 skill 的触发场景、核心思想和主要流程。不要把这里当作可替代 `SKILL.md` 的执行规范；真正执行时仍以对应 skill 原文为准。

## 总体设计

Superpowers 的核心不是“提示词集合”，而是一套强制 agent 在关键节点采用高纪律流程的行为框架。

- `using-superpowers` 是入口：任何任务开始先判断是否有 skill 适用。
- `brainstorming -> writing-plans -> subagent-driven-development/executing-plans -> finishing-a-development-branch` 构成从想法到交付的主线。
- `type-driven-verification` 负责类型优先验证，并要求测试优先通过真实入口覆盖行为；`systematic-debugging`、`verification-before-completion` 继续负责阻止猜测和未验证宣称。
- `requesting-code-review`、`receiving-code-review` 和 subagent review 流程按风险设置质量门；merged task reviewer 在一次 diff 读取中分别报告 Spec / Standards 两个 verdict。
- `writing-skills` 把 skill 本身视为会影响 agent 行为的“代码”，要求按风险选择验证强度。

## 主流程关系

典型开发路径：

1. `using-superpowers`：启动时检查是否需要加载 skill。
2. `brainstorming`：按不确定性自动选择 Compact/Full；清晰单域需求一次呈现完整设计并一次批准，高不确定性保留完整澄清和分段审批。
3. `writing-plans`：Compact 计划只保留风险、接口、实现要点和验证，faithful plan 不重复审批；Full 计划保留详细步骤。随后统一询问 execution/worktree/commit 授权。
4. `using-git-worktrees`：消费统一 handoff 的 workspace 决策，只做检测和执行，不重复询问。
5. `subagent-driven-development`：在同一会话中按 Task 风险执行；low 由 controller 直接处理，medium/high 使用 implementer + merged reviewer，high/跨 Task 风险追加 final review。若不授权 checkpoint commits 或要 inline 执行，则用 `executing-plans`。
6. `requesting-code-review`：medium/high Task、high/跨 Task final gate 或合并前按风险请求独立评审。
7. `verification-before-completion`：声明完成前必须有新鲜验证证据。
8. `finishing-a-development-branch`：仅在 feature branch/worktree 或真实 Git 集成决策存在时，让用户选择合并、PR、保留或丢弃。

## Description 注入总览

`description` 是 skill 被发现和触发前注入模型上下文的第一层内容。它不只是摘要，而是会直接影响模型是否加载该 skill、是否误触发、以及加载前对任务的初步理解。理想状态是只写触发条件，不在 description 里展开流程，避免模型只看 description 就跳过 skill 正文。

| Skill | Description 注入原文 | 注入效果 |
|------|----------------------|----------|
| `brainstorming` | `You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation.` | 强制把任何创造性工作前置到设计讨论。触发面很宽，容易把“熟悉上下文”等预热请求误判为脑暴，所以正文已补 `Preparation-Only Requests` 排除项。 |
| `dispatching-parallel-agents` | `Use when facing 2+ independent tasks that can be worked on without shared state or sequential dependencies` | 只在多个独立任务时触发，关键词是 `2+ independent tasks`、无共享状态、无顺序依赖。注入内容干净，没有泄露具体流程。 |
| `executing-plans` | `Use when executing an approved implementation plan inline or without SDD checkpoint commits` | 用于已批准计划的 Inline 执行，或用户不授权 SDD checkpoint commits 的场景。 |
| `finishing-a-development-branch` | `Use when verified work on a feature branch or worktree needs a merge, PR, retention, discard, or cleanup decision` | 只在已验证的 feature branch/worktree 仍有真实集成或清理决策时触发，避免 current-main Inline 工作出现无效菜单。 |
| `receiving-code-review` | `Use when receiving code review feedback, before implementing suggestions, especially if feedback seems unclear or technically questionable - requires technical rigor and verification, not performative agreement or blind implementation` | 在收到评审反馈时触发，并提前注入“先验证、反表演性认同、反盲从”的态度。description 稍长，但这是核心纪律。 |
| `requesting-code-review` | `Use when completing tasks, implementing major features, or before merging to verify work meets requirements` | 在任务完成、重大功能完成、合并前触发。注入重点是“请求评审验证需求”，触发面适中。 |
| `subagent-driven-development` | `Use when executing implementation plans with independent tasks in the current session` | 触发条件是已有实现计划、任务相对独立、当前会话执行。description 很克制，没有总结“两阶段 review”流程，避免模型偷懒只做部分流程。 |
| `systematic-debugging` | `Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes` | 任何 bug、测试失败、异常行为都会触发，并强调“提出修复前”。这是强纪律入口，阻止先猜修。 |
| `type-driven-verification` | `Use when implementing behavior that needs explicit verification, especially core logic, bug fixes, public APIs, algorithms, parsers, protocols, state machines, or high-risk changes` | 类型优先验证。触发条件收窄到需要显式验证的行为，避免所有改动都进入严格 TDD。 |
| `using-git-worktrees` | `Use when starting feature work that needs isolation from current workspace or before executing implementation plans - ensures an isolated workspace exists via native tools or git worktree fallback` | 在需要隔离工作区或执行计划前触发。后半句说明目的和 fallback，可能略像流程摘要，但能防止直接在当前分支开工。 |
| `using-superpowers` | `Use when starting any conversation - establishes how to find and use skills, requiring Skill tool invocation before ANY response including clarifying questions` | 会话入口强触发，要求任何回应前先检查 skill。这个 description 极强，会带来误触发压力；正文已通过 `Intent Gate` 分流预热型请求。 |
| `verification-before-completion` | `Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and confirming output before making any success claims; evidence before assertions always` | 在任何成功声明、提交、PR 前触发。description 明确注入“证据先于声明”，是防止虚假完成声明的强纪律。 |
| `writing-plans` | `Use when you have a spec or requirements for a multi-step task, before touching code` | 有 spec/需求且任务多步骤、还没碰代码时触发。边界清楚，防止需求后直接实现。 |
| `writing-skills` | `Use when creating new skills, editing existing skills, or verifying skills work before deployment` | 创建、修改、验证 skill 时触发。注入范围覆盖 skill 生命周期，提醒 skill 正文变更也要当作行为代码处理。 |

## Skills 逐项梳理

### brainstorming

- 触发场景：任何创造性工作，包括新功能、组件、行为变更、配置变更。
- 核心思想：设计批准仍是硬门，但交互成本按不确定性分级。Compact 是清晰单域工作的自动默认，Full 处理多子系统、多个阻断问题、长期架构取舍和不可逆/安全/协议风险。
- 主要流程：探索上下文后选择 Compact/Full；Compact 最多问一个阻断问题，一次呈现 2-3 个方案、推荐与完整设计，用户一次批准；faithful written spec self-review 后不重复审批，只有 material delta 才回问。Full 保留逐问题澄清、分段设计和 written spec review。两种流程的 spec commit 都只在显式授权时执行，最终都转 `writing-plans`。
- 关键约束：terminal state 只能是 `writing-plans`，不能直接进入实现类 skill。

### dispatching-parallel-agents

- 触发场景：有 2 个以上互相独立、没有共享状态或顺序依赖的问题域。
- 核心思想：每个独立问题域一个 agent，并行调查，主会话只做协调和整合。
- 主要流程：按根因或子系统划分独立域；为每个 agent 构造聚焦、自包含、有明确输出要求的任务；并行派发；回收结果后检查冲突、理解改动并跑完整验证。
- 关键约束：不要用于彼此相关的失败、需要全局上下文的问题，或会编辑同一文件/共享资源的任务。

### executing-plans

- 触发场景：已有批准的实现计划，要在当前会话 Inline 执行，或用户不授权 SDD checkpoint commits。
- 核心思想：先批判性 review 计划，再严格逐任务执行，不猜测、不跳过验证。
- 主要流程：读取计划；指出疑问或风险，必要时先问用户；无问题则建立 todo；逐任务执行和验证。只有 feature branch/worktree、用户请求 Git 集成/清理或存在真实 integration decision 时才转 `finishing-a-development-branch`；current-main Inline 直接验证并报告原地变更。
- 关键约束：遇到 blocker、计划缺口、理解不了的指令或反复验证失败时停止并询问；不得在 main/master 上未经明确许可开始实现。

### finishing-a-development-branch

- 触发场景：feature branch/worktree 上的实现已验证，且仍需 merge、PR、保留、丢弃或 cleanup 决策。
- 核心思想：只在真实 branch integration decision 存在时，先验证、识别环境、给结构化选项并执行。
- 主要流程：运行项目测试；失败则停止；检测是否普通仓库、命名 worktree 或 detached HEAD；确定 base branch；普通分支展示 4 个选项：本地合并、push 并建 PR、保留、丢弃；detached HEAD 展示 3 个选项；按选择执行；只在本地合并或丢弃时清理 worktree。
- 关键约束：current-main Inline 且无 Git 集成请求时不触发；丢弃必须要求用户输入 `discard`；不得清理 harness 拥有的 worktree；不得在未验证测试的情况下进入合并或 PR。

### receiving-code-review

- 触发场景：收到代码评审反馈，尤其是反馈不清楚或技术上可疑时。
- 核心思想：评审反馈是需要技术验证的建议，不是社交表演，也不是无条件命令。
- 主要流程：完整读反馈；用自己的话理解要求或提问；对照代码库验证；判断建议在当前项目中是否正确；正确则逐项实现和测试；不正确则用技术理由 push back。
- 关键约束：禁止“你完全正确”“好建议”式表演性认同；多项反馈中有任意不清楚项时，先澄清再实现；外部 reviewer 的建议要更谨慎，检查是否破坏现有功能、是否违反 YAGNI、是否冲突用户先前决策。

### requesting-code-review

- 触发场景：完成任务、完成重要功能、合并前，或复杂 bug 修复后。
- 核心思想：早评审但不机械评审，用隔离上下文的 reviewer agent 在有实际风险的节点发现缺陷；评审始终分别给出 Spec 和 Standards verdict，避免需求符合度与代码质量互相掩盖。
- 主要流程：SDD 的 medium/high Task 使用一个 merged reviewer，low Task 不派 reviewer；high 或跨 Task 集成风险追加 final whole-change review。独立 review 确定 base/head SHA，提供变更说明、计划/需求和 SHA 范围，分别报告 Spec Findings 与 Standards Findings；Critical/Important 在继续前修复，Minor 在需要 final review 时进入最终 triage；错误 finding 用证据反驳。
- 关键约束：不要因为“很简单”跳过 review；不要忽略 Critical/Important；不要让 reviewer 继承当前会话历史，必须提供精确上下文。

### subagent-driven-development

- 触发场景：已有实现计划，任务基本独立，并希望在当前会话中连续执行。
- 核心思想：按行为风险支付执行和 review 成本。low Task 由 controller 直接实现；medium/high Task 使用 fresh implementer 和一个 merged task reviewer，reviewer 在同一上下文中先检查 Spec、再检查 Standards，并输出两个独立阻断 verdict；high 或跨 Task 集成风险再增加独立 final review。
- 主要流程：计划为每个 Task 显式写 `Risk` 与 rationale；启动时先执行 unified handoff 的 workspace 决策，再检查 progress ledger 和 pre-flight，并消费 handoff 的 local checkpoint commit 授权（只有缺失时才询问）。low Task 由 controller 读取 brief、实现、验证、自检 diff、checkpoint commit 并记 ledger；medium/high Task 使用 brief/report/diff 文件交接，implementer 验证并提交 checkpoint 后，merged reviewer 一次读取 diff 输出 Spec Compliance 与 Task Quality；任一轴失败时把全部 findings 一次性交给 fixer并完整复审两个轴。high、共享接口/状态或组合行为触发 final whole-change review；最后由 controller 跑新鲜整体验证并清理 `.superpowers/sdd/`。调用预算（不含 finding fix loop）：all-low 为 `0`，`N` 个 delegated Task 为 `2N`，需要 final review 时为 `2N+1`。
- 关键约束：缺失风险元数据不能默认为 low，controller 只能基于新证据升级、不能静默降级；low 一旦出现运行时行为、公共契约或范围扩张必须升级；checkpoint 授权不包含 push/merge/PR/amend/force，拒绝授权不能用 stash/patch 模拟 SDD；merged reviewer 缺少任一 verdict 或任一轴有开放问题都不能推进；不要并行派发实现 agent，不要粘贴 bulky artifacts，不要重复 executor 已为同一 checkpoint 跑过的 broad verification；high/跨 Task 风险不能跳过 final review。

### systematic-debugging

- 触发场景：任何 bug、测试失败、构建失败、性能问题或非预期行为。
- 核心思想：没有根因调查就不能修复；症状修复就是失败；进入假设或修复前要先建立能捕获用户具体症状的 agent-runnable feedback loop。
- 主要流程：Phase 1 读完整错误、建立 bug-specific feedback loop、检查近期变更、在多组件边界加诊断、追踪数据流；Phase 2 找工作示例、读参考实现、比较差异、理解依赖；Phase 3 写出单一假设并用最小变化验证；Phase 4 先选择验证方式，决定 loop 归宿（保留为 regression test、删除临时 harness、或说明为何不提交），再实现单一根因修复并验证。
- 关键约束：不能“先试一个”；没有能失败/通过的具体反馈循环或明确 blocker 之前不能提出修复；不能多改一起跑；修了 3 次还失败要停下来质疑架构，而不是继续补丁。

### type-driven-verification

- 触发场景：实现需要显式验证的行为，例如核心逻辑、bugfix、公共 API、算法、parser、协议、状态机或高风险变更。
- 核心思想：优先用类型、接口、可见性和编译器表达不变量；测试只覆盖类型无法证明或回归代价高的行为，并优先通过调用方真实入口验证行为。
- 主要流程：明确行为/不变量；先设计类型和 API 边界；识别编译器无法证明的风险；只为核心行为和回归风险加聚焦测试；测试优先走 public API、CLI、HTTP handler、parser entrypoint、状态机 transition 等真实入口；实现最小变更；运行相关验证。
- 关键约束：不再要求所有改动严格 test-first；不能以“有类型”逃避运行时行为验证；测试应保护核心语义而非锁死实现细节；简单 private helper 默认通过 public behavior 覆盖，除非承载复杂算法、高风险逻辑或昂贵回归。

### using-git-worktrees

- 触发场景：开始需要隔离的功能工作，或执行实现计划前。
- 核心思想：先检测已有隔离，再优先使用平台原生 worktree 工具，最后才手动 `git worktree`，不要和 harness 对抗。
- 主要流程：检测 `git-dir` 与 `git-common-dir` 判断是否已在 linked worktree，并排除 submodule；优先消费 Unified Execution Handoff 或已有用户指令中的 workspace 决策，不重复询问；只有没有既定决策时才询问。创建时优先原生工具，否则选择既有目录并检查 ignore；之后执行项目 setup 和 baseline verification。
- 关键约束：不要嵌套创建 worktree；不要在有原生工具时手写 `git worktree add`；不要跳过 ignore 检查和 baseline 验证。

### using-superpowers

- 触发场景：任何会话开始时。
- 核心思想：在任何回应、澄清或动作之前，先判断是否有 skill 适用；1% 可能适用就必须加载。
- 主要流程：收到用户消息；判断可能适用的 skill；加载 skill；声明使用目的；如果 skill 有 checklist，用 todo 跟踪；按 skill 执行；再响应用户。
- 关键约束：用户直接指令优先于 skill；skill 优先于默认系统行为；不要以“只是简单问题”“先看一眼文件”为理由跳过 skill 检查。

### verification-before-completion

- 触发场景：准备声称工作完成、修好了、测试通过、构建成功、提交或建 PR 前。
- 核心思想：证据先于声明；没有本轮新鲜验证输出，就不能做成功声明。
- 主要流程：识别能证明声明的命令；运行完整命令；读取完整输出和 exit code；确认是否支持声明；不支持则如实报告状态；支持才带证据声明。委派流程中 executor 运行并记录 Task 验证，controller 检查 report/diff/checkpoint/review verdict，reviewer 检查代码与证据，最终完成声明前由 controller 跑新鲜整体验证。
- 关键约束：不能用“应该”“看起来”“之前跑过”替代验证；不能相信 agent 的成功报告而不查 exact checkpoint 证据；同一个未变化 checkpoint 不需要仅因“下一步是委派/记账”由第二个 owner 重跑完全相同命令；部分验证不能推出整体成功。

### writing-plans

- 触发场景：已有 spec 或明确需求，要开始多步骤任务且还未碰代码。
- 核心思想：计划要能交给一个几乎不了解项目、品味可疑但有能力的工程师执行；每一步都要具体、可验证、无占位。
- 主要流程：读取 `Flow: Compact | Full`。Compact 计划保留 Goal/Architecture/Global Constraints，以及每个 Task 的 files、slice、risk、必要 interfaces、实现要点和 verification；不强制五步模板、2-5 分钟动作或 routine full-code blocks，faithful plan self-review 后直接进入统一 handoff。Full 保留详细模板和独立 plan review。统一 handoff 一次选择 SDD/Inline、worktree/current workspace 和 checkpoint commit authorization；选择即授权实现及明示动作，但不授权 push/merge/PR/amend/force。
- 关键约束：不能写 “TODO/TBD/类似上一步/添加适当错误处理” 这类占位；代码步骤必须给实际代码；命令必须给预期结果，且优先复用 CI、项目脚本、package/task 配置或 memory 中的最小相关命令，不自行扩大 target/suite/matrix scope；全局约束必须集中写入计划头部并由所有任务继承；跨任务契约必须在 `Interfaces` 中显式写清；代码注释语言优先跟随项目指令和邻近文件风格；按层/按文件拆任务只适用于真实前置类型/API 边界、必要 prefactor、机械迁移或文档/config 变更，并且要有清晰验证；commit 政策由 Execution Handoff 下的 `Commit Authorization` 小节单一承载——plan 文档只在用户显式选择时提交，批准计划不等于授权实现或提交实现代码。

### writing-skills

- 触发场景：创建、修改或验证 skill。
- 核心思想：skill 会塑造 agent 行为，验证强度必须匹配行为风险且永远不为零（Iron Law 已正文化为三级分级表）。
- 主要流程：先选择模式、声明不变量与风险；低风险静态审查，中风险增加反例推演，高风险优先使用真实用户 trace/incident/eval/review 作为 observed baseline，仅缺失时才 synthetic baseline。默认从 2-3 个代表性 failure-class 场景开始，one whole-change review 后 batch findings、one re-review；只有新 rationalization/failure class 或 material fix 才扩展。Todo 只跟踪 applicable checklist items，相关 cross-skill workflow 可作为一个行为契约验证。
- 关键约束：description 只描述触发条件；不批量混合无关 skills；按效果而非 diff 大小分级；observed baseline 不重复 synthetic baseline；验证强度永远不为零。

## 后续微调建议

- 先区分“个人偏好”与“可贡献上游”：个人偏好放 fork 文档、项目记忆或独立插件；不要直接改 core skill 正文后开 PR。
- 改 behavior-shaping 内容前，先明确行为不变量和风险；高风险改动再用 `writing-skills` 做压力场景和 before/after。
- 对高频触发 skill 优先关注 token 成本，特别是 `using-superpowers`、`brainstorming`、`verification-before-completion`。
- 如果只是为了个人使用减少摩擦，优先在 agent 配置层做“用户指令优先”的覆盖，而不是改 skill 原文。

# Superpowers Skills 中文梳理

本文面向个人 fork 的后续微调使用，重点记录每个 skill 的触发场景、核心思想和主要流程。不要把这里当作可替代 `SKILL.md` 的执行规范；真正执行时仍以对应 skill 原文为准。

## 总体设计

Superpowers 的核心不是“提示词集合”，而是一套强制 agent 在关键节点采用高纪律流程的行为框架。

- `using-superpowers` 是入口：任何任务开始先判断是否有 skill 适用。
- `brainstorming -> writing-plans -> subagent-driven-development/executing-plans -> finishing-a-development-branch` 构成从想法到交付的主线。
- `type-driven-verification` 负责类型优先验证，并要求测试优先通过真实入口覆盖行为；`systematic-debugging`、`verification-before-completion` 继续负责阻止猜测和未验证宣称。
- `requesting-code-review`、`receiving-code-review` 和 subagent review 流程把评审变成强制质量门；实现评审按 Spec / Standards 两轴分开报告。
- `writing-skills` 把 skill 本身视为会影响 agent 行为的“代码”，要求按风险选择验证强度。

## 主流程关系

典型开发路径：

1. `using-superpowers`：启动时检查是否需要加载 skill。
2. `brainstorming`：把模糊需求澄清成设计，并拿到用户批准。
3. `writing-plans`：把设计拆成可执行、可验证、可交给低上下文 agent 的计划，默认偏向可独立验证且大小合适的 vertical slice，并显式下沉全局约束和跨任务接口。
4. `using-git-worktrees`：执行前建立或确认隔离工作区。
5. `subagent-driven-development`：在同一会话中用子 agent 逐任务执行并双重评审；若没有子 agent 或要在独立会话执行，则用 `executing-plans`。
6. `requesting-code-review`：关键节点或合并前请求独立代码评审。
7. `verification-before-completion`：声明完成前必须有新鲜验证证据。
8. `finishing-a-development-branch`：测试通过后，让用户选择本地合并、发 PR、保留或丢弃。

## Description 注入总览

`description` 是 skill 被发现和触发前注入模型上下文的第一层内容。它不只是摘要，而是会直接影响模型是否加载该 skill、是否误触发、以及加载前对任务的初步理解。理想状态是只写触发条件，不在 description 里展开流程，避免模型只看 description 就跳过 skill 正文。

| Skill | Description 注入原文 | 注入效果 |
|------|----------------------|----------|
| `brainstorming` | `You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation.` | 强制把任何创造性工作前置到设计讨论。触发面很宽，容易把“熟悉上下文”等预热请求误判为脑暴，所以正文已补 `Preparation-Only Requests` 排除项。 |
| `dispatching-parallel-agents` | `Use when facing 2+ independent tasks that can be worked on without shared state or sequential dependencies` | 只在多个独立任务时触发，关键词是 `2+ independent tasks`、无共享状态、无顺序依赖。注入内容干净，没有泄露具体流程。 |
| `executing-plans` | `Use when you have a written implementation plan to execute in a separate session with review checkpoints` | 触发条件是“已有书面实现计划”且在单独会话执行。和 `subagent-driven-development` 的边界在于 separate session。 |
| `finishing-a-development-branch` | `Use when implementation is complete, all tests pass, and you need to decide how to integrate the work - guides completion of development work by presenting structured options for merge, PR, or cleanup` | 在实现完成、测试通过、需要集成决策时触发。后半句已经泄露一点流程（structured options），但有助于区分 merge/PR/cleanup 场景。 |
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
- 核心思想：先把想法变成经过用户确认的设计，禁止未经设计批准就实现。
- 主要流程：先探索项目上下文；如果涉及视觉问题，单独询问是否启用 visual companion；一次只问一个澄清问题；提出 2-3 个方案与权衡；分段展示设计并逐段确认；写入 `docs/superpowers/specs/YYYY-MM-DD-<topic>-design.md`；自检占位符、矛盾、范围和歧义；要求用户 review spec；spec 提交走 Commit Gate（单一来源）——仅用户显式选择时提交，且批准 spec 不等于授权实现；之后转入 `writing-plans`。
- 关键约束：terminal state 只能是 `writing-plans`，不能直接进入实现类 skill。

### dispatching-parallel-agents

- 触发场景：有 2 个以上互相独立、没有共享状态或顺序依赖的问题域。
- 核心思想：每个独立问题域一个 agent，并行调查，主会话只做协调和整合。
- 主要流程：按根因或子系统划分独立域；为每个 agent 构造聚焦、自包含、有明确输出要求的任务；并行派发；回收结果后检查冲突、理解改动并跑完整验证。
- 关键约束：不要用于彼此相关的失败、需要全局上下文的问题，或会编辑同一文件/共享资源的任务。

### executing-plans

- 触发场景：已有书面实现计划，要在单独会话或无子 agent 条件下执行。
- 核心思想：先批判性 review 计划，再严格逐任务执行，不猜测、不跳过验证。
- 主要流程：读取计划；指出疑问或风险，必要时先问用户；无问题则建立 todo；逐任务标记、按计划步骤执行、运行指定验证、完成后标记；全部完成后转入 `finishing-a-development-branch`。
- 关键约束：遇到 blocker、计划缺口、理解不了的指令或反复验证失败时停止并询问；不得在 main/master 上未经明确许可开始实现。

### finishing-a-development-branch

- 触发场景：实现完成、测试通过，需要决定如何集成或清理。
- 核心思想：先验证，再识别环境，再给结构化选项，最后按用户选择执行。
- 主要流程：运行项目测试；失败则停止；检测是否普通仓库、命名 worktree 或 detached HEAD；确定 base branch；普通分支展示 4 个选项：本地合并、push 并建 PR、保留、丢弃；detached HEAD 展示 3 个选项；按选择执行；只在本地合并或丢弃时清理 worktree。
- 关键约束：丢弃必须要求用户输入 `discard` 确认；不得清理 harness 拥有的 worktree；不得在未验证测试的情况下进入合并或 PR。

### receiving-code-review

- 触发场景：收到代码评审反馈，尤其是反馈不清楚或技术上可疑时。
- 核心思想：评审反馈是需要技术验证的建议，不是社交表演，也不是无条件命令。
- 主要流程：完整读反馈；用自己的话理解要求或提问；对照代码库验证；判断建议在当前项目中是否正确；正确则逐项实现和测试；不正确则用技术理由 push back。
- 关键约束：禁止“你完全正确”“好建议”式表演性认同；多项反馈中有任意不清楚项时，先澄清再实现；外部 reviewer 的建议要更谨慎，检查是否破坏现有功能、是否违反 YAGNI、是否冲突用户先前决策。

### requesting-code-review

- 触发场景：完成任务、完成重要功能、合并前，或复杂 bug 修复后。
- 核心思想：早评审、常评审，用隔离上下文的 reviewer agent 在问题扩散前发现缺陷；评审按 Spec 和 Standards 两轴分开，避免需求符合度与代码质量互相掩盖。
- 主要流程：确定 base/head SHA；用 `requesting-code-review/code-reviewer.md` 模板派发 reviewer；提供变更说明、计划/需求、SHA 范围；reviewer 分别报告 Spec Findings（漏做、多做、做错）和 Standards Findings（项目约定、质量、维护性、测试）；处理反馈：Critical 立即修、Important 继续前修、Minor 可记录；若 reviewer 错误则用证据反驳。
- 关键约束：不要因为“很简单”跳过 review；不要忽略 Critical/Important；不要让 reviewer 继承当前会话历史，必须提供精确上下文。

### subagent-driven-development

- 触发场景：已有实现计划，任务基本独立，并希望在当前会话中连续执行。
- 核心思想：每个任务使用新鲜 implementer subagent，随后做两阶段评审：先 Spec axis（是否按要求完成且无多做漏做），再 Standards axis（质量、维护性、测试和项目约定）。
- 主要流程：读取计划并建立 todo；启动时检查 `.superpowers/sdd/progress.md`，已完成任务不重复派发；Task 1 前先做 pre-flight plan review，批量发现任务互相矛盾、全局约束冲突或计划要求与 reviewer 纪律冲突的问题；每个任务先用 `scripts/task-brief` 写出包含 `Global Constraints` 和完整任务正文的 brief 文件，controller 先做 self-contained 检查，必要时追加 `Controller Notes` 或停止澄清，再派发 implementer 读取 brief 并把详细报告写到 report 文件；处理 implementer 的 `DONE`、`DONE_WITH_CONCERNS`、`NEEDS_CONTEXT`、`BLOCKED` 状态；用 `scripts/review-package BASE HEAD` 写出 diff package；通过 spec reviewer 确认没有少做、多做或违反全局约束，`⚠️ Cannot verify from diff` 项由 controller 解决后才能过；通过自包含 code quality reviewer 检查 Standards axis；有问题回到 implementer 修复、更新 report、重写 review package 并按风险复审；任务通过后同步 todo 和 progress ledger；所有任务完成后用 whole-change review package 做最终 review；最终 review 通过后运行 `scripts/sdd-cleanup` 删除 `.superpowers/sdd/`，再转 `finishing-a-development-branch`。
- 关键约束：不要并行派发多个实现 agent；不要让 implementer 读取完整 plan，也不要把完整任务、报告或 diff 粘进 prompt，优先传 brief/report/diff 文件路径；reviewer prompt 不能预设“不许 flag / 最多 Minor / 计划这么要求所以别报”；spec 未通过前不能做 code quality review；quality 修复若影响行为、API、配置、manifest、测试、文档、触及文件或任务范围，必须回到 spec review；两个 review 任一有开放问题都不能进入下一任务；Minor findings 要记录给最终 review triage；未明确授权时 implementer 不得提交 commit。

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
- 主要流程：检测 `git-dir` 与 `git-common-dir` 判断是否已在 linked worktree，并排除 submodule；若普通仓库且无既定偏好，询问是否创建隔离 worktree；优先使用原生工具；否则选择 `.worktrees/`、`worktrees/` 或全局目录；项目内目录必须先确认被 ignore；创建后自动安装依赖并跑 baseline tests。
- 关键约束：不要嵌套创建 worktree；不要在有原生工具时手写 `git worktree add`；不要跳过 ignore 检查和 baseline 验证。

### using-superpowers

- 触发场景：任何会话开始时。
- 核心思想：在任何回应、澄清或动作之前，先判断是否有 skill 适用；1% 可能适用就必须加载。
- 主要流程：收到用户消息；判断可能适用的 skill；加载 skill；声明使用目的；如果 skill 有 checklist，用 todo 跟踪；按 skill 执行；再响应用户。
- 关键约束：用户直接指令优先于 skill；skill 优先于默认系统行为；不要以“只是简单问题”“先看一眼文件”为理由跳过 skill 检查。

### verification-before-completion

- 触发场景：准备声称工作完成、修好了、测试通过、构建成功、提交或建 PR 前。
- 核心思想：证据先于声明；没有本轮新鲜验证输出，就不能做成功声明。
- 主要流程：识别能证明声明的命令；运行完整命令；读取完整输出和 exit code；确认是否支持声明；不支持则如实报告状态；支持才带证据声明。
- 关键约束：不能用“应该”“看起来”“之前跑过”替代验证；不能相信 agent 的成功报告而不查 diff 和验证；部分验证不能推出整体成功。

### writing-plans

- 触发场景：已有 spec 或明确需求，要开始多步骤任务且还未碰代码。
- 核心思想：计划要能交给一个几乎不了解项目、品味可疑但有能力的工程师执行；每一步都要具体、可验证、无占位。
- 主要流程：先检查 spec 是否过大或跨多个独立子系统；规划文件结构和职责边界；把 spec 中版本下限、依赖限制、命名、精确值等项目级要求复制到 `Global Constraints`；默认把任务拆成可独立验证且值得单独 review 的 vertical slice，setup/config/docs 默认并入需要它们的 deliverable；每个任务写清 slice 行为、依赖、文件、跨任务 `Interfaces`、验证命令；任务模板按类型优先顺序展开：定义类型/API 边界（显式写出类型证不了的 Runtime risk）→ 最小实现（核心结构、核心函数、核心抽象默认要有跟随语言和项目习惯的解释性注释/文档，除非确实自解释；说明它表示什么、如何使用、关键不变量/生命周期/协议/状态规则）→ 只对类型证不了的行为加聚焦测试 → 运行验证 → 授权时才做 commit checkpoint；bug 修复任务的回归测试需先复现失败再修复；每个任务列出精确文件、代码片段、验证命令和预期输出；写完后自检 spec 覆盖、占位符、类型和命名一致性、约束传播、接口一致性、核心说明和任务大小；保存到 `docs/superpowers/plans/YYYY-MM-DD-<feature-name>.md`；让用户选择 subagent-driven 或 inline execution。
- 关键约束：不能写 “TODO/TBD/类似上一步/添加适当错误处理” 这类占位；代码步骤必须给实际代码；命令必须给预期结果，且优先复用 CI、项目脚本、package/task 配置或 memory 中的最小相关命令，不自行扩大 target/suite/matrix scope；全局约束必须集中写入计划头部并由所有任务继承；跨任务契约必须在 `Interfaces` 中显式写清；代码注释语言优先跟随项目指令和邻近文件风格；按层/按文件拆任务只适用于真实前置类型/API 边界、必要 prefactor、机械迁移或文档/config 变更，并且要有清晰验证；commit 政策由 Execution Handoff 下的 `Commit Authorization` 小节单一承载——plan 文档只在用户显式选择时提交，批准计划不等于授权实现或提交实现代码。

### writing-skills

- 触发场景：创建、修改或验证 skill。
- 核心思想：skill 会塑造 agent 行为，验证强度必须匹配行为风险且永远不为零（Iron Law 已正文化为三级分级表）。
- 主要流程：先选择模式（创建新 skill / 修改已有 skill / 验证已有 skill / 仅审查）；修改已有 skill 时先读目标 skill、声明要保留的不变量、识别影响面（触发条件、流程 gate、subagent 行为、验证要求、示例或交叉引用）和失败模式；按效果分级——低风险（措辞/格式/死链）做静态审查加冲突措辞搜索，中风险（流程 gate/checklist/交叉引用）追加反例推演，高风险（触发条件/纪律规则/subagent 流程/新行为塑造 skill）基于真实失败证据或压力场景走 baseline → write → verify → close-loopholes 完整循环（方法论在 `testing-skills-with-subagents.md`，含压力场景设计与堵漏机制）。
- 关键约束：description 只描述触发条件，不能概括流程；不要批量创建多个未验证 skill；按效果而非 diff 大小分级——改措辞但影响 skill 触发时机的就是高风险；禁止把验证降为零。

## 后续微调建议

- 先区分“个人偏好”与“可贡献上游”：个人偏好放 fork 文档、项目记忆或独立插件；不要直接改 core skill 正文后开 PR。
- 改 behavior-shaping 内容前，先明确行为不变量和风险；高风险改动再用 `writing-skills` 做压力场景和 before/after。
- 对高频触发 skill 优先关注 token 成本，特别是 `using-superpowers`、`brainstorming`、`verification-before-completion`。
- 如果只是为了个人使用减少摩擦，优先在 agent 配置层做“用户指令优先”的覆盖，而不是改 skill 原文。

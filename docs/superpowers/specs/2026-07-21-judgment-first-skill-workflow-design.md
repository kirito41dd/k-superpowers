# Judgment-First Skill Workflow 设计

## Flow

Full

## 状态

Approved section by section on 2026-07-21. Include with implementation; do not
create a standalone documentation commit unless separately authorized.

## 目标

把 K Superpowers 从“要求 agent 精确执行流程协议”调整为“给智能 agent 明确目标、
权限边界、风险边界和成功标准”。交付速度、用户等待时间、模型调用成本和 ceremony
同正确性一样，是 skill 是否好用的评价维度。

本设计吸收并继续执行
`2026-07-21-bounded-review-closure-design.md`：Review 保持一次 Discovery、一次批量
修复和一次 Closure，但删除不受外部解析器要求的精确输出与工具顺序。

## 设计原则

### 固定边界，不固定思考路径

Skill 应优先定义：

- 用户目标与完成标准；
- 当前 owner 的责任；
- 不得越过的授权与安全边界；
- 需要用户决定的 material ambiguity；
- 能支持完成声明的证据。

除真实外部协议外，不冻结 prose、tool-call 顺序、读取顺序、输出行数或 prompt 字节。
Agent 可以根据项目、平台、上下文和已获得证据选择局部步骤。

### 速度是一等产品指标

流程只在能降低实际风险或总交付时间时增加步骤。默认选择可逆、低权限、低 ceremony
路径；发现新非阻断改进不 reopen 当前迭代。任何 review、delegation 或验证都要有明确
问题和退出条件。

### 保留真正的硬边界

以下行为继续明确约束：

- 未授权不 commit、push、merge、建 PR、amend、force；
- destructive discard 需要明确确认；
- 不覆盖、吸收或清理用户已有修改；
- worktree cleanup 必须证明 ownership；
- material architecture、scope、dependency、public contract 和兼容性决定交给用户；
- completion claim 必须有相称的新鲜证据；
- 核心代码解释性注释和项目注释语言契约；
- 类型/API 优先排除非法状态；
- Review Closure 有界，失败不伪装成功。

## 主流程

### Intent 路由

```text
ordinary question -> direct answer, no task skill
preparation/read-only -> read/search/report, stop
bug/unexpected behavior -> systematic debugging
clear bounded behavior change -> Direct
multi-step tightly coupled change -> Planned Inline
independent tasks with material delegation benefit -> SDD
```

只加载当前 owner 和当前动作确实需要的 domain skill。未来可能相关不是 trigger。

### Direct

Direct 适用于目标清楚、单一问题域、可逆、无未决 material decision，且实现可以由同一
agent 连续完成的小型或中等变更。

流程：

```text
inspect relevant context
-> present concise recommended design when behavior changes
-> user approves or says implement
-> current workspace + Inline + no commit
-> focused implementation and bounded verification
-> hand back for real use
```

用户明确说“改吧”“实现”“继续”且已批准设计时，授权当前 scope 内的实现编辑；默认不
授权 commit 或外部操作。除非 worktree、SDD 或 checkpoint commit 有实际收益，否则不
展示 Unified Handoff 菜单。

Direct/Compact 默认使用内部 todo，不创建持久 spec/plan。只有用户要求、跨会话交接、
复杂到内存计划容易漂移，或后续执行者需要稳定 artifact 时才写文件。

### Planned Inline

多步骤但任务紧密耦合、共享上下文或整体语义需要同一 agent 判断时使用 Inline。计划只
记录对实现有用的接口、约束、任务切片和验证；不为模板填充字段。当前 workspace、无
commit 是安全默认。只有存在实际隔离或恢复收益时询问 worktree/commit。

### SDD

只有任务能够独立理解和执行，且 delegation 的延迟/上下文收益大于交接成本时进入
SDD。用户仍需明确授权 checkpoint commits；不为使用 multi-agent 而使用 SDD。

风险路由调整为：

- low：controller 直接实现和自审；
- medium：implementer 执行，controller 检查实际 diff 和验证；默认无独立 reviewer；
- high：implementer + independent reviewer；
- final whole-change review：只用于真实跨任务共享接口、共享状态或未验证组合风险，
  不因存在单个 high task 重复完整审查。

Controller 可以根据运行时新证据升级验证或 review，但必须说明具体风险；不能因模板
缺字段而自动升级或阻断。

## Brainstorming 与 Planning

### Brainstorming

- 只有存在真实可行且影响不同的取舍时才展示多个方案；明显优选方案可直接推荐并说明
  关键 trade-off。
- Direct/Compact 一次呈现足够决策的信息，用户一次批准。
- Full 适用于真正的跨域、不可逆、安全、协议、迁移或重大兼容性决策；按 material
  decision 获得批准，不强制逐章节 ceremony。
- 设计批准可授权后续计划，也可在用户明确要求实现时直接授权 Direct/Inline 编辑；
  永远不隐含 Git 或外部写授权。

### Writing Plans

- 只有持久计划确实有交接价值时才写 plan 文件。
- 计划按复杂度记录目标、关键边界、必要接口、任务切片、风险与验证。
- Risk 只在影响执行路线、review、权限或验证时显式记录；明显机械任务不因缺少 `low`
  标签阻断。
- Implementation Design Contract 是思考维度，不是必须逐字段填充的表单。
- 不强制五选一 handoff。安全默认是 Inline + current workspace + no commit；只有偏离
  默认或需要额外权限时询问。

## Delegated Prompts

删除 Role Prompt Fidelity 和所有无外部协议依据的精确执行要求，包括：

- 逐字复制、固定非 placeholder 字序；
- 第一动作必须读取指定文件；
- 每个 assistant decision 只能有一个 tool call；
- 固定读取顺序；
- 禁止任何进度文字；
- 输出第一字符、精确行数和固定文本 block 形状。

Delegated brief 只要求语义完整：

```text
goal
inputs and relevant context
authorized and forbidden actions
material blocking conditions
quality/verification expectations
result information needed by controller
```

Controller 可按平台能力和任务上下文重组 wording、tool usage 和读取顺序。Subagent
必须读取完成任务需要的 supplied context，但 agent 自己决定高效顺序。

## Review

### 生命周期

保留：

```text
Discovery -> frozen finding ledger -> one coherent fix batch -> Closure
          -> PASS | PASS_WITH_FOLLOWUPS | STOPPED_BLOCKED
```

Closure 优先由同一逻辑 reviewer 完成；替代 agent 必须看到完整 review record。Closure
只确认原 blocker、fix 直接引入的回归和原交付目标证据。Minor 或无因果关系的新观察
进入 follow-up，不能 reopen discovery。

### 输出

保留 stable finding ID、severity、Spec/Standards axis、location、issue、impact、required
fix、closure disposition 和最终 result。只要求信息完整、可引用，不要求精确行数、首
字符或固定纯文本编码。

### 读取能力

冻结的是 review goal、修改 scope 和 evidence snapshot，不是 reviewer 的只读能力。
Reviewer 可以为一个具体审查问题读取调用方、邻近实现、项目规范和直接依赖；不得修改
工作区、扩大 change request，或把无关观察作为当前 blocker。

同一 controller 内的 Inline review 默认直接使用 requirements、当前 diff 和验证证据。
Review package 只在跨 agent/上下文、需要冻结 working tree 或 committed range 时使用。
Scope 使用显式路径和 source/base/head，不恢复 scope hash handshake。

## Debugging

- 修改前收集足以支持下一步的证据；不要求所有问题都有本地可运行 reproducer。
- 能复现时建立最小 feedback loop；生产、外部、偶发或环境受限问题可根据日志、dump、
  traces 和差异提出带置信度的假设。
- 无验证手段时可以诊断和给出验证建议，不能声称 fixed。
- 一次只验证一个有区分度的假设，避免堆叠 speculative fixes。
- 删除固定“三次失败”。当连续尝试没有产生新信息、修复范围开始扩大，或证据指向
  architecture/ownership 问题时停止编辑并与用户讨论。
- Working example 和完整差异对比只在能回答当前问题时使用，不作为必经步骤。

## Type-Driven Verification 与 Completion

`type-driven-verification` 的工程哲学继续保留。Implementation Design Contract 改为
适用时的思考清单，不强制空字段或固定报告格式。核心代码解释性注释契约不变。

`verification-before-completion` 保留 claim/evidence 对齐。证据可以是命令、编译器、
类型/API 约束、diff inspection 或可靠 artifact，取决于 claim；不因 bookkeeping、
review delegation 或未变化的代码机械重跑相同验证。

## Parallel Agents

允许多个 agent 读取相同文件和上下文。只有以下情况禁止并行：

- 会产生冲突写入或竞争同一外部资源；
- 一个任务消费另一个任务尚未产生的结果；
- 一个任务的决定可能使另一个任务的工作失效；
- 交接与整合成本高于预期延迟收益。

每个 agent 仍获得清晰目标、边界、必要上下文和输出期望。Controller 负责整合实际
结果，而不是相信 success message。

## Writing Skills

小改动只需明确 intended behavior 和可能回归的少量不变量。完整 Change Contract 仅
用于 routing、authorization、delegation、review 或其他高影响 workflow 变更，并且
只记录适用字段。

继续遵守：真实使用反馈驱动、最小 coherent change、一次 self-review、非阻断建议进入
后续迭代、不创建持久 skill tests/evals、不默认调用付费模型验证。

## 文件范围

主要修改：

- `skills/using-superpowers/SKILL.md`
- `skills/brainstorming/SKILL.md`, `skills/brainstorming/full-flow.md`
- `skills/writing-plans/SKILL.md`, `skills/writing-plans/full-plan-guide.md`
- `skills/executing-plans/SKILL.md`
- `skills/using-git-worktrees/SKILL.md`（仅 caller 对齐，ownership 行为不变）
- `skills/subagent-driven-development/SKILL.md`
- `skills/subagent-driven-development/implementer-prompt.md`
- `skills/subagent-driven-development/task-reviewer-prompt.md`
- `skills/subagent-driven-development/scripts/task-brief`（仅注释对齐）
- `skills/requesting-code-review/SKILL.md`
- `skills/requesting-code-review/code-reviewer.md`
- `skills/receiving-code-review/SKILL.md`
- `skills/systematic-debugging/SKILL.md`
- `skills/type-driven-verification/SKILL.md`
- `skills/verification-before-completion/SKILL.md`
- `skills/dispatching-parallel-agents/SKILL.md`
- `skills/writing-skills/SKILL.md`
- README、overview、plugin manifests 和经用户确认后的项目记忆。

保留 worktree ownership、finishing branch destructive safety 和 review-package 的内容
冻结能力；只在其 callers 中降低默认使用频率。

## 验收标准

1. 普通问答与 read-only 路由保持最小 skill 集。
2. 清晰变更在一次设计批准后可 Direct 实现，不强制 spec/plan/handoff menu。
3. 安全默认是 current workspace + Inline + no commit。
4. 无外部解析器的逐字 prompt、固定 tool 顺序和精确输出编码全部删除。
5. Medium SDD 默认不派独立 reviewer；单个 high task 不重复 final review。
6. Bounded Review Closure、stable IDs、非阻断 follow-up 与停止终态保留。
7. Reviewer 可按具体问题做有界只读上下文检查。
8. Debugging 允许无 reproducer 的证据化诊断，不再固定三次失败。
9. Shared read-only context 不阻止 parallel agents。
10. Git、destructive action、用户修改、worktree ownership、material decision、注释、
    type-first 和 completion evidence 等硬边界无回归。
11. 不新增测试、eval 或模型验证；只做一次文本自审、冲突搜索和廉价语法/JSON检查。

## 失败转移

- Direct 中发现 material decision、不可逆风险或 scope 扩大：停止并升级设计，不猜测。
- 默认 workspace 与用户已有修改重叠：停止并报告具体冲突，不能覆盖或吸收。
- Delegated brief 缺少完成所需的实质上下文：subagent 返回具体缺口；不因格式缺失失败。
- Closure 仍有 blocker：`STOPPED_BLOCKED` 并交还用户，不自动循环。
- 无 reproducer 的 debugging 缺少足够证据：报告不确定性和所需观察，不实施猜测性 fix。
- 简化导致真实权限或安全边界不清：恢复最小必要边界，不恢复整个旧 ceremony。

## 授权边界

批准本设计授权进入 implementation planning，不授权 commit、push、merge、PR、amend、
force、发布或清理外部状态。实现时继续保护当前工作区已有改动。

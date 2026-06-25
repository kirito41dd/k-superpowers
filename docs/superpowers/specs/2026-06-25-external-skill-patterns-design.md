# 外部 Skill 模式吸收：强化 Agent 写代码的实现纪律

**日期：** 2026-06-25
**状态：** 待审核草案
**来源：** `refs/mattpocock-skills`

## 问题

`refs/mattpocock-skills` 里有一些能让 agent 更稳定写代码的模式。值得吸收的不是整套 workflow，也不是它的 TDD / 产品流程假设，而是几条更小、更直接的实现纪律：

- 修 bug 前先建立 tight red-capable feedback loop
- 按 Spec 和 Standards 两个轴独立评审实现
- 把实现工作拆成端到端纵向薄切片，而不是按技术层横向拆分
- 测试应通过调用方真实使用的入口验证行为，而不是追着私有实现细节跑

当前 K Superpowers fork 已经有更强的 workflow gate、类型优先验证和项目记忆。这里的目标是吸收这些能直接提升代码实现质量的概念，同时避免引入不兼容假设，例如 blanket TDD、自动 commit、issue tracker 优先的计划流程，或额外的产品流程机械装置。

## 目标

1. 提升 agent 写代码的可靠性，同时保持本 fork 的类型优先哲学。
2. 让实现计划更可执行，默认偏向可独立验证的纵向切片。
3. 让调试减少猜测，进入假设和修复前必须有具体 red-capable feedback loop。
4. 让评审结果更清晰，分开报告需求符合度、代码质量和项目约定问题。
5. 强化“通过真实入口测试行为”，让测试落在稳定行为边界上。

## 非目标

- 不重新引入 TDD 或 red-green-refactor 作为默认开发纪律。
- 不完整复制 referenced skills。
- 不增加 issue tracker、PRD 发布、triage 或自动 commit workflow。
- 不引入 Invocation 分层；当前 skill 触发方式保持现状。
- 不引入 `writing-great-skills` 的 skill 质量词汇体系。
- 不引入 Deep Module / Seam 词汇体系。
- 不引入 Design It Twice 流程；设计质量继续依赖模型本身和 review 把控。
- 不修改插件打包、marketplace 结构或安装链路。

## 强烈建议吸收的模式

### 1. Tight Red-Capable Debugging Loop

强化 `systematic-debugging`，让 Phase 1 有一个明确 exit criterion：

> 在提出原因或修复方案前，先产出一个 agent 可运行的命令或脚本。它必须能在用户报告的具体 bug 存在时失败，并在修复后通过。

这个 loop 应满足：

- **specific**：断言用户报告的具体症状，而不是只检查“没有崩溃”
- **red-capable**：bug 存在时会失败
- **fast**：足够窄，可以反复运行
- **deterministic**：结果稳定；如果是 flaky bug，则需要足够高的复现率
- **agent-runnable**：不依赖非结构化人工点击

如果构造不了这样的 loop，agent 必须说明尝试过什么，并向用户请求可复现环境、捕获物、日志、HAR、trace，或临时 instrumentation 权限。不能继续进入猜测式假设。

这和类型优先验证兼容：这个 loop 不一定是正式测试。它可以是聚焦单测、集成测试、CLI script、curl 命令、Playwright 脚本、replay harness、fixture diff 或临时 debug harness。

#### Loop 的保留规则

red-capable loop 是调试入口，不默认等于要随代码提交。修复完成后必须明确判断它的归宿：

- **保留为回归保护**：当 bug 属于核心行为、公共 API、parser / serializer / 协议、状态机、权限 / 计费等高风险路径，或未来复发代价高时，把 loop 沉淀成正式 regression test。测试应落在稳定 interface 上，避免锁死私有实现细节。
- **删除临时复现工具**：当 loop 只是为了定位问题搭的临时 harness、一次性 curl / shell 脚本、临时日志、trace replay、局部 debug fixture，且对应风险已由类型约束、现有测试或更合适的验证覆盖时，修复后删除，不把调试脚手架留进代码库。
- **记录但不提交**：当复现依赖生产数据、用户私有数据、外部环境、手工步骤或不可稳定运行的资源时，不提交该 loop；在最终说明里记录验证方式、为什么不保留，以及替代的长期保护。

完成 bugfix 前，agent 应报告本次 loop 的归宿：`kept as regression test`、`deleted as temporary harness` 或 `not committed with rationale`。

### 2. Vertical Slice Planning

强化 `writing-plans`，让实现任务默认按 vertical slice 拆分：

- 一个 slice 应交付一条窄但完整的行为路径。
- 一个完成的 slice 应能独立验证或 demo。
- 避免“先 schema、再 API、再 UI”这种 layer-based task，除非该层任务本身是真正的前置条件，并且有独立验证方式。
- 如果 prefactoring 能让后续改动更容易，先做 prefactoring，再做 feature slices。

这应改变 plan 的形状，而不是新增 workflow。现有 plan 模板可以要求每个任务写清：

- 该 slice 交付的用户可见或外部可观察行为
- 预计会触及的文件
- 本地验证命令
- 对前序 slice 的依赖

### 3. Spec / Standards 双轴评审

调整 `requesting-code-review` 和 `subagent-driven-development` 的最终评审，让评审按两个独立轴报告：

- **Spec axis**：diff 是否实现了已批准的 spec / plan？有没有漏做、部分实现、做错或多做？
- **Standards axis**：diff 是否符合项目约定、代码质量要求和本地风格？

两个轴应分开报告。不要让“代码看起来干净”掩盖需求做错；也不要让“需求满足了”掩盖破坏项目约定或可维护性的问题。

这和当前 `subagent-driven-development` 的两阶段 review 很契合：

- spec compliance review 明确成为 Spec axis
- code quality review 明确成为 Standards axis 加 maintainability risk

对 `requesting-code-review`，reviewer prompt 应要求同时检查两个轴，并保持 findings 分组。

### 4. 通过真实入口测试行为

强化 `type-driven-verification` 的测试选择标准，不引入额外架构理论：

- 测试应优先通过调用方真实使用的入口验证行为，例如 public API、CLI、HTTP handler、parser entrypoint、状态机 transition。
- 如果只能测试私有内部，先判断是否因为外部入口没有表达清楚行为。
- 简单私有 helper 默认不单独测试，通过 public behavior 覆盖；除非它承载复杂算法、高风险逻辑或昂贵回归。

这支持当前 fork 的哲学：类型和公开边界承载不变量；测试覆盖编译器无法证明、且值得长期保护的行为。

## 建议集成点

| 目标 | 推荐改动 |
|---|---|
| `skills/systematic-debugging/SKILL.md` | 把 tight red-capable loop 加为 Phase 1 completion criterion，进入假设前必须满足。 |
| `skills/writing-plans/SKILL.md` | 增加 vertical slice / tracer bullet 的任务拆分指导。 |
| `skills/type-driven-verification/SKILL.md` | 增加“通过真实入口测试行为”的测试选择指导。 |
| `skills/requesting-code-review/code-reviewer.md` | 将 findings 拆成 Spec 和 Standards 两轴。 |
| `skills/subagent-driven-development/*reviewer-prompt.md` | 把现有 spec compliance 和 code quality 拆分显式命名为 Spec vs Standards。 |
| `docs/skills-overview.zh.md` | 汇总这些吸收后的概念，便于后续微调。 |

## 风险评估

这些都是会塑造 agent 行为的改动。风险按目标不同而不同：

- **高风险**：`systematic-debugging`、`writing-plans`、`type-driven-verification` 和 review prompts。它们会影响 agent 何时停止、何时提问、如何测试、如何实现。
- **低风险**：更新 `docs/skills-overview.zh.md`。

验证强度应匹配风险：

- 所有改动都做静态审查：搜索是否有冲突旧措辞。
- planning / review 文案做反例推演：检查 agent 是否仍可能拆 horizontal task，或把 Spec / Standards findings 混在一起。
- debugging 文案做压力场景：验证 agent 在没有 red-capable loop 前不会提出修复。

## 验收标准

- 本 fork 继续保持类型优先验证默认路线，不引入 blanket TDD 语言。
- planning guidance 默认偏向 vertical slices，并要求每个任务可独立验证。
- debugging guidance 在没有 tight red-capable loop 或明确 blocker 前，阻止猜测式修复。
- bugfix 完成前必须说明 red-capable loop 的归宿：保留为 regression test、删除临时 harness，或说明为何不提交。
- review guidance 分开报告 Spec 和 Standards findings。
- type-driven guidance 强化“通过真实入口测试行为”，但不引入 Deep Module / Seam 词汇体系。
- 不引入自动 commit、issue tracker、PRD 发布或外部 workflow 假设。
- 不改变当前 skill invocation 方式。

## 自检

- 占位符检查：没有未完成占位标记。
- 范围检查：这是吸收外部实现纪律的单一设计，不规定具体实现 diff。
- 兼容性检查：不兼容的 TDD、自动 commit、issue-tracker、Invocation 分层、skill 质量词汇、Deep Module / Seam 和 Design It Twice 假设已明确排除。
- 歧义检查：每个建议吸收的概念都有建议目标和适用边界。

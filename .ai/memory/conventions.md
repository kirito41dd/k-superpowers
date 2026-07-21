# 项目约定

<!-- SUMMARY
覆盖范围：项目特定的代码风格、命名规则、目录结构、流程约定
条目数：16
最近更新：2026-07-21
高频标签：#skills #memory #iteration #personalization #codex #claude-code #brainstorming #opencode #install #verification #type-driven #version #comments #routing #prompt #judgment-first
-->

## 说明

- 仅记录项目特定约定，不记录语言通用规范。
- 用户明确纠正过的做法优先记录。
- 与通用规范冲突时，项目约定优先。

## 写入格式

```
## YYYY-MM-DD 一句话约定标题

- **约定**：具体规则
- **理由**：为什么这么定
- **反例**：错误写法示范（可选）
- **正例**：正确写法示范
- **范围**：影响哪些模块 / 文件类型
```

---

## 2026-07-21 把 Agent 当作聪明的智能体

- **约定**：Skill 是给智能 Agent 的行为指导，不是确定性程序。只明确目标、职责、授权边界、需要用户决定的关键事项和成功标准；除真实外部协议外，把局部判断、措辞、读取和工具顺序、输出组织交给 Agent。每条新增约束都必须能对应明确的高价值风险或真实使用问题，不能用流程完整度、Review 次数或测试规模代替交付价值。
- **理由**：模型能力和任务上下文持续变化，冻结局部执行路径会消耗上下文、降低速度并诱发 review/fix 循环。最小充分约束能保留 Agent 的判断力，同时显式边界保护不可逆行为。
- **反例**：要求固定首字符、精确行数、逐字 role prompt、固定读取顺序或无退出条件的反复复审，仅因为模板存在就强制 plan、worktree、SDD 或模型验证。
- **正例**：说明完成目标、禁止动作和所需证据，让 Agent 选择高效路径；真实问题出现后做一次最小编辑和一次自审，再交回真实任务验证。代码产出继续遵循类型/API 优先和核心解释性注释 owner。
- **范围**：`AGENTS.md`, `skills/*`, `docs/skills-overview.zh.md`, `README.md`。

---

## 2026-07-21 Skill 修改采用一次编辑一次自审

- **约定**：Skill 修改以真实使用反馈为输入，默认只做一次聚焦编辑和一次自审；检查直接修改的 skill、其活跃引用、矛盾措辞以及必要的 shell/JSON/diff 等零成本边界。不新增或维护持久测试、fixture、snapshot、eval matrix、ablation、golden output，也不默认调用任何付费模型验证。只有用户明确要求并接受成本时才运行模型验证。单次随机模型输出不定义回归，非阻断 review 建议进入后续迭代。
- **理由**：skills 是给智能 agent 的行为指导，模型能力与上下文会持续变化；把随机输出固化为测试会造成过拟合、review/fix 循环、交付延迟和不可控成本。
- **反例**：每次改 prompt 都跑多模型 campaign；一次 reviewer 偏离就修改产品约束并全量复测；review 发现可选优化后反复扩大 scope。
- **正例**：根据真实任务的明确问题调整最小文本，自审行为边界和注释契约，运行廉价静态检查后交付；新问题在下一次真实反馈中独立处理。
- **范围**：`skills/*`, `README.md`, `docs/skills-overview.zh.md`。

---

## 2026-07-21 日常问答走 No Task Skill 且 Prompt 瘦身不得弱化注释契约

- **约定**：普通知识问答、闲聊和无需仓库/工具/workflow 的解释应直接回答，入口 bootstrap 不等于必须调用 task skill，也不得输出 skill 公告或流程 ceremony。只有当前阶段确有 owner 时才加载最小充分 skill。任何 prompt/skill 瘦身都必须保留 `#2026-07-15-核心代码说明由-type-driven-verification-单一拥有` 的传播链：核心解释要求、项目/邻近文件决定的注释形式与语言、self-explanatory 排除，以及 implementer/reviewer 的独立自包含检查。
- **理由**：用户明确指出日常问答可能完全不需要 skill，并要求现有代码注释产品行为不受优化影响。把 no-skill 作为合法终态可减少误路由；把注释契约作为行为 gate 可避免 owner 去重时静默删除关键质量要求。
- **反例**：回答常识问题前加载 brainstorming；因对话使用中文就改写项目英文注释；用注释数量代替核心抽象契约检查；为缩短 subagent prompt 删除 caller/invariant/lifecycle/protocol 要求。
- **正例**：日常问答直接作答；变更请求只加载当前 owner；非自解释核心抽象按项目语言解释 purpose、caller、invariant、生命周期和协议/状态转换，自解释 helper 不加复述注释。
- **范围**：`skills/using-superpowers/SKILL.md`, `skills/type-driven-verification/SKILL.md`, `skills/writing-plans/SKILL.md`, `skills/executing-plans/SKILL.md`, `skills/subagent-driven-development/*`, `skills/requesting-code-review/*`。

---

## 2026-07-15 核心代码说明由 type-driven-verification 单一拥有

- **约定**：核心结构、函数和抽象的解释性注释/文档原则由 `skills/type-driven-verification/SKILL.md` 完整拥有；`writing-plans` 和 generic code reviewer 只引用该 owner，避免在高频 skill 中复制整套规则。SDD implementer/reviewer prompt 因子 Agent 上下文独立，可保留直接且自包含的要求。完整内容原则继续以 `#2026-07-07-skill-写代码时的注释原则` 为准。
- **理由**：注释是所有实现路径的核心代码产出质量，不能只覆盖 SDD/Full；同时单一 owner 能补齐 Compact/Inline 覆盖而不让 skill 再次膨胀。
- **反例**：只在 SDD prompt 保留规则，导致 Compact/Inline 无直接约束；或在每个 execution/review skill 中重复完整注释清单。
- **正例**：`type-driven-verification` 定义“非自解释的核心代码需要说明、解释哪些非显然契约、避免哪些噪音”，plan 和 generic review 各用一句引用传播要求。
- **范围**：`skills/type-driven-verification/SKILL.md`, `skills/writing-plans/SKILL.md`, `skills/requesting-code-review/code-reviewer.md`, `skills/subagent-driven-development/*`, `docs/skills-overview.zh.md`。

---

## 2026-07-14 Rust 哲学只评价代码产出并按目标语言能力适配

- **约定**：本 fork 所说的“吸收 Rust 哲学”，只评价 agent 使用 skills 完成用户需求时的领域建模、类型/API 设计、错误与资源 ownership、边界校验和测试选择，不把 workflow 是否像 Rust 类型系统作为验收证据。优先用目标语言现有能力排除非法状态：Rust 使用 enum/newtype/ownership/lifetime/穷尽匹配；TypeScript 使用 discriminated union 并在 JSON/API 边界做 runtime schema 校验；Go 使用明确 struct/constructor、小 interface 和显式 `error`；动态语言使用 validator、明确数据模型和窄 API。类型能力越弱，必要运行时验证越多。测试只保护静态系统无法证明的核心语义与高价值回归；不为类型已证明约束、机械 glue 或简单配置修复机械增加测试。
- **理由**：用户长期经验是强类型约束加少量核心测试通常优于强制逐测试流程；skills 又服务多语言项目，因此应保留工程哲学而非 Rust 专属语法。Workflow 的显式状态、单一 owner、handoff 等属于独立流程工程原则。
- **反例**：在 TypeScript 中把未经校验的 JSON 直接断言为静态类型；在 Go 中为模仿 Rust 引入低收益包装层；reviewer 仅因“没有新增测试”报 finding；用 skill 的 Compact/Full 状态机证明 Rust 哲学已保留。
- **正例**：先通过类型/API/可见性排除非法状态，在不可信边界校验，只为剩余 runtime risk 写聚焦测试；reviewer 指出具体非法组合或未证明行为后才要求类型调整或测试。
- **范围**：`skills/type-driven-verification`, `skills/writing-plans`, SDD brief/report/reviewer prompts, generic review, `docs/skills-overview.zh.md`, `README.md`。

---

## 2026-07-08 Skill 验证命令与代码注释 source-of-truth

- **约定**：Skill 生成计划或执行任务时，验证命令优先复用 CI、项目脚本、package/task 配置或项目记忆中的最小相关命令，不自动扩大 target/suite/matrix scope；代码注释、doc comments、docstrings、接口注释的语言和风格优先跟随项目指令和邻近文件，会话语言只影响用户可见文本。
- **理由**：避免 agent 把项目既有 lint/test gate 泛化成更宽 target 导致无关噪音，也避免通用语言适配规则覆盖仓库的代码注释约定。
- **反例**：计划把项目已有的窄 lint 命令升级成全量 target；因为会话是中文就强制把所有代码注释改成中文，忽略邻近文件风格。
- **正例**：从 CI 或项目脚本复制最小相关验证命令；只有在明确标为 optional broader check 或先获确认后才跑更宽检查；代码注释语言按项目指令和局部风格选择。
- **范围**：`skills/writing-plans/SKILL.md`, `skills/subagent-driven-development/*`, `docs/skills-overview.zh.md`

## 2026-07-07 Skill 写代码时的注释原则

- **约定**：Skill 引导 agent 写代码时，核心结构、核心函数、核心抽象默认应有解释性注释/文档，除非它们确实自解释。注释形式跟随语言和项目习惯（如 doc comment、docstring、接口注释或普通邻近注释），内容应说明它表示什么、如何使用、关键不变量、生命周期语义、协议边界或状态转换。避免只复述明显赋值、命名或控制流的噪音注释。
- **理由**：用户希望核心结构/函数/抽象附近有必要说明，但不希望形成机械注释覆盖率；注释的价值包括解释代码本身表达不出的意图，也包括降低人类理解核心代码的成本。
- **反例**：只在非显然实现附近零散补注释，却不给核心公开类型、抽象接口、入口函数或状态模型任何说明；给每个字段赋值、循环或显而易见的函数名写复述性注释。
- **正例**：在核心类型、抽象接口、状态机转换、协议边界、复杂算法、不变量维护点附近，用项目既有注释语言解释“这是什么 / 怎么用 / 为什么这样做 / 保护什么约束”；如果命名、类型和上下文已经足够自解释，则不额外注释。
- **范围**：`skills/writing-plans/SKILL.md`, `skills/type-driven-verification/SKILL.md`, `skills/subagent-driven-development/*`, `skills/requesting-code-review/*`, `docs/skills-overview.zh.md`

## 2026-06-25 重要变更必须更新插件版本号

- **约定**：每次重要变更后都要 bump k-superpowers 版本号，让 Codex app / Claude Code 等 agent 产品能直观看出本地插件是否更新。需要同步更新根 `package.json`、`.codex-plugin/plugin.json`、`.claude-plugin/plugin.json`、`.claude-plugin/marketplace.json`，以及 README 中展示的验证版本号。
- **理由**：本 fork 通过本地 marketplace / 本地路径安装，产品界面和 CLI 列表常依赖 manifest 版本判断是否有新版本；不 bump version 会让安装侧看不出 skill 行为已变化。
- **反例**：修改 `skills/*` 或插件 manifest 后仍保持旧版本号。
- **正例**：吸收外部 skill 实现纪律后，将 `5.1.0` bump 到 `5.1.1` 并同步 README 预期输出。
- **范围**：`package.json`, `.codex-plugin/plugin.json`, `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `README.md`

## 2026-06-25 Skill 实现纪律吸收边界

- **约定**：吸收外部 skill 设计时优先选择能直接提升实现质量、且符合类型优先哲学的纪律：bug-specific feedback loop、vertical slice planning、Spec / Standards 双轴 review、通过真实入口测试行为。不吸收 Invocation 分层、`writing-great-skills` 的质量词汇体系、Deep Module / Seam 词汇体系、Design It Twice。
- **理由**：用户明确希望保持当前 invocation 模式，且不希望引入看不懂或过重的架构词汇和设计流程；保留的四点能直接改善 agent 修 bug、写计划、做 review 和写测试的质量。
- **反例**：把外部 skills 整套复制进本 fork；引入 `disable-model-invocation` 分层；把 Deep Module / Seam 作为默认架构语言；要求高风险接口必须 Design It Twice。
- **正例**：bugfix 前建立能捕获具体症状的 feedback loop；计划任务默认按可独立验证的 vertical slice 切；review 输出分 Spec Findings 和 Standards Findings；测试优先通过 public API / CLI / HTTP handler / parser entrypoint / 状态机 transition 等真实入口。
- **范围**：`skills/systematic-debugging/SKILL.md`, `skills/writing-plans/SKILL.md`, `skills/type-driven-verification/SKILL.md`, `skills/requesting-code-review/*`, `skills/subagent-driven-development/*reviewer-prompt.md`, `docs/skills-overview.zh.md`

## 2026-06-10 三条安装链路并列维护，CC 插件命名 k-superpowers

- **约定**：仓库只维护三条安装链路——Claude Code 本地 marketplace（`.claude-plugin/`，插件 `k-superpowers@k-superpowers-dev`）、Codex app 本地 marketplace（`.agents/plugins/`）、OpenCode git/本地安装。不维护 Cursor、Gemini 等其它生态 manifest，不走任何官方 marketplace 发布。skill 交叉引用命名空间统一写 `k-superpowers:<skill-name>`。
- **理由**：用户主用 CC 与 Codex 本地安装；CC 插件与官方 superpowers 同名会冲突，且 `superpowers:` 交叉引用会解析到官方插件。
- **反例**：恢复 `gemini-extension.json` / `.cursor-plugin`；新写的 skill 交叉引用用 `superpowers:xxx`。
- **正例**：新 skill 引用写 `k-superpowers:writing-plans`；CC 安装用 `/plugin marketplace add <仓库根>` + `/plugin install k-superpowers@k-superpowers-dev`，并先卸载官方 superpowers。
- **范围**：`.claude-plugin/*`, `.agents/plugins/*`, `.opencode/*`, `skills/*`, `hooks/session-start`, `tests/*`, `README.md`

## 2026-05-22 Codex app 本地 marketplace 使用仓库根目录

- **约定**：Codex app 添加本地市场时填写仓库根目录 `/Users/kirito/my/k-superpowers`，不要填写 `.agents/plugins/marketplace.json` 文件路径；仓库内维护 `.agents/plugins/marketplace.json` 和 `plugins/k-superpowers -> ..`。
- **理由**：Codex app 要求 local marketplace source 是目录，且目录根需要包含 `.agents/plugins/marketplace.json`；直接选择 JSON 文件或 `~/.agents/plugins` 会报 marketplace manifest 不支持或列表为空。
- **反例**：把 `/Users/kirito/.agents/plugins/marketplace.json` 或 `/Users/kirito/.agents/plugins` 作为 Codex app 本地市场。
- **正例**：添加 `/Users/kirito/my/k-superpowers`，安装 `k-superpowers@k-superpowers-dev`，用 `codex plugin list | grep k-superpowers` 验证 `installed, enabled`。
- **范围**：`.agents/plugins/marketplace.json`, `plugins/k-superpowers`, `.codex-plugin/plugin.json`, `README.md`

## 2026-05-21 测试只保护核心行为和回归风险

- **约定**：不要默认要求所有 feature/bugfix 严格 TDD。优先用类型、接口、模块边界、可见性、所有权等表达不变量；测试用于保护核心逻辑、公共行为、bug 回归和类型无法证明的风险。
- **理由**：这是受 Rust 哲学影响的个人 fork；blanket test-first 成本高，类型系统和编译器应承担更多正确性约束。
- **反例**：要求每个私有 helper、机械改名、简单 glue code 都先写 failing test。
- **正例**：对 parser、算法、状态机、协议、核心业务逻辑、回归 bug 写聚焦单测或属性测试；对类型可证明的约束通过编译器验证。
- **范围**：`skills/type-driven-verification/SKILL.md`, `skills/writing-plans/SKILL.md`, `skills/systematic-debugging/SKILL.md`

## 2026-05-21 优先维护 OpenCode 安装链路

> [DEPRECATED 2026-06-10] 已被「三条安装链路并列维护，CC 插件命名 k-superpowers」取代：CC/Codex 本地 marketplace 与 OpenCode 并列，不再以 OpenCode 为优先。

- **约定**：本 fork 的安装引导优先维护 OpenCode 的 git-backed plugin、本地路径安装，以及 Codex app 的仓库级本地 marketplace；Claude Code、Cursor、Gemini 等 marketplace manifest 暂不作为主要安装方式，不做批量重命名。
- **理由**：这是自用 fork，当前主要在 OpenCode 使用；全生态改名会引入发布、manifest、测试和 marketplace 维护成本。
- **反例**：一次性把 `.claude-plugin`、`.codex-plugin`、`.cursor-plugin`、`gemini-extension.json` 全部改名但没有对应发布链路。
- **正例**：README 明确推荐 OpenCode 使用 `k-superpowers@git+https://github.com/kirito41dd/k-superpowers.git` 或 `file:///Users/kirito/my/k-superpowers`，Codex app 本地市场添加 `/Users/kirito/my/k-superpowers`。
- **范围**：`README.md`, `docs/README.opencode.md`, `.opencode/INSTALL.md`, `package.json`, `.agents/plugins/marketplace.json`, `.codex-plugin/plugin.json`

## 2026-05-21 预热型请求不触发 brainstorming

- **约定**：当用户说“熟悉开发规范 / 熟悉模块 / 先看项目 / 等我给需求”等预热型请求时，只读取相关上下文并等待后续需求，不触发 `brainstorming`，不问设计问题，不写 spec/plan。
- **理由**：用户经常先要求 agent 熟悉上下文，需求稍后才给；过早进入脑暴会打断工作流。
- **反例**：用户说“熟悉 xx，然后我给你需求”后立即提出方案、追问需求澄清或创建设计文档。
- **正例**：读取指定规范或模块，简要总结关键点，然后等待明确的 build/change/fix 请求。
- **范围**：`skills/using-superpowers/SKILL.md`, `skills/brainstorming/SKILL.md`

## 2026-05-21 Skill 正文变更必须先评估

> [DEPRECATED 2026-07-21] 其中压力场景和 before/after eval 要求已被「Skill 修改采用一次编辑一次自审」取代；先明确行为边界、做静态审查和反例检查的原则继续有效。

- **约定**：修改 `skills/*/SKILL.md` 前采用类型优先、风险驱动验证，而不是默认 RED-GREEN-REFACTOR。先明确行为不变量、触发条件、禁止状态和影响范围；小范围措辞/流程 gate 变更可通过静态审查、反例检查和相关文本搜索验证。只有高风险行为塑造、触发条件、subagent 流程或容易误触发/漏触发的改动，才需要构造压力场景或 before/after eval。
- **理由**：这是个人 fork，更接近 Rust 哲学：优先让规则边界和非法状态清晰可证明，测试/压力场景用于覆盖类型和静态审查无法证明的行为风险；不把所有改动都套进 TDD 红绿灯仪式。
- **反例**：为了任何一行 skill 文案改动都强制跑 RED/GREEN；或者为了“更清晰”直接重写 Red Flags、rationalization table、`human partner` 语气而不评估行为风险。
- **正例**：先写出本次变更要保证的不变量，例如“spec/plan 文档必须先 review，批准后才 commit；批准文档不等于允许实现”；再做最小文案调整，搜索旧冲突措辞，必要时补压力场景。
- **范围**：`skills/*/SKILL.md`, `skills/*/*.md` 中会影响 agent 行为的内容。

## 2026-05-21 项目记忆采用渐进式披露

- **约定**：新会话或任务开始只读 `.ai/memory/index.md`，按当前任务关键词再读取相关记忆文件；不要一次性读取整个 `.ai/memory/`。
- **理由**：避免长期记忆造成上下文膨胀，同时保留可追溯的项目历史。
- **正例**：准备改 skill 时先读 `index.md`，再按索引读 `conventions.md` 和 `gotchas.md`。
- **范围**：`.ai/memory/*`, `CLAUDE.md`

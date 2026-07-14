# 研发流程 Skills 瘦身设计

## Flow

Full

## 目标

在不削弱关键研发纪律的前提下，减少研发流程 skills 的注入体积、重复
gate、重复询问和跨 skill 规则漂移。

本次瘦身以本 fork 已吸收的 Rust 哲学为首要不变量：优先通过类型、状态、
所有权和显式边界排除错误，再用少量核心单测及风险匹配的运行时验证覆盖
编译器无法证明的语义。目标不是单纯减少词数，而是把重复散文压缩成更明确
的状态机、owner contract 和失败路径。

当前 14 个 `SKILL.md` 合计约 19,771 词。预期在保留行为不变量的基础上降至
约 10,000-12,000 词；词数是观察指标，不是验收 gate。若压缩与行为清晰度
冲突，以行为正确性为准。

### Rust 哲学的适用范围

本设计所说的“保留 Rust 哲学”，专指 agent 使用这些 skills 完成用户需求时，
如何分析领域、设计类型与接口、实现代码、处理错误、选择测试和执行 review。
它不要求 skill 文档、agent 编排或研发流程本身模仿 Rust 类型系统。

流程状态、单一 owner、handoff 和失败 gate 的收敛是本次独立的工作流优化
方法，不作为“已保留 Rust 哲学”的验收证据。Rust 哲学是否保留，只看最终
产出的代码设计与验证行为：是否优先通过类型和边界排除错误、是否显式处理
错误和所有权、是否只为编译器无法证明的核心语义保留少量测试。

## 背景

现有 skills 已完成 Compact/Full、风险自适应 SDD、类型优先验证和显式 Git
授权等定制，但同一纪律经常同时出现在 Overview、流程图、Checklist、Red
Flags、rationalization 表、示例和总结中。更强的模型不再需要如此多同义
说服文本；重复定义反而带来以下问题：

- 高频 skill 注入成本过高，关键约束被大量解释性文本稀释。
- handoff、workspace、review、completion evidence 等规则存在多个 owner，
  后续修改容易漂移。
- 已由 Unified Execution Handoff 做出的选择，在执行阶段仍可能被重复询问或
  重新推荐。
- review 依赖 committed SHA range，Inline 未提交修改缺少正式审查入口。
- 部分测试锁定章节措辞，而不是锁定实际禁止状态和状态转换。

## 核心原则

### 写代码时让非法状态不可表示

这是面向 agent 实现代码的首要设计原则，不是本次修改 skill 文本的修辞原则。
相关 skills 必须引导 agent 优先使用语言能力消除非法状态，而不是先写宽松数据
结构，再依赖测试覆盖所有错误组合。

在 Rust 中优先考虑：

- 用 enum 代替互相约束的 bool、string tag 和可冲突 flag；
- 用 newtype、私有字段和受控 constructor 区分未校验值与已校验值；
- 在输入边界完成 parse/validate，内部只传递已满足不变量的类型；
- 用 ownership、borrowing 和 lifetime 表达资源归属与生命周期；
- 用 trait、module visibility 和窄 API 限制无效操作；
- 对有限状态使用穷尽匹配，使新增状态必须经过编译器检查；
- 仅在状态转换风险足够高时使用 typestate 等更强建模，避免为简单流程制造泛型
  和类型复杂度。

计划、实现和 review 都应先问“这个错误能否由类型和 API 边界排除”，再决定
是否需要运行时检查或测试。Reviewer 发现可表示的非法状态时，应指出具体失效
组合和更合适的类型边界，而不是泛化要求“增加更多测试”。

### Implementation Design Contract

Rust 哲学不能只留在 `type-driven-verification` 的原则段。对包含核心领域逻辑、
公共接口、parser、协议、状态机、资源生命周期或显著错误边界的任务，plan、
task brief、implementer report 和 review 必须传播同一份实现设计合同：

```text
Domain invariants
Invalid states excluded by types or APIs
Untrusted input and validation boundaries
Error and resource-ownership model
Runtime risks the compiler cannot prove
Focused verification for those remaining risks
```

纯文档、格式化、机械 rename 和没有上述风险的简单 glue 不需要填充空合同。
`writing-plans` 负责在适用 task 中定义合同；`task-brief` 原样传递；implementer
按合同实现并报告实际取舍；reviewer 检查代码是否兑现合同。Caller 和 prompt
只引用这些字段，不重新发明一套“type-first”口号。

### 流程状态显式化（独立工作流原则）

本次 skill 瘦身同时要求关键流程决策使用穷尽、互斥的状态表达，而不是模糊
fallback：

- `Flow` 只能是 `Compact | Full`。
- Task risk 只能是 `low | medium | high`；缺失值不能退化为 `low`。
- execution mode 只能来自已批准的 Unified Execution Handoff。
- review input 必须明确为 committed range、working tree 或 review package。
- 未授权、来源不明、证据不足和存在开放 verdict 都是阻断状态，不能静默
  fallback。

瘦身不得把这些穷尽分支改回模糊的“视情况处理”。这一节只约束 skill 工作流，
不是 Rust 哲学保留范围，也不能替代上一节面向实际代码设计的原则。

### 类型优先，少量核心单测

在 Rust 中，默认验证顺序是：

1. 用 newtype、enum、trait、可见性、所有权、生命周期和穷尽匹配表达不变量。
2. 用编译器和静态工具证明类型边界、借用关系和不可达状态。
3. 识别编译器无法证明的核心业务语义、算法、parser、协议、状态机和回归风险。
4. 只为这些剩余风险添加聚焦单测或必要的集成验证。

不为机械 glue、简单 private helper、类型已经证明的约束或覆盖率指标编写
仪式化测试。对其他语言按能力梯度适配，不机械复制 Rust wrapper 或 typestate：
优先使用该语言已有的封闭 union/enum、受控构造、模块可见性和穷尽检查；JSON、
网络、数据库和动态输入等不可信边界必须运行时校验；Go 显式传播 `error`，
TypeScript 不能把静态类型当作运行时验证，动态语言依赖窄 API 和边界 validator。
只有当约束收益大于额外抽象成本时才增加包装类型。

reviewer 不能仅以“没有新增测试”作为 finding；必须指出类型和现有验证无法
覆盖的具体行为风险。

### 一个不变量一个 Owner

| 不变量 | 唯一完整 owner | 其他 skill 的职责 |
|--------|----------------|-------------------|
| Skill 发现与 Intent Gate | `using-superpowers` | 只声明 required sub-skill |
| Compact/Full 与设计批准 | `brainstorming` | 消费已批准设计 |
| Plan contract 与 Unified Handoff | `writing-plans` | 消费 handoff，不重新选择 |
| Workspace 创建与 provenance | `using-git-worktrees` | 只传入已选 workspace 模式 |
| Task risk schema 与初始分类 | `writing-plans` | execution 不静默降级 |
| 运行时风险升级与 SDD 路由 | `subagent-driven-development` | reviewer 报告新风险，不重写计划 |
| 实现设计与验证方法 | `type-driven-verification` | plan/brief/report/review 传播合同 |
| Review 输入与输出协议 | `requesting-code-review` | SDD/Inline 选择输入模式 |
| 完成声明证据 gate | `verification-before-completion` | executor 记录证据并调用 owner |
| Merge/PR/keep/discard | `finishing-a-development-branch` | execution 只判断是否需要进入 |
| Skill 变更风险与验证强度 | `writing-skills` | 具体 skill 不复制 authoring 方法 |

Caller 中只保留触发条件、传入参数和阻断结果，不复制 owner 的完整流程。

### 显式失败传播

setup、验证、review、worktree 创建或 Git 操作失败时，返回实际状态并停止依赖
该结果的后续步骤。禁止：

- worktree 创建失败后静默改为 current workspace；
- 缺失 risk 时默认 low；
- review 缺少一个 verdict 时按通过处理；
- verification 失败后继续作完成声明；
- 未知来源 worktree 按目录名推断为本流程所有并自动清理；
- 用户拒绝 checkpoint commits 后用 stash/patch 模拟 SDD。

## 语义校验和

每个目标 skill 在修改前都要记录以下语义校验和，修改后逐项对照：

```text
Triggers
Valid states
Forbidden states
Owner responsibilities
Authorization boundaries
Failure transitions
Verification obligations
```

允许删除的内容：

- 重复总结、重复 checklist 和重复流程图；
- 历史故事、无法验证的效果数据和多个同义示例；
- 情绪化、威胁式和人格判断式说服文本；
- 已由 owner 完整定义的流程副本；
- 可由明确状态、接口和失败分支直接推导的教学解释。

不得仅为达成词数目标删除语义校验和中的任何项目。

## 主流程瘦身

### `using-superpowers`

正文只保留：指令优先级、skill-first 规则、Intent Gate、process-skill 路由和
平台映射入口。删除重复 DOT 流程和大部分 rationalization 表。

Bug、测试失败和 unexpected behavior 明确先进入 `systematic-debugging`。根因
明确且方案唯一时，进入精简 Compact design approval，不重复根因探索；存在
material design choice 时按正常判定选择 Compact 或 Full。任何行为修改仍保留
设计批准 gate。

### `brainstorming`

保留 Compact/Full 穷尽判定、设计批准 hard gate、material delta gate 和 spec
commit 授权。Checklist、DOT、Process 和 Key Principles 只保留一个权威流程
表示。Full 细节和 visual companion 方法按需加载支撑文件。

瘦身不得把 preparation-only 请求重新送入设计流程，也不得允许 Compact 从
“信息缺失”推导出来。

### `writing-plans`

正文保留 Compact contract、Global Constraints、Task Risk、必要 Interfaces、
验证要求和 Unified Execution Handoff。Full 的长模板、routine 示例和占位符
说明移入支撑文件，只有 Full flow 才加载。

计划默认先定义类型/API/ownership 边界，再列出类型无法证明的行为验证。测试
不是固定步骤；只有具体剩余风险存在时才进入任务验证设计。

适用 task 使用 Implementation Design Contract；不适用 task 不生成空字段或
机械测试步骤。计划允许纯类型约束、机械 glue 和简单配置修复不新增测试，并
明确由编译、静态检查或具体复现命令承担验证。

Unified Handoff 继续是 implementation、workspace 和 local checkpoint commit
授权的唯一 owner。批准 spec/plan 不等于授权实现或 Git 写操作。

### `executing-plans`

删除用户已选择 Inline 后再次推荐 SDD 的提示。Compact plan 按 task/slice
执行；Full plan 才要求遵循细粒度步骤。执行前 review 只有发现阻断矛盾、缺失
必要决策或 material delta 时才重新询问；非阻断 concern 记录后继续。

current-main Inline 且没有集成请求时，完成验证后原地报告，不进入 branch
finishing。

### `using-git-worktrees`

消费 Unified Handoff，不重复询问 workspace 选择。选择 current workspace 时
完成状态检测后返回，不运行仅适用于新 worktree 的依赖安装和 baseline setup。

`using-git-worktrees` 返回穷尽的 workspace ownership 状态：

```text
manual-owned(marker)
platform-owned(native cleanup handle/tool)
unowned
```

`finishing-a-development-branch` 只消费该状态，不按 `.worktrees/` 等目录名推断
所有权。`platform-owned` 只调用原生工具提供的 cleanup；没有可用 handle/tool
就降为 `unowned` 并保留 workspace。

新增 `skills/using-git-worktrees/scripts/worktree-provenance`，接口为：

```text
worktree-provenance write WORKTREE_PATH
worktree-provenance inspect WORKTREE_PATH
```

两个命令都必须先证明 `WORKTREE_PATH` 的 canonical path 等于
`git -C WORKTREE_PATH rev-parse --show-toplevel`，仓库不是 bare，且
`git-dir != git-common-dir`。Main checkout、普通子目录、bare repository 和
无法解析的路径都拒绝写入或返回 owned 状态。

手动 `git worktree add` 成功后调用 `write`。脚本在该 linked worktree 的
`git rev-parse --git-dir` 下原子写入 `k-superpowers-provenance-v1`，内容固定为
以下 UTF-8 key/value 格式，其中 path 通过 `pwd -P` 得到且不得包含换行：

```text
schema=k-superpowers-worktree-provenance/v1
owner=k-superpowers
path=<canonical-worktree-path>
```

`inspect` 校验文件格式、owner 和 canonical path：匹配输出 `manual-owned` 并
返回 0；marker 缺失输出 `unowned` 并返回 1；损坏、路径不符或 Git 状态异常输出
诊断并返回 2。进入 main checkout 执行 cleanup 前必须先保存 inspect 结果和原
worktree canonical path。Marker 写入失败时停止自动 cleanup 并报告，不退回路径
猜测。

Worktree consent 不扩张为仓库编辑授权。项目内目录未被 ignore 时使用全局
worktree 目录；只有用户另行明确授权时才编辑 `.gitignore`。创建失败后停止并
请求修订 handoff，不静默 fallback。

### `finishing-a-development-branch`

正文只保留触发条件、环境分类、语义选项、破坏性确认和 cleanup ownership。
merge、PR 和 cleanup 命令配方移入按选择加载的支撑文件。

普通分支和 detached HEAD 使用 `MERGE | PR | KEEP | DISCARD` 等语义 action，
不复用会错位的数字执行映射。`DISCARD` 仍要求精确确认。

本地 merge 保留 `git pull`。本次设计不改变其既有语义，也不增加额外网络
授权 gate。

## 质量流程瘦身

### `systematic-debugging`

正文压缩为现有根因 gate、agent-runnable feedback loop、单一假设、最小验证
和三次失败后的架构复查。禁止无假设试改的纪律保持不变。本次只删除重复案例、
说服文本和同义总结，不改变 feedback loop 的前置地位、blocker 语义或三次失败
升级规则；这些行为若要调整，必须单独设计和批准。

### `type-driven-verification`

作为 Rust 类型优先哲学的唯一完整 owner，保留：

- 先设计类型和 API 边界；
- 让非法状态不可表示；
- 测试只覆盖类型无法证明的核心语义与回归风险；
- 测试优先经过 public API、CLI、handler、parser entrypoint 或状态机 transition；
- 编译通过不能替代必要的运行时行为验证。

删除 completion gate、代码注释规范和其他 owner 的流程副本。不恢复 blanket
TDD、test-first、RED/GREEN 或覆盖率导向。

### `verification-before-completion`

保留 fresh evidence before claim 的唯一 owner 地位。`FULL command` 继续表示
完整运行所选验证命令并读取完整输出，不解释为强制运行整个 workspace、全部
target 或全部 matrix。本次不改变既有完成验证策略。

删除人格判断、威胁式措辞、重复 Red Flags、重复示例，以及 requirements、
review 和 delegation 的完整流程副本。Subagent 成功自述仍不是证据；controller
必须检查实际 diff、checkpoint 和记录的验证结果。

## Review 输入协议

### Source 与 Snapshot

`requesting-code-review` 统一拥有两个正交字段：

```text
source = committed-range(BASE_SHA, HEAD_SHA)
       | working-tree(BASE_SHA = current HEAD)

snapshot = live
         | package-v1(PACKAGE_PATH)
```

完整 `ReviewRequest` 还必须包含 requirements/plan、change description、review
scope (`SCOPE_FILE`) 和 verification evidence；这些作为 reviewer 输入与 source、
snapshot 并列，不重复嵌入 diff package。缺少 requirements 或 scope 时返回输入
错误，不允许
reviewer 自行猜测任务目标。

SDD checkpoint 使用 `committed-range + package-v1`。Inline review 使用
`working-tree + package-v1`；只有 reviewer 在同一 controller 上下文立即读取且
工作区在读取期间冻结时才允许 `working-tree + live`。Review 不能为了获得 SHA
range 而要求用户授权 implementation commit。

`SCOPE_FILE` 是排序去重的 NUL-delimited repo-relative path manifest，由 caller
从批准计划、task-owned 路径或用户明确指定范围生成。生成器拒绝 absolute path、
`..`、repo 外路径和空 scope。ReviewRequest、source collector 与 package header
必须消费同一 scope 的 SHA-256；不接受两份独立 scope。Working-tree review 要求 snapshot 时
`BASE_SHA == HEAD`；若 HEAD 已移动，caller 必须重新选择 committed source 或
重新生成 scope/snapshot，不能把 committed delta 隐含进 working-tree diff。

### Working-tree 完整性

将现有 `skills/subagent-driven-development/scripts/review-package` 移到 owner
目录 `skills/requesting-code-review/scripts/review-package`，并扩展为公共生成器：

```text
review-package committed BASE HEAD SCOPE_FILE OUTFILE
review-package working-tree BASE SCOPE_FILE OUTFILE
```

输出 `k-superpowers-review-package/v1` Markdown。公共 header 固定包含 source、
base、head、scope hash、scope paths 和生成时 `git status --short`。Committed body 包含 commit
list、stat 和 `BASE..HEAD` diff；working-tree body 必须分开包含：

```text
git diff                  # unstaged tracked changes
git diff --cached HEAD    # staged tracked changes
untracked files in scope  # text content; binary metadata + content hash
```

Scope 内全部 untracked 文件都必须进入 package，不能由模型主观挑选“相关”文件。
文本文件记录完整内容；binary 记录 path、size 和 SHA-256，并使 reviewer 对无法
检查的内容输出 `CANNOT_VERIFY`。删除和 rename 使用 Git diff 原生表示。Package
通过临时文件加原子 rename 生成。生成前后分别计算 scoped staged binary diff、
unstaged binary diff，以及 untracked path/type/size/content-hash manifest 的组合
SHA-256；任一指纹或 HEAD 变化都失败并删除临时文件。只比较 status letter 不足
以证明内容稳定。

### Review 输出

`requesting-code-review` 定义公共 finding/verdict contract；具体 prompt 只实现
格式，不成为第二 owner：

```text
Finding: severity = Critical | Important | Minor
         axis = Spec | Standards
         file/line, issue, impact, required fix

Spec verdict = PASS | FAIL | CANNOT_VERIFY
Standards verdict = PASS | FAIL | CANNOT_VERIFY
```

Reviewer 只输出非空 findings，按严重度排序。任一 verdict 缺失、`FAIL` 或
`CANNOT_VERIFY` 都阻断推进。SDD 的 `task-reviewer-prompt.md` 和 generic
`code-reviewer.md` 均使用相同轴名和值域。

删除固定 Strengths、重复 Recommendations、长示例输出和空栏目。Reviewer 不
重复 executor 已对 exact checkpoint 运行的 broad verification，除非存在一个
具体、尚未回答的疑点。

### 路由 Owner

- `subagent-driven-development` 只决定哪些 task 必须 review，并选择 review 输入
  source/snapshot；不复制 review schema。
- `executing-plans` 在计划要求或风险需要独立 review 时，生成 exact scope，选择
  `working-tree + package-v1`，并把 package、需求和验证证据交给 reviewer。
- `requesting-code-review` 定义输入 package 和 verdict contract；不重新定义
  SDD task risk。
- `verification-before-completion` 只判断完成声明是否有证据；不决定 review
  次数。
- 同一未变化 checkpoint 不重复 review。Material delta 或新增集成风险才触发
  复审。

## Delegation 与 Skill Authoring

### `dispatching-parallel-agents`

统一 frontmatter 和正文为 `2+ independent tasks`。正文只保留 eligibility、
self-contained prompt contract 和 integration check。删除历史 session、Benefits、
Real-World Impact 和重复案例。

“Subagent 不继承上下文”改为“不依赖继承上下文，显式提供必要输入”，避免把
平台实现细节写成绝对保证。

### `subagent-driven-development`

保留 Task Risk、checkpoint authorization、progress ledger、dirty ownership、
merged reviewer 和 high/cross-task final review。

文件交接是 SDD 的保留不变量：task brief、implementer report、review package 和
progress ledger 继续存放在 `.superpowers/sdd/`，controller 向 subagent 传路径，
不把 bulky artifact 粘贴回主上下文。Context resume 继续以 ledger 和这些文件为
准，不重新派发已完成 task。

`task-brief` 对适用 task 传递 Implementation Design Contract。Implementer report
按同一字段报告实际类型/API 设计、错误与 ownership 取舍及剩余 runtime risk；
不适用 task 不生成空模板。`implementer-prompt.md` 和 `task-reviewer-prompt.md`
引用该合同，reviewer 必须指出具体非法状态或边界缺口，不能泛化要求更多测试。

`task-reviewer-prompt.md` 消费 `requesting-code-review` 的公共 finding/verdict
contract，不拥有另一套 schema。每个 medium/high task 仍由一个 fresh merged
reviewer 在一次 artifact/diff 读取中分别检查 Spec 与 Standards；两个 verdict
独立阻断，不退回两个 reviewer agent。任一轴失败时批量修复全部 findings，随后
由 fresh reviewer 对两个轴做完整复审。High task 和跨 task 集成风险仍追加独立
final whole-change review。Completion evidence contract 改为引用
`verification-before-completion`。

新增 `skills/subagent-driven-development/scripts/task-snapshot`：

```text
task-snapshot capture OUTDIR
task-snapshot check-scope SNAPSHOT_DIR SCOPE_FILE
task-snapshot verify SNAPSHOT_DIR TASK_BASE TASK_HEAD SCOPE_FILE AUTHORIZED_COMMITS_FILE
```

`capture` 以 NUL-safe 格式保存初始 HEAD/status、staged 与 unstaged binary patch，
并保存每个 pre-existing untracked file 的 path、size 和 SHA-256。`check-scope`
发现 pre-existing dirty path 与 task scope 重叠时返回 1；输入或 snapshot 损坏返回
2。`verify` 要求 TASK_BASE 精确等于 snapshot 中捕获的 HEAD，TASK_HEAD 是当前
HEAD 且后代于 TASK_BASE；`AUTHORIZED_COMMITS_FILE` 是 controller 根据 executor
report 记录的完整 commit SHA 列表，必须与 `TASK_BASE..TASK_HEAD` 的 rev-list
完全一致，且每个 commit 的 paths 都是 scope 子集。Pre-existing dirty state 与
hash 必须完全不变，当前 index/worktree 不得有无法解释的新变化；所有权失败
返回 1，工具错误返回 2。主文只保留 capture、
check-scope、verify 三步和任一非零结果停止的规则。

三个新/扩展 shell helper 必须兼容仓库现有 macOS Bash 环境：路径枚举使用 Git
的 `-z` 输出和 NUL-safe 读取，不依赖 GNU `realpath`；canonical path 使用
`cd -- "$path" && pwd -P`。SHA-256 helper 优先使用 `sha256sum`，不可用时使用
`shasum -a 256`，两者都不可用则返回工具错误 2，不能退化为弱 hash。

### `receiving-code-review`

保留理解、验证、技术判断、按根因/依赖分组修复和复验。删除社交措辞教学、
项目无关暗号和重复对话案例。

一个不清楚的 finding 只阻断依赖它或可能与它冲突的工作；其他明确且独立的
finding 可以继续处理。多个共享根因的 finding 允许作为一个原子批次修复，
不机械逐项重复构建和测试。

### `writing-skills`

主文只保留 mode selection、语义不变量、风险矩阵、Iron Law、verification
routing 和适用项 checklist。Pressure scenario 的构造、rationalization plugging
和 campaign 方法只由 testing 支撑文件完整定义。

本 fork 的 description 规则仍是“只描述触发条件，不泄露 workflow”。官方参考
文件作为背景资料，不得与本地规范形成两个有效 source of truth；需要保留原始
资料时，明确标为 non-normative reference。

## 文件范围

主要修改：

- `skills/using-superpowers/SKILL.md`
- `skills/brainstorming/SKILL.md`
- `skills/brainstorming/full-flow.md`（新增，承载 Full 专属细节）
- `skills/brainstorming/visual-companion.md`
- `skills/writing-plans/SKILL.md`
- `skills/writing-plans/full-plan-guide.md`（新增，承载 Full 模板）
- `skills/using-git-worktrees/SKILL.md`
- `skills/using-git-worktrees/scripts/worktree-provenance`（新增）
- `skills/executing-plans/SKILL.md`
- `skills/finishing-a-development-branch/SKILL.md`
- `skills/finishing-a-development-branch/git-actions.md`（新增）
- `skills/systematic-debugging/SKILL.md`
- `skills/type-driven-verification/SKILL.md`
- `skills/type-driven-verification/testing-anti-patterns.md`
- `skills/verification-before-completion/SKILL.md`
- `skills/requesting-code-review/SKILL.md`
- `skills/requesting-code-review/code-reviewer.md`
- `skills/requesting-code-review/scripts/review-package`（从 SDD 移入并扩展）
- `skills/receiving-code-review/SKILL.md`
- `skills/dispatching-parallel-agents/SKILL.md`
- `skills/subagent-driven-development/SKILL.md`
- `skills/subagent-driven-development/task-reviewer-prompt.md`
- `skills/subagent-driven-development/implementer-prompt.md`
- `skills/subagent-driven-development/scripts/task-brief`
- `skills/subagent-driven-development/scripts/task-snapshot`（新增）
- `skills/writing-skills/SKILL.md`
- `skills/writing-skills/testing-skills-with-subagents.md`
- `skills/writing-skills/anthropic-best-practices.md`

同步修改：

- `docs/skills-overview.zh.md`
- `tests/claude-code/test-compact-development-flow.sh`
- `tests/claude-code/test-requesting-code-review.sh`
- `tests/claude-code/test-subagent-driven-development.sh`
- `tests/claude-code/test-subagent-driven-development-integration.sh`
- `tests/claude-code/test-worktree-native-preference.sh`
- `tests/claude-code/test-worktree-provenance.sh`（新增）
- `tests/claude-code/test-review-package.sh`（新增）
- `tests/claude-code/test-task-snapshot.sh`（新增）
- `tests/claude-code/test-type-driven-behavior.sh`（新增）
- `tests/claude-code/run-skill-tests.sh`
- `package.json`
- `.codex-plugin/plugin.json`
- `.claude-plugin/plugin.json`
- `.claude-plugin/marketplace.json`
- `README.md` 中 Rust 代码产出哲学与独立 workflow 工程原则的术语边界，以及
  展示版本

项目记忆不在未授权情况下修改。Spec 批准后单独询问是否把“Rust 哲学只评价
agent 产出的代码设计与验证行为”追加到 `.ai/memory/`；获批后按项目记忆流程
更新 `decisions.md`、`conventions.md` 和 `index.md`，不改写历史条目。

## 非目标

- 不新增新的顶层 workflow skill。
- 不改变 Compact/Full 总体架构。
- 不恢复 blanket TDD、test-first 或覆盖率目标。
- 不取消设计批准、显式 Git 授权、根因调查、完成验证或风险 review。
- 不删除或改变 local merge 中的 `git pull`。
- 不把所有验证改成全 workspace，也不引入新的“最小充分验证”政策。
- 不新增任何未经 Unified Handoff 或用户单独授权的 commit、push、merge、PR、
  amend 或 force 操作；已授权 SDD checkpoint commits 保持不变。
- 不为兼容历史文本保留已无调用方的重复章节。

## 实施 Campaign

每个 campaign 是一个 coherent behavior contract，独立记录 before/after semantic
checksum，完成对应验证和 review 后再进入下一个：

1. **Implementation philosophy**：`type-driven-verification`、`writing-plans` 的
   Implementation Design Contract、brief/report/reviewer 传播和语言能力梯度。
2. **Review protocol**：公共 source/snapshot、package v1、finding/verdict contract、
   Inline caller 和 SDD consumer。
3. **Workspace lifecycle**：worktree ownership 状态、provenance helper、`.gitignore`
   授权、detached actions 和 cleanup。
4. **Main flow slimming**：`using-superpowers`、`brainstorming`、plan 主文、Inline
   execution 和 Full 支撑文件；不修改 debugging 核心纪律。
5. **Debugging slimming**：只压缩 `systematic-debugging` 的重复文本，单独验证现有
   feedback loop 和三次失败升级。
6. **Completion slimming**：只压缩 `verification-before-completion`，验证 fresh
   evidence gate 和 `FULL command` 语义不变。
7. **Delegation slimming**：parallel dispatch、SDD task-boundary helper、prompt 和
   ledger contract；review 协议只作为已验证依赖消费。
8. **Review reception slimming**：独立处理 finding 分组、技术验证和复验，不与
   requesting-review 协议混为一个 campaign。
9. **Skill authoring slimming**：最后压缩 `writing-skills` 及支撑资料；它负责前八
   个 campaign 的验证方法，不能提前改变。

词数统计与文档/manifest/version 同步在每个 campaign 收尾执行；重要版本号在
全部 campaign 完成后统一 bump 一次，避免制造无意义版本 churn。

## 验证策略

这是高风险 behavior-shaping 修改。使用当前走查和用户反馈作为 observed
baseline，不为同一失败重复构造 synthetic baseline。每个 campaign 从下方矩阵
选择 2-3 个覆盖不同 failure class 的场景，运行一次 campaign review、一次 batch
fix 和一次 re-review；只有出现新 failure class 时扩展。全部 campaign 完成后再
运行一次跨 owner whole-change review。

### 静态检查

- 所有 frontmatter description 只描述触发条件。
- `test-driven|TDD|RED-GREEN|test-first` 在 active skills 中保持零命中。
- 同时检查无条件 `add/write a test`、每 task 固定 test step、所有 bug 强制
  regression test 和 coverage gate 等语义回流；禁词零命中不是充分证据。
- handoff、workspace、review、completion 等不变量各只有一个完整 owner。
- 没有 caller 复制完整 review schema 或 completion evidence contract。
- 没有缺失 risk 默认 low、worktree 失败静默 fallback、未知 provenance 自动
  cleanup 等文案。
- 插件版本、manifest 和 README 展示版本一致。
- 记录每个 `SKILL.md` 修改前后的词数，但不设机械失败阈值。
- 每个 campaign 产出一份 before/after semantic-checksum 表，reviewer 逐项给出
  preserved/changed 及证据；没有该 artifact 不能以“更短”宣告完成。

### 行为场景

1. **Rust domain modeling**：输入任务包含冲突 bool/string tag、未校验外部值、
   可吞掉错误和资源生命周期。计划与实现必须使用适当 enum/newtype/私有构造、
   边界 parse、显式 `Result` 和清晰 ownership；测试只覆盖编译器无法证明的业务
   语义。Reviewer 必须抓到故意保留的可表示非法状态。
2. **No-test is correct**：纯类型约束、机械 glue 和简单配置修复允许零新增测试，
   以编译、静态检查或具体复现验证；plan/reviewer 机械要求测试即失败。
3. **Language gradient**：TypeScript 外部 JSON 使用 runtime schema 后进入窄 union，
   不把静态类型当校验；Go 使用受控构造和显式 `error`，不为模仿 Rust 增加低
   收益 wrapper。至少选一个非 Rust 场景运行。
4. **Intent routing**：Preparation-only 只读上下文；清晰功能用 Compact；不可逆
   变更用 Full；Bug 先 debugging，根因明确后仍经过 Compact 或 Full design
   approval，不重复根因探索。
5. **Inline execution**：current workspace 不重新推荐 SDD、不运行新 worktree
   setup、不显示 finishing 菜单；风险需要 review 时调用 working-tree package。
6. **Workspace ownership**：分别验证有效 manual marker、marker 缺失、损坏、路径
   不符和写入失败；main checkout、普通子目录和 bare repo 不能获得 owned 状态；
   只有有效 linked-worktree marker 可自动 manual cleanup。Native cleanup handle
   只走平台工具；unowned 一律保留。
7. **Worktree placement**：未忽略 project-local path 自动使用 global path；只有
   单独明确授权才编辑 `.gitignore`；创建失败不静默 fallback。
8. **Finish actions**：Detached PR/Keep/Discard 分别进入正确语义 action，Discard
   要求精确确认；local merge 继续执行既有 `git pull`。
9. **Working-tree package**：`BASE == HEAD`，scope 同时包含 unstaged、staged、
   rename/delete、全部 scoped untracked 文本及 binary hash；生成期间 HEAD/status
   或完整内容指纹变化必须失败，request/package scope hash 不一致也必须失败，且
   流程不请求 implementation commit。
10. **Committed package**：SDD checkpoint 使用 committed-range + package-v1，
    commit list/stat/diff 与 scope 一致；同一未变化 checkpoint 不重复 review。
11. **Verdict contract**：两个 prompt 都输出 `Spec`/`Standards` 与公共值域；缺失、
    `FAIL` 或 `CANNOT_VERIFY` 任一轴都阻断推进。
12. **Task ownership**：snapshot scope overlap、pre-existing patch/hash 变化、越界
    commit、TASK_BASE 与 captured HEAD 不同、未列入 authorized commit manifest
    的提交或 unexplained dirty state 都被 helper 阻断；正常 task range 通过。
13. **Debugging preserved**：feedback loop 前置、单假设和三次失败架构复查在瘦身
    后仍执行，不采用本 spec 已删除的弱化路径。分别覆盖正常根因闭环、时间压力
    下要求猜修，以及连续三次失败后的停止升级。
14. **Completion preserved**：controller 检查真实 diff 和 fresh evidence；完整运行
    所选 command，但不无条件扩张到全 workspace/target/matrix。分别覆盖 partial
    check 不足、subagent 自述不构成证据和完整运行已选窄命令。
15. **Authoring preserved**：skill 风险分级非零，高风险触发/纪律变更仍使用
    observed 或 synthetic baseline 和 post-change behavioral verification。分别
    覆盖低风险静态审查、高风险 observed baseline 和 description trigger 变更。
16. **Review reception**：不清楚 finding 只阻断相关项；共享根因 findings 原子
    分组修复；技术上错误的 finding 用代码与验证证据 push back。
17. **Parallel eligibility**：两个真正独立的问题并行派发；共享文件、状态或顺序
    依赖的问题保持串行；回收后检查冲突并运行整体验证。

### 测试与命令映射

| Campaign | Deterministic checks | Agent behavior checks |
|----------|----------------------|-----------------------|
| Implementation philosophy | 禁词与无条件测试语义扫描 | `test-type-driven-behavior.sh` 场景 1-3 |
| Review protocol | `test-review-package.sh` | `test-requesting-code-review.sh` 场景 9-11 |
| Workspace lifecycle | `test-worktree-provenance.sh` | `test-worktree-native-preference.sh`、Compact flow 场景 6-8 |
| Main flow | 文本 owner/路由扫描 | `test-compact-development-flow.sh` 场景 4-5 |
| Debugging | semantic checksum | fresh-agent 场景 13 的三个分支 |
| Completion | semantic checksum | fresh-agent 场景 14 的三个分支 |
| Delegation | `test-task-snapshot.sh` | task ownership 场景 12、parallel 场景 17 |
| Review reception | semantic checksum | receiving-review 场景 16 的三个分支 |
| Skill authoring | frontmatter、引用、词数扫描 | writing-skills 场景 15 的三个分支 |

Fast deterministic scripts 加入 `run-skill-tests.sh` 默认集合；需要真实模型的
fresh-agent checks 保持 integration 模式并允许在认证不可用时明确报告 skipped，
不能把 skipped 记为 passed。计划必须复用这些项目 runner，不自行扩张 matrix。

## 成功标准

- Rust 类型优先、少量核心单测的哲学通过 Implementation Design Contract 进入
  plan、brief、implementation report 和 review，而不只存在于 owner 的口号。
- Active skills 中没有 blanket TDD、覆盖率仪式或“没有测试即失败”的 review
  规则。
- 14 个 `SKILL.md` 总词数记录前后差异并以约 10,000-12,000 词为非阻断目标；
  所有 semantic checksum 和行为 gate 通过才是完成条件。
- 高频入口 skill 的正文只保留触发、状态、owner 和关键 gate。
- Unified Handoff 后不重复选择 execution/workspace/commit 模式。
- Review source 与 snapshot 正交，支持 committed 和未提交改动，不制造隐性
  commit 压力。
- Workspace cleanup 基于 manual marker 或 native handle，不基于目录名猜测
  所有权。
- Completion、review 和 task verification 各有唯一 owner，不重复跑同一
  checkpoint 的 broad command。
- `git pull`、完成验证语义和显式 Git 授权边界保持不变。
- 行为测试锁定禁止状态和状态转换，而不是锁定章节标题或同义措辞。
- README 明确区分代码产出哲学与 workflow 工程原则；项目记忆仅在用户另行
  授权后追加澄清。

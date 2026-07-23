# K Superpowers

这是我自用的 Superpowers fork，用来沉淀个人化的 agent 工作流、skills 定制和项目记忆规则。

本仓库不面向上游贡献，也不使用上游 marketplace 发布链路。默认安装方式以 git 或本地路径为主。

## 定制哲学

本 fork 用 Rust-inspired 工程哲学指导 agent 产出的代码设计；workflow 自身采用
独立的流程工程原则，两者不混为一谈。

代码产出哲学：优先使用目标语言的类型、接口和边界排除非法状态，只为静态系统
无法证明的核心语义保留少量测试。Rust 使用 enum/newtype/ownership 等机制；
TypeScript、Go 和动态语言按各自能力增加必要的运行时边界校验，不机械复制 Rust。

Workflow 工程原则：

- **固定边界，不固定路径**：明确目标、owner、权限、material decision 和成功证据；除真实外部协议外，不冻结 agent 的措辞、tool 顺序或局部判断。
- **交付速度是一等指标**：默认使用可逆、低权限、低 ceremony 的 Direct/Inline 路径；只有能降低实际风险或总延迟时才增加 plan、worktree、SDD 或 review。
- **类型优先验证**：用 `type-driven-verification` 取代上游的强制逐测试流程——优先用类型、接口、可见性、所有权表达不变量，测试只保护核心行为、公共 API 和回归风险，不做覆盖率仪式。计划模板同样按"定类型边界 → 实现 → 只测类型证不了的行为 → 验证"展开。
- **一个不变量一个 owner**：同一条政策只在一处完整定义，caller 只传播适用结果和边界，避免多副本漂移。
- **额外权限必须显式**：批准设计并说“改吧”可授权当前 scope 的文件编辑；commit、push、merge、PR、amend、force、discard 和外部写仍需单独授权。
- **零成本抽象**：高频注入的内容只留触发条件、不变量和决策点，流程细节放支撑文件按需加载，与 `.ai/memory/` 的渐进披露同构。

Skill 文本是给持续进化的智能体使用的行为指导，不以固定模型输出作为回归合同。
修改以真实使用反馈为输入，小步迭代并尽快回到实际使用。

## 当前定制重点

- `using-superpowers`：普通问答直接回答；清晰、已批准的变更走 Direct，安全默认是 current workspace + Inline + no commit；独立多任务先完成一次 execution handoff，不强制无价值 ceremony。
- `brainstorming` / `writing-plans`：只有真实取舍才列方案，只有交接价值才落持久 spec/plan；Full 保护 material decision，而不是逐章节审批；符合条件的 plan 主动给出 SDD checkpoint 授权与 Inline no-commit 选择。
- `type-driven-verification`：采用类型优先、风险驱动验证，并单一拥有核心代码与核心测试说明合同。核心测试优先靠行为化命名和结构表达契约，只为非显然不变量、回归背景、特殊 fixture/顺序或关键断言后果补充说明。
- `subagent-driven-development`：只在独立任务且委派收益明确、用户授权本 plan checkpoint commits 时使用。Low 由 controller 处理，medium/high 均有 independent reviewer；final review 只保护真实跨任务 integration risk。
- `requesting-code-review`：所有改动做 controller Spec/Standards 自审；除纯文档/注释/格式、机械 rename/config 和简单 glue 外，非平凡行为与 bug fix 默认触发独立双轴 review，并保持一次 Discovery、一次批量修复、一次 Closure。
- `systematic-debugging`：优先建立 feedback loop；无法复现的生产/外部问题允许证据化、带置信度诊断，无验证不声称 fixed，按信息增益而非固定次数停止。
- `writing-skills`：以真实使用反馈驱动最小修改；不创建持久化测试、eval matrix 或模型 golden output，也不默认调用模型做验证。单次随机输出只作观察，新改进不反复 reopen 当前迭代。
- `CLAUDE.md`：只保留项目记忆规则，后续用于放个人 fork 的 agent 提示。
- `.ai/memory/`：记录本 fork 的长期决策、约定、坑点和术语。
- `docs/skills-overview.zh.md`：中文梳理每个 skill 的核心思想、流程和 `description` 注入效果。

## OpenCode 安装

### Git 安装

在全局或项目级 `opencode.json` 中加入：

```json
{
  "plugin": ["k-superpowers@git+https://github.com/kirito41dd/k-superpowers.git"]
}
```

保存后重启 OpenCode。

验证方式：开启新会话后问：

```text
Tell me about your superpowers
```

### 本地开发安装

如果要直接使用当前 checkout：

```json
{
  "plugin": ["file:///Users/kirito/my/k-superpowers"]
}
```

也可以用普通路径，取决于 OpenCode 当前版本对 plugin path 的支持：

```json
{
  "plugin": ["/Users/kirito/my/k-superpowers"]
}
```

保存后重启 OpenCode。运行中的 OpenCode 不会热加载插件和 skill 变更。

## OpenCode 更新

Git-backed plugin 可能被 OpenCode、Bun 或 lockfile/cache 固定到旧 commit。

如果更新没有生效：

1. 重启 OpenCode。
2. 清理 OpenCode package cache 或重新安装 plugin。
3. 如需固定版本，可在 git spec 后追加分支、tag 或 commit：

```json
{
  "plugin": ["k-superpowers@git+https://github.com/kirito41dd/k-superpowers.git#main"]
}
```

## Codex app 本地市场安装

Codex app 使用本仓库作为本地 marketplace。添加本地市场时填写仓库根目录：

```text
/Users/kirito/my/k-superpowers
```

不要填写 `marketplace.json` 文件路径。Codex app 会读取：

```text
/Users/kirito/my/k-superpowers/.agents/plugins/marketplace.json
```

当前 marketplace 暴露的插件是：

```text
k-superpowers@k-superpowers-dev
```

安装后可用 CLI 验证：

```bash
codex plugin list | grep k-superpowers
```

预期能看到：

```text
k-superpowers@k-superpowers-dev  installed, enabled  5.4.5
```

本地 marketplace 的结构是：

```text
.agents/plugins/marketplace.json
plugins/k-superpowers -> ..
.codex-plugin/plugin.json
skills/
```

如果 Codex app 显示市场已添加但列表为空，先重启 Codex app，再搜索 `k-superpowers` 或 `K Superpowers`。也可以直接运行：

```bash
codex plugin add k-superpowers@k-superpowers-dev
```

## Claude Code 本地市场安装

本仓库根目录同时是 Claude Code 的本地 marketplace（`.claude-plugin/marketplace.json`）。在 Claude Code 中执行：

```text
/plugin marketplace add /Users/kirito/my/k-superpowers
/plugin install k-superpowers@k-superpowers-dev
```

注意：

- 如果装有官方 `superpowers` 插件，先卸载或禁用，避免两套 skills 同时注入、交叉引用解析到官方版本。
- 安装后 skill 命名空间为 `k-superpowers:<skill-name>`，与 Codex 侧命名一致。
- 本地 marketplace 指向当前 checkout，改动 skill 后新会话即生效，无需重新安装。

## 其它生态

本 fork 只维护三条安装链路：Claude Code 本地 marketplace、Codex app 本地 marketplace、OpenCode git/本地安装。Cursor、Gemini 等生态的 manifest 已移除；如果后续需要支持某个生态，再单独梳理对应发布方式和 manifest。

## 项目记忆

新会话先读 `.ai/memory/index.md`，再按任务需要读取相关记忆文件。

写入长期记忆前必须先确认，避免把临时偏好误写成长期规则。

## 参考

- 上游项目：<https://github.com/obra/superpowers>
- OpenCode 文档：<https://opencode.ai/docs/>

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

- **让非法状态不可表示**：规则写成显式分级、owner 和失败转移，不留歧义兜底。例如 `writing-skills` 按效果而非 diff 大小划分低/中/高风险——改措辞但影响触发时机的就是高风险。
- **类型优先验证**：用 `type-driven-verification` 取代上游的强制逐测试流程——优先用类型、接口、可见性、所有权表达不变量，测试只保护核心行为、公共 API 和回归风险，不做覆盖率仪式。计划模板同样按"定类型边界 → 实现 → 只测类型证不了的行为 → 验证"展开。
- **一个不变量一个 owner**：同一条政策只在一处完整定义，其他位置引用。例如 spec/plan 的 commit 审批政策分别收敛到 `brainstorming` 的 Commit Gate 和 `writing-plans` 的 Commit Authorization，避免多副本漂移。
- **显式优于隐式**：commit 必须用户显式授权，批准文档不等于授权实现；意图先分流——普通问答可直接进入 `no task skill`，预热型请求（"先熟悉模块"）只读上下文，不触发 brainstorming。
- **零成本抽象**：高频注入的内容只留触发条件、不变量和决策点，流程细节放支撑文件按需加载，与 `.ai/memory/` 的渐进披露同构。

Skill 文本是给持续进化的智能体使用的行为指导，不以固定模型输出作为回归合同。
修改以真实使用反馈为输入，小步迭代并尽快回到实际使用。

## 当前定制重点

- `using-superpowers`：按当前意图选择最小充分 skill 集。普通知识问答直接回答，不加载任务 skill；preparation/read-only、bug、change、approved-spec planning 和 Unified Handoff 只选择当前需要的 owner，不预加载后续或互斥路径。
- Skill description 只承载触发条件；本轮只修改 behavior evidence 证明存在误触发或漏触发的项，不为统一措辞做全量重写。
- `type-driven-verification`：替代上游旧的强制测试流程，采用类型优先、风险驱动验证，并单一拥有核心代码说明合同。Planning、Inline 与 SDD 都传播该 owner；注释语言跟随项目和邻近文件，不按会话语言切换，也不追求注释数量。
- `subagent-driven-development`：消费 `writing-plans` 的 risk/Unified Handoff、`requesting-code-review` 的 package/verdict 和 completion owner 的证据合同。只有明确授权本计划 local checkpoints 才进入 SDD；merged reviewer 使用独立阻断的 Spec/Standards verdict。
- `writing-skills`：以真实使用反馈驱动最小修改；不创建持久化测试、eval matrix 或模型 golden output，也不默认调用模型做验证。单次随机输出只作观察，新改进不反复 reopen 当前迭代。
- `brainstorming`：明确 preparation-only requests 不是触发条件。
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
k-superpowers@k-superpowers-dev  installed, enabled  5.3.0
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

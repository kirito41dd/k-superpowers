# 项目约定

<!-- SUMMARY
覆盖范围：项目特定的代码风格、命名规则、目录结构、流程约定
条目数：6
最近更新：2026-05-25
高频标签：#skills #memory #eval #personalization #codex #brainstorming #opencode #install #verification #type-driven
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

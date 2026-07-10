# K Superpowers

这是我自用的 Superpowers fork，用来沉淀个人化的 agent 工作流、skills 定制和项目记忆规则。

本仓库不面向上游贡献，也不使用上游 marketplace 发布链路。默认安装方式以 git 或本地路径为主。

## 定制哲学

本 fork 用 Rust 的设计哲学塑造 skill 行为，所有定制围绕这几条原则展开：

- **让非法状态不可表示**：规则写成显式分级和穷尽分支，不留歧义兜底。例如 `writing-skills` 的 Iron Law 是三级风险分级表（低/中/高 → 静态审查/反例推演/压力场景），且按效果而非 diff 大小分级——改措辞但影响触发时机的就是高风险。
- **类型优先验证**：上游的强制 TDD 改为 `type-driven-verification`——优先用类型、接口、可见性、所有权表达不变量，测试只保护核心行为、公共 API 和回归风险，不做覆盖率仪式。计划模板同样按"定类型边界 → 实现 → 只测类型证不了的行为 → 验证"展开。
- **一个不变量一个 owner**：同一条政策只在一处完整定义，其他位置引用。例如 spec/plan 的 commit 审批政策分别收敛到 `brainstorming` 的 Commit Gate 和 `writing-plans` 的 Commit Authorization，避免多副本漂移。
- **显式优于隐式**：验证强度必须匹配行为风险且永远不为零；commit 必须用户显式授权，批准文档不等于授权实现；意图先分流——预热型请求（"先熟悉模块"）只读上下文，不触发 brainstorming。
- **零成本抽象**：高频注入的内容只留触发条件、不变量和决策点，流程细节放支撑文件按需加载，与 `.ai/memory/` 的渐进披露同构。

Skill 文本就是会塑造 agent 行为的代码，按上述原则修改和验证。

## 当前定制重点

- `type-driven-verification`：替代上游的 `test-driven-development`，类型优先、风险驱动验证，相关 skill 已全部清除 TDD/RED-GREEN 残留。
- `using-superpowers`：增加预热型请求判断。“熟悉规范 / 熟悉模块 / 先看项目 / 等我给需求”只读取上下文并等待，不进入 brainstorming。
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
k-superpowers@k-superpowers-dev  installed, enabled  5.1.12
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

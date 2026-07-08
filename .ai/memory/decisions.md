# 技术决策记录

<!-- SUMMARY
覆盖范围：架构决策、技术选型、废弃方案（ADR 风格）
条目数：12
最近更新：2026-07-08
高频标签：#memory #fork #personalization #codex #opencode #claude-code #install #verification #type-driven #skills #sdd
-->

## 写入格式（ADR 风格）

```
## YYYY-MM-DD 一句话决策标题

- **背景**：为什么需要做这个决策
- **选项**：考虑过哪些方案（A/B/C）
- **决策**：最终选择的方案
- **理由**：为什么选这个，放弃其他的原因
- **影响**：影响的模块 / 文件
- **状态**：已实施 / 试验中 / [DEPRECATED 原因]
```

---

## 2026-07-08 强化 SDD task brief 全局约束与复审路由

- **背景**：真实 SDD 执行中，Task 3 的 spec reviewer 发现 brief 细节不足，漏掉 manifest 更新频率和 `tokio::fs::OpenOptions` 等要求。进一步检查发现 `scripts/task-brief` 只抽取 `Task N` 段落，不会带上计划头部的 `Global Constraints`；同时 quality 修复后是否需要回到 spec review 的路由不够明确。
- **选项**：合并 Spec / Standards reviewer 降低调用次数；保留双阶段 reviewer 但增加 brief readiness gate；只修 `task-brief` 不改流程文字。
- **决策**：选择第二项。`task-brief` 输出 `Task N Brief`，包含 `Global Constraints` 和完整 `Task N` 正文；SDD 主流程在派发 implementer 前要求 controller 读取 brief 做 self-contained 检查，必要时追加 `Controller Notes` 或停止澄清；review loop 明确为 spec fix 后重跑 spec review，quality fix 若影响行为、API、配置、manifest、测试、文档、触及文件或任务范围则回到 spec review，行为中性的 quality fix 只重跑 quality review。Spec reviewer 负责检查全局约束，quality reviewer 对会影响 spec 的建议标记 `Requires spec re-review`。
- **理由**：Spec / Standards 双轴 review 仍能避免需求符合度和代码质量混在一起；问题根因是 handoff 信息丢失和复审路由含糊，而不是双 reviewer 本身。把全局约束前置进 brief 并加 readiness gate，能减少 implementer 低上下文猜测；按风险路由复审能控制成本。
- **影响**：`skills/subagent-driven-development/SKILL.md`, `skills/subagent-driven-development/scripts/task-brief`, `skills/subagent-driven-development/spec-reviewer-prompt.md`, `skills/subagent-driven-development/code-quality-reviewer-prompt.md`, `docs/skills-overview.zh.md`, `package.json`, `.codex-plugin/plugin.json`, `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `README.md`
- **状态**：已实施。

## 2026-06-26 跟进上游 v6 SDD 文件交接与进度账本

- **背景**：上游 Superpowers v6.0.0 将 `subagent-driven-development` 的 task brief、implementer report、review diff package 和 progress ledger 改为文件交接，以降低 controller 常驻上下文并支持压缩后恢复。用户要求在本 fork 中吸收这一部分，并明确不同时吸收 reviewer 合并等其它 v6 变化。
- **选项**：整套同步上游 SDD；只吸收文件交接和 progress ledger；暂不跟进。
- **决策**：选择第二项。新增 `skills/subagent-driven-development/scripts/{sdd-workspace,task-brief,review-package}`，将短期产物放到自忽略的 `.superpowers/sdd/`；SDD 主流程改为传 task brief、report、diff package 路径；新增 `progress.md` ledger 恢复规则；implementer prompt 要求详细报告写入 report 文件，最终回复保持简短；两个现有 reviewer prompt 改为读取同一套 brief/report/diff 文件。保留本 fork 的 Spec / Standards 双阶段 review，不吸收上游单 `task-reviewer-prompt.md`。
- **理由**：文件交接能减少重复粘贴任务、报告和 diff 带来的上下文膨胀，progress ledger 能避免上下文压缩后重复派发已完成任务；同时保留双阶段 review 和未授权不提交规则，避免一次引入过多行为变化。
- **影响**：`skills/subagent-driven-development/SKILL.md`, `skills/subagent-driven-development/implementer-prompt.md`, `skills/subagent-driven-development/spec-reviewer-prompt.md`, `skills/subagent-driven-development/code-quality-reviewer-prompt.md`, `skills/subagent-driven-development/scripts/*`, `docs/skills-overview.zh.md`, `package.json`, `.codex-plugin/plugin.json`, `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `README.md`
- **状态**：已实施。

## 2026-06-26 跟进上游 v6 writing-plans 结构增强

- **背景**：上游 Superpowers v6.0.0 发布后，用户已将最新上游拉到 `refs/obra-superpowers`，希望评估哪些调整值得本 fork 跟进。经过 review，决定先只跟进第 1 项：`writing-plans` 中的计划结构增强。
- **选项**：整包同步上游 v6；暂不跟进；只吸收 `writing-plans` 的 `Task Right-Sizing`、`Global Constraints` 和 `Interfaces`，并保持本 fork 的 type-first / focused verification / commit 授权语义。
- **决策**：选择第三项。`skills/writing-plans/SKILL.md` 增加任务大小指导，要求 setup/config/docs 并入需要它们的 deliverable；计划头部增加 `Global Constraints`；每个任务增加 `Interfaces` 的 `Consumes` / `Produces`；self-review 增加约束传播、接口一致性和任务大小检查。同步更新 `docs/skills-overview.zh.md`，并将插件版本 bump 到 `5.1.2`。
- **理由**：这些改动能减少低上下文 implementer 猜全局约束和跨任务接口、避免过小任务制造无意义 review gate，同时不恢复上游 TDD、不过早引入 SDD reviewer 合并、文件交接、visual companion 安全重构或新 harness 支持。
- **影响**：`skills/writing-plans/SKILL.md`, `docs/skills-overview.zh.md`, `package.json`, `.codex-plugin/plugin.json`, `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `README.md`
- **状态**：已实施。

## 2026-06-25 吸收外部 skills 中强化 agent 写代码的实现纪律

- **背景**：用户在 `refs/mattpocock-skills` 中放入外部 skills，希望评估哪些设计能提升 agent 写代码质量。经过 review，明确不吸收 Invocation 分层、`writing-great-skills` 质量词汇体系、Deep Module / Seam 词汇和 Design It Twice，只吸收直接提升实现质量的部分。
- **选项**：整套复制外部 skills；只保留讨论记录不改当前 fork；选择性吸收与类型优先哲学兼容的实现纪律。
- **决策**：选择性吸收四点：`systematic-debugging` 增加 bug-specific feedback loop 和 loop 归宿规则；`writing-plans` 默认按可独立验证的 vertical slice 拆任务；review prompt 按 Spec / Standards 双轴报告；`type-driven-verification` 强化“通过真实入口测试行为”，避免默认测试私有 helper。
- **理由**：这些改动能减少猜测式修复、横向分层计划、需求符合度与质量问题混杂、以及测试锁死私有实现，同时不恢复 blanket TDD、不引入自动 commit / issue tracker / PRD workflow，也不改变当前 skill invocation 方式。
- **影响**：`skills/systematic-debugging/SKILL.md`, `skills/writing-plans/SKILL.md`, `skills/type-driven-verification/SKILL.md`, `skills/requesting-code-review/code-reviewer.md`, `skills/subagent-driven-development/*reviewer-prompt.md`, `docs/skills-overview.zh.md`, `docs/superpowers/specs/2026-06-25-external-skill-patterns-design.md`, `docs/superpowers/plans/2026-06-25-external-skill-patterns.md`
- **状态**：已实施。

## 2026-06-10 收敛安装链路并将 Claude Code 插件改名为 k-superpowers

- **背景**：用户明确主用 Claude Code 与 Codex 的本地安装，仓库聚焦 skill 定制；且发现 Claude Code 实际加载的是官方 marketplace 缓存的 superpowers 插件（同名），fork 的全部定制在 CC 中不生效。
- **选项**：保留上游全生态 manifest；只删不用的生态、CC 插件保持上游名字；删除无用生态并把 CC 插件改名为 k-superpowers。
- **决策**：移除 Cursor（`.cursor-plugin/`、`hooks/hooks-cursor.json`）、Gemini（`gemini-extension.json`、`GEMINI.md`、`gemini-tools.md` 及 skill 正文相关段落）、上游社区文件（`.github/`、`CODE_OF_CONDUCT.md`、`RELEASE-NOTES.md`）、版本发布工具（`.version-bump.json`、`scripts/bump-version.sh`）、Codex 官方市场发布管道（`scripts/sync-to-codex-plugin.sh`、`tests/codex-plugin-sync/`）。`.claude-plugin` 改名为 `k-superpowers`/`k-superpowers-dev`（作者 kirito，仓库地址指向 fork），并将 skills/hooks/tests 中全部 `superpowers:` 交叉引用统一替换为 `k-superpowers:`。OpenCode 链路保留。
- **理由**：个人 fork 不走任何 marketplace 发布链路；CC 插件与官方同名会冲突且 skill 交叉引用会解析到官方版本；改名后与 Codex 侧命名一致。OpenCode 按 skills 目录注册，命名空间前缀只是引导文本，替换不影响。`assets/` 被 `.codex-plugin/plugin.json` 引用、`hooks/run-hook.cmd` 是 hooks.json 全平台入口，均保留。
- **影响**：`.claude-plugin/*`, `skills/*`, `hooks/session-start`, `tests/*`, `README.md`，及上述删除文件
- **状态**：已实施。

## 2026-06-03 清除 skills 内全部 TDD / RED-GREEN 残留字眼

- **背景**：2026-05-26 改名后，`skills/` 内仍散落 `test-driven` / `TDD` / `RED-GREEN` / `test-first` 字眼（SKILL 正文、checklist、历史日志、死链接）。skill 每次注入都是全新环境，无向前兼容包袱，残留只会让模型套回 test-first 思维。
- **选项**：只清会注入行为的 SKILL 正文，历史日志保持原样（避免伪造历史）；或全部清干净，历史决策交给 `.ai/memory/` 承载。
- **决策**：全部清干净。SKILL 正文去仪式化措辞；历史日志（CREATION-LOG、Real-World Impact）中性化或修正死链；历史背景由本记忆文件承载。
- **理由**：用户明确"历史靠项目记忆、skill 全新环境无兼容包袱"。`skills/` 内 grep `test-driven|TDD|RED-GREEN|test-first` 应为零命中。
- **影响**：`skills/verification-before-completion/SKILL.md`, `skills/type-driven-verification/SKILL.md`, `skills/using-superpowers/SKILL.md`, `skills/writing-skills/SKILL.md`, `skills/writing-skills/testing-skills-with-subagents.md`, `skills/systematic-debugging/CREATION-LOG.md`
- **状态**：已实施。

## 2026-05-26 将 test-driven-development 改名为 type-driven-verification

- **背景**：`test-driven-development` 的正文已经改为 Type-Driven Verification，但 skill 名仍保留 TDD，容易让模型继续套用 test-first / 红绿灯思维。
- **选项**：继续保留旧名；新增 alias；直接重命名为 `type-driven-verification` 并迁移引用。
- **决策**：直接重命名为 `type-driven-verification`，不保留旧 alias；同步更新活跃 skill 引用、触发测试、中文总览和记忆。
- **理由**：这是个人 fork，不需要维持上游兼容；旧名与实际语义冲突。alias 会制造两个触发入口，增加模型噪音。
- **影响**：`skills/type-driven-verification/SKILL.md`, `skills/writing-skills/*`, `skills/systematic-debugging/SKILL.md`, `skills/subagent-driven-development/SKILL.md`, `tests/skill-triggering/*`, `docs/skills-overview.zh.md`, `.ai/memory/*`
- **状态**：已实施。

## 2026-05-22 Codex app 使用仓库级本地 marketplace 安装 k-superpowers

- **背景**：用户希望在 Codex app 中以添加本地市场的方式使用当前 fork 的 skills，并保持插件名为 `k-superpowers`。
- **选项**：使用全局 `~/.agents/plugins/marketplace.json`；使用仓库根目录作为本地 marketplace；继续仅通过 OpenCode 使用。
- **决策**：在仓库内维护 `.agents/plugins/marketplace.json`，本地市场目录填写仓库根 `/Users/kirito/my/k-superpowers`；marketplace 条目为 `k-superpowers@k-superpowers-dev`，通过 `plugins/k-superpowers -> ..` 指向当前 checkout。
- **理由**：Codex app 添加本地 marketplace 时需要目录根包含 `.agents/plugins/marketplace.json`，而不是直接选择 `marketplace.json` 文件；仓库级结构跟随 fork，便于版本化和复用。
- **影响**：`.agents/plugins/marketplace.json`, `plugins/k-superpowers`, `.codex-plugin/plugin.json`, `README.md`
- **状态**：已实施。

## 2026-05-21 从强制 TDD 改为类型优先验证

- **背景**：用户长期使用 Rust，认为不是所有代码都需要测试；测试应保护核心逻辑和回归风险，更多不变量应交给类型系统、接口和编译器。
- **选项**：保留上游严格 TDD；删除测试纪律；保留 `test-driven-development` 名称但改为类型优先验证语义。
- **决策**：保留 skill 名以兼容现有引用，但正文改为 Type-Driven Verification：优先让非法状态不可表示，只对核心行为、bug 回归、公共 API、算法、parser、协议、状态机、高风险重构等写聚焦测试。
- **理由**：直接删除 TDD 会让 agent 退回“凭感觉完成”；保留验证纪律但放弃 blanket test-first 更符合 Rust 哲学和用户效率偏好。
- **影响**：`skills/test-driven-development/SKILL.md`, `skills/writing-plans/SKILL.md`, `skills/systematic-debugging/SKILL.md`, `skills/subagent-driven-development/SKILL.md`, `skills/verification-before-completion/SKILL.md`, `docs/skills-overview.zh.md`
- **状态**：[DEPRECATED 2026-05-26 已改名为 `type-driven-verification`]。

## 2026-05-21 OpenCode 使用 k-superpowers git 安装

- **背景**：用户将 fork 命名为 `k-superpowers`，并明确这是自用版本，需要安装引导指向自己的 fork，而不是上游 marketplace。
- **选项**：继续使用上游 `superpowers` 安装说明；全生态重命名并发布 marketplace；只维护 OpenCode 的 git/local 安装链路。
- **决策**：根 `package.json` 改名为 `k-superpowers`，README 和 OpenCode 安装文档使用 `k-superpowers@git+https://github.com/kirito41dd/k-superpowers.git`；本地开发安装使用 `file:///Users/kirito/my/k-superpowers`。
- **理由**：当前主要使用 OpenCode，git-backed plugin 足够满足自用；其它生态 marketplace 需要额外发布流程，暂不扩大范围。
- **影响**：`package.json`, `README.md`, `docs/README.opencode.md`, `.opencode/INSTALL.md`
- **状态**：已实施。

## 2026-05-21 个人 fork 不面向上游贡献

- **背景**：用户明确表示本仓库是个人 fork，用于定制属于自己的 Superpowers，不打算提交给上游。
- **选项**：保留上游贡献规范；把上游规范移到参考文档；让 `CLAUDE.md` 只承载个人 fork 的运行提示和记忆规则。
- **决策**：`CLAUDE.md` 当前只保留项目记忆机制；后续如需新增提示，也只放 skill 定制相关内容。
- **理由**：上游 PR 规范对个人 fork 日常工作是噪音，会干扰 agent 判断；个人 fork 更需要稳定记录自定义行为偏好。
- **影响**：`CLAUDE.md`, `skills/*/SKILL.md`, `.ai/memory/*`
- **状态**：已实施。

## 2026-05-21 安装项目级 AI 记忆系统

- **背景**：用户希望后续持续微调个人 fork，需要项目级长期记忆记录需求、约定、坑点和术语，避免每次重新建立上下文。
- **选项**：只写中文总览文档；使用 `/Users/kirito/wk/ai-memory-template` 的 `.ai/memory/` 渐进式披露模板；把记忆写进全局 CLAUDE 配置。
- **决策**：在本项目内创建 `.ai/memory/`，并在项目 `CLAUDE.md` 追加项目记忆机制入口。
- **理由**：项目级记忆跟随仓库，适合 fork 内部演进；渐进式披露避免每次加载所有历史；不污染全局配置。
- **影响**：`.ai/memory/*`, `CLAUDE.md`
- **状态**：已实施。

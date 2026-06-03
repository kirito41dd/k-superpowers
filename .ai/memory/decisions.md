# 技术决策记录

<!-- SUMMARY
覆盖范围：架构决策、技术选型、废弃方案（ADR 风格）
条目数：7
最近更新：2026-06-03
高频标签：#memory #fork #personalization #codex #opencode #install #verification #type-driven
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

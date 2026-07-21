# 需求演进史

<!-- SUMMARY
覆盖范围：需求变更、功能增删、产品方向调整
条目数：4
最近更新：2026-07-21
高频标签：#skills #fork #routing #comments #iteration #judgment-first #review
-->

## 写入格式

```
## YYYY-MM-DD 一句话标题
- **来源**：用户主动提出 / PRD / Issue#xxx
- **内容**：需求描述
- **状态**：设计中 / 实施中 / 已完成 / [DEPRECATED]
- **相关**：文件路径 / commit / PR 链接
```

---

## 2026-07-21 Skills 以智能 Agent 和真实交付为中心

- **来源**：用户在本轮 Skill 优化和超过 24 小时的 review/fix 循环后主动提出并逐段批准。
- **内容**：把 Agent 当作聪明的智能体，而不是死板程序。Skill 只固定目标、职责、授权边界、需要用户决定的关键事项和成功证据，把局部判断、措辞、工具顺序和输出组织交给 Agent；交付速度、等待时间和调用成本也是产品质量。普通问答允许不加载 task skill，清晰变更默认走最小可行路径，计划、worktree、SDD、独立 Review 和更宽验证只在有实际收益时增加。Review 使用一次 Discovery、一次批量修复和一次 Closure；复审继承完整记录，未关闭则停止交还用户，不自动循环；删除 review scope SHA-256。类型/API 优先、核心代码解释性注释、Git 授权和用户已有修改保护继续保留。
- **状态**：已完成，版本 `5.4.0`。
- **相关**：`AGENTS.md`, `docs/superpowers/specs/2026-07-21-bounded-review-closure-design.md`, `docs/superpowers/specs/2026-07-21-judgment-first-skill-workflow-design.md`, `skills/*`

---

## 2026-07-21 Skills 仓库移除全部持久测试

- **来源**：用户主动提出并批准。
- **内容**：本仓库的产物是供持续进化的智能体使用的 skills，不按传统确定性代码维护测试资产。删除整个 `tests/`、测试说明和 skill 测试支撑文档；后续不新增持久 fixture、snapshot、eval matrix、golden output 或默认付费模型验证。通过真实使用反馈做小步迭代，只保留与改动直接相关的零成本语法、JSON、引用和 diff 检查。普通日常问答仍允许直接回答而不加载 task skill，核心代码解释性注释等既有产品行为不受影响。
- **状态**：已完成，版本 `5.3.0`。
- **相关**：`skills/writing-skills/SKILL.md`, `README.md`, `docs/skills-overview.zh.md`

---

## 2026-07-21 GPT-5.6 Prompt 优化须保留既有行为

> [DEPRECATED 2026-07-21] 固定 Compact/Full、SDD/Inline 和风险 Review 机制已由「Skills 以智能 Agent 和真实交付为中心」取代；No Task Skill、Git 授权和核心代码注释契约继续有效。

- **来源**：用户主动提出。
- **内容**：结合 OpenAI GPT-5.6 prompting guidance 优化研发流程 skills，减少不必要的 skill 加载、重复指令、重复审批和长上下文。普通日常问答必须允许模型直接回答而不使用 task skill；preparation/read-only/设计/调试/计划执行只选择当前阶段的最小充分 owner。同时不得改变 Compact/Full、SDD/Inline、Git 授权、风险自适应 review、类型优先验证和核心代码解释性注释等既有行为；注释形式、语言和风格继续服从项目指令与邻近文件。
- **状态**：已完成，版本 `5.2.3`；其中持久测试和行为 eval 要求已由 `#2026-07-21-skills-仓库移除全部持久测试` 取代，路由与既有行为保护继续有效。
- **相关**：`docs/superpowers/specs/2026-07-17-gpt-5-6-skill-prompt-optimization-design.md`, `skills/using-superpowers/SKILL.md`, `skills/subagent-driven-development/*`, `skills/requesting-code-review/*`

---

## 2026-05-21 个人 fork 用于后续微调 Superpowers skills

- **来源**：用户主动提出。
- **内容**：本仓库是 `superpowers` skills 的个人 fork。当前目标是熟悉项目、梳理所有 skill 的核心思想和主要流程，后续会根据个人使用情况微调。
- **状态**：已完成初始梳理。
- **相关**：`docs/skills-overview.zh.md`, `skills/*/SKILL.md`

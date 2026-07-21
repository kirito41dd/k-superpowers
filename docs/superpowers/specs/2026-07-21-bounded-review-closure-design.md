# 有界 Review Closure 设计

## Flow

Compact

## 状态

Approved in conversation on 2026-07-21 and incorporated into
`2026-07-21-judgment-first-skill-workflow-design.md`; no standalone documentation
commit.

## 目标

让代码审查以交付目标为中心，并在一次 discovery、一次批量修复和一次 closure
后产生明确终态。修复后由同一个逻辑 reviewer 消费完整审查记录，避免 fresh
reviewer 丢失上下文、重新扩大范围或为了找问题而找问题。

## 核心设计

每个 review checkpoint 只有一个逻辑 reviewer 生命周期：

```text
Discovery Review
  -> frozen finding ledger
  -> one coherent fix batch
  -> Closure Review
  -> PASS | PASS_WITH_FOLLOWUPS | STOPPED_BLOCKED
```

优先复用同一 reviewer 会话；平台无法恢复时，可以使用 fresh agent，但必须传入完整
review record，并以 closure mode 工作，不能重新执行 discovery。

Review record 至少包含：原始目标与 approved source、冻结 scope/source binding、首次
verdict、带稳定 ID 的 findings、controller adjudication、fix report、fix-only diff、
verification evidence 和 deferred observations。

Scope binding 使用显式排序后的 repo-relative path 列表与 source/base/head，不使用
`EXPECTED_SCOPE_SHA256` 或 package 内部 scope hash。路径 hash 只能证明 controller
生成的两份路径选择一致，不能发现它一开始遗漏或选错路径，额外 hard gate 不值得。

## Finding 与阻断规则

- Discovery Review 只运行一次，并冻结 finding ledger。
- Critical 以及具有具体正确性、安全、数据、兼容性或已批准需求影响的 Important
  finding 阻断；Minor 只进入 follow-up，不得单独造成 FAIL。
- Controller 将每条 finding 一次性分类为 `accepted`、`rejected-with-evidence`、
  `follow-up` 或 `needs-user-decision`。
- Closure Review 只确认 accepted finding 是否关闭、fix 是否直接引入阻断回归，
  以及修复后的证据是否覆盖原始目标。
- Closure 中的新观察必须标记来源：`original-finding-unresolved`、
  `fix-induced-regression`、`pre-existing-missed`、`unrelated-observation` 或
  `material-scope-change`。
- 只有未关闭的原阻断 finding、fix 直接引入的 Critical/Important 回归，或新发现的
  严重安全、数据丢失、权限越界问题可以阻断 closure。其他新观察进入 follow-up。
- Material scope、architecture、dependency 或 public-contract 变化停止并交给用户，
  不能由 reviewer 扩大当前迭代。

## 终止与恢复

默认预算为一次 Discovery Review、一次批量修复、一次 Closure Review。Closure
仍有 blocker、再次 `CANNOT_VERIFY` 或输出无效时，状态为 `STOPPED_BLOCKED`：保留
artifacts，报告剩余 blocker 和证据，不再自动派 fixer 或 reviewer。继续修复需要用户
明确决定。

Review 上限不把失败转换成成功。Spec conflict、verification failure、Critical/Important
fix regression 继续阻断，只是从无限循环改成显式停止。

## 范围

- `skills/requesting-code-review/SKILL.md`
- `skills/requesting-code-review/code-reviewer.md`
- `skills/requesting-code-review/scripts/review-package`
- `skills/receiving-code-review/SKILL.md`
- `skills/subagent-driven-development/SKILL.md`
- `skills/subagent-driven-development/task-reviewer-prompt.md`
- `skills/executing-plans/SKILL.md`
- 相关 overview、README、版本与项目记忆（记忆需另行确认）

## 验收标准

1. 每个 checkpoint 只有一次 discovery，fix 后只能进入 closure。
2. Closure reviewer 必须看到完整 review record；fresh agent 不能无历史重审。
3. Minor 和非因 fix 产生的新一般观察不阻断当前交付。
4. Closure 可以阻断未关闭 finding、fix regression 和严重安全/数据/权限问题。
5. 默认一个修复周期；未关闭时进入 `STOPPED_BLOCKED`，不自动循环。
6. SDD、Inline 与 generic review 使用同一状态与 finding 语义。
7. 不新增测试、fixture、eval 或默认模型验证，只做一次文本自审和廉价静态检查。

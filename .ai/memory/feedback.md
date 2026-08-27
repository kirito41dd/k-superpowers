# Skill 使用反馈

<!-- SUMMARY
覆盖范围：真实研发中使用 skills 的不爽点、期望规则和处理状态
条目数：5
最近更新：2026-08-27
高频标签：#feedback #skills #routing #verification #review #independent-review #logging #git #gitlab #handoff #performance #worktree #submodule
-->

只记录经过脱敏、可公开泛化的真实使用体验，不写私有项目名、业务标识、
接口或存储细节。新反馈放在顶部，过时反馈标记 `[DEPRECATED]`，不删除。

---

## 2026-08-27 提交请求可能绕过独立 Review

### 场景

任务完成后用户直接要求提交，Agent 可能漏掉本应进行的独立 Review。

### 不爽点

- 独立 reviewer 确实能发现问题，却依赖用户主动提醒。
- 不能因此让所有简单任务都进入正式 Review。

### 我的规则

- 简单、自解释且证据充分的改动只做普通检查和验证。
- 命中 Review trigger 的变更默认派发独立 reviewer。
- COMMIT/MERGE/PR 前补查缺失的必要 Review，不重复已有有效 Review。

### 处理状态

已收紧正式 Review 边界并增加 Git action 前兜底，版本为 `5.4.16`。

---

## 2026-08-26 上下文压缩后漏读 PR action recipe

### 场景

父 skill 已加载，但延迟执行 PR action 时未重读对应 recipe。

### 不爽点

- Agent 先普通 push，再尝试未安装的 `glab`，最后又尝试无效的 no-op push options。
- “skill 已加载”的摘要掩盖了实际未读取 action 细节。

### 我的规则

- 每个 action 执行前重读完整 recipe，不依赖记忆或上下文摘要。
- GitLab 同项目新分支首次 push 直接用 push options 创建 MR，不预查 `glab`。
- 已推送且无更新时不做 no-op push；改用已认证的 `glab`/API，不可用则报告或给手动链接。
- 只授权 COMMIT 时，不推送或创建 MR。

### 处理状态

已增加 action recipe gate 并收紧 GitLab PR 路径，版本为 `5.4.15`。

---

## 2026-08-24 含 submodule 的干净 worktree 被误判为不可清理

### 场景

用户要求清理工作区，普通 `git worktree remove` 因 worktree 含已初始化的
submodule 而拒绝删除。

### 不爽点

- Agent 把 Git 的 submodule 特殊限制直接当成无法清理。
- Submodule 是正常项目结构，不应因此残留已经完成的干净 worktree。

### 我的规则

- Submodule 本身不是清理阻塞条件。
- Worktree 归属明确且包含 submodule 在内的状态为空时，可单次 `--force` 清理。
- Worktree 脏、锁定、归属不明或失败原因不同时仍应停止，不能无条件强删。

### 处理状态

MERGE/DISCARD 共用的清理说明已增加受控 fallback，版本为 `5.4.14`。

---

## 2026-08-22 提交阶段重复运行已完成的验证

### 场景

任务完成时已经通过相关编译和单测。之后用户只要求提交代码，期间代码和
验证范围没有变化。

### 不爽点

- Agent 因进入提交阶段再次运行相同编译和单测。
- 重复验证没有增加置信度，只增加等待时间和资源消耗。

### 我的规则

- 已验证内容、相关输入/环境和完成声明未变化时，复用已有新鲜证据。
- 暂存和提交同一份内容不会使验证失效，不应自动重跑测试。
- 先确认待提交 diff 与已验证 diff 一致，且没有夹带未验证改动。
- 内容、生成文件、相关环境或验证范围变化，或者旧证据失败、不完整、已过期时才重跑。
- 仓库自动执行的 pre-commit hook 可以正常运行，不为了省时绕过项目 gate。

### 处理状态

`verification-before-completion` 保留总原则；COMMIT 路径已明确复用覆盖当前
diff 的新鲜证据，不因暂存或提交重复运行编译和测试。版本为 `5.4.13`。

---

## 2026-08-22 纯日志改动被过度工程化

### 场景

在敏感业务代码中只补充研发可读的失败日志，不改变业务决策、对外行为、
持久状态或资源生命周期。

### 不爽点

- Agent 仅因文件位于 auth 模块就触发 TDV 和独立 Review。
- 为日志文案新增精确字符串测试。
- 为方便测试，把 bool helper 改成 `Result` 枚举。
- 简单日志增强被扩大成生产代码重构；新增测试后来被删除。

### 我的规则

- 按实际语义增量判断风险，不按模块或文件名判断。
- 普通研发日志不写持久测试，也不为测试日志文案改造生产抽象。
- 只需检查相关分支、fmt/check 和敏感信息泄露。
- 机器消费、告警、审计、合规、计费或兼容性合同依赖的日志仍需测试。
- 鉴权判定、状态或对外响应发生变化时，仍按正式行为和协议验证。
- Skill 修正要保持最小；关键规则必须出现在实际会加载的 skill 中。

### 处理状态

已在 `using-superpowers`、`type-driven-verification` 和
`requesting-code-review` 中收紧边界，首轮调整于 `5.4.12`。不新增 skill
测试或 eval，交回真实任务继续验证。

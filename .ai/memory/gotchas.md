# 踩坑与注意事项

<!-- SUMMARY
覆盖范围：非显而易见的 bug、易犯错误、隐藏依赖
条目数：3
最近更新：2026-07-21
高频标签：#upstream-pr #skills #eval #sdd #prompt #judgment-first
-->

## 写入格式

```
## YYYY-MM-DD 一句话坑点标题

- **现象**：表现出的错误行为
- **原因**：根本原因
- **解决**：如何修复（文件:行号）
- **避免**：将来如何避免（检查清单 / 约定）
- **标签**：#module-name #error-type
```

---

## 2026-07-21 Live reviewer 单次零读取不等于 Prompt 结构缺陷

> [DEPRECATED 2026-07-21] 本仓库不再运行或维护 live reviewer campaign，也不再保留 Role Prompt Fidelity 或 scope-hash gate。保留此条仅用于说明历史成本来源；现行规则见 `decisions.md#2026-07-21-skills-工作流采用-judgment-first-与有界-review`。

- **现象**：SDD live integration 中，一个 task reviewer 在 Inputs、文件和 binding 都完整时仍以 0 次工具调用直接返回双 `CANNOT_VERIFY`，触发 fresh re-review，导致典型 happy path 的 exact `2N` 断言失败；相同 prompt 随后的 reviewer 完成 4 次 Read 并双轴通过。
- **原因**：首次 reviewer 错误选择了“Inputs absent/malformed”的 fail-fast 分支。首、次 dispatch prompt 字节完全一致，路径存在，header 匹配，声明占位符无残留，nested transcript 也没有工具错误，证据更符合一次模型 instruction-following 波动，而不是模板或 controller 缺陷。
- **解决**：保留首次 transcript，比较 dispatch prompt 的原始/归一化内容、占位符、路径与嵌套工具事件；确认 controller 按既有 `CANNOT_VERIFY -> fresh complete review` 恢复后，再以未改代码 fresh 重跑 exact happy-path campaign。单次波动不放宽 `2N`、prompt fidelity 或 scope-hash gate。
- **避免**：live eval 失败先区分确定性 prompt/harness 缺陷与随机解码；只有可重复失败或存在结构差异时才改 prompt，不能为了让一次 campaign 变绿而弱化产品或测试契约。
- **标签**：#skills #eval #sdd #prompt #claude-code

---

## 2026-07-21 Role Prompt 保真不能只查关键字或无边界占位符

> [DEPRECATED 2026-07-21] 对应测试资产和产品侧 Role Prompt Fidelity 均已删除。Delegated brief 只需语义完整，不再冻结模板字序、占位符实例化方式或工具顺序；现行规则见 `decisions.md#2026-07-21-skills-工作流采用-judgment-first-与有界-review`。

- **现象**：SDD integration 把只含少量 sentinel 的截断 prompt 误判为完整；改成 `.+?` 加反向引用后，特制的重复 `[BRIEF_FILE]` 值仍可吞入两次出现之间的固定正文并产生假阳性。真实 dispatch 还暴露 controller 只替换 Inputs 中的动态路径、遗漏正文内同名 placeholder，reviewer 因而反复返回 `CANNOT_VERIFY`。
- **原因**：无序关键字只证明片段存在，不证明模板完整或顺序正确；无类型边界的 regex capture 可以跨越后续 literal，反向引用也无法保证逻辑上的占位符值一致。动态值在模板多处重复则扩大了 partial substitution 面。
- **解决**：`tests/claude-code/test-subagent-driven-development-integration.sh` 从当前 role template 解析完整 inner `prompt: |` body，归一化仅传输空白，按固定正文从左到右确定边界，并对任务号、SHA、内部路径和自由文本使用不同 placeholder rule；重复占位符必须逐字一致。`task-reviewer-prompt.md` 只在 Inputs 声明动态路径，后续指令引用 Inputs 字段名；static/live eval 断言渲染后的 reviewer prompt 无声明 placeholder 残留。增加截断、重排、普通不一致和跨正文吞噬的反例。
- **避免**：任何“完整 prompt/文档/协议保真”断言都不能只查 sentinel；占位符 matcher 必须有确定性边界、类型约束、重复值一致性和能复现旧假阳性的 adversarial fixture。动态 task 数据优先单点注入，正文引用字段名而不是复制 placeholder。
- **标签**：#skills #eval #sdd #prompt

---

## 2026-05-21 上游 PR 门槛很高

- **现象**：如果把个人偏好、未验证 skill 文案、批量修改或 speculative fix 提交到上游，很可能被快速关闭。
- **原因**：项目明确要求 PR 解决真实问题、完整填写模板、检索 open/closed PR、证明适合 core、提供人类 review；skill 行为内容修改还需要 adversarial eval。
- **解决**：任何 PR 前先读 `.github/PULL_REQUEST_TEMPLATE.md` 和 `CLAUDE.md`；确认真实问题；检索既有 PR；展示完整 diff 给用户批准。
- **避免**：个人 fork 微调默认留在 fork；不把项目特定、个人配置、未测试 skill 改动推给 upstream。
- **标签**：#upstream-pr #skills #eval

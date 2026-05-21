# 踩坑与注意事项

<!-- SUMMARY
覆盖范围：非显而易见的 bug、易犯错误、隐藏依赖
条目数：1
最近更新：2026-05-21
高频标签：#upstream-pr #skills #eval
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

## 2026-05-21 上游 PR 门槛很高

- **现象**：如果把个人偏好、未验证 skill 文案、批量修改或 speculative fix 提交到上游，很可能被快速关闭。
- **原因**：项目明确要求 PR 解决真实问题、完整填写模板、检索 open/closed PR、证明适合 core、提供人类 review；skill 行为内容修改还需要 adversarial eval。
- **解决**：任何 PR 前先读 `.github/PULL_REQUEST_TEMPLATE.md` 和 `CLAUDE.md`；确认真实问题；检索既有 PR；展示完整 diff 给用户批准。
- **避免**：个人 fork 微调默认留在 fork；不把项目特定、个人配置、未测试 skill 改动推给 upstream。
- **标签**：#upstream-pr #skills #eval

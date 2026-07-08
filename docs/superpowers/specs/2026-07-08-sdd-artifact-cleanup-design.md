# SDD Artifact Cleanup Design

## 背景

`subagent-driven-development` 会把 task brief、implementer report、review package 和 `progress.md` 写到 `.superpowers/sdd/`。这些文件用于同一次 SDD 执行中的恢复和低上下文文件交接。

实际使用中，新的任务可能被旧的 `.superpowers/sdd/progress.md` 或旧 review/report 痕迹影响，导致 agent 把上一次任务的完成状态或上下文当成当前任务的一部分。

## 目标

SDD 成功完成后，删除整棵 `.superpowers/sdd/`，避免下一次 SDD 任务读取旧中间产物。

## 非目标

- 不删除 `.superpowers/` 父目录。
- 不在 SDD 启动时无条件清理旧目录。
- 不在 `BLOCKED`、未完成 review、用户中断或上下文压缩恢复场景清理中间产物。
- 不改变 worktree cleanup 或 `finishing-a-development-branch` 的行为。

## 方案

新增 `skills/subagent-driven-development/scripts/sdd-cleanup`，由 SDD 主流程在所有任务完成、最终整体 review 通过后调用。

清理脚本通过 `git rev-parse --show-toplevel` 定位当前 worktree 根目录，只删除 `<repo>/.superpowers/sdd`。目录不存在时成功退出。

SDD 文档明确：

- `.superpowers/sdd/` 是短生命周期中间产物目录。
- `progress.md` 只用于当前未完成的 SDD 执行恢复。
- 成功完成后必须运行 `./scripts/sdd-cleanup`，再进入 `k-superpowers:finishing-a-development-branch`。
- 未成功完成时必须保留目录，便于恢复或排查。

## 风险与验证

风险等级：中风险。该变更增加 SDD 完成阶段的流程 gate，并引入删除命令，但不改变 skill 触发条件。

必须保持的不变量：

- 成功完成后不会留下 `.superpowers/sdd/` 污染下一次任务。
- 未完成、阻塞、中断时不会清理恢复所需文件。
- 清理脚本只删除当前 repo 的 `.superpowers/sdd`。

验证方式：

- 静态检查 SDD 文档中不存在“成功完成后仍保留 progress ledger”的冲突措辞。
- 在临时 git repo 中创建 `.superpowers/sdd/progress.md` 和其它 repo 文件，运行 `sdd-cleanup` 后确认只删除 `.superpowers/sdd`。
- 运行 shell 语法检查。

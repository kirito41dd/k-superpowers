# Codex Tool Use

Use the tools and skill-loading mechanisms exposed by the current Codex session.
Treat tool names in examples as descriptions of operations; use the actual tool
schemas for names, arguments, waiting, and agent lifecycle. Do not assume a
particular tool is available or change user configuration just to match an
example.

Workflow and authorization stay with their existing owners:

- [Subagent-Driven Development](../../subagent-driven-development/SKILL.md)
  governs delegated implementation and checkpoint authority.
- [Reasoning-Based Testing](../../reasoning-based-testing/SKILL.md)
  governs independent context isolation and source evidence.
- [Using Git Worktrees](../../using-git-worktrees/SKILL.md) governs workspace
  selection and cleanup ownership.
- [Finishing A Development Branch](../../finishing-a-development-branch/SKILL.md)
  governs authorized Git actions.

Inspect actual workspace state and permissions. Detached HEAD describes a
checkout state; it does not establish sandbox restrictions or authorize a
commit, branch operation, push, or cleanup. Use native app controls when a
required operation is unavailable, preserving the user's action boundaries.

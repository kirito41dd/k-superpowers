# Installing K Superpowers for OpenCode

## Prerequisites

- [OpenCode.ai](https://opencode.ai) installed

## Installation

Add `k-superpowers` to the `plugin` array in your `opencode.json` (global or project-level):

```json
{
  "plugin": ["k-superpowers@git+https://github.com/kirito41dd/k-superpowers.git"]
}
```

Restart OpenCode. The plugin installs through OpenCode's plugin manager and registers all skills.

Verify by asking: "Tell me about your superpowers"

## Local Development Install

To use this checkout directly:

```json
{
  "plugin": ["file:///Users/kirito/my/k-superpowers"]
}
```

Restart OpenCode after every plugin or skill change.

## Migrating From Upstream Symlink Install

If you previously installed upstream superpowers using `git clone` and symlinks, remove the old setup:

```bash
rm -f ~/.config/opencode/plugins/superpowers.js
rm -rf ~/.config/opencode/skills/superpowers
rm -rf ~/.config/opencode/superpowers
```

Remove `skills.paths` from `opencode.json` if you added one for upstream superpowers. Then follow the installation steps above.

## Usage

Use OpenCode's native `skill` tool:

```text
use skill tool to list skills
use skill tool to load brainstorming
```

## Updating

OpenCode installs K Superpowers through a git-backed package spec. Some OpenCode and Bun versions pin that resolved git dependency in a lockfile or cache, so a restart may not pick up the newest commit. If updates do not appear, clear OpenCode's package cache or reinstall the plugin.

To pin a branch, tag, or commit:

```json
{
  "plugin": ["k-superpowers@git+https://github.com/kirito41dd/k-superpowers.git#main"]
}
```

## Troubleshooting

### Plugin Not Loading

1. Check logs: `opencode run --print-logs "hello" 2>&1 | grep -i superpowers`
2. Verify the plugin line in your `opencode.json`
3. Make sure you're running a recent version of OpenCode

### Windows Install Issues

If OpenCode cannot install the git-backed plugin, try installing with system npm and pointing OpenCode at the local package:

```powershell
npm install k-superpowers@git+https://github.com/kirito41dd/k-superpowers.git --prefix "$HOME\.config\opencode"
```

Then use the installed package path in `opencode.json`:

```json
{
  "plugin": ["~/.config/opencode/node_modules/k-superpowers"]
}
```

### Skills Not Found

1. Use `skill` tool to list what's discovered
2. Check that the plugin is loading

### Tool Mapping

When skills reference Claude Code tools:

- `TodoWrite` -> `todowrite`
- `Task` with subagents -> `@mention` syntax
- `Skill` tool -> OpenCode's native `skill` tool
- File operations -> your native tools

## References

- Fork repository: https://github.com/kirito41dd/k-superpowers
- Upstream project: https://github.com/obra/superpowers

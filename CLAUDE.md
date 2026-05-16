# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A Claude Code skills plugin published as `meickol/skills` on [skills.sh](https://skills.sh/meickol/skills). Each skill is a `SKILL.md` file that teaches Claude how to behave for a specific command. There is no build step, no package.json, no test runner.

## Skill anatomy

Each skill lives in `skills/<name>/SKILL.md` with YAML frontmatter:

```yaml
---
name: <name>
description: >
  <when to trigger — this is what the harness uses to decide which skill to invoke>
---
```

The `description` field is the trigger condition. Write it to match user intent precisely — it controls when the skill fires, not just what it does.

## Adding a skill

1. Create `skills/<name>/SKILL.md` with `name` and `description` frontmatter.
2. Add `"./skills/<name>"` to `.claude-plugin/plugin.json` under `"skills"`.
3. Link to Claude Code for local testing: `bash scripts/link-skills.sh`

## Scripts

| Command | Purpose |
|---|---|
| `bash scripts/link-skills.sh` | Symlink `skills/` → `~/.claude/skills/` for live editing |
| `bash scripts/list-skills.sh` | List all skill paths (useful for audits) |

After running `link-skills.sh`, edits to any `SKILL.md` are picked up by Claude Code immediately — no restart needed.

## Plugin registration

`.claude-plugin/plugin.json` is the manifest. Every skill directory must be listed there or it won't be installed by the skills CLI.

## Skill design principles

- **`teach-me`** has its own file layout it creates at runtime under `~/.claude/teaching/<topic>/`. Edits to its templates (`skills/teach-me/templates/`) affect all future HTML rendering — verify changes don't break the shared stylesheet path (`assets/style.css`).
- **`html`** is self-contained in one SKILL.md — the full rendering spec is inline. No supporting files.
- Skills cannot invoke each other. Any shared behaviour must be duplicated or extracted into a reference file the skill reads directly.

## Publishing

```bash
npx skills@latest add meickol/skills   # install (end-user command, not for dev)
```

Publishing is via the skills.sh platform — there is no `npm publish` step. Pushing to `main` is sufficient once the plugin is registered upstream.

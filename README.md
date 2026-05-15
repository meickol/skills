# maicol/skills

**Claude Code skills that fix two things AI assistants do badly: output and learning.**

[![skills](https://img.shields.io/badge/skills.sh-meickol%2Fskills-blue)](https://skills.sh/meickol/skills)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-8A2BE2)](https://claude.ai/code)
[![MIT License](https://img.shields.io/badge/license-MIT-green)](./LICENSE)

---

## Install

```bash
npx skills@latest add meickol/skills
```

Works with Claude Code, Cursor, Copilot, Windsurf, and [50+ other agents](https://skills.sh).

---

## The problems these skills solve

### Problem 1 — AI output is walls of markdown

You ask for a comparison, a status report, a technical explainer. You get a wall of bullet points. It's hard to scan, impossible to share, and looks nothing like the complexity of what you asked about.

**→ `/html` fixes this.**

Every time you'd get a markdown document, you get a self-contained `.html` file instead — tabbed comparisons, clickable architecture diagrams, slide decks, live design tokens, interactive reports. No CDN, no frameworks, no build step. Just one file you can open, share, or print.

```
/html

# or just ask naturally:
"document the auth flow"
"compare these three approaches"
"make a status report"
"summarize this PR"
```

---

### Problem 2 — Every explanation disappears when the session ends

You spend 20 minutes getting a concept explained. The session ends. Tomorrow you can't remember the gotcha. Next month you ask again.

**→ `/teach-me` fixes this.**

It teaches you the concept AND saves a polished HTML entry to a per-topic reference book at `~/.claude/teaching/<topic>/`. Each entry is written to be readable by future-you OR shared with a colleague — no session context assumed, no "as we discussed" filler. Cross-linked, tagged, and searchable.

```
/teach-me React Server Components
/teach-me database connection pooling
/teach-me how Rust's borrow checker works
```

The book grows every time you learn something. Come back to it, share it, build on it.

---

## Skills

| Skill | Trigger | What it produces |
|---|---|---|
| `html` | `/html` or any structured output request | Self-contained `.html` file: tabs, diagrams, decks, reports |
| `teach-me` | `/teach-me <concept>` | Chat explanation + persistent HTML reference entry |

---

## Compatibility

Tested with **Claude Code**. Installable into 55+ agents via the [skills CLI](https://github.com/vercel-labs/skills).

---

## License

MIT — [Maicol Lopez Mora](https://github.com/meickol)

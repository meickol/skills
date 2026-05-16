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

It doesn't just explain — it teaches using the same principles cognitive scientists use to design effective instruction, then saves a polished interactive HTML entry to a searchable reference book at `~/.claude/teaching/`.

```
/teach-me React Server Components
/teach-me database connection pooling
/teach-me how Rust's borrow checker works
/teach-me the CAP theorem
/teach-me how HTTPS works
```

**What makes it different:**

**Built on Mayer's Multimedia Learning Theory.** Every entry follows Richard Mayer's 12 research-backed principles for learning from words and visuals (Coherence, Signaling, Spatial Contiguity, Segmenting, Pre-training, and more). The result: animated SVG diagrams, step-by-step interactive reveals, and concept maps — not walls of text.

**Calibrated to your level.** Before teaching, it asks where you're starting from — none / some exposure / working knowledge. That answer maps to Bloom's Taxonomy and controls visual complexity, explanation depth, and recall type. A beginner and an expert asking the same question get fundamentally different explanations.

**Always fetches official sources first.** Never relies on training data alone. For a React question it queries context7 for current React docs. For a networking protocol it fetches the IETF RFC. For a math concept it reads NIST. Every entry cites the sources consulted with fetch dates, so you can verify currency.

**Adaptive interactive recall.** Beginners get a clickable quiz with immediate feedback. Advanced learners get open-ended "what would happen if…" questions with no safety net — the retrieval attempt is the point.

**A hybrid reference book, not just files.** Entries are cross-linked bidirectionally. A global search index lets you find any concept across all topics instantly. Filter by topic, tag, or level. Share any entry — it reads like a published article, not a personal note.

The book grows every time you learn something. Come back to it, share it, build on it.

---

## Skills

| Skill | Trigger | What it produces |
|---|---|---|
| `html` | `/html` or any structured output request | Self-contained `.html` file: tabs, diagrams, decks, reports |
| `teach-me` | `/teach-me <concept>` | Mayer-calibrated explanation + animated HTML entry + searchable reference book |

---

## Compatibility

Tested with **Claude Code**. Installable into 55+ agents via the [skills CLI](https://github.com/vercel-labs/skills).

---

## Contributing

Clone the repo, link the skills you're working on to your local Claude Code, edit, and test:

```bash
git clone https://github.com/meickol/skills
cd skills
bash scripts/link-skills.sh   # symlinks skills/ → ~/.claude/skills/
```

Edits to a skill file are picked up by Claude Code immediately — no re-install needed.

To list all skills in the repo:

```bash
bash scripts/list-skills.sh
```

To add a new skill, create a `skills/<name>/SKILL.md` with `name` and `description` frontmatter, then add the path to `.claude-plugin/plugin.json`.

---

## License

MIT — [Maicol Lopez Mora](https://github.com/meickol)

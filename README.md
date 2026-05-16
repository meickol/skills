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

It answers immediately — no setup questions, no friction — then lets you build a searchable reference book from the conversation, one question at a time.

```
/teach-me React Server Components
/teach-me database connection pooling
/teach-me how Rust's borrow checker works
/teach-me the CAP theorem
/teach-me how HTTPS works
```

**What makes it different:**

**Answers first, no friction.** Every question gets a short, direct answer immediately — 1–3 sentences and a concrete example. No setup questions block the first response. If you want to save it, you choose. If you just wanted a quick answer, you're done.

**The doc grows from the conversation.** Say yes once and a draft doc is created from your question. Ask a follow-up and you're offered to add it. Ask something different and that gets added too. The reference entry accumulates knowledge from actual questions you asked, not a pre-generated template.

**Publish when it's ready.** Run `/teach-me generate <topic>` when you want HTML. It reads all the Q&A you've saved, curates what adds genuine new knowledge, synthesizes a full article with animated SVG diagrams and interactive recall, and opens it in the browser. `/teach-me generate <topic> <slug>` targets a single entry.

**Never repeats itself.** If you ask the same concept twice in a session — because it didn't click the first time — it switches tactic automatically: different example, real-world analogy, ELI5, inverse approach, or step-by-step trace. If you have a doc, it offers to revise the explanation there too.

**Setup questions happen once.** The first time you save anything, it asks where to keep your library (user-wide or project-scoped) and which topic book to use. That's it for the session — every subsequent save skips straight to writing.

**Built on Mayer's Multimedia Learning Theory.** Every generated entry follows Richard Mayer's 12 research-backed principles: animated SVG diagrams, step-by-step interactive reveals, concept maps. Calibrated to your level — beginner, some exposure, or working knowledge — which controls visual complexity, explanation depth, and recall type.

**Always fetches official sources before persisting.** When you say "add to doc", it fetches current docs first — context7 for libraries, IETF RFCs for protocols, NIST for security, official language docs for languages. Every entry cites sources with fetch dates.

**A hybrid reference book, not just files.** Entries are cross-linked bidirectionally. A global search index lets you find any concept across all topics instantly. Filter by topic, tag, or level. Every entry reads like a published article — shareable, not a personal note.

---

## Skills

| Skill | Trigger | What it produces |
|---|---|---|
| `html` | `/html` or any structured output request | Self-contained `.html` file: tabs, diagrams, decks, reports |
| `teach-me` | `/teach-me <concept>` | Short answer immediately. Optionally grows a `source.md` doc from Q&A. |
| `teach-me generate` | `/teach-me generate <topic>` | Synthesizes saved Q&A into a full Mayer-calibrated HTML article with SVG diagrams. |

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

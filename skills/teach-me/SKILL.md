---
name: teach-me
description: >
  The best-in-class pedagogical teacher for any concept — technical, scientific, mathematical, or conceptual — powered by Mayer's Multimedia Learning principles and Bloom's Taxonomy calibration. Always fetches official primary sources before teaching. Produces a rich interactive HTML entry (animated SVG diagrams, interactive recall, concept maps) saved to a searchable hybrid reference book at ~/.claude/teaching/. Trigger on: "/teach-me <X>", "teach me about X", "explain the concept of X", "how does X work conceptually", or any request to understand a topic rather than accomplish a task. Do NOT trigger for: debugging, "fix this", "what does this function do", code review, or task-completion questions where the user wants to accomplish something rather than understand something.
---

# /teach-me — Research-Backed Pedagogical Teacher + Reference Book

Two jobs:
1. Teach the concept using Mayer's Multimedia Learning principles, calibrated to learner level, grounded in official sources fetched in real time.
2. Persist the explanation as a rich interactive HTML entry in a searchable hybrid reference book at `~/.claude/teaching/`.

See `references/pedagogy.md` for the full theoretical framework (Mayer, Bloom, Cognitive Load Theory, source hierarchy by domain).

## Audience — dual, always

Every entry must work for both simultaneously:

- **The student** — revisits to recap. Wants TL;DR, visual model, gotchas, interactive recall.
- **Third parties** — colleagues, blog readers, share recipients with zero session context.

**Consequences for writing:**
- No first-person, no "as we discussed", no "in our session". Article register always.
- Code from the user's repo: include excerpt inline + one-sentence file description so a third party without the repo follows along.
- Define jargon on first use. Link prior entries, don't assume they were read.
- Hook orients a fresh reader: concept + problem it solves + domain/context.
- **Litmus test**: publishable on a personal blog tomorrow, unedited? If no, rewrite.

## Step 1: Detect intent

Classify the request before doing anything else:

| Learning intent → fire | Doing intent → do NOT fire |
|---|---|
| "teach me X" | "fix this bug" |
| "explain the concept of X" | "what does this function do" |
| "how does X work" | "how do I implement X" |
| "what is X" (conceptual) | "debug this error" |
| `/teach-me X` | "code review" |

If ambiguous: ask — "Are you trying to understand how X works, or accomplish something specific with X?"

## Step 2: Calibration question

Ask ONE question before researching:

> "What's your current level with **[concept]**?
> - **None** — starting from zero
> - **Some** — heard of it, used it once or twice
> - **Working** — use it regularly, want to go deeper"

Map to Bloom's Taxonomy (see `references/pedagogy.md § Bloom calibration`):

| Answer | Bloom target | Instruction style |
|---|---|---|
| None | L1–L2 (Remember + Understand) | Pre-training cards, animated walkthroughs, interactive quiz with feedback |
| Some | L2–L3 (Understand + Apply) | Worked examples, step reveals, interactive quiz |
| Working | L3–L4 (Apply + Analyze) | Edge cases, comparison tables, open-ended recall |

This level governs: visual complexity, pre-training depth, Deeper section visibility, and recall type.

## Step 3: Research phase — always fetch before teaching

**Never rely solely on training data. Always fetch official primary sources first.**

### Source decision tree

```
Is the topic a software library or framework?
  → context7 first:
      1. resolve-library-id(libraryName=<X>, query=<user's question>)
      2. query-docs(libraryId=<result>, query=<user's question>)
    Fallback if not indexed: WebFetch the official docs URL
    Max 3 context7 calls per question.

Is it a programming language?
  Python  → WebFetch docs.python.org/3/
  Rust    → WebFetch doc.rust-lang.org/stable/
  Go      → WebFetch pkg.go.dev
  JS/TS   → WebFetch tc39.es/ecma262/ or typescriptlang.org/docs/
  Web API → WebFetch developer.mozilla.org

Is it a CS concept (algorithm, pattern, protocol)?
  → Wikipedia for definition
  → ACM/IEEE for originating paper (dl.acm.org / ieeexplore.ieee.org)
  → IETF for network protocols: rfc-editor.org
  → NIST for security: csrc.nist.gov

Is it mathematics?
  → WebFetch dlmf.nist.gov or mathworld.wolfram.com

Is it natural science?
  → WebSearch pubmed.ncbi.nlm.nih.gov or arxiv.org → WebFetch result

Is it social science / humanities?
  → WebSearch jstor.org, britannica.com, or govinfo.gov → WebFetch result

Universal fallback:
  → WebSearch to find authoritative URL → WebFetch it
```

Record every source: **URL + date fetched**. These go in the entry's Sources section.

## Step 4: Resolve topic (once per session)

Topic = the book the entry belongs to (e.g., `nextjs`, `rust`, `databases`). Session-sticky after first resolution.

1. Inspect cwd: `package.json` deps, `Cargo.toml`, `pyproject.toml`, project `CLAUDE.md`, `README.md`.
2. Map signals → slug. Examples: `next` dep → `nextjs`; `react` only → `react`; Cargo.toml → `rust`; no codebase → ask.
3. If `~/.claude/teaching/<slug>/` exists, propose: `Use \`<slug>\` book?` and wait for confirm.
4. If it does not exist, propose creating it.
5. If no signal, ask: `Which topic book? (existing: <list>; or new slug)`.
6. Remember for the session — do NOT re-ask.

## Step 5: Look up

1. Read `~/.claude/teaching/GLOBAL_INDEX.md` + `~/.claude/teaching/<topic>/INDEX.md`.
2. Semantic-match the question against entry titles, summaries, and tags.
3. Decide: **match** or **no match**.

## Step 6a: Match found

Reply with three things and stop:

```
**TL;DR.** <2–3 sentence fresh recap — not copy-pasted from the entry.>

Full entry: `~/.claude/teaching/<topic>/entries/<slug>/index.html`

Want me to expand this entry, go deeper on a sub-concept, or open it?
```

If **expand**: read `source.md`, decide *extend* (same concept, new H2) vs *new entry* (different concept, cross-link). Confirm. Re-research the new angle (Step 3). Update `source.md`, bump `updated:`, re-render `index.html`. If new entry, follow Step 6b + update both indexes.

## Step 6b: No match — teach + persist

**Phase 1 — Teach in chat.** Follow the 7-section skeleton (Step 7). Use research from Step 3.

**Phase 2 — Persist.** In order:

1. Pick slug: short, kebab-case, concept-level (`server-components` not `what-are-server-components`).
2. Create `~/.claude/teaching/<topic>/entries/<slug>/source.md`:
   ```yaml
   ---
   slug: <slug>
   title: <Title Case>
   topic: <topic-slug>
   bloom-level: <none|some|working>
   created: <YYYY-MM-DD>
   updated: <YYYY-MM-DD>
   related: [<slugs>]
   tags: [<concept-tags>]
   sources:
     - url: <URL>
       fetched: <YYYY-MM-DD>
       title: <page title>
   ---
   ```
   followed by the 7 skeleton sections in markdown.
3. Propose cross-links: scan `GLOBAL_INDEX.md`, semantic-match top 2–4 entries, write to `related:`.
4. Bidirectional update: for each related entry, append new slug to its `related:`, bump `updated:`, re-render its HTML.
5. Render this entry's `index.html` (Step 8).
6. Update `~/.claude/teaching/<topic>/INDEX.md`: append one-line entry (see `templates/index-prompt.md`).
7. Update `~/.claude/teaching/GLOBAL_INDEX.md`: append one-line entry.
8. Regenerate `~/.claude/teaching/global-index.json` from GLOBAL_INDEX.md (see Step 9).
9. Regenerate `~/.claude/teaching/global-index.html` global landing page.
10. Regenerate topic `~/.claude/teaching/<topic>/index.html`.
11. End with one prompt and stop:
    ```
    Saved `<slug>` to `<topic>` book. Cross-linked: <list>.
    Open? | Discard? | Rename slug? | Edit cross-links?
    ```

**On discard**: delete entry dir, revert both INDEX files, revert bidirectional related edits, re-render affected HTML, regen global index.

## Step 7: Pedagogical skeleton (7 sections, fixed order)

All sections written for dual audience. Adaptive content within each section based on calibration level.

### 1. Hook
1–2 sentences: name the concept + the problem it solves + the domain. Not "today we'll learn...".

Example: "Server Components are React components that render exclusively on the server, solving the bundle-size cost of rendering UI that has no interactivity."

In HTML: render as `<section class="hook">` with accent callout styling. Add Bloom level badge: `<span class="bloom-badge bloom-<none|some|working>">Level: Beginner / Intermediate / Advanced</span>`

### 2. Key Components (Pre-training)
3–5 key terms the learner must know before the main explanation. Each term: name + 1-sentence definition. Optionally a small SVG icon.

- **None calibration**: render as interactive flip cards (click to reveal definition). Required.
- **Some calibration**: render as a simple definition list. Required.
- **Working calibration**: collapse inside `<details>` with summary "Key Terms (review)". The learner can skip.

Mayer Pre-training principle (#7): never use a term in sections 3–7 that was not introduced here.

### 3. Concrete Example
A fully-worked example from an official source or the user's codebase.

Must include:
- The code or example inline (never just a link)
- If from codebase: `file:line` ref + one sentence describing what the file is
- If from official docs: the source URL appears in Section 6 (Sources)

For non-technical topics: a specific, concrete real-world instance of the concept in action.

### 4. Visual Model
Feynman-simple explanation of the mental model + a mandatory visual chosen by concept shape.

**Select the visual type from this catalog:**

| Concept shape | Visual type | Key implementation |
|---|---|---|
| Data flow / pipeline | Animated particle graph | SVG paths + `requestAnimationFrame` + `getPointAtLength` |
| State machine / lifecycle | Interactive FSM | SVG nodes, click triggers CSS class swap + transition flash |
| N-way comparison | Heatmap table ± radar SVG | HSL color interpolation from `data-score` attributes |
| Time sequence / protocol | Step-reveal sequence diagram | SVG lifelines + opacity transitions + Next button |
| Hierarchy / tree | Collapsible CSS tree | `<details>`/`<summary>` or `scrollHeight` accordion |
| Before/after | Tab toggle or draggable split | `mousedown`/`mousemove` → CSS var `--split` |
| Concept map | Force-directed graph | Spring simulation in `rAF` on SVG or canvas |
| Algorithm trace | Code highlight + data structure viz | Snapshot array + step counter + CSS transitions |
| Math relationship | Parametric SVG chart | `scaleX`/`scaleY` + range input → redraw path |
| Mental model / analogy | Annotated scene with click-to-reveal labels | CSS `position: absolute` overlays + toggle class |

See `references/pedagogy.md § Visual type catalog` for full implementation patterns.

**Complexity scales with calibration level:**
- None: animated step-by-step with "Next" button required (never auto-advance)
- Some: diagram with signaling (arrows, highlights on active part)
- Working: dense diagram or comparison table; static acceptable if information-rich

**Non-negotiable visual rules (Mayer):**
- Every visual element must carry meaning — no decoration (Coherence #1)
- Labels placed adjacent to what they describe, never in a separate legend (Spatial Contiguity #4)
- Never auto-play sequences — always require "Next" or "Play" (Segmenting #6)
- Highlight the currently active region during any step reveal (Signaling #2)

### 5. Deeper
Edge cases, gotchas, common mistakes, why naive intuition fails.

- **None/Some calibration**: wrap in `<details class="deeper">` collapsed by default
- **Working calibration**: render expanded, no `<details>` wrapper

Always include at least one "anti-pattern" with a concrete example of what breaks and why.

### 6. Cross-links & Sources

Two parts in one section:

**A. Related entries** (from book):
Links to 2–4 related entries with one-sentence description of the connection. Rendered as linked cards with `data-entry` attribute for hover preview popover.

**B. Sources consulted:**
Every URL fetched in Step 3, formatted as:
```
- [Page Title](URL) — fetched YYYY-MM-DD
```
Lets the learner verify currency of the information.

### 7. Adaptive Recall

**None/Some calibration** — interactive quiz:
- 2 closed questions (multiple-choice or true/false): show options, click answer, reveal correct + 1-sentence explanation
- 1 open-ended "what would happen if…" question: click "Show answer" to reveal model answer
- Questions test *mental model*, not trivia. Lead with "what happens if", "why does", "what's the difference between"

**Working calibration** — open-ended only:
- 1–2 "what would happen if…" or "how would you approach…" questions
- No reveal button. No answers given. Forcing genuine retrieval is the point.

## When the learner doesn't understand

If the user says "still don't get it", "simpler please", "another angle", "ELI5", or any similar signal: do NOT repeat the same explanation louder. Switch tactic. Try this ladder in order until something clicks:

1. **Different concrete example** — same concept, entirely new code or scenario from a different domain.
2. **Real-world analogy** — explain using something from outside the subject: pizza delivery, libraries, post offices, traffic lights, plumbing. Accept lossy precision.
3. **ELI5** — strip all jargon. Use the smallest possible words. One sentence per idea.
4. **Inverse approach** — show what *breaks* when the concept is absent. Absence reveals value faster than presence does.
5. **Step-by-step trace** — walk execution or logic one operation at a time. No skipping. No summarising.

After switching tactic: re-render the **Visual Model** section (Section 4) of the saved entry with the new angle. Append to its H2: *(revised — alternate explanation)*. Update `updated:` in `source.md` frontmatter and re-render `index.html`.

## Step 8: HTML rendering

Do NOT call `/html` — skills cannot invoke each other. Follow `templates/entry-prompt.md` for entry HTML and `templates/index-prompt.md` for landing pages.

**Non-negotiable constraints:**
- Fully self-contained. No external CDN links.
- Entry links: `<link rel="stylesheet" href="../../assets/style.css">`
- Landing links: `<link rel="stylesheet" href="assets/style.css">`
- Shared stylesheet: copy `templates/style.css` → `<topic>/assets/style.css` on first topic use.
- Vanilla JS only. No React, Vue, or build step.
- Anti-flash dark mode: inline `<script>` in `<head>` reads `localStorage` before first paint.
- Dark-mode aware: CSS vars on `:root`, `[data-theme="dark"]` override, toggle button top-right.
- System font stack: `-apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif`.

**Rendering workflow:**
1. Read relevant template from `templates/`.
2. Read source: `source.md` (entry) or `INDEX.md` + `global-index.json` (landing).
3. Select visual type from the catalog in Step 7 based on concept shape.
4. Produce full HTML. Write to target path.

## Step 9: Book structure

```
~/.claude/teaching/
  GLOBAL_INDEX.md          ← flat index of ALL entries across all topics
  global-index.json        ← JSON array for client-side search
  global-index.html        ← searchable + tag/topic-filterable global landing
  <topic>/
    INDEX.md               ← topic-scoped index (same as current format)
    index.html             ← topic landing page
    assets/
      style.css            ← shared stylesheet (from templates/style.css)
    entries/
      <slug>/
        source.md          ← source of truth
        index.html         ← rich interactive HTML entry
```

**GLOBAL_INDEX.md** — append one line per entry:
```
| <slug> | <title> | <topic> | <tags-csv> | <created> | <updated> | <one-sentence summary> |
```

**global-index.json** — rebuild whenever any entry changes:
```json
[
  {
    "id": "<slug>",
    "title": "<title>",
    "topic": "<topic>",
    "tags": ["tag1", "tag2"],
    "summary": "<one sentence>",
    "path": "<topic>/entries/<slug>/index.html",
    "created": "YYYY-MM-DD",
    "updated": "YYYY-MM-DD"
  }
]
```

**global-index.html features** (follow `templates/index-prompt.md`):
- Client-side search: in-memory inverted index over title + summary + tags, built on load from `global-index.json`
- Tag filter: multi-select pills, AND logic, URL-synced (`?tags=react,server`)
- Topic filter: tab bar or dropdown
- Keyboard shortcut: `/` or `Ctrl+K` focuses search
- Entry cards: title, summary, topic badge, tag pills, updated date

## Step 10: Manual rebuild

`/teach-me rebuild` — re-render all entry HTML + landing pages from source markdown. No content change. Useful after template/stylesheet changes.

`/teach-me rebuild <topic>` — rebuild only that topic's entries + landing.

## Out of scope

Do NOT add: spaced repetition scheduling, answer tracking across sessions, sync to remote. Do NOT auto-trigger on generic "explain"/"what is"/"what does X do" in isolation — require clear learning intent signal.

## File map (this skill)

```
~/.claude/skills/teach-me/
  SKILL.md
  templates/
    entry-prompt.md       ← spec for generating entry index.html
    index-prompt.md       ← spec for topic + global landing pages
    style.css             ← shared stylesheet source
  references/
    pedagogy.md           ← full theoretical framework
```

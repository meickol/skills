---
name: teach-me
description: >
  The best-in-class pedagogical teacher for any concept — technical, scientific, mathematical, or conceptual — powered by Mayer's Multimedia Learning principles and Bloom's Taxonomy calibration. Always fetches official primary sources before teaching. Produces a rich interactive HTML entry (animated SVG diagrams, interactive recall, concept maps) saved to a searchable hybrid reference book at user scope (<teaching-root>/) or project scope (.claude/teaching/ in cwd) — asks user once per session. Trigger on: "/teach-me <X>", "teach me about X", "teach me X", "explain me X", "explain X to me", "explain X", "explain the concept of X", "how does X work conceptually", "what is X", "what are X", or any request to understand a topic rather than accomplish a task. Do NOT trigger for: debugging, "fix this", "what does this function do", code review, or task-completion questions where the user wants to accomplish something rather than understand something.
---

# /teach-me — Research-Backed Pedagogical Teacher + Reference Book

Two jobs:
1. Teach the concept using Mayer's Multimedia Learning principles, calibrated to learner level, grounded in official sources fetched in real time.
2. Persist the explanation as a rich interactive HTML entry in a searchable hybrid reference book at `<teaching-root>/`.

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

## Step 0: Scope resolution (once per session)

Resolve `<teaching-root>` before anything else. Session-sticky — do NOT re-ask.

If already resolved this session: skip to Step 1.

Ask the user:

> Where should books be saved?
> - **User library** — `~/.claude/teaching/` (accessible from any project)
> - **Project library** — `.claude/teaching/` in current working directory (scoped to this project)

Map answer to `<teaching-root>`:

| Choice | `<teaching-root>` |
|---|---|
| User library | `~/.claude/teaching` |
| Project library | `<absolute-path-of-cwd>/.claude/teaching` |

Resolve cwd absolute path with `pwd` if project scope is chosen. Store for the session.

If invoked as `/teach-me rebuild` or `/teach-me rebuild <topic>`: ask scope before rebuilding.

## Step 1: Detect intent

Classify the request before doing anything else:

| Learning intent → fire | Doing intent → do NOT fire |
|---|---|
| "teach me X" / "teach me about X" | "fix this bug" |
| "explain me X" / "explain X" / "explain X to me" | "what does this function do" |
| "explain the concept of X" | "how do I implement X" |
| "how does X work" | "debug this error" |
| "what is X" / "what are X" (conceptual) | "code review" |
| `/teach-me X` | "how do I do X" (task intent) |

If ambiguous: ask — "Are you trying to understand how X works, or accomplish something specific with X?"

## Step 2: Calibration

**Default to "Some" (L2–L3) and proceed without asking** unless one of these signals is present:
- User explicitly says beginner/new/never used/don't know
- User says expert/advanced/deep dive/internals
- The concept is highly fundamental (e.g., "what is a variable") — default **None**
- The concept is highly advanced/niche — default **Working**

When asking is necessary (genuinely ambiguous AND calibration will materially change the output), ask ONE question only:

> "What's your current level with **[concept]**?
> - **None** — starting from zero
> - **Some** — heard of it, used it once or twice *(default)*
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

**Scale research to concept complexity:**
- **Foundational concept** ("what is a variable", "what is recursion") → one authoritative source is enough. Don't hit academic papers for things with stable, universal definitions.
- **Library/framework API** ("how does useEffect work", "Rust lifetimes") → fetch current official docs. APIs change; training data goes stale.
- **Complex/domain-specific** ("how does the V8 garbage collector work", "CAP theorem proof") → full source hierarchy. Multiple sources, cite all.

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

## First-run initialization

If `<teaching-root>/` does not exist, create the full structure before doing anything else:

```bash
mkdir -p <teaching-root>
```

Then create these files:

**`<teaching-root>/GLOBAL_INDEX.md`** — create with header row only:
```
| slug | title | topic | tags | created | updated | summary |
|---|---|---|---|---|---|---|
```

**`<teaching-root>/global-index.json`** — create as empty array:
```json
[]
```

Do NOT create `global-index.html` yet — generate it the first time an entry is saved (Step 6b).

When creating a new topic for the first time (`<teaching-root>/<topic>/` doesn't exist):
```bash
mkdir -p <teaching-root>/<topic>/entries
mkdir -p <teaching-root>/<topic>/assets
```
Then copy `templates/style.css` → `<teaching-root>/<topic>/assets/style.css`.

Create `<teaching-root>/<topic>/INDEX.md` with header row:
```
| slug | title | tags | created | updated | description |
|---|---|---|---|---|---|
```

Do NOT create `<topic>/index.html` yet — generate it after the first entry is saved.

## Step 4: Resolve topic (once per session)

Topic = the book the entry belongs to (e.g., `nextjs`, `rust`, `databases`). Session-sticky after first resolution.

1. Inspect cwd: `package.json` deps, `Cargo.toml`, `pyproject.toml`, project `CLAUDE.md`, `README.md`.
2. Map signals → slug. Examples: `next` dep → `nextjs`; `react` only → `react`; Cargo.toml → `rust`; no codebase → ask.
3. If `<teaching-root>/<slug>/` exists, propose: `Use \`<slug>\` book?` and wait for confirm.
4. If it does not exist, propose creating it.
5. If no signal, ask: `Which topic book? (existing: <list>; or new slug)`.
6. Remember for the session — do NOT re-ask.

## Step 5: Look up

1. Read `<teaching-root>/GLOBAL_INDEX.md` + `<teaching-root>/<topic>/INDEX.md`.
2. Semantic-match the question against entry titles, summaries, and tags.
3. Decide: **match** or **no match**.

## Step 6a: Match found

Reply with three things and stop:

```
**TL;DR.** <2–3 sentence fresh recap — not copy-pasted from the entry.>

Full entry: `<teaching-root>/<topic>/entries/<slug>/index.html`

Want me to expand this entry, go deeper on a sub-concept, or open it?
```

If **expand**: read `source.md`, decide *extend* (same concept, new H2) vs *new entry* (different concept, cross-link). Confirm. Re-research the new angle (Step 3). Update `source.md`, bump `updated:`, re-render `index.html`. If new entry, follow Step 6b + update both indexes.

## Step 6b: No match — teach + persist

**Phase 1 — Teach in chat.** Follow the 7-section skeleton (Step 7). Use research from Step 3.

**Phase 2 — Persist.** In order:

1. Pick slug: short, kebab-case, concept-level (`server-components` not `what-are-server-components`).
2. Create `<teaching-root>/<topic>/entries/<slug>/source.md`:
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
6. Update `<teaching-root>/<topic>/INDEX.md`: append one-line entry (see `templates/index-prompt.md`).
7. Update `<teaching-root>/GLOBAL_INDEX.md`: append one-line entry.
8. Regenerate `<teaching-root>/global-index.json` from GLOBAL_INDEX.md (see Step 9).
9. Regenerate `<teaching-root>/global-index.html` global landing page.
10. Regenerate topic `<teaching-root>/<topic>/index.html`.
11. Open the entry in the browser:
    - macOS: `open <teaching-root>/<topic>/entries/<slug>/index.html`
    - Linux: `xdg-open <teaching-root>/<topic>/entries/<slug>/index.html`
12. End with one prompt and stop:
    ```
    Saved `<slug>` to `<topic>` book. Opened in browser. Cross-linked: <list>.
    Discard? | Rename slug? | Edit cross-links?
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

**Select the visual type** using this decision algorithm:

1. Ask: *what is the single most important thing the learner needs to see?*
   - A thing flowing through stages → **Data flow**
   - A thing changing state in response to events → **State machine**
   - Multiple options the learner needs to pick between → **N-way comparison**
   - Events happening in a specific time order → **Time sequence**
   - Parts nested inside parts → **Hierarchy / tree**
   - What it looked like before vs after a transformation → **Before/after**
   - How concepts relate to each other → **Concept map**
   - Each step of a procedure → **Algorithm trace**
   - How changing one variable affects another → **Math relationship**
   - A real-world parallel to an abstract concept → **Mental model / analogy**

2. If the concept fits two types equally: pick the one that shows the *core insight* (the thing the learner most often gets wrong), not just any applicable type.

3. Full implementation patterns for each type: see `references/pedagogy.md § Visual type catalog`.

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
<teaching-root>/
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
    "id": "<topic>/<slug>",
    "title": "<title>",
    "topic": "<topic>",
    "slug": "<slug>",
    "tags": ["tag1", "tag2"],
    "summary": "<one sentence>",
    "path": "<topic>/entries/<slug>/index.html",
    "created": "YYYY-MM-DD",
    "updated": "YYYY-MM-DD"
  }
]
```

Note: `id` is `"<topic>/<slug>"` (not just `"<slug>"`) to avoid collisions when two topics have entries with the same concept name (e.g., `nextjs/promises` vs `rust/promises`).

**global-index.html features** (follow `templates/index-prompt.md`):
- Client-side search: in-memory inverted index over title + summary + tags, built on load from `global-index.json`
- Tag filter: multi-select pills, AND logic, URL-synced (`?tags=react,server`)
- Topic filter: tab bar or dropdown
- Keyboard shortcut: `/` or `Ctrl+K` focuses search
- Entry cards: title, summary, topic badge, tag pills, updated date

## Step 10: Manual rebuild

`/teach-me rebuild` — re-render all entry HTML + landing pages from source markdown. No content change. Useful after template/stylesheet changes.

`/teach-me rebuild <topic>` — rebuild only that topic's entries + landing.

## Follow-up handling

If the user asks a follow-up about a concept immediately after a teach session (same session, same topic):

- **Clarification** ("wait, what does X mean in that context?") → answer inline in chat. Do NOT restart the full skill flow. Append a brief note to the saved entry's source.md under a `## Clarifications` H2 if the clarification is substantive.
- **Deeper dive** ("tell me more about X") → treat as an expand request (Step 6a expand flow). Check if it warrants a new entry or extending the current one.
- **Unrelated new concept** ("now teach me Y") → fresh skill invocation. Full flow from Step 1.

Avoid re-running calibration, re-fetching sources already fetched this session, or re-saving an entry that hasn't changed.

## Topic slug rules

Slugify topic names to lowercase kebab-case:
- "machine learning" → `machine-learning`
- "Next.js" → `nextjs`
- "React Native" → `react-native`
- "C++" → `cpp`
- "Node.js" → `nodejs`
- Single-word names unchanged: "rust", "python", "databases"

Entry slug collision within a topic: if `promises` already exists in `nextjs/`, append a disambiguator (`promises-async-await`, `promises-error-handling`). Never overwrite an existing entry silently.

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

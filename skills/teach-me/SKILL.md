---
name: teach-me
description: >
  The best-in-class pedagogical teacher for any concept — technical, scientific, mathematical, or conceptual — powered by Mayer's Multimedia Learning principles and Bloom's Taxonomy calibration. Always fetches official primary sources before teaching. Produces a rich interactive HTML entry (animated SVG diagrams, interactive recall, concept maps) saved to a searchable hybrid reference book at user scope (<teaching-root>/) or project scope (.claude/teaching/ in cwd) — asks user once per session. Trigger on: "/teach-me <X>", "teach me about X", "teach me X", "explain me X", "explain X to me", "explain X", "explain the concept of X", "how does X work conceptually", "what is X", "what are X", or any request to understand a topic rather than accomplish a task. Do NOT trigger for: debugging, "fix this", "what does this function do", code review, or task-completion questions where the user wants to accomplish something rather than understand something.
---

# /teach-me — Research-Backed Pedagogical Teacher + Reference Book

Two jobs:
1. Answer immediately and clearly — no setup friction for quick lookups.
2. Optionally persist the explanation as a rich interactive HTML entry in a searchable reference book that grows with the conversation.

See `references/pedagogy.md` for the full theoretical framework (Mayer, Bloom, Cognitive Load Theory, source hierarchy by domain).

## Audience — dual, always

Every saved entry must work for both simultaneously:

- **The student** — revisits to recap. Wants TL;DR, visual model, gotchas, interactive recall.
- **Third parties** — colleagues, blog readers, share recipients with zero session context.

**Consequences for writing:**
- No first-person, no "as we discussed", no "in our session". Article register always.
- Code from the user's repo: include excerpt inline + one-sentence file description so a third party without the repo follows along.
- Define jargon on first use. Link prior entries, don't assume they were read.
- Hook orients a fresh reader: concept + problem it solves + domain/context.
- **Litmus test**: publishable on a personal blog tomorrow, unedited? If no, rewrite.

## Main flow

```
Step 1: Detect intent
  ↓
Step 2: Session check + lookup
  ↓
  Same concept answered this session? → Step 5 (different tactic)
  ↓
Step 3: Short answer (no research, no setup questions, always fires)
  ↓
Step 4: Offer
  No doc exists → "Want to create a doc for this? [Yes / No]"
  Doc exists    → "Want to add this to the [topic] doc? [Yes / No]"
  ↓ (if Yes)
Step 5a: New doc creation  (scope → topic → calibration → research → write source.md only)
Step 5:  Same concept      (different tactic → offer to revise source.md)
Step 6:  Add to existing   (research scoped → append/revise source.md only)

── PUBLISH PHASE ────────────────────────────────────────────────────

/teach-me generate <topic>
  → curate new Q&A sections (AI judges value)
  → synthesize full 7-section article from Q&A as source material
  → generate SVG visuals
  → render index.html + indexes
  → open in browser
```

---

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

---

## Step 2: Session check + lookup

Before answering:

1. **Session tracker**: Check if this concept was already answered this session.
   - Yes → skip to **Step 5 (same concept — different tactic)**.
   - No → continue.

2. **Doc lookup**: If `<teaching-root>` is already known this session, read `GLOBAL_INDEX.md` and check for a semantic match.
   - If `<teaching-root>` is not known yet (scope not set) → skip doc lookup. Answer anyway.

3. Note match result (yes/no) for Step 4 offer wording.

---

## Step 3: Short answer

**Always fires first. No research. No setup questions. No headers or sections.**

Format:
- 1–3 sentences: what the concept is + the problem it solves
- 1 minimal code or real-world example (inline, not linked)
- Default "Some" calibration — accessible wording, not oversimplified
- No sections, headers, quiz, visual diagram

Example — "what is a server action":

> Server Actions are async functions that run on the server and can be called directly from React components — they replace API route boilerplate for mutations and form submissions.
> ```tsx
> async function saveUser(formData: FormData) {
>   'use server'
>   await db.users.create({ name: formData.get('name') })
> }
> ```

After answering: record this concept in the session tracker.

---

## Step 4: Offer

After the short answer, always ask exactly one of:

**No doc exists for this concept:**
```
Want to create a doc for this? [Yes / No]
```

**Doc exists:**
```
Want to add this to the [topic] doc? [Yes / No]
```

If user says No or ignores: stop. The answer stands on its own.

---

## Step 5: Same concept — different tactic

Fires when session tracker shows this concept was already answered this session.

Apply the tactic ladder in order until something clicks:

1. **Different concrete example** — same concept, entirely new code or scenario from a different domain.
2. **Real-world analogy** — explain using something from outside the subject: pizza delivery, libraries, post offices, traffic lights, plumbing. Accept lossy precision.
3. **ELI5** — strip all jargon. Use the smallest possible words. One sentence per idea.
4. **Inverse approach** — show what *breaks* when the concept is absent. Absence reveals value faster than presence does.
5. **Step-by-step trace** — walk execution or logic one operation at a time. No skipping. No summarising.

After answering:
- If doc exists: "Want me to update the doc with this explanation? [Yes / No]"
  - Yes → find the existing section → rewrite with new angle → append *(revised — alternate explanation)* to the section heading → bump `updated:` → re-render `index.html`.
- If no doc: "Want to create a doc? [Yes / No]" → Step 5a.

---

## Step 5a: New doc creation path

Fires when user says Yes to "Want to create a doc?"

### Onboarding notice (show once per session — at first doc creation only)

> **One-time setup** — I'll ask a few questions now. These won't be asked again this session:
> 1. **Where to save** — your user-wide learning library or this project only?
> 2. **Which topic book** — e.g. `nextjs`, `rust`, `databases`
> 3. **Your level** — only if it affects how I structure the entry

Session-sticky: after the first doc creation this session, skip this notice for all subsequent saves.

### Scope resolution (old Step 0)

Ask:

> Where should books be saved?
> - **User library** — `~/.claude/teaching/` (accessible from any project)
> - **Project library** — `.claude/teaching/` in current working directory (scoped to this project)

Map answer to `<teaching-root>`:

| Choice | `<teaching-root>` |
|---|---|
| User library | `~/.claude/teaching` |
| Project library | `<absolute-path-of-cwd>/.claude/teaching` |

Resolve cwd absolute path with `pwd` if project scope is chosen. Store for the session. Do NOT re-ask.

### Topic resolution

1. Inspect cwd: `package.json` deps, `Cargo.toml`, `pyproject.toml`, project `CLAUDE.md`, `README.md`.
2. Map signals → slug. Examples: `next` dep → `nextjs`; `react` only → `react`; Cargo.toml → `rust`; no codebase → ask.
3. If `<teaching-root>/<slug>/` exists, propose: `Use \`<slug>\` book?` and wait for confirm.
4. If it does not exist, propose creating it.
5. If no signal, ask: `Which topic book? (existing: <list>; or new slug)`.
6. Session-sticky — do NOT re-ask.

### Calibration

Default "Some" unless one of these signals is present:
- User explicitly says beginner/new/never used/don't know → **None**
- User says expert/advanced/deep dive/internals → **Working**
- Concept is highly fundamental (e.g., "what is a variable") → **None**
- Concept is highly advanced/niche → **Working**

If genuinely ambiguous AND calibration will materially change the output, ask ONE question:

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

### Research phase

**Now fetch official primary sources. Never rely solely on training data.**

**Scale research to concept complexity:**
- **Foundational concept** ("what is a variable", "what is recursion") → one authoritative source is enough.
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

### First-run initialization

If `<teaching-root>/` does not exist, create before persisting:

```bash
mkdir -p <teaching-root>
```

Then create:

**`<teaching-root>/GLOBAL_INDEX.md`** — header row only:
```
| slug | title | topic | tags | created | updated | summary |
|---|---|---|---|---|---|---|
```

**`<teaching-root>/global-index.json`** — empty array:
```json
[]
```

Do NOT create `global-index.html` yet — generate it when the first entry is saved.

When creating a new topic for the first time (`<teaching-root>/<topic>/` doesn't exist):
```bash
mkdir -p <teaching-root>/<topic>/entries
mkdir -p <teaching-root>/<topic>/assets
```
Copy `templates/style.css` → `<teaching-root>/<topic>/assets/style.css`.

Create `<teaching-root>/<topic>/INDEX.md` with header row:
```
| slug | title | tags | created | updated | description |
|---|---|---|---|---|---|
```

Do NOT create `<topic>/index.html` yet — generate after the first entry is saved.

### Create stub doc

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
published: null
related: []
tags: []
sources: []
---
```

```markdown
## Answer

<the short answer text from Step 3>

```<language>
<code example from Step 3>
```
```

3. Propose cross-links: scan `GLOBAL_INDEX.md`, semantic-match top 2–4 entries, write to `related:`.
4. Bidirectional update: for each related entry, append new slug to its `related:`, bump `updated:`.
5. Update `<teaching-root>/<topic>/INDEX.md`.
6. Update `<teaching-root>/GLOBAL_INDEX.md`.
7. Regenerate `global-index.json`.
8. End with:
    ```
    Saved `<slug>` to `<topic>` book. Cross-linked: <list>.
    Run `/teach-me generate <topic>` to publish as HTML.
    Discard? | Rename slug?
    ```

**No HTML is generated here.** HTML only produced by `/teach-me generate`.

**On discard**: delete entry dir, revert both INDEX files, revert bidirectional related edits, regen global-index.json.

---

## Step 6: Add to existing doc

Fires when user says Yes to "Want to add this to the doc?" or "Want me to update the doc?"

1. Research the new angle only (source decision tree above, scoped to the specific question).
2. Read `source.md`.
3. **Same concept as existing section?** → revise that section. Append *(revised — alternate explanation)* to the H2. Do not duplicate.
4. **New angle or new sub-question?** → append:
   ```markdown
   ## Q: <question asked>

   <answer>

   **Sources:** <fetched URLs with fetch date>
   ```
5. Bump `updated:` in frontmatter.
6. Update `GLOBAL_INDEX.md` + `global-index.json` updated dates.

**No HTML is generated here.** Run `/teach-me generate` to publish.

---

## Step 7: Pedagogical skeleton (7 sections — used by `/teach-me generate` only)

These 7 sections are the output format of the `generate` command. They are synthesized from Q&A content in `source.md`. They are **never pre-generated** during Q&A — the stub grows as raw material and `generate` organizes it.

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

Each entry's visual is self-contained — no cross-entry SVG reuse.

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
Every URL fetched, formatted as:
```
- [Page Title](URL) — fetched YYYY-MM-DD
```

### 7. Adaptive Recall

**None/Some calibration** — interactive quiz:
- 2 closed questions (multiple-choice or true/false): show options, click answer, reveal correct + 1-sentence explanation
- 1 open-ended "what would happen if…" question: click "Show answer" to reveal model answer
- Questions test *mental model*, not trivia. Lead with "what happens if", "why does", "what's the difference between"

**Working calibration** — open-ended only:
- 1–2 "what would happen if…" or "how would you approach…" questions
- No reveal button. No answers given. Forcing genuine retrieval is the point.

---

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

---

## Step 9: Book structure

```
<teaching-root>/
  GLOBAL_INDEX.md          ← flat index of ALL entries across all topics
  global-index.json        ← JSON array for client-side search
  global-index.html        ← searchable + tag/topic-filterable global landing
  <topic>/
    INDEX.md               ← topic-scoped index
    index.html             ← topic landing page
    assets/
      style.css            ← shared stylesheet (from templates/style.css)
    entries/
      <slug>/
        source.md          ← source of truth (grows incrementally)
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

Note: `id` is `"<topic>/<slug>"` to avoid collisions when two topics have entries with the same concept name.

**global-index.html features** (follow `templates/index-prompt.md`):
- Client-side search: in-memory inverted index over title + summary + tags, built on load from `global-index.json`
- Tag filter: multi-select pills, AND logic, URL-synced (`?tags=react,server`)
- Topic filter: tab bar or dropdown
- Keyboard shortcut: `/` or `Ctrl+K` focuses search
- Entry cards: title, summary, topic badge, tag pills, updated date

---

## Step 10: `/teach-me generate` — publish Q&A as rich HTML article

Aliases: `generate` (official) = `publish` = `render`.

### Syntax

| Command | Behavior |
|---|---|
| `/teach-me generate <topic>` | Generate/update all entries in topic |
| `/teach-me generate <topic> <slug>` | Force-generate one specific entry |

### Per-entry process

For each entry in the topic:

**1. Determine scope**
- Read `source.md` frontmatter: check `published` date.
- Collect all `## Q:` and `## Answer` sections added **after** `published` date (or all sections if `published: null`).
- If no new sections → skip this entry. Log: `<slug>: no new content, skipped`.

**2. Curate new sections**
- For each new section, evaluate: does it introduce a new concept, a distinct example, a new edge case, or a new source not already represented in the current article?
- Include → yes. Exclude → no. Exclusion logged: `<slug>: skipped "<section heading>" (duplicate of existing Answer)`.

**3. Synthesize article**
Using all included sections as source material, produce a full 7-section article (Step 7):
- Synthesize: extract best examples, edge cases, and explanations from Q&A — do NOT copy-paste verbatim.
- Infer missing sections: if Q&A never covered a section (e.g., "Deeper"), write it from the research sources already in `source.md`.
- Generate visual model (SVG diagram) — select type from the decision algorithm in Step 7 § Visual Model. This is the primary place visuals are produced.
- Use only sources already captured in `source.md` frontmatter. No new web fetches.

**4. Write output**
- Render `index.html` per Step 8 spec.
- Set `published: <YYYY-MM-DD>` in `source.md` frontmatter.
- Update `GLOBAL_INDEX.md` + `global-index.json` updated date.
- Regenerate `global-index.html` and topic `index.html`.
- Open in browser:
  - macOS: `open <teaching-root>/<topic>/entries/<slug>/index.html`
  - Linux: `xdg-open <teaching-root>/<topic>/entries/<slug>/index.html`

**5. End with summary**
```
Generated `<topic>` book:
  ✓ server-actions — 3 sections added
  ✓ server-components — first publish
  – promises — no new content, skipped

Opened: server-actions, server-components
```

### Manual rebuild (template/stylesheet changes only)

`/teach-me rebuild` — re-render all HTML from existing `source.md` without curation or synthesis. No content change.

`/teach-me rebuild <topic>` — rebuild only that topic.

---

## Follow-up handling

If the user asks a follow-up about a concept immediately after a teach session (same session, same topic):

- **Clarification** ("wait, what does X mean in that context?") → answer inline in chat. Do NOT restart the full skill flow. Append a brief note to `source.md` under a `## Clarifications` H2 if the clarification is substantive.
- **Deeper dive** ("tell me more about X") → treat as a Step 6 append. Research the deeper angle. Offer to add to doc.
- **Same concept, rephrased** ("I still don't get it", "explain differently") → Step 5 (different-tactic ladder).
- **Unrelated new concept** ("now teach me Y") → full flow from Step 1.

Avoid re-running calibration, re-fetching sources already fetched this session, or re-saving an entry that hasn't changed.

---

## Topic slug rules

Slugify topic names to lowercase kebab-case:
- "machine learning" → `machine-learning`
- "Next.js" → `nextjs`
- "React Native" → `react-native`
- "C++" → `cpp`
- "Node.js" → `nodejs`
- Single-word names unchanged: "rust", "python", "databases"

Entry slug collision within a topic: if `promises` already exists in `nextjs/`, append a disambiguator (`promises-async-await`, `promises-error-handling`). Never overwrite an existing entry silently.

---

## Out of scope

Do NOT add: spaced repetition scheduling, answer tracking across sessions, sync to remote. Do NOT auto-trigger on generic "explain"/"what is"/"what does X do" in isolation — require clear learning intent signal.

---

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

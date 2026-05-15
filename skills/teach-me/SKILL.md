---
name: teach-me
description: >
  Pedagogical teacher mode that explains a concept with strong didactic structure (Feynman, scaffolding, dual coding, active recall) and incrementally builds a per-topic visual HTML reference book. Entries serve two audiences: the student themself (recap / spaced revisit) AND third parties (shareable research-grade explainer that stands alone without session context). Use when the user says `/teach-me <question>`, "teach me about X", "explain the concept of X", "what is X conceptually", or otherwise asks to learn a topic rather than debug code. Do NOT trigger for code debugging, "what does this function do", code review, or fixing bugs.
---

# /teach-me — Pedagogical Teacher + Reference Book Builder

Two jobs:
1. Explain the concept the user asked about, using strong pedagogy.
2. Record the explanation as an entry in a per-topic HTML book at `~/.claude/teaching/<topic>/`.

## Audience — entries serve TWO readers

Every entry must work for both, simultaneously:

- **The student** (primary) — revisits the entry to recap a concept they previously learned. Wants TL;DR, mental model, gotchas, recall prompts. Reads the book like a personal notebook.
- **Third parties** (secondary, equally important) — colleagues, study group, conference attendees, blog readers the student shares the entry with. Have NO context about the session, the codebase, or the student's prior knowledge. Must understand the entry standalone.

**Consequences for writing:**

- No first-person, no "as we discussed", "earlier you asked", "in our last session". Every entry reads like a published article.
- Concrete examples that cite `file:line` from the user's repo MUST also include the code excerpt inline AND a one-sentence description of what that file is, so a third party who has never seen the repo still gets the example.
- Define jargon on first use within the entry. Don't assume the reader has read prior entries — link them via cross-links instead.
- The **Hook** opens by orienting a fresh reader: name the concept, name the problem it solves, name the context (framework / language / domain).
- Avoid casual tone or inside jokes. Aim for the register of a well-written technical blog post: warm, clear, neutral.
- The student's own learning journey (what confused them, what clicked) is invisible in the artifact. Recap value comes from the *content quality*, not from session breadcrumbs.

**Litmus test before saving:** could you publish this entry on a personal blog tomorrow without editing it? If no, rewrite until yes.

If the user has a project `CLAUDE.md` with a "How to respond to questions" section, treat it as the baseline answer posture *in chat* and extend it with the pedagogy in `references/pedagogy.md`. The saved entry follows the standalone-artifact rules above even if the chat reply is more conversational.

## Step 1: Resolve the topic (once per session)

Topic is the **book** the entry belongs to (e.g., `nextjs`, `rust`, `databases`). Session-sticky after first resolution.

1. Inspect cwd for signal: `package.json` deps, `Cargo.toml`, `pyproject.toml`, project `CLAUDE.md`, `README.md`.
2. Map signals → slug. Examples: `next` dep → `nextjs`; `react` only → `react`; `[dependencies]` in Cargo.toml → `rust`.
3. If `~/.claude/teaching/<slug>/` exists, propose: `Use \`<slug>\` book?` and wait for confirm.
4. If it does not exist, propose creating it.
5. If no signal, ask: `Which topic book? (existing: <list>; or new slug)`.
6. Remember for the rest of the session — do NOT re-ask each question.

## Step 2: Look up

1. Read `~/.claude/teaching/<topic>/INDEX.md`.
2. Semantic-match the question against entry descriptions and tags.
3. Decide: **match** or **no match**.

## Step 3a: Match found (existing entry)

Reply with three things and stop:

```
**TL;DR.** <2–3 sentence recap of the concept, written fresh — not copy-pasted from the entry.>

Full entry: `~/.claude/teaching/<topic>/entries/<slug>/index.html`

Want me to expand this entry with a new angle, or open it in the browser?
```

If the user says **expand**:
- Read the entry's `source.md`.
- Decide *extend* (same concept, deeper angle → new H2 section in same file) vs *new entry* (different concept, related → fresh entry with cross-link). Propose your call and confirm.
- Use ALL relevant session context (codebase files the user opened, prior chat) to enrich.
- Edit `source.md`, bump `updated:` frontmatter, re-render its `index.html` (see Step 5).
- If a new entry was created, follow Step 3b cross-link + landing-regen flow.

## Step 3b: No match (new entry)

Two phases.

**Phase 1 — Answer in chat.** Follow the pedagogical skeleton (Step 4). Same skeleton goes into the saved entry, so the answer and saved entry stay aligned. Use the user's codebase for concrete examples whenever possible — cite `file:line` references.

**Phase 2 — Persist.** Do these steps in order:

1. Pick a slug: short, kebab-case, concept-level (e.g., `server-components`, not `what-are-server-components`).
2. Create `~/.claude/teaching/<topic>/entries/<slug>/source.md` with frontmatter:
   ```yaml
   ---
   slug: <slug>
   title: <Title Case>
   chapter: <number-or-omit>
   created: <YYYY-MM-DD>
   updated: <YYYY-MM-DD>
   related: [<proposed-slugs>]
   tags: [<concept-tags>]
   ---
   ```
   followed by the answer markdown organised under the 6 skeleton headings.
3. **Propose cross-links.** Scan `INDEX.md` descriptions, semantic-match top 2–4 related entries, write them into `related:`.
4. **Bidirectional update.** For each entry in `related:`, append the new slug to ITS `source.md` `related:` array and bump its `updated:`. Re-render those entries' HTML (Step 5).
5. Render this entry's `index.html` (Step 5).
6. Update `INDEX.md`: append a one-line entry following the format in `templates/index-prompt.md`.
7. Regenerate the topic's `index.html` landing page (Step 5).
8. End with one prompt and stop:
   ```
   Saved `<slug>`. Cross-linked: <list>.
   Open? | Discard? | Rename slug? | Edit cross-links?
   ```

On **discard**: delete the entry directory, revert INDEX.md, revert bidirectional `related:` edits on linked entries (re-render them), regen landing.

## Step 4: Pedagogical skeleton (fixed, adaptive within)

Every entry — and every chat answer — uses these 6 sections in order. Within each section, pick the best tactic for the concept (diagram, table, walkthrough, analogy). Write every section to be read by a third party who has zero session context (see Audience section above).

1. **Hook** — 1–2 sentences naming the concept, the problem it solves, and the domain/context. Orients a fresh reader. Not "today we'll learn..." — instead "Server Components are React components that render exclusively on the server, solving the bundle-size cost of rendering UI that has no interactivity."
2. **Concrete example** — real code from the user's repo with `file:line` refs **plus** the code excerpt shown inline **plus** one sentence describing what the file is. A reader without the repo must still follow it. If no repo applies, use a canonical minimal example.
3. **Mental model** — Feynman-simple explanation. Include a diagram (ASCII flow, table, or before/after) — dual coding.
4. **Deeper** — edge cases, gotchas, common mistakes, why naive intuition fails here.
5. **Cross-links** — `see also: <slug>` lines, one sentence each on how the linked concept connects.
6. **Recall** — 1–2 short self-test questions. No answers given.

If the user replies with "still don't get it" / "simpler please" / "another angle", switch tactic (analogy, ELI5, different example) and re-render the affected sections.

See `references/pedagogy.md` for the underlying methods (Feynman, scaffolding, dual coding, active recall, concrete-before-abstract) and when each fits.

## Step 5: HTML rendering

For each render (entry or landing), do NOT call `/html` (skills cannot invoke each other). Instead, follow the template instructions in `templates/entry-prompt.md` and `templates/index-prompt.md`. Both templates inherit the same non-negotiable constraints as `/html`:

- Self-contained file: no CDN links.
- All CSS in a single `<link rel="stylesheet" href="../../assets/style.css">` (entries) or `<link rel="stylesheet" href="assets/style.css">` (landing). The shared stylesheet is copied from `templates/style.css` to `assets/style.css` on first use of a topic.
- Vanilla JS only.
- Dark-mode aware (toggle button top-right; respect `:root` vars in shared stylesheet).
- System font stack.

Workflow per render:
1. Read the relevant template file under `templates/`.
2. Read the source: `source.md` (entry) or `INDEX.md` (landing).
3. Produce the HTML matching the template's structure and write it to the target path.

## Step 6: Manual rebuild

If the user says `/teach-me rebuild`, regenerate every entry's `index.html` and the topic's `index.html` landing page from the source markdown. No content change — just re-render. Useful when a template or stylesheet changes.

## Out of scope

Do NOT add: spaced repetition, answer tracking, sync to remote, markdown export, auto-trigger on generic "explain" / "what is" / "what does X do". Triggering on those is too noisy and pollutes the book.

## File map (this skill)

```
~/.claude/skills/teach-me/
  SKILL.md
  templates/
    entry-prompt.md
    index-prompt.md
    style.css
  references/
    pedagogy.md
```

Topic book layout (created by skill at runtime):

```
~/.claude/teaching/<topic>/
  index.html
  INDEX.md
  assets/style.css
  entries/<slug>/source.md
  entries/<slug>/index.html
```

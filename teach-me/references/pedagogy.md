# Pedagogy reference — methods used by /teach-me

The 6-section entry skeleton is the *delivery container*. The methods below are the *tactics* you apply within each section. Pick adaptively based on the concept's shape, not a fixed mapping.

## 0. Dual-audience writing (overrides everything below)

Every entry serves **the student** (revisit / recap) AND **third parties** (colleagues, study group, blog readers). Apply the methods below through this lens:

- **No session breadcrumbs.** "Earlier you asked", "we saw above in chat", "your repo at..." — all banned in saved entries. Use neutral, published-article voice.
- **Self-contained examples.** Code from the student's repo must include the excerpt inline and a one-line description of what the file is, so a reader without the repo follows along. The `file:line` ref is a bookmark for the student, not a prerequisite for the reader.
- **Define on first use.** No assumption the reader has read prior entries — link them via cross-links, but the current entry must still parse standalone.
- **Tone register.** Warm and clear, like a well-written technical blog post. Not casual, not academic, not lecturing.
- **Litmus test.** Could the student publish this entry on a personal blog tomorrow, unedited? If no, the entry isn't ready to save.

The student's learning journey (what confused them, what clicked) does NOT appear in the artifact. Recap value lives in *content quality*, not in session memory of how the explanation was reached.

## 1. Feynman technique

**Idea.** Explain the concept in the simplest possible language, as if to someone who has never heard of it. Where you hand-wave or use jargon without grounding it, that's a gap in your own understanding — close the gap with a simpler word or a concrete example.

**Where it goes.** **Mental model** section. Lead with one or two sentences a child could parse, then introduce a single piece of jargon at a time with a concrete grounding.

**Anti-pattern.** "It's basically a higher-order asynchronous primitive that decouples..." → no. Try: "Imagine you ordered a pizza. You don't stand at the door. You go do other things until the doorbell rings. A Promise is the receipt."

## 2. Concrete-before-abstract

**Idea.** Show one fully-worked example first, then generalise. Brains parse the general rule far easier *after* seeing a specific instance, not before.

**Where it goes.** **Concrete example** comes before **Mental model** in the skeleton for this reason. Always.

**How to apply.** If the user has a codebase, pull the example from their files with `file:line` refs. If not, write the tiniest runnable snippet that exercises the concept once.

**Anti-pattern.** Definition-first ("Server Components are React components that...") with no code visible for 200 words. The user is already lost.

## 3. Scaffolding

**Idea.** Connect new knowledge to something the user already knows. Build the new concept on top of an existing mental model, not in a vacuum.

**Where it goes.** **Mental model** + **Cross-links**. Lead the mental model with "you already know X, this is X but with Y added" when an analogue exists in the book or in common programming knowledge.

**How to apply.** Check `INDEX.md` before writing a new entry. If a related entry exists, *use it as scaffolding*: reference it in the mental model, then cross-link it.

**Anti-pattern.** Treating each concept as standalone. Causes islanded knowledge that doesn't transfer.

## 4. Dual coding

**Idea.** Pair verbal explanation with a visual representation. The brain encodes both channels and retrieval is stronger from either cue.

**Where it goes.** **Mental model** + **Deeper** sections. Every entry should have at least one visual.

**Visual options (pick by shape):**

| Concept shape | Visual |
|--------------|--------|
| Data flow / pipeline | ASCII flow diagram in `<pre class="diagram">` |
| Comparison of N approaches | `<table class="compare">` with rows = facets, cols = options |
| Procedural sequence | Numbered list + small diagram showing state evolution |
| Hierarchy / tree | Indented ASCII tree |
| Before/after refactor | Two code blocks side-by-side in prose, or stacked with `// before` / `// after` markers |

**Anti-pattern.** Wall-of-text explanation with zero visual. Even a 3-row table beats prose for comparison concepts.

## 5. Active recall

**Idea.** Forcing retrieval cements memory more than re-reading. The act of trying to answer — even if you fail — strengthens the neural path.

**Where it goes.** **Recall** section. 1–2 questions per entry. No more, or the user skips them.

**Question rules:**
- Specific, not vague. *"What happens if you forget `'use client'` in a component that calls `useState`?"* > *"How do client components work?"*
- Testable in the user's head, no need to run code.
- Lead with how / why / what-if. Avoid yes/no.
- Never provide the answer in the entry. The retrieval attempt is the value.

**Anti-pattern.** Quiz questions copying the heading. *"Q: What is a Server Component?"* — that's a definition prompt, not recall.

## 6. Cognitive load management

**Idea.** Working memory is small (≈4 chunks). Overload it and learning stops. Chunk the entry so each section is one idea.

**Where it goes.** All sections. The 6-section skeleton itself is a load-management device — each section has one job.

**How to apply.**
- One concept per section. If a section starts sprouting sub-concepts, that's a signal to **extend** the entry with new sections, or split off a **new entry** and cross-link.
- Defer edge cases to **Deeper** (which is a `<details>` block — collapsed by default).
- Use the **Hook** to set up *why* this matters before diving in. Without the why, the user can't hold the rest in working memory because they don't know what they're holding it for.

## 7. Adaptive escalation

**Idea.** If the user says "still don't get it" / "simpler please" / "another angle", do not repeat the same explanation louder. Switch the tactic.

**Escalation ladder (try in order):**
1. **Different concrete example** — same concept, new code.
2. **Analogy from outside programming** — pizza, mail, post office, library, restaurant.
3. **ELI5** — strip all jargon, use the smallest words, accept lossy precision.
4. **Inverse approach** — "let's look at what happens when this *isn't* there". Shows the value by absence.
5. **Step-by-step trace** — walk the runtime execution one operation at a time.

After switching, re-render the affected sections of the entry (usually **Mental model**) with the new angle, and append a note to the section heading: *"Mental model (revised after second look)"*.

## What NOT to do

- Don't over-explain. If a concept fits in 4 sentences, use 4 sentences. The book is denser the more it ships.
- Don't editorialise ("this is a really cool feature"). Stay neutral; teach the concept.
- Don't gate-keep. If the user asks something that seems "too basic", that's exactly the kind of entry the book needs.
- Don't paste official docs verbatim. Synthesise. The book's value is the *re-explanation*, not the copy.
- Don't make recall questions that are really mini-quizzes for facts. Questions test *mental model*, not trivia.
- Don't address the student directly in the entry ("you asked", "your code", "remember when"). The artifact must read as if written for a general audience. Address-the-reader phrasing in the *chat reply* is fine; in the saved entry it breaks the third-party-readable contract.

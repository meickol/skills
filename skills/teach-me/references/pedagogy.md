# Pedagogy reference — /teach-me theoretical framework

Sources: Mayer (2009) *Multimedia Learning*, Anderson & Krathwohl (2001) *A Taxonomy for Learning, Teaching, and Assessing*, Sweller (1988) Cognitive Load Theory, Paivio (1971) Dual Coding Theory.

---

## 0. Dual-audience writing (overrides everything)

Every entry serves **the student** (revisit / recap) AND **third parties** (colleagues, blog readers). Both simultaneously.

- No session breadcrumbs ("earlier you asked", "we saw above in chat", "your repo at...") — banned in saved entries.
- Self-contained examples: code from student's repo includes excerpt inline + one-line file description.
- Define on first use: no assumption the reader has read prior entries — link them, but the entry parses standalone.
- Tone: warm and clear, like a well-written technical blog post. Not casual, not academic.
- Litmus test: could the student publish this entry on a personal blog tomorrow, unedited? If no, rewrite.

---

## 1. Mayer's Multimedia Learning Theory (primary spine)

**Basis**: Cognitive Theory of Multimedia Learning (CTML). Three axioms:
- **Dual-channel**: visual and verbal channels are separate in working memory.
- **Limited capacity**: each channel holds ~4 chunks maximum.
- **Active processing**: learning requires selecting, organizing, and integrating information.

The 12 principles fall into 3 groups:

### Group A — Reduce extraneous processing

**1. Coherence** (d=0.86): exclude extraneous words, pictures, sounds. No decorative images, background music, or interesting-but-irrelevant tangents. Every visible element must map to a learning objective.
- HTML rule: no decorative `<img>`, no background audio, no seductive-detail sidebars.

**2. Signaling** (d=0.41): add cues that highlight the organization of essential material. Numbered steps, arrows, highlights on the active diagram region.
- HTML rule: highlight currently-explained SVG region via JS class swap; use step counters ("Step 2 of 4"); bold key terms at first introduction.

**3. Redundancy** (d=0.86): do not pair narration with its verbatim transcript on screen. Short labels anchored to diagram elements are fine — they don't duplicate narration.
- HTML rule: if using `<audio>`, do NOT show the full script as visible `<p>` simultaneously. Provide a collapsed `<details>` transcript instead.

**4. Spatial Contiguity** (d=1.10 — highest in group): place corresponding words and pictures near each other. Never put a caption at the bottom of a page when the diagram is at the top.
- HTML rule: labels inside `<svg>` using `<text>` elements adjacent to what they describe. `<figcaption>` immediately below `<figure>`, never in a separate column.

**5. Temporal Contiguity** (d=1.22 — highest overall): present animation and narration simultaneously, not sequentially. Never show the full animation then play audio.
- HTML rule: if using audio, use `audio.ontimeupdate` + a cue array to trigger CSS class changes on diagram elements in sync. If no audio, animate diagram regions in sync with auto-advancing text using `setInterval` or scroll-triggered reveals.

### Group B — Manage essential processing

**6. Segmenting** (d=0.70): present content in learner-paced segments. Never auto-advance. Require explicit "Next" button click.
- HTML rule: JS step array; only the current step is visible. Show progress indicator ("Section 2 of 5"). Never auto-advance.

**7. Pre-training** (d=0.46): learners learn better when they know the names and characteristics of key concepts beforehand.
- HTML rule: Section 2 (Key Components) introduces all terms before the main explanation. Never use a term in sections 3–7 that wasn't defined in section 2.

**8. Modality** (d=0.72): graphics + spoken narration > graphics + on-screen text (when both compete for visual attention). Exception: code, equations, non-native language.
- HTML rule: prefer `<audio>` narration + visual over dense text + visual. For code-heavy content (exception applies), on-screen text is acceptable.

### Group C — Foster generative processing

**9. Multimedia** (d=1.67): words + pictures > words alone. Every process, structural, or relational concept needs a visual.
- HTML rule: no entry section consists only of `<p>` elements for a process concept. Minimum one diagram per concept introduced.

**10. Personalization** (d=1.11): conversational style > formal academic style.
- HTML rule: second-person ("you", "your", "you'll"), contractions, conversational openers ("Let's look at...", "Here's the tricky part...").

**11. Voice** (d=0.74): human voice > machine-synthesized voice for narration.
- HTML rule: prefer pre-recorded audio. If using `SpeechSynthesis` API, select highest-quality local voice with `voices.find(v => v.localService && v.lang === 'en-US')`.

**12. Image** (d≈0): instructor face/avatar on screen adds no learning benefit; can be distracting.
- HTML rule: no talking-head overlay, no persistent mascot during explanation. A text byline is sufficient attribution.

### Quick-reference: principle → concern

| Concern | Governing principles |
|---|---|
| Animations | Temporal Contiguity (#5), Signaling (#2), Coherence (#1) |
| Diagrams | Spatial Contiguity (#4), Multimedia (#9), Signaling (#2) |
| Text placement | Spatial Contiguity (#4), Redundancy (#3), Modality (#8) |
| Pacing / sequencing | Segmenting (#6), Pre-training (#7) |
| Tone | Personalization (#10) |
| Content selection | Coherence (#1) |

---

## 2. Bloom's Taxonomy — calibration mapping

Source: Anderson & Krathwohl (2001) revision of Bloom (1956).

| Level | Cognitive operation | Example question types |
|---|---|---|
| L1 Remember | Recall, recognize, list, define | "What are the three components of X? List them." |
| L2 Understand | Explain, summarize, compare, paraphrase | "Explain how X works in your own words." |
| L3 Apply | Use, execute, implement, solve | "Given this scenario, how would you apply X?" |
| L4 Analyze | Differentiate, deconstruct, trace, examine | "Break this process into components. Which step is most critical?" |
| L5 Evaluate | Judge, justify, critique, recommend | "Which approach is better for [use case]? Justify with criteria." |
| L6 Create | Design, formulate, construct, invent | "Design a solution using what you've learned." |

**Calibration → Bloom target:**

| User answers | Bloom target | Instruction style |
|---|---|---|
| None | L1–L2 | Define terms first (Pre-training #7), analogy + diagram, interactive quiz with feedback |
| Some | L2–L3 | Skip raw definitions, go to worked example, step-paced reveal |
| Working | L3–L4 | Lead with non-obvious edge case, dense comparison, open-ended recall |

---

## 3. Cognitive Load Theory — pacing rules

Source: Sweller (1988). Working memory holds ≈4 chunks. Overload stops learning.

- **One concept per section**: if a section sprouts sub-concepts, extend the entry (new H2) or split to a new entry + cross-link.
- **Defer edge cases**: edge cases live in Section 5 (Deeper), collapsed for beginners. They are not suppressed — they're deferred.
- **Hook sets the why**: without a clear "why this matters", the learner can't hold subsequent information in working memory because they don't know what they're holding it for.
- **Pre-training reduces intrinsic load**: introducing terms before the main explanation splits the cognitive work across time.

---

## 4. Visual type catalog

Select by concept shape. Implement with vanilla JS/CSS/SVG only (no CDN).

**Data flow / pipeline**
- Visual: animated directed graph — nodes as `<rect>`/`<circle>`, edges as `<path marker-end="url(#arrow)">`, data packets as `<circle>` animated along paths using `SVGPathElement.getTotalLength()` + `getPointAtLength(t)` inside `requestAnimationFrame`.
- Mayer rules: Signaling (highlight active node), Segmenting (step-by-step with Next button, not auto-play).
- Implementation: pause on each node to show processing. Use `stroke-dashoffset` animation for edge "flow" effect.

**State machine / lifecycle**
- Visual: interactive FSM — SVG nodes with `.active` CSS class, click triggers CSS class swap + edge `stroke` flash.
- Mayer rules: Pre-training (label all states before simulation), Signaling (active state color).
- Implementation: JS state object + transition table. Keyboard input box lets user trigger events by name.

**N-way comparison**
- Visual: HTML `<table class="compare">` for ≤6 attributes; radar SVG polygon for N>4 options on many axes.
- Mayer rules: Coherence (no decorative icons), Signaling (bold the winner row or color-code scores).
- Implementation: `td[data-score]` → HSL color interpolation: `hsl(${score * 1.2}, 70%, 85%)` for heatmap.

**Time sequence / protocol**
- Visual: step-reveal sequence diagram — SVG vertical lifelines, horizontal arrow messages revealed one at a time.
- Mayer rules: Segmenting (never show all messages at once), Signaling (highlight active lifeline column).
- Implementation: opacity 0→1 transitions triggered by step counter. Never auto-play. Show "Step N of M".

**Hierarchy / tree**
- Visual: collapsible nested `<ul>` with CSS connecting lines (no SVG needed for most cases).
- Mayer rules: Pre-training (explain node types before rendering the full tree), Coherence (suppress leaf details initially).
- Implementation: `<details>`/`<summary>` for zero-JS collapse; or JS `scrollHeight` toggle for smooth animation.
  ```css
  .tree ul { padding-left: 1.5em; border-left: 1px solid var(--border); }
  .tree li::before { content:''; position:absolute; left:-1px; top:0.8em; width:1em; height:1px; background:var(--border); }
  ```

**Before/after transformation**
- Visual: tab toggle (accessible, recommended) or draggable split divider.
- Mayer rules: Spatial Contiguity (before/after must be adjacent), Signaling (highlight changed regions).
- Implementation (draggable): `mousedown` on `.divider` → `mousemove` → update CSS var `--split` → `.before { width: var(--split, 50%) }`.

**Concept map / knowledge graph**
- Visual: force-directed graph on `<canvas>` (>30 nodes) or inline `<svg>` (<30 nodes). Clickable nodes show detail panel.
- Mayer rules: Coherence (show 8–12 node subgraph first, not the full graph), Signaling (highlight neighbors on hover).
- Implementation: spring simulation — repulsion (inverse square) + attraction along edges (spring) + center gravity + damping (velocity × 0.85) in `requestAnimationFrame` loop.

**Algorithm trace**
- Visual: split pane — code on left with line highlight, data structure visualization on right (array cells as `<div>` blocks with CSS transitions on value/color changes). Step controls at bottom.
- Mayer rules: Temporal + Spatial Contiguity (code highlight synchronized with visualization), Segmenting (learner controls stepping).
- Implementation: record all steps upfront as snapshot array `[{lineNum, arrayState, explanation}]`. Playback via step counter.

**Mathematical/statistical relationship**
- Visual: interactive SVG chart — parametric curves, sliders change parameters and SVG path re-renders.
- Mayer rules: Multimedia (strong support), Spatial Contiguity (axis labels adjacent to axes), Coherence (minimal grid lines).
- Implementation: `scaleX`/`scaleY` helpers map data domain to SVG pixels. `pathFromFn(f, xMin, xMax, steps=200)` generates `<path d>`. Wire to `<input type="range">` → redraw.

**Mental model / analogy**
- Visual: layered annotated illustration — familiar objects (pipes, rooms, gears) mapped to abstract concepts. Click/hover reveals the mapping label.
- Mayer rules: Coherence (only use concrete elements that map 1:1 to the abstract concept — metaphor can become seductive detail), Signaling (make connection arrows between familiar object and abstract label prominent).
- Implementation: `<div class="analogy-object">` with `position:absolute` label overlays toggled by click.

---

## 5. Source research protocol by domain

Priority order: fetch the highest-priority source available before teaching.

**Software libraries / frameworks**
1. context7 MCP (`resolve-library-id` → `query-docs`) — version-specific API reference
2. Official docs URL for the library
3. GitHub CHANGELOG + RFCs for unreleased behavior

**Programming languages**
- Python: docs.python.org/3/ + peps.python.org
- Rust: doc.rust-lang.org/stable/ + docs.rs (crates)
- Go: pkg.go.dev + go.dev/doc/
- JS/TS: tc39.es/ecma262/ + typescriptlang.org/docs/ + developer.mozilla.org
- Web APIs: developer.mozilla.org + w3.org/TR/ + html.spec.whatwg.org

**CS concepts / algorithms / protocols**
- Wikipedia (definition + complexity)
- ACM Digital Library (dl.acm.org) — originating papers
- IEEE Xplore (ieeexplore.ieee.org) — networking, systems
- IETF RFCs (rfc-editor.org) — HTTP, TLS, QUIC, DNS
- NIST (csrc.nist.gov) — security standards

**Mathematics**
- NIST DLMF (dlmf.nist.gov) — special functions, canonical
- Wolfram MathWorld (mathworld.wolfram.com)
- arXiv.org/math/ — current research

**Natural sciences**
- Biology: PubMed (pubmed.ncbi.nlm.nih.gov) + PubMed Central
- Physics/Chemistry: arXiv.org + NIST (nist.gov/webbook)
- Any: flag preprints (bioRxiv, arXiv) as not peer-reviewed

**Social sciences / humanities**
- JSTOR (jstor.org)
- Encyclopaedia Britannica (britannica.com)
- Primary sources: govinfo.gov, official government data
- Economics: NBER (nber.org), IMF, World Bank

**context7 usage rules:**
- Use for software libraries/frameworks — not for CS concepts, science, or math
- Max 3 `query-docs` calls per question
- Skip `resolve-library-id` if you already know the exact ID (e.g., `/vercel/next.js`)
- Falls back to WebFetch on official docs URL if library not indexed

---

## 6. Adaptive escalation — when the learner doesn't understand

If the user signals confusion ("still don't get it", "simpler", "another angle", "ELI5"), do NOT repeat the same explanation. Switch tactic using this ordered ladder:

| Step | Tactic | When to use |
|---|---|---|
| 1 | Different concrete example | Same concept, new domain or language |
| 2 | Real-world analogy | Anything involving cause/effect, flow, or containment |
| 3 | ELI5 | When jargon is the blocker, not the concept |
| 4 | Inverse approach | When "why it matters" isn't landing — show what breaks without it |
| 5 | Step-by-step trace | When the learner can't follow the sequence — slow down completely |

After switching: re-render the Visual Model section of the saved entry with the new angle. Append *(revised — alternate explanation)* to its H2. Update `updated:` and re-render `index.html`.

**Anti-patterns:**
- Repeating the same explanation more slowly — no new information, more frustrating.
- Jumping straight to ELI5 — it's lossy precision; try a better example first.
- Switching tactic AND adding more content simultaneously — isolate the variable.

## 7. Adaptive recall rules

**None/Some calibration — interactive quiz:**
- 2 closed questions: multiple-choice or true/false. Show options. Click answer → reveal correct + 1-sentence explanation.
- 1 open-ended "what would happen if…": click "Show answer" → reveal model answer.
- Questions test *mental model*, not trivia. Lead with: "what happens if", "why does", "what's the difference between".
- Question rules: specific not vague, testable in the learner's head, avoids yes/no, never copies the heading as the question.

**Working calibration — open-ended only:**
- 1–2 "what would happen if…" or "how would you approach…" questions.
- No reveal button. No answers given. Genuine retrieval is the point — feedback would short-circuit it.
- Target Bloom L4: "Trace what happens when [assumption] is violated."

**Anti-patterns to avoid:**
- "Q: What is X?" — definition prompt, not recall.
- "Q: Did we cover Y?" — yes/no, no cognitive work.
- Providing the answer in the question stem.
- More than 3 questions total — user skips them.

---

## 7. Reference book UX patterns (static HTML, vanilla JS)

**Client-side search** (dictionary-speed lookup):
- Build in-memory inverted index on load: tokenize title + summary + tags → word → Set of entry IDs.
- Search: intersection of result sets (AND logic). Debounce 150ms.
- Performance target: <5ms for ≤2000 entries with in-memory index.

**Cross-linking**:
- Within topic: `href="../<slug>/index.html"`. Within global index: `href="<topic>/entries/<slug>/index.html"`.
- Hover preview: on `<a data-entry="slug">` hover, render popover with entry title + summary using `getBoundingClientRect()`.
- History: `history.pushState` + `popstate` for back-button navigation without page reload.

**Tag filtering**:
- `data-tags="tag1 tag2"` on each entry card.
- Multi-select: `Set` of active tags, AND logic (`every(t => entryTags.has(t))`). Toggle with OR: `.some()`.
- URL sync: `?tags=react,server` via `URLSearchParams` + `history.replaceState`.
- Toggle `element.hidden` (faster than class + CSS for large lists).

**Progressive disclosure**:
- Native `<details>`/`<summary>` for Deeper section — zero JS, keyboard accessible.
- Smooth animation: `details[open] .content { max-height: 500px; transition: max-height 0.3s ease; }` or measure `scrollHeight` before animating.
- Three-tier model: title + gloss (always visible) → `<details>` explanation → full article link.

**Dark mode**:
- CSS custom properties on `:root`, override on `[data-theme="dark"]`.
- Anti-flash inline script in `<head>` reads `localStorage` before first paint.
- System preference listener: `matchMedia('(prefers-color-scheme: dark)').addEventListener('change', ...)`.
- `color-scheme: light` / `dark` on `:root` for native browser controls.

---

## 8. What NOT to do

- Over-explain. If it fits in 4 sentences, use 4 sentences.
- Editorialise ("this is a really cool feature"). Stay neutral.
- Gate-keep. If it seems "too basic", that's exactly what the book needs.
- Paste official docs verbatim. Synthesise.
- Make recall questions that test trivia rather than mental model.
- Address the student directly in the saved entry ("you asked", "your code"). Article register in artifact; conversational in chat is fine.
- Use a visual because it looks impressive. Every visual must serve comprehension (Coherence #1).
- Show all steps of an animation at once. Always segment (Segmenting #6).
- Place diagram labels far from what they describe (Spatial Contiguity #4).
- Teach without fetching current official sources first.

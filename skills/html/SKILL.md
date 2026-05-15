---
name: html
description: >
  Generate a self-contained, interactive HTML file instead of markdown whenever output has structure, comparison, hierarchy, or interactivity potential. Use for: technical explainers, approach comparisons, code review summaries, design references, status reports, diagrams/flowcharts, slide decks, and interactive editing tools. Trigger whenever the user asks to "document", "explain", "compare", "summarize", "create a report", "make a deck", "write up", or produce any structured output — even if they never say "HTML". A beautiful interactive HTML file is almost always better than a wall of markdown. Also trigger for /html explicitly.
---

# /html — Produce HTML Instead of Markdown

When you'd write a markdown document, write a self-contained `.html` file instead. HTML encodes spatial relationships, interactivity, and visual hierarchy that markdown cannot.

## Step 1: Identify the category

| # | Type | When to use | Key patterns |
|---|------|-------------|--------------|
| 1 | **Exploration / Approaches** | Comparing 2–4 options or directions | Tabbed cards or side-by-side grid, pros/cons table per option, recommendation callout at the end |
| 2 | **Code Review / PR** | Summarising a PR, diff, or set of changes | File list with risk-level badges (safe / look / critical), collapsible inline diffs, annotation comments, next-steps section |
| 3 | **Design Reference** | Design tokens, components, or style guide | Color swatches with real hex backgrounds, typography specimens, spacing scale, live component examples using actual CSS |
| 4 | **Prototype / Interaction** | Demonstrating a UI flow or animation | Clickable state transitions, CSS animations, multi-step wizard with prev/next |
| 5 | **Diagram / Flowchart** | Pipeline, architecture, decision tree | Inline SVG with labeled nodes; click any node to show a detail panel beside the diagram |
| 6 | **Slide Deck** | Presentation, briefing, or pitch | Keyboard-navigable slides (← →), fixed slide counter, one idea per slide, speaker notes in `<details>` |
| 7 | **Research / Explainer** | Teaching a concept, system, or API | TL;DR callout banner, `<details>`/`<summary>` for each section, step-by-step breakdown, gotchas, FAQ |
| 8 | **Report** | Status update, incident timeline, changelog | Shipped / In-Progress / Blocked sections, metric bars (CSS width = percentage), decision callout demanding a binary choice |
| 9 | **Custom Editor / Tool** | Interactive editing with export | Drag-and-drop columns or panels, live preview pane, "Copy as markdown" or "Export" button |

If two types fit equally well, combine them (e.g., an explainer with an inline flowchart, or a report with a slide deck).

## Step 2: Build the HTML

### Non-negotiable constraints

- **Fully self-contained.** No external CDN links. All CSS and JS in `<style>` and `<script>` tags inside the file. System font stack: `-apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif`.
- **Single file.** Everything in one `.html` the user can open, share, or print offline.
- **No frameworks.** Vanilla JS only. No React, Vue, or build step required.
- **Dark-mode aware.** Use CSS variables (`--bg`, `--text`, `--accent`, etc.) set in `:root` with a `[data-theme="dark"]` override, plus a toggle button in the top-right corner.

### Visual quality bar

- Clean whitespace, clear typographic hierarchy (one prominent page title, clear section headings)
- Color used semantically: green = good/shipped, yellow = caution/in-progress, red = blocked/critical
- Hover states and focus rings on all interactive elements (200ms ease transitions)
- Responsive layout (flexbox/grid, no fixed pixel widths wider than the viewport)
- The page should feel crafted, not generated — add subtle borders, rounded corners, and spacing that make sections breathe

### Per-category implementation

**Exploration**: `<nav>` tab bar at the top; clicking a tab shows/hides the corresponding `<section>`. Each section has a pros list, cons list, and metrics table. Final `<section class="recommendation">` has a colored left-border callout with a clear verdict.

**Code Review**: Each file is a `<details>` block. Color the left border: `--green` for safe, `--yellow` for look, `--red` for critical. Inside, a `<pre>` diff block where lines starting with `+` get a green background and `-` get a red background using a small JS post-processor.

**Design Reference**: Render real CSS. Color swatches are `<div>` elements with `background-color` set to the actual hex. Typography specimens display real text at the specified sizes. Component examples are actual HTML elements styled with the design tokens.

**Diagram/Flowchart**: Use inline `<svg>` with `<g>` node groups that have `cursor: pointer` and a `data-id` attribute. A JS click handler reads `data-id` and populates a `<div id="detail">` beside the SVG with the node's details. Decision diamonds, process rectangles, and terminal ovals are distinguishable by shape.

**Slide Deck**: Slides are `<section class="slide">` elements. The active slide has `opacity: 1; transform: translateX(0)`, others are off-screen. `keydown` listener handles `ArrowLeft`/`ArrowRight` and `Space`. Fixed `<div class="counter">` shows `currentSlide / total`.

**Research/Explainer**: The TL;DR is a visually distinct callout (2px left-border in accent color, light tinted background). First `<details>` is `open` by default, the rest closed. Each section heading includes an estimated read time or step number.

**Report**: Decision callout demands attention with a colored border and two distinct buttons (Option A / Option B) that toggle a selected state without submitting anywhere. Metric rows show label, bar (CSS `width` driven by inline style), and percentage.

**Custom Editor**: All state lives in a JS object. Drag-and-drop uses the HTML5 Drag and Drop API (no libraries). The export button serialises state to markdown and copies to clipboard via `navigator.clipboard.writeText()`, then shows a "Copied!" flash.

## Step 3: Save and open

1. Pick a descriptive kebab-case filename from the content (e.g., `server-actions-explainer.html`, `q4-status-report.html`).
2. Save to the current working directory.
3. Open it: `open <filename>.html` (macOS) or `xdg-open <filename>.html` (Linux/WSL).
4. Tell the user the path and which category you used.

## What makes a great output

The goal is a document the user would **actually read** rather than skim past. Ask yourself: does this output communicate faster than its markdown equivalent? If a reader can grasp the key insight in 10 seconds by scanning the visual layout, you've succeeded. If they'd have to read every line to understand it, reconsider the layout.

Use the user's actual data throughout — never leave placeholder text like "Acme Corp" or "example.com" unless those are the real values. The file should look like it was made specifically for this project.

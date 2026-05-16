# Entry HTML template

Render an entry's `source.md` to `index.html` in the same directory. Self-contained, no CDN, dark-mode aware, links to `../../assets/style.css`.

Serves **two audiences**: the student revisiting for recap, and a third party (colleague, blog reader) with zero session context. The HTML must read as a polished standalone explainer — like a technical blog post.

## Required HTML structure

```html
<!doctype html>
<html lang="en" data-theme="light">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>{{title}} — {{topic}}</title>
  <!-- Anti-flash dark mode: runs before first paint -->
  <script>
    (function() {
      const saved = localStorage.getItem('teach-theme');
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      document.documentElement.dataset.theme = saved || (prefersDark ? 'dark' : 'light');
    })();
  </script>
  <link rel="stylesheet" href="../../assets/style.css" />
</head>
<body>
  <header class="entry-header">
    <div class="entry-nav">
      <a class="back-link" href="../../index.html">← {{topic}} book</a>
      <a class="back-link global" href="../../../global-index.html">⊞ All topics</a>
    </div>
    <button class="theme-toggle" id="theme-toggle" aria-label="Toggle theme">◐</button>
  </header>

  <article class="entry">
    <h1>{{title}}</h1>

    <!-- Section 1: Hook -->
    <section class="hook">
      <p class="hook-text">{{hook — 1–2 sentences: concept + problem it solves + domain}}</p>
      <div class="entry-meta">
        <span class="bloom-badge bloom-{{bloom-level}}">{{Beginner|Intermediate|Advanced}}</span>
        {{#tags}}<span class="badge tag">{{.}}</span>{{/tags}}
        <span class="meta-dates">Created {{created}} · Updated {{updated}}</span>
      </div>
    </section>

    <!-- Section 2: Key Components (Pre-training, Mayer #7) -->
    <!-- NONE calibration: render as flip cards -->
    <!-- SOME calibration: render as definition list -->
    <!-- WORKING calibration: render as collapsed <details> -->
    <section id="key-components" class="key-components">
      <h2>Key Components</h2>

      <!-- NONE / SOME: one .term-card per key term -->
      <div class="term-grid">
        <div class="term-card" tabindex="0">
          <div class="term-front"><strong>{{term name}}</strong></div>
          <div class="term-back">{{one-sentence definition}}</div>
        </div>
        <!-- ... repeat for each term (3–5 total) -->
      </div>

      <!-- WORKING: use <details> instead -->
      <!-- <details class="terms-collapsible">
             <summary>Key Terms (review)</summary>
             <dl>...</dl>
           </details> -->
    </section>

    <!-- Section 3: Concrete Example -->
    <section id="concrete">
      <h2>Concrete Example</h2>
      <!-- Code from codebase: show excerpt with file:line ref -->
      <!-- <p class="file-ref"><code>path/to/file.ts:42</code> — one sentence describing what this file is.</p> -->
      <!-- Code from official source: show excerpt; URL will appear in Sources section -->
      <pre><code class="lang-{{lang}}">{{code example}}</code></pre>
      <!-- Prose explanation of what the example shows -->
    </section>

    <!-- Section 4: Visual Model -->
    <section id="visual-model">
      <h2>Visual Model</h2>
      <!-- Feynman-simple explanation, then the visual -->
      <p>{{mental model explanation — conversational, second-person, Personalization #10}}</p>

      <!-- VISUAL: select type by concept shape. See pedagogy.md § Visual type catalog -->
      <!-- The visual is inline below the explanation (Spatial Contiguity #4) -->

      <!-- EXAMPLE: Step-reveal sequence diagram for time sequence / protocol -->
      <div class="visual-container">
        <div class="step-info" aria-live="polite">Step <span id="step-num">1</span> of <span id="step-total">N</span></div>
        <svg class="diagram-svg" viewBox="0 0 600 300" aria-label="{{visual description}}">
          <!-- inline SVG: nodes, edges, labels all within this element -->
          <!-- Labels adjacent to what they describe (Spatial Contiguity #4) -->
          <!-- Only currently-active region has .active class (Signaling #2) -->
        </svg>
        <div class="step-controls">
          <button class="step-btn" id="prev-btn" disabled aria-label="Previous step">← Prev</button>
          <button class="step-btn primary" id="next-btn" aria-label="Next step">Next →</button>
          <button class="step-btn" id="reset-btn" aria-label="Reset">↺ Reset</button>
        </div>
        <p class="step-explanation" id="step-explanation">{{explanation for step 1}}</p>
      </div>

      <!-- EXAMPLE: Heatmap comparison table for N-way comparison -->
      <!-- <table class="compare">
             <thead><tr><th>Approach</th><th>Speed</th><th>Memory</th><th>Complexity</th></tr></thead>
             <tbody>
               <tr><td>Option A</td><td data-score="90">Fast</td><td data-score="40">High</td><td data-score="70">Low</td></tr>
             </tbody>
           </table> -->

      <!-- EXAMPLE: Force-directed concept map -->
      <!-- <canvas id="concept-map" width="600" height="400" aria-label="Concept map"></canvas> -->
    </section>

    <!-- Section 5: Deeper (edge cases, gotchas) -->
    <!-- NONE/SOME: wrapped in <details>, collapsed -->
    <!-- WORKING: rendered open, no <details> wrapper -->
    <details id="deeper" class="deeper">
      <summary><h2>Deeper — Edge Cases &amp; Gotchas</h2></summary>
      <div class="deeper-content">
        <!-- At least one anti-pattern with concrete example of what breaks and why -->
        <div class="antipattern">
          <strong>Anti-pattern:</strong> {{description of wrong approach}}
          <pre><code>{{example of what breaks}}</code></pre>
          <p>{{why it breaks}}</p>
        </div>
      </div>
    </details>

    <!-- Section 6: Cross-links & Sources -->
    <section id="cross-links" class="cross-links">
      <h2>See Also</h2>
      <!-- Related entries in the book -->
      {{#related}}
      <a class="related-card" href="../{{slug}}/index.html" data-entry="{{slug}}">
        <strong>{{title}}</strong>
        <span>{{one-sentence description of the connection}}</span>
      </a>
      {{/related}}

      <!-- Sources consulted (from research phase) -->
      <div class="sources">
        <h3>Sources consulted</h3>
        <ul>
          {{#sources}}
          <li><a href="{{url}}" target="_blank" rel="noopener">{{title}}</a> — fetched {{fetched}}</li>
          {{/sources}}
        </ul>
      </div>
    </section>

    <!-- Section 7: Adaptive Recall -->
    <section id="recall" class="recall">
      <h2>Test Yourself</h2>

      <!-- NONE/SOME: interactive quiz with reveal -->
      <div class="quiz">
        <div class="quiz-question">
          <p class="question-text">{{question 1 — specific, tests mental model}}</p>
          <!-- Multiple choice -->
          <div class="options" role="radiogroup">
            <button class="option" data-correct="false">{{option A}}</button>
            <button class="option" data-correct="true">{{option B — correct}}</button>
            <button class="option" data-correct="false">{{option C}}</button>
          </div>
          <div class="feedback hidden">
            <span class="feedback-icon"></span>
            <p class="feedback-text">{{one-sentence explanation of why the correct answer is right}}</p>
          </div>
        </div>

        <div class="quiz-question">
          <p class="question-text">{{question 2 — "what would happen if…" open-ended}}</p>
          <button class="reveal-btn">Show answer</button>
          <div class="answer hidden">
            <p>{{model answer}}</p>
          </div>
        </div>
      </div>

      <!-- WORKING calibration: open-ended only, no reveal button -->
      <!-- <div class="recall-open">
             <ol>
               <li>{{open-ended question — no answer provided, no reveal button}}</li>
             </ol>
           </div> -->
    </section>
  </article>

  <!-- Hover preview popover for cross-links -->
  <div class="link-popover" id="link-popover" hidden>
    <strong class="popover-title"></strong>
    <p class="popover-summary"></p>
  </div>

  <script>
    // ── Dark mode toggle ──────────────────────────────────────────
    const root = document.documentElement;
    const themeBtn = document.getElementById('theme-toggle');
    const updateIcon = () => themeBtn.textContent = root.dataset.theme === 'dark' ? '☀' : '◐';
    updateIcon();
    themeBtn.addEventListener('click', () => {
      const next = root.dataset.theme === 'dark' ? 'light' : 'dark';
      root.dataset.theme = next;
      localStorage.setItem('teach-theme', next);
      updateIcon();
    });

    // ── Copy buttons for <pre> blocks ─────────────────────────────
    document.querySelectorAll('pre').forEach(pre => {
      const btn = document.createElement('button');
      btn.className = 'copy-btn';
      btn.textContent = 'copy';
      btn.addEventListener('click', () => {
        navigator.clipboard.writeText(pre.innerText.replace('copy', '').trim());
        btn.textContent = 'copied ✓';
        setTimeout(() => btn.textContent = 'copy', 1500);
      });
      pre.style.position = 'relative';
      pre.appendChild(btn);
    });

    // ── Flip cards (term cards for NONE calibration) ──────────────
    document.querySelectorAll('.term-card').forEach(card => {
      const toggle = () => card.classList.toggle('flipped');
      card.addEventListener('click', toggle);
      card.addEventListener('keydown', e => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); toggle(); }});
    });

    // ── Comparison table heatmap ──────────────────────────────────
    document.querySelectorAll('td[data-score]').forEach(cell => {
      const score = +cell.dataset.score;
      cell.style.background = `hsl(${score * 1.2}, 60%, ${root.dataset.theme === 'dark' ? '25%' : '88%'})`;
    });

    // ── Interactive quiz ──────────────────────────────────────────
    document.querySelectorAll('.quiz-question').forEach(q => {
      const options = q.querySelectorAll('.option');
      const feedback = q.querySelector('.feedback');
      const feedbackIcon = q.querySelector('.feedback-icon');
      const feedbackText = q.querySelector('.feedback-text');

      options.forEach(opt => {
        opt.addEventListener('click', () => {
          if (q.dataset.answered) return;
          q.dataset.answered = 'true';
          const correct = opt.dataset.correct === 'true';
          options.forEach(o => {
            o.disabled = true;
            if (o.dataset.correct === 'true') o.classList.add('correct');
            else o.classList.add('wrong');
          });
          if (feedback) {
            feedback.classList.remove('hidden');
            feedbackIcon.textContent = correct ? '✓' : '✗';
            feedback.classList.add(correct ? 'feedback-correct' : 'feedback-wrong');
          }
        });
      });

      // Reveal button for open-ended questions
      const revealBtn = q.querySelector('.reveal-btn');
      if (revealBtn) {
        revealBtn.addEventListener('click', () => {
          q.querySelector('.answer').classList.remove('hidden');
          revealBtn.hidden = true;
        });
      }
    });

    // ── Step-reveal controls (for animated diagrams) ──────────────
    // Populate `steps` at render time based on visual type. Examples:
    //
    // TIME SEQUENCE (e.g., TCP handshake):
    // const steps = [
    //   { activate: ['#msg-syn', '#node-client'],  explanation: 'Client sends SYN packet to initiate connection.' },
    //   { activate: ['#msg-synack', '#node-server'], explanation: 'Server responds with SYN-ACK, acknowledging the request.' },
    //   { activate: ['#msg-ack', '#node-client'],   explanation: 'Client sends ACK. Three-way handshake complete.' },
    // ];
    //
    // STATE MACHINE (e.g., promise lifecycle):
    // const steps = [
    //   { activate: ['#state-pending'],  explanation: 'Promise starts in Pending — async work is running.' },
    //   { activate: ['#state-fulfilled'], explanation: 'If work succeeds, transitions to Fulfilled. .then() handlers run.' },
    //   { activate: ['#state-rejected'],  explanation: 'If work fails, transitions to Rejected. .catch() handlers run.' },
    // ];
    //
    // ALGORITHM TRACE (e.g., bubble sort step i=0):
    // const steps = [
    //   { activate: ['#cell-0', '#cell-1'], explanation: 'Compare index 0 (5) and index 1 (3). 5 > 3, so swap.' },
    //   { activate: ['#cell-1', '#cell-2'], explanation: 'Compare index 1 (5) and index 2 (8). 5 < 8, no swap.' },
    // ];
    //
    // DATA FLOW (e.g., HTTP request pipeline):
    // const steps = [
    //   { activate: ['#node-browser', '#edge-0'], explanation: 'Browser sends HTTP GET request.' },
    //   { activate: ['#node-cache', '#edge-1'],  explanation: 'CDN cache checks for a cached response.' },
    //   { activate: ['#node-origin'],            explanation: 'Cache miss — request forwarded to origin server.' },
    // ];
    //
    // Each step: activate = array of CSS selectors to add .active class to.
    // All .step-el elements start with opacity 0.25; .active brings them to full opacity.
    const steps = []; // ← Replace with actual steps for the concept being rendered
    let currentStep = 0;
    const stepNum = document.getElementById('step-num');
    const stepTotal = document.getElementById('step-total');
    const stepExp = document.getElementById('step-explanation');
    const prevBtn = document.getElementById('prev-btn');
    const nextBtn = document.getElementById('next-btn');
    const resetBtn = document.getElementById('reset-btn');

    if (steps.length && stepTotal) {
      stepTotal.textContent = steps.length;

      function applyStep(i) {
        // Deactivate all, then activate current step
        document.querySelectorAll('.diagram-svg .step-el').forEach(el => el.classList.remove('active'));
        if (steps[i].activate) steps[i].activate.forEach(sel => {
          document.querySelectorAll(sel).forEach(el => el.classList.add('active'));
        });
        if (stepExp) stepExp.textContent = steps[i].explanation || '';
        if (stepNum) stepNum.textContent = i + 1;
        prevBtn.disabled = i === 0;
        nextBtn.disabled = i === steps.length - 1;
      }

      applyStep(0);
      prevBtn.addEventListener('click', () => { if (currentStep > 0) applyStep(--currentStep); });
      nextBtn.addEventListener('click', () => { if (currentStep < steps.length - 1) applyStep(++currentStep); });
      resetBtn.addEventListener('click', () => { currentStep = 0; applyStep(0); });
    }

    // ── Cross-link hover preview ──────────────────────────────────
    const popover = document.getElementById('link-popover');
    // Populate entryData at render time: for each slug in `related:` frontmatter,
    // read ~/.claude/teaching/<topic>/entries/<slug>/source.md and extract:
    //   - title: the `title:` frontmatter field
    //   - summary: the one-liner from that entry's INDEX.md row (text after " — ")
    // Example (rendered inline at build time, not fetched at runtime):
    // const entryData = {
    //   'event-loop':   { title: 'Event Loop',   summary: 'How JavaScript schedules async callbacks via a single-threaded queue.' },
    //   'promises':     { title: 'Promises',     summary: 'An object representing the eventual completion or failure of async work.' },
    // };
    const entryData = {}; // ← Replace with actual related entry data

    document.querySelectorAll('[data-entry]').forEach(link => {
      link.addEventListener('mouseenter', e => {
        const d = entryData[link.dataset.entry];
        if (!d) return;
        popover.querySelector('.popover-title').textContent = d.title;
        popover.querySelector('.popover-summary').textContent = d.summary;
        const rect = link.getBoundingClientRect();
        popover.style.top = (rect.bottom + window.scrollY + 8) + 'px';
        popover.style.left = Math.min(rect.left, window.innerWidth - 260) + 'px';
        popover.hidden = false;
      });
      link.addEventListener('mouseleave', () => { popover.hidden = true; });
    });
  </script>
</body>
</html>
```

## Rendering rules

**Sections → HTML mapping:**

| source.md H2 | HTML element |
|---|---|
| `Hook` | `<section class="hook">` |
| `Key Components` | `<section id="key-components">` |
| `Concrete Example` | `<section id="concrete">` |
| `Visual Model` | `<section id="visual-model">` |
| `Deeper` | `<details id="deeper" class="deeper">` |
| `See Also` + `Sources` | `<section id="cross-links">` |
| `Recall` | `<section id="recall">` |

**Visual type rendering:** Select from the catalog in `references/pedagogy.md § Visual type catalog` based on the concept shape. Implement the visual inline in Section 4. All SVG must be self-contained within the HTML file.

**Code blocks:** `<pre><code class="lang-<lang>">` with HTML-escaped content. Preserve indentation. `file:line` refs become inline `<code>` spans with a `.file-ref` paragraph above showing the file description.

**Bloom badge values:**
- `bloom-none` → label "Beginner"
- `bloom-some` → label "Intermediate"  
- `bloom-working` → label "Advanced"

**Calibration-dependent rendering:**
- Key Components: flip cards (none), `<dl>` (some), `<details>` (working)
- Deeper: `<details>` collapsed (none/some), expanded without wrapper (working)
- Recall: interactive multiple-choice + reveal (none/some), open-ended no reveal (working)

**Tone check:** Strip any first-person, "as we discussed", or session-context phrasing from source.md during render. The artifact is publishable; the chat session is not.

**If a section is missing** in source.md: omit its rendered block entirely. Never render empty `<section>` tags.

**The `steps` array**: populated at render time. See the commented examples in the `<script>` block above for the exact object shape per visual type (time sequence, state machine, algorithm trace, data flow). Every step has: `activate` (array of CSS selectors to highlight) + `explanation` (shown in `.step-explanation` below the diagram).

**The `entryData` object**: populated at render time. For each slug in the entry's `related:` frontmatter field: read `~/.claude/teaching/<topic>/entries/<slug>/source.md` → extract `title:` field; read `~/.claude/teaching/<topic>/INDEX.md` → extract the description text for that slug (text after the ` — ` on that slug's line). Inline both as a JS object literal — do not fetch at runtime.

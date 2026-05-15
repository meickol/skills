# Entry HTML template

Render an entry's `source.md` to `index.html` in the same directory. Self-contained, no CDN, dark-mode aware, links to `../../assets/style.css` for shared styling.

The rendered entry serves **two audiences simultaneously**:

1. The student revisiting their own book for recap.
2. A third party the student shares the link / file with — colleague, study group, blog reader. This reader has no session context, no access to the student's codebase, no prior chapter knowledge.

The HTML must therefore read as a polished, standalone explainer — like a technical blog post, not a personal note. Visual polish, clear navigation, and self-explanatory examples are non-negotiable.

## Required structure

```html
<!doctype html>
<html lang="en" data-theme="light">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>{{title}} — {{topic}}</title>
  <link rel="stylesheet" href="../../assets/style.css" />
</head>
<body>
  <header class="entry-header">
    <a class="back-link" href="../../index.html">← {{topic}} book</a>
    <button class="theme-toggle" aria-label="Toggle theme">◐</button>
  </header>

  <article class="entry">
    <h1>{{title}}</h1>
    <div class="meta">
      {{#chapter}}<span class="badge chapter">Chapter {{chapter}}</span>{{/chapter}}
      {{#tags}}<span class="badge tag">{{.}}</span>{{/tags}}
      <span class="meta-dates">Created {{created}} · Updated {{updated}}</span>
    </div>

    <section class="hook">
      <p class="hook-text">{{hook content}}</p>
    </section>

    <section id="concrete">
      <h2>Concrete example</h2>
      {{concrete content — code blocks, file:line refs}}
    </section>

    <section id="mental-model">
      <h2>Mental model</h2>
      {{simple explanation + diagram (ASCII pre, SVG, or styled HTML table)}}
    </section>

    <details id="deeper" class="deeper">
      <summary><h2>Deeper — edge cases &amp; gotchas</h2></summary>
      {{deeper content}}
    </details>

    <section id="cross-links" class="cross-links">
      <h2>See also</h2>
      <ul>
        {{#related}}
        <li><a href="../{{slug}}/index.html">{{slug}}</a> — {{one-line description from related entry's frontmatter or INDEX.md}}</li>
        {{/related}}
      </ul>
    </section>

    <section id="recall" class="recall">
      <h2>Recall</h2>
      <ol>
        {{#recall_questions}}<li>{{.}}</li>{{/recall_questions}}
      </ol>
    </section>
  </article>

  <script>
    // theme toggle: persist in localStorage per-book
    const root = document.documentElement;
    const stored = localStorage.getItem('teach-theme');
    if (stored) root.dataset.theme = stored;
    document.querySelector('.theme-toggle').addEventListener('click', () => {
      const next = root.dataset.theme === 'dark' ? 'light' : 'dark';
      root.dataset.theme = next;
      localStorage.setItem('teach-theme', next);
    });

    // copy buttons for every <pre><code>
    document.querySelectorAll('pre').forEach(pre => {
      const btn = document.createElement('button');
      btn.className = 'copy-btn';
      btn.textContent = 'copy';
      btn.addEventListener('click', () => {
        navigator.clipboard.writeText(pre.innerText);
        btn.textContent = 'copied';
        setTimeout(() => btn.textContent = 'copy', 1200);
      });
      pre.appendChild(btn);
    });
  </script>
</body>
</html>
```

## Rules

- Render every code block from `source.md` as `<pre><code class="lang-<lang>">...</code></pre>` with HTML-escaped content. Preserve indentation exactly.
- `file:line` references inside prose become inline `<code>` spans, no linking (paths are local to the user). Always pair with the code shown inline so a third-party reader without the repo still understands.
- Diagrams: ASCII goes in `<pre class="diagram">`; tables become real `<table>` with `class="compare"`; flowcharts become inline `<svg>` if non-trivial.
- The `<details>` wrapper on **Deeper** is intentional — keeps the entry scannable, deep content one click away.
- Recall questions have no answers. Plain list only.
- If `related` is empty, omit the entire `cross-links` section (do not render an empty "See also" heading).
- Always include theme toggle + copy-on-code-blocks JS shown above. No other scripts.
- Tone check: the rendered entry must read like a published technical article. Strip any first-person, session-context, or "as we discussed" phrasing during render if it leaked into `source.md`.

## Source.md → render mapping

Sections in `source.md` must use these H2 headings exactly (case-sensitive, no trailing punctuation): `Hook`, `Concrete example`, `Mental model`, `Deeper`, `See also`, `Recall`. Render each into the corresponding `<section>` / `<details>` block above. If a section is missing in `source.md`, omit its rendered block.

Frontmatter `recall_questions` may also live as the body of the `Recall` H2 — accept either form.

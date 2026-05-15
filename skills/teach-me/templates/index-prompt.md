# Landing page HTML template

Render the topic's `index.html` from `INDEX.md`. Self-contained, no CDN, dark-mode aware, links to `assets/style.css`.

## Required structure

```html
<!doctype html>
<html lang="en" data-theme="light">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>{{topic}} — Learning Book</title>
  <link rel="stylesheet" href="assets/style.css" />
</head>
<body>
  <header class="landing-header">
    <h1>{{topic}}</h1>
    <p class="subtitle">{{entry-count}} entries · last updated {{latest-update-date}}</p>
    <div class="controls">
      <input class="search" type="search" placeholder="Filter entries…" aria-label="Filter entries" />
      <div class="tag-filter" role="group" aria-label="Filter by tag">
        {{#all-tags}}<button class="tag-chip" data-tag="{{.}}">{{.}}</button>{{/all-tags}}
        <button class="tag-chip clear" data-tag="">clear</button>
      </div>
      <button class="theme-toggle" aria-label="Toggle theme">◐</button>
    </div>
  </header>

  <main class="entries-grid">
    {{#entries}}
    <a class="entry-card" href="entries/{{slug}}/index.html" data-tags="{{tags-joined-space}}" data-title="{{title-lower}}" data-desc="{{description-lower}}">
      <h2 class="entry-title">{{title}}</h2>
      <p class="entry-desc">{{description}}</p>
      <div class="entry-meta">
        {{#chapter}}<span class="badge chapter">Ch.{{chapter}}</span>{{/chapter}}
        {{#tags}}<span class="badge tag">{{.}}</span>{{/tags}}
        {{#related-count}}<span class="badge related">↔ {{related-count}}</span>{{/related-count}}
      </div>
    </a>
    {{/entries}}
  </main>

  <script>
    const root = document.documentElement;
    const stored = localStorage.getItem('teach-theme');
    if (stored) root.dataset.theme = stored;
    document.querySelector('.theme-toggle').addEventListener('click', () => {
      const next = root.dataset.theme === 'dark' ? 'light' : 'dark';
      root.dataset.theme = next;
      localStorage.setItem('teach-theme', next);
    });

    const cards = Array.from(document.querySelectorAll('.entry-card'));
    const search = document.querySelector('.search');
    let activeTag = '';

    function apply() {
      const q = search.value.trim().toLowerCase();
      cards.forEach(card => {
        const matchText = !q || card.dataset.title.includes(q) || card.dataset.desc.includes(q);
        const matchTag = !activeTag || card.dataset.tags.split(' ').includes(activeTag);
        card.style.display = matchText && matchTag ? '' : 'none';
      });
    }

    search.addEventListener('input', apply);
    document.querySelectorAll('.tag-chip').forEach(chip => {
      chip.addEventListener('click', () => {
        activeTag = chip.dataset.tag;
        document.querySelectorAll('.tag-chip').forEach(c => c.classList.toggle('active', c === chip && activeTag));
        apply();
      });
    });
  </script>
</body>
</html>
```

## Rules

- Read each `entries/<slug>/source.md` frontmatter to populate cards (title, tags, chapter, related count, created/updated).
- The `description` for each card comes from the corresponding `INDEX.md` line (the text after the `— `).
- `all-tags` = union of every entry's `tags`, sorted alphabetically.
- `entry-count` = number of entries.
- `latest-update-date` = max of all entries' `updated:` frontmatter values.
- `tags-joined-space` = the entry's tags joined by single space (used by client-side filter).
- Card click navigates to the entry's `index.html`.
- Search filter is client-side over title + description. Tag filter is single-select (clicking another tag swaps, "clear" resets).
- Cards have hover state (slight lift + border accent), focus ring for keyboard nav.
- If zero entries, show an empty-state message: `No entries yet. Ask /teach-me to add the first one.`

## Sort order

Cards sorted by `updated:` descending (most recently touched first). Stable secondary sort by `created:` descending.

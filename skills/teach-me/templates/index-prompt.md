# Landing page HTML templates

Two landing pages to render:

1. **Topic landing** — `~/.claude/teaching/<topic>/index.html` — shows all entries in one topic. Built from `<topic>/INDEX.md`.
2. **Global landing** — `~/.claude/teaching/global-index.html` — searches across all topics. Built from `global-index.json`.

Both: self-contained, no CDN, dark-mode aware. Anti-flash script in `<head>`.

---

## 1. Topic landing page

```html
<!doctype html>
<html lang="en" data-theme="light">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>{{topic}} — Learning Book</title>
  <script>
    (function() {
      const saved = localStorage.getItem('teach-theme');
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      document.documentElement.dataset.theme = saved || (prefersDark ? 'dark' : 'light');
    })();
  </script>
  <link rel="stylesheet" href="assets/style.css" />
</head>
<body>
  <header class="landing-header">
    <div class="landing-nav">
      <a class="back-link" href="../global-index.html">⊞ All topics</a>
    </div>
    <h1>{{topic}}</h1>
    <p class="subtitle">{{entry-count}} entries · last updated {{latest-update-date}}</p>
    <div class="controls">
      <input class="search" type="search" placeholder="Search entries…" aria-label="Search entries" />
      <div class="tag-filter" role="group" aria-label="Filter by tag">
        {{#all-tags}}<button class="tag-chip" data-tag="{{.}}">{{.}}</button>{{/all-tags}}
        <button class="tag-chip clear" data-tag="">clear</button>
      </div>
      <button class="theme-toggle" id="theme-toggle" aria-label="Toggle theme">◐</button>
    </div>
  </header>

  <main class="entries-grid" id="entries-grid">
    {{#entries}}
    <a class="entry-card" href="entries/{{slug}}/index.html"
       data-tags="{{tags-joined-space}}"
       data-title="{{title-lower}}"
       data-desc="{{description-lower}}">
      <h2 class="entry-title">{{title}}</h2>
      <p class="entry-desc">{{description}}</p>
      <div class="entry-meta">
        <span class="bloom-badge bloom-{{bloom-level}}">{{Beginner|Intermediate|Advanced}}</span>
        {{#tags}}<span class="badge tag">{{.}}</span>{{/tags}}
        {{#related-count}}<span class="badge related">↔ {{related-count}}</span>{{/related-count}}
        <span class="meta-dates">{{updated}}</span>
      </div>
    </a>
    {{/entries}}
    <p class="empty-state" hidden>No entries yet. Ask <code>/teach-me</code> to add the first one.</p>
  </main>

  <script>
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

    const cards = Array.from(document.querySelectorAll('.entry-card'));
    const search = document.querySelector('.search');
    const emptyState = document.querySelector('.empty-state');
    const activeTags = new Set();

    function apply() {
      const q = search.value.trim().toLowerCase();
      let visible = 0;
      cards.forEach(card => {
        const matchText = !q || card.dataset.title.includes(q) || card.dataset.desc.includes(q);
        const cardTags = new Set(card.dataset.tags.split(' ').filter(Boolean));
        const matchTag = activeTags.size === 0 || [...activeTags].every(t => cardTags.has(t));
        card.hidden = !(matchText && matchTag);
        if (!card.hidden) visible++;
      });
      emptyState.hidden = visible > 0;
      // Sync to URL
      const params = new URLSearchParams();
      if (q) params.set('q', q);
      if (activeTags.size) params.set('tags', [...activeTags].join(','));
      history.replaceState(null, '', params.toString() ? '?' + params : location.pathname);
    }

    search.addEventListener('input', () => { clearTimeout(search._t); search._t = setTimeout(apply, 150); });

    document.querySelectorAll('.tag-chip').forEach(chip => {
      chip.addEventListener('click', () => {
        const tag = chip.dataset.tag;
        if (!tag) { activeTags.clear(); document.querySelectorAll('.tag-chip').forEach(c => c.classList.remove('active')); }
        else { activeTags.has(tag) ? activeTags.delete(tag) : activeTags.add(tag); chip.classList.toggle('active'); }
        apply();
      });
    });

    // Restore from URL on load
    const params = new URLSearchParams(location.search);
    if (params.get('q')) { search.value = params.get('q'); }
    if (params.get('tags')) params.get('tags').split(',').forEach(t => {
      activeTags.add(t);
      document.querySelector(`.tag-chip[data-tag="${t}"]`)?.classList.add('active');
    });
    apply();
  </script>
</body>
</html>
```

### Topic landing rules

- Read each `entries/<slug>/source.md` frontmatter for: title, bloom-level, tags, related (count), created, updated.
- `description` for each card: from the corresponding `INDEX.md` line (text after the `— `).
- `all-tags`: union of all entries' tags, sorted alphabetically.
- Sort cards: by `updated:` descending. Stable secondary sort by `created:` descending.
- `tags-joined-space`: tags joined by single space for `data-tags` attribute.
- If zero entries: show empty-state message.

---

## 2. Global landing page

```html
<!doctype html>
<html lang="en" data-theme="light">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>Learning Book — All Topics</title>
  <script>
    (function() {
      const saved = localStorage.getItem('teach-theme');
      const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches;
      document.documentElement.dataset.theme = saved || (prefersDark ? 'dark' : 'light');
    })();
  </script>
  <link rel="stylesheet" href="assets/style.css" />
  <!-- global-index.json loaded inline at render time (see rules below) -->
  <script>
    const ENTRIES = {{inline JSON array from global-index.json}};
  </script>
</head>
<body>
  <header class="landing-header global-header">
    <h1>Learning Book</h1>
    <p class="subtitle">{{total-entry-count}} entries across {{topic-count}} topics</p>
    <div class="controls">
      <input class="search" type="search" id="global-search"
             placeholder="Search all topics…" aria-label="Search all topics"
             accesskey="/" />
      <div class="topic-filter" role="group" aria-label="Filter by topic">
        {{#all-topics}}<button class="topic-chip" data-topic="{{.}}">{{.}}</button>{{/all-topics}}
      </div>
      <div class="tag-filter" role="group" aria-label="Filter by tag">
        {{#all-tags}}<button class="tag-chip" data-tag="{{.}}">{{.}}</button>{{/all-tags}}
        <button class="tag-chip clear" data-tag="">clear tags</button>
      </div>
      <button class="theme-toggle" id="theme-toggle" aria-label="Toggle theme">◐</button>
    </div>
  </header>

  <main id="global-grid" class="entries-grid"></main>

  <script>
    // ── Dark mode ─────────────────────────────────────────────────
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

    // ── In-memory inverted index for search ───────────────────────
    const stopWords = new Set(['the','a','an','is','in','of','to','and','or','for','with','that','this','it','on','at','by','are','was','be','as','from','have']);
    function tokenize(str) {
      return (str || '').toLowerCase().replace(/[^\w\s]/g, '').split(/\s+/).filter(w => w.length > 2 && !stopWords.has(w));
    }

    const index = {}; // word → Set of entry ids (each id is "topic/slug")
    const byId = {};
    ENTRIES.forEach(entry => {
      byId[entry.id] = entry; // id = "<topic>/<slug>" — no collision across topics
      tokenize(entry.title + ' ' + entry.summary + ' ' + entry.tags.join(' ')).forEach(word => {
        if (!index[word]) index[word] = new Set();
        index[word].add(entry.id);
      });
    });

    function search(query) {
      const terms = tokenize(query);
      if (!terms.length) return ENTRIES;
      let results = new Set(index[terms[0]] || []);
      terms.slice(1).forEach(t => {
        const m = index[t] || new Set();
        results = new Set([...results].filter(id => m.has(id)));
      });
      return [...results].map(id => byId[id]);
    }

    // ── Render cards ──────────────────────────────────────────────
    const grid = document.getElementById('global-grid');
    let activeTopic = '';
    const activeTags = new Set();

    function bloomLabel(l) { return l === 'none' ? 'Beginner' : l === 'some' ? 'Intermediate' : 'Advanced'; }

    function renderCards(entries) {
      grid.innerHTML = '';
      if (!entries.length) {
        grid.innerHTML = '<p class="empty-state">No entries match. Try a different search or clear filters.</p>';
        return;
      }
      entries.forEach(e => {
        const a = document.createElement('a');
        a.className = 'entry-card';
        a.href = e.path;
        a.innerHTML = `
          <h2 class="entry-title">${e.title}</h2>
          <p class="entry-desc">${e.summary}</p>
          <div class="entry-meta">
            <span class="topic-badge">${e.topic}</span>
            ${e.bloom ? `<span class="bloom-badge bloom-${e.bloom}">${bloomLabel(e.bloom)}</span>` : ''}
            ${e.tags.map(t => `<span class="badge tag">${t}</span>`).join('')}
            <span class="meta-dates">${e.updated}</span>
          </div>`;
        grid.appendChild(a);
      });
    }

    function apply() {
      const q = document.getElementById('global-search').value.trim();
      let results = search(q);
      if (activeTopic) results = results.filter(e => e.topic === activeTopic);
      if (activeTags.size) results = results.filter(e => [...activeTags].every(t => e.tags.includes(t)));
      // Sort: updated desc
      results.sort((a, b) => b.updated.localeCompare(a.updated));
      renderCards(results);
      // Sync URL
      const params = new URLSearchParams();
      if (q) params.set('q', q);
      if (activeTopic) params.set('topic', activeTopic);
      if (activeTags.size) params.set('tags', [...activeTags].join(','));
      history.replaceState(null, '', params.toString() ? '?' + params : location.pathname);
    }

    document.getElementById('global-search').addEventListener('input', function() {
      clearTimeout(this._t); this._t = setTimeout(apply, 150);
    });

    // Keyboard shortcut: / focuses search
    document.addEventListener('keydown', e => {
      if ((e.key === '/' || (e.ctrlKey && e.key === 'k')) && document.activeElement !== document.getElementById('global-search')) {
        e.preventDefault();
        document.getElementById('global-search').focus();
      }
    });

    document.querySelectorAll('.topic-chip').forEach(chip => {
      chip.addEventListener('click', () => {
        activeTopic = activeTopic === chip.dataset.topic ? '' : chip.dataset.topic;
        document.querySelectorAll('.topic-chip').forEach(c => c.classList.toggle('active', c.dataset.topic === activeTopic));
        apply();
      });
    });

    document.querySelectorAll('.tag-chip').forEach(chip => {
      chip.addEventListener('click', () => {
        const tag = chip.dataset.tag;
        if (!tag) { activeTags.clear(); document.querySelectorAll('.tag-chip').forEach(c => c.classList.remove('active')); }
        else { activeTags.has(tag) ? activeTags.delete(tag) : activeTags.add(tag); chip.classList.toggle('active'); }
        apply();
      });
    });

    // Restore from URL
    const params = new URLSearchParams(location.search);
    if (params.get('q')) document.getElementById('global-search').value = params.get('q');
    if (params.get('topic')) { activeTopic = params.get('topic'); document.querySelector(`.topic-chip[data-topic="${activeTopic}"]`)?.classList.add('active'); }
    if (params.get('tags')) params.get('tags').split(',').forEach(t => { activeTags.add(t); document.querySelector(`.tag-chip[data-tag="${t}"]`)?.classList.add('active'); });

    apply();
  </script>
</body>
</html>
```

### Global landing rules

- Inline `global-index.json` as the `ENTRIES` constant — keeps the page self-contained (no fetch needed).
- `all-topics`: sorted unique list of all `topic` values in the index.
- `all-tags`: sorted unique list of all tags across all entries.
- Search uses the in-memory inverted index — sub-5ms for ≤2000 entries.
- Topic filter: single-select (click again to deselect).
- Tag filter: multi-select AND logic.
- Default view: all entries, sorted by `updated` descending.

### INDEX.md format (both topic and global)

Topic `INDEX.md` — one line per entry:
```
| <slug> | <title> | <tags-csv> | <created> | <updated> | <one-sentence description> |
```

Global `GLOBAL_INDEX.md` — one line per entry:
```
| <slug> | <title> | <topic> | <tags-csv> | <created> | <updated> | <one-sentence description> |
```

When appending: always append, never rewrite the whole file. Rebuild `global-index.json` from `GLOBAL_INDEX.md` content after each append.

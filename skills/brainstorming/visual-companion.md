# Visual Companion Guide

An optional browser companion for mockups, diagrams, and visual comparisons.
[Brainstorming](SKILL.md) owns design decisions and approval boundaries; this
reference supplies presentation and event-handling details.

## When to Use

Use it when seeing the content materially helps the user understand or choose.
A UI topic alone does not require a browser. Choose text, a diagram, an existing
preview, or this companion according to the current decision and available
tools; do not create a separate visual workflow for every question.

## Starting a Session

```bash
scripts/start-server.sh --project-dir /path/to/project

# Returns: {"type":"server-started","port":52341,"url":"http://localhost:52341",
#           "screen_dir":"/path/to/project/.superpowers/brainstorm/12345-1706000000/content",
#           "state_dir":"/path/to/project/.superpowers/brainstorm/12345-1706000000/state"}
```

Save the returned `screen_dir` and `state_dir`, and give the user the URL when
needed to access the presentation. Startup details are also in
`state_dir/server-info`; a `server-stopped` record indicates shutdown.

Use `--project-dir` when preserving the mockups is useful; otherwise the script
uses `/tmp`. Respect the project's ignore rules when creating project artifacts.

Keep the server alive across turns using the current platform's persistent
terminal or background-task tools. The script may select foreground mode in
some environments. If detached processes are reaped, use `--foreground` with a
persistent execution tool rather than assuming behavior from a platform name.

The default bind address is loopback. When remote access is needed, choose the
appropriate bind and display hosts for that environment:

```bash
scripts/start-server.sh --project-dir /path/to/project --host 0.0.0.0 --url-host localhost
```

## Presenting And Interpreting Feedback

Write useful HTML to `screen_dir` using the available file tools. The server
serves the newest HTML file and reloads the browser when content changes.
Fragments are wrapped in the provided frame; a full document starting with
`<!DOCTYPE` or `<html` is served as-is with the helper script added.

Use semantic filenames. A new decision screen needs a new filename because the
server clears recorded events when it first sees a new screen. Updating the
same file reloads it while retaining earlier events. Read any feedback still
needed before replacing the current decision screen.

Explain what the user is seeing and what judgment is needed. Wait when further
progress depends on their feedback; continue independent authorized work when
useful. Choose the feedback interface, URL reminders, and turn boundaries to
suit the current interaction. Refresh or clear stale content when leaving it
visible would confuse the next decision.

Read `state_dir/events` when interpreting browser feedback. Combine recorded
interactions with the user's messages; clicks can reflect exploration, toggles,
or a changed preference. Resolve material ambiguity rather than treating the
last click as automatic approval. Existing design and action authority still
applies. If the server stops or becomes unreachable, restore it when needed;
missing events alone do not prove the user made no selection.

## Writing Content Fragments

Write just the content that goes inside the page. The server wraps it in the frame template automatically (header, theme CSS, selection indicator, and all interactive infrastructure).

**Minimal example:**

```html
<h2>Which layout works better?</h2>
<p class="subtitle">Consider readability and visual hierarchy</p>

<div class="options">
  <div class="option" data-choice="a" onclick="toggleSelect(this)">
    <div class="letter">A</div>
    <div class="content">
      <h3>Single Column</h3>
      <p>Clean, focused reading experience</p>
    </div>
  </div>
  <div class="option" data-choice="b" onclick="toggleSelect(this)">
    <div class="letter">B</div>
    <div class="content">
      <h3>Two Column</h3>
      <p>Sidebar navigation with main content</p>
    </div>
  </div>
</div>
```

That's it. No `<html>`, no CSS, no `<script>` tags needed. The server provides all of that.

## CSS Classes Available

The frame template provides these CSS classes for your content:

### Options (A/B/C choices)

```html
<div class="options">
  <div class="option" data-choice="a" onclick="toggleSelect(this)">
    <div class="letter">A</div>
    <div class="content">
      <h3>Title</h3>
      <p>Description</p>
    </div>
  </div>
</div>
```

**Multi-select:** Add `data-multiselect` to the container to let users select multiple options. Each click toggles the item. The indicator bar shows the count.

```html
<div class="options" data-multiselect>
  <!-- same option markup — users can select/deselect multiple -->
</div>
```

### Cards (visual designs)

```html
<div class="cards">
  <div class="card" data-choice="design1" onclick="toggleSelect(this)">
    <div class="card-image"><!-- mockup content --></div>
    <div class="card-body">
      <h3>Name</h3>
      <p>Description</p>
    </div>
  </div>
</div>
```

### Mockup container

```html
<div class="mockup">
  <div class="mockup-header">Preview: Dashboard Layout</div>
  <div class="mockup-body"><!-- your mockup HTML --></div>
</div>
```

### Split view (side-by-side)

```html
<div class="split">
  <div class="mockup"><!-- left --></div>
  <div class="mockup"><!-- right --></div>
</div>
```

### Pros/Cons

```html
<div class="pros-cons">
  <div class="pros"><h4>Pros</h4><ul><li>Benefit</li></ul></div>
  <div class="cons"><h4>Cons</h4><ul><li>Drawback</li></ul></div>
</div>
```

### Mock elements (wireframe building blocks)

```html
<div class="mock-nav">Logo | Home | About | Contact</div>
<div style="display: flex;">
  <div class="mock-sidebar">Navigation</div>
  <div class="mock-content">Main content area</div>
</div>
<button class="mock-button">Action Button</button>
<input class="mock-input" placeholder="Input field">
<div class="placeholder">Placeholder area</div>
```

### Typography and sections

- `h2` — page title
- `h3` — section heading
- `.subtitle` — secondary text below title
- `.section` — content block with bottom margin
- `.label` — small uppercase label text

## Browser Events Format

When the user clicks options in the browser, their interactions are recorded to `$STATE_DIR/events` (one JSON object per line). The file is cleared automatically when you push a new screen.

```jsonl
{"type":"click","choice":"a","text":"Option A - Simple Layout","timestamp":1706000101}
{"type":"click","choice":"c","text":"Option C - Complex Grid","timestamp":1706000108}
{"type":"click","choice":"b","text":"Option B - Hybrid","timestamp":1706000115}
```

Custom controls can call `window.brainstorm.choice("design-a")`; this records a
`choice` event with the same `choice` field. Interpret the event stream together
with current user intent as described above.

## Design Tips

- **Scale fidelity to the question** — wireframes for layout, polish for polish questions
- **Explain the question on each page** — "Which layout feels more professional?" not just "Pick one"
- **Iterate before advancing** — if feedback changes current screen, write a new version
- **Keep choices focused** — show only meaningful alternatives for the current decision
- **Use representative content** when placeholder text or images would hide layout or design problems.
- **Keep mockups simple** — focus on layout and structure, not pixel-perfect design

## Cleaning Up

```bash
scripts/stop-server.sh "$SESSION_DIR"
```

If the session used `--project-dir`, mockup files persist in `.superpowers/brainstorm/` for later reference. Only `/tmp` sessions get deleted on stop.

## Reference

- Frame template (CSS reference): `scripts/frame-template.html`
- Helper script (client-side): `scripts/helper.js`

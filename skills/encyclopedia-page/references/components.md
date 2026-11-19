# Components

Copy-ready snippets for the template. All styling already lives in `assets/template.html`, so only use these classes and never add a second stylesheet.

## Contents
1. Hatnote and lead
2. Infobox (generic and taxobox)
3. Boxes: note, warning, one-sentence, analogy
4. Math
5. Tables
6. Figures (inline SVG) and theme classes
7. Spoiler
8. Calculator and generated plot
9. Gallery
10. Glossary, references, see also, navbox, categories

---

## 1. Hatnote and lead
```html
<div class="hatnote">This article is about the suborder of reptiles. For the Greek term, see <i>ophis</i>.</div>
<p><span class="lead-term">Snakes</span> (<i>Serpentes</i>), also called ophidians, are …<sup class="ref"><a href="#ref-1">1</a></sup></p>
```
The `sup.ref` brackets are added automatically. Number references in the order they first appear.

## 2. Infobox
```html
<aside class="infobox">
  <div class="ib-title band">Title</div>
  <div class="ib-media"><svg viewBox="0 0 280 160" role="img" aria-label="…">…</svg></div>
  <div class="cap">Caption of the illustration</div>
  <table>
    <tr><td colspan="2" class="ib-head">Group heading</td></tr>
    <tr><th>Key</th><td>Value</td></tr>
  </table>
</aside>
```
- **Taxobox**: a group heading "Scientific classification" (or "Clasificación científica"), then rows for kingdom, phylum, class, order, suborder and so on, with the taxon itself in `<b><i>…</i></b>`. To give the bands a kingdom colour, add `style="--ib-band:#d3e8c2"` (plants) or `style="--ib-band:#f2d3d3"` (animals) to the `<aside>`, but only in light mode. It is fine to skip this.
- **Formula card**: put the main equation inside `.ib-media` as `$$…$$`. For a long equation, use `\begin{aligned}…\end{aligned}` to split it so it fits the 300 px width.

## 3. Boxes
```html
<div class="box good"><span class="bt">In one sentence</span>…</div>
<div class="box"><span class="bt">Check</span>…</div>            <!-- blue note: verification, tip -->
<div class="box warn"><span class="bt">⚠️ Common mistake</span>…</div>  <!-- pitfalls, errata, myths -->
<div class="analogy"><span class="bt">Analogy: the crumpled map</span>…</div>
```
Errata: show the printed version and the corrected version, and say why the correction is right in one line.

## 4. Math
Inline `$…$` and display `$$…$$` are rendered by KaTeX. For a numbered display equation:
```html
<div class="eqnum"><div class="eq">$$…$$</div><span class="n">(8.29)</span></div>
```
Wrap a wide unnumbered display equation in `<div class="eq">` so it scrolls instead of overflowing. Use `\underbrace{…}_{\text{A}}` to label terms you discuss later. Never put `$` inside an `<svg>`, an `<option>` or a heading: those are not rendered. Use Unicode there instead (ε², g₀₀, ∇²φ).

## 5. Tables
```html
<div class="tscroll"><table class="wt">
  <caption>What is given and what is unknown</caption>
  <tr><th>Symbol</th><th>Meaning</th><th>Role</th></tr>
  <tr><td>…</td><td>…</td><td>…</td></tr>
  <tr class="hl"><td colspan="3">highlighted row</td></tr>
</table></div>
```

## 6. Figures
```html
<figure class="thumb">            <!-- add class "right" for a floated 340 px thumbnail -->
  <svg viewBox="0 0 640 260" role="img" aria-label="…">
    <defs><marker id="arA" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto"><path d="M0 0L10 5L0 10z" class="tm"/></marker></defs>
    <rect x="20" y="20" width="160" height="50" rx="4" class="card"/>
    <text x="100" y="50" text-anchor="middle" font-size="13" class="t">Label</text>
    <path d="M180 45 L300 45" class="ln" stroke-width="1.4" fill="none" marker-end="url(#arA)"/>
  </svg>
  <figcaption><b>Figure 1.</b> What it shows, and what to look at.</figcaption>
</figure>
```
Theme classes that adapt to dark mode:
- text: `.t` (main), `.tm` (muted)
- lines: `.ln`, `.grid`
- boxes: `.card` (neutral), `.card-a` (blue, data), `.card-w` (amber, the focus or the result), `.card-g` (green)
- fixed accents, fine in both themes: `#edab00`, `#3366cc`, `#14866d`, `#d73333`

SVG tips:
- Give each figure's `<marker>` ids a unique suffix.
- Leave about 10 px of padding inside the viewBox, and keep labels at 12 px or more at the rendered width.
- Place labels away from lines.
- For anatomy or diagrams, draw simple clean shapes (paths and ellipses) with numbered or leader-line labels, not detailed drawings.
- Flowcharts: left to right, at most about 7 boxes, with the focus box in `card-w`.

## 7. Spoiler
```html
<details class="spoiler">
  <summary>Show the result of each term (try it on paper first)</summary>
  <div> … </div>
</details>
```

## 8. Calculator and generated plot
```html
<div class="calc">
  <label for="c-body">Object:</label>
  <select id="c-body"><option value="a">…</option></select>
  <div class="out">
    <div class="cell"><div class="k">Quantity</div><div class="v" id="c-o1">–</div></div>
  </div>
  <div class="msg" id="c-msg"></div>
</div>
```
Put the script after the template's main script (see the marker comment). Keep it plain JS, compute from real constants, and format very small or very large numbers as `2.55×10⁻⁸` (superscript digits), not `e-8`. For a plot, build the SVG in JS with `createElementNS` into an empty `<svg id="plot" viewBox="0 0 640 330">`. Include axes, tick labels, axis titles and a legend, and clamp the ranges so the curves don't flatten at the edge.

## 9. Gallery
```html
<div class="gallery">
  <figure><svg viewBox="0 0 200 120">…</svg><figcaption>…</figcaption></figure>
</div>
```

## 10. End matter
```html
<h2 id="glossary">Glossary</h2>
<dl class="glossary"><dt>Term</dt><dd>Plain-language definition.</dd></dl>

<h2 id="references">References</h2>
<ol class="reflist"><li id="ref-1">Author, A. <i>Title</i>. Publisher, Year.</li></ol>

<h2 id="see-also">See also</h2>
<ul class="seealso"><li><a href="#">Related topic</a></li></ul>

<div class="navbox">
  <div class="nb-title">Family of topics</div>
  <div class="nb-row"><div>Group</div><div><a href="#">A</a> · <a href="#">B</a></div></div>
</div>

<div class="catlinks"><span data-i18n="categories"></span>: <a href="#">Cat 1</a> | <a href="#">Cat 2</a></div>
```
Links to pages that don't exist can use `href="#"`. If the user wants companion pages, link them by relative filename.

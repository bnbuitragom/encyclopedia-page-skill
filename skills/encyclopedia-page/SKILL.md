---
name: encyclopedia-page
description: Create a single, self-contained HTML explainer page about any topic, laid out like an encyclopedia article (wiki-style). It has a header, a numbered table of contents in a sidebar, an infobox, a lead, sections, figures, a glossary, references and categories, written so a non-expert can understand it. Use this whenever someone asks for a "Wikipedia-style", "wiki-like", "enciclopedia", "estilo Wikipedia" or "artículo enciclopédico" page. Also use it when they give a bare topic to explain as a page (e.g. "ofidio", "fotosíntesis", "the Ricci tensor", "la Revolución Francesa"), want a study or explainer page that makes a subject or a homework problem easy to understand, or want an "article" about a concept, organism, person, place, event, technology or equation, even if they never say "wiki".
---

# Encyclopedia page

This skill turns a topic into one polished HTML file. The file looks like an encyclopedia article and reads like a patient tutor. The page uses the familiar encyclopedia layout so the reader instantly knows how to navigate it. The content goes further than an encyclopedia would, adding analogies, "why this matters" passages and interactive figures, because the goal is that **someone with no background understands the topic**.

## Name and trademark (read once)

"Wikipedia" and the puzzle-globe logo are trademarks of the Wikimedia Foundation, and using them in a product or page name requires a licence. So:

- Never put "Wikipedia", "Wiki" + "pedia" combinations that imitate it (e.g. "Wikipedia ES"), or the globe logo on the page.
- Give the page a **fictional brand ending in "-pedia"**, themed to the topic. Examples: *Orbipedia* for astronomy, *Herpetopedia* or *Faunapedia* for snakes, *Historipedia* for history. If the user names a brand, use it. Otherwise invent one that is unlikely to be a real site.
- Keep the template's footer disclaimer ("fictional name, not affiliated with the Wikimedia Foundation").
- Describing the page as "estilo Wikipedia" in conversation is fine. The page itself must not claim to be Wikipedia.
- Write the page as a local file. Do not publish it to a public URL dressed as Wikipedia.

## Workflow

### 1. Pin down the topic and the reader

From the request, work out:
- **Topic and angle.** "Ofidio" means the suborder Serpentes. "Ecuación 8.29" means a specific derivation in a specific book, so read the source if the user gave one.
- **Language.** Write in the user's language and set `<html lang>` to match. The template localises its interface strings for es, en, pt and fr, and falls back to English.
- **Reader.** Assume a curious, intelligent non-expert unless told otherwise. Never dumb down the facts; make the path to them gentler.

Ask only if the topic is genuinely ambiguous, for example "Mercury" the planet versus the element. Otherwise choose the most likely reading and mention the alternative in the hatnote.

### 2. Gather and verify facts

Wrong facts in an authoritative-looking page are worse than no page. So:
- Use web search or fetch tools if available, and any files the user provided. Prefer primary or authoritative sources.
- **Recompute every number, formula and derivation yourself** before putting it on the page. Do the algebra and check the units. If the user's source has an error, show it in a ⚠️ box with the printed version next to the corrected one. Users love this.
- **References must be real.** Cite only works you are confident exist (title, author, year). Three solid references beat ten doubtful ones. Never invent DOIs, URLs or page numbers.
- When something is uncertain or debated, say so in the text.

### 3. Plan the article

Choose sections from `references/topic-patterns.md` for the topic type: concept, equation or homework, organism, person, place, event, technology or work. Every page, whatever the type, has:

1. **Hatnote:** one italic line saying what this article covers and pointing to related readings.
2. **Infobox:** a quick-facts card with an illustration on top. It is a taxobox for organisms, a formula card for equations and a dates card for events.
3. **Lead:** 2–4 paragraphs that alone give a complete answer. Bold the term in the first sentence.
4. **"En una frase / In one sentence" box:** a green `.box.good` near the top that states the core idea, or for a task, exactly what has to be done.
5. **Body sections:** each with at least one of an analogy, a figure, a table or a worked example.
6. **Misconceptions or pitfalls:** a ⚠️ box with the most common error.
7. **Glossary, references, see also, categories** (and a navbox when the topic belongs to a family).

Aim for about 1,500–3,500 words. Depth beats breadth: a few sections explained well are better than many thin ones.

### 4. Build the page from the template

Write only the article body, meaning everything that goes between `BEGIN ARTICLE` and `END ARTICLE` in `assets/template.html`, to a fragment file. Optionally also write a `<script>` block for calculators or plots and a 44×44 SVG emblem for the brand. Then assemble the page:

```bash
python3 <skill-dir>/scripts/assemble.py --article article.html --out <topic>.html \
  --lang es --brand Ofidiopedia --tagline "La enciclopedia de las serpientes" \
  --title "Ofidios" [--script extra.html] [--logo logo.svg]
```

The script fills the slots, refuses a brand containing "Wikipedia", and fails if a slot is left empty. Pick components from `references/components.md`, which has copy-ready snippets for the infobox, boxes, analogies, equations, tables, SVG figures, spoilers, calculators, galleries, the navbox and the reference list. `examples/` in this skill has a complete worked page (`ofidio.*`) to imitate for depth and tone.

The template already handles the table of contents and its numbering, the localized interface, dark mode, KaTeX math (`$…$` and `$$…$$`) and responsive layout, so don't rebuild those. Give every `h2` an `id`. Keep math and HTML tags out of headings so the table of contents stays clean; use Unicode instead (ε², g₀₀).

Rules for the content:
- **Explain every symbol and every technical term the first time it appears.** This is the main difference from a real encyclopedia.
- **Analogies** (`.analogy`): 2–4 per page, each tied to one specific idea. Say where the analogy breaks if that could mislead.
- **Figures:** draw them as **inline SVG** that you design for the topic, such as diagrams, flowcharts, anatomy sketches, timelines, maps or plots. Use the theme classes (`.t`, `.ln`, `.card`, …) so they work in dark mode. Every figure gets a numbered caption that says what to look at. 2–4 figures is typical.
- **External images:** use them only if you have verified that the URL resolves. Wikimedia Commons files under a free licence are fine, credited in the caption with author and licence. When in doubt, draw an SVG instead.
- **Interactivity is optional but valued.** A small calculator, slider or generated plot that makes a scale or relationship tangible. Plain JS at the bottom of the page, no frameworks.
- **Exercises and derivations:** when the topic is a task the reader must solve, explain the strategy but hide the answers inside a `details.spoiler` so they can try first.

### 5. Check the rendering

Open the file in a real browser before handing it over. `scripts/screenshot.sh <page.html> [out.png] [width]` finds Chrome, Chromium or Edge (including Windows Chrome from WSL) and writes a full-page screenshot. Look at it for:
- formulas that failed to render (raw `$` or red KaTeX text);
- SVG labels that overlap lines or each other, are cut off at the right edge of the viewBox, or are unreadable (this is the most common defect, so check every figure);
- horizontal overflow at a narrow width (try 500 px; headless Chrome's minimum viewport is about 500 px);
- infobox or figure floats colliding with tables.

Fix the problems and look again. If no browser is available, say so instead of claiming the page was checked.

### 6. Deliver

Save the file where the user asked. Otherwise save it in the current working directory as `<topic-slug>.html`. Tell the user the path, list the sections in one line, and mention anything notable, such as errata found, facts you could not verify, or a brand you invented. Offer the obvious next step, for example a guided step-by-step derivation page or a companion page on a related topic.

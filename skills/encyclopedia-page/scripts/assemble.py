#!/usr/bin/env python3
"""Assemble an encyclopedia page from the template plus an article fragment.

Usage:
  python3 assemble.py --article article.html --out page.html \
      --lang es --brand Ofidiopedia --tagline "La enciclopedia de las serpientes" \
      --title "Ofidios" [--short-title "Ofidios"] [--logo logo.svg] [--script extra.html]

article.html : everything that goes between BEGIN ARTICLE and END ARTICLE
               (hatnote, infobox, lead, h2 sections, glossary, references, catlinks).
logo.svg     : optional 44x44 <svg> emblem that replaces the default one.
extra.html   : optional <script>…</script> block (calculators, generated plots).
The script fails if any {{SLOT}} remains outside HTML comments.
"""
import argparse, pathlib, re, sys

here = pathlib.Path(__file__).resolve().parent
ap = argparse.ArgumentParser()
ap.add_argument("--template", default=str(here.parent / "assets" / "template.html"))
ap.add_argument("--article", required=True)
ap.add_argument("--out", required=True)
ap.add_argument("--lang", default="en")
ap.add_argument("--brand", required=True)
ap.add_argument("--tagline", required=True)
ap.add_argument("--title", required=True)
ap.add_argument("--short-title")
ap.add_argument("--logo")
ap.add_argument("--script")
a = ap.parse_args()

if re.search(r"wikipedia", a.brand, re.I):
    sys.exit("Brand must not contain 'Wikipedia' (Wikimedia trademark). Pick a fictional -pedia name.")

t = pathlib.Path(a.template).read_text(encoding="utf-8")
art = pathlib.Path(a.article).read_text(encoding="utf-8")
t, n = re.subn(r"<!-- BEGIN ARTICLE.*?END ARTICLE =+ -->", lambda m: art, t, flags=re.S)
if n != 1:
    sys.exit("Template article markers not found.")
if a.logo:
    logo = pathlib.Path(a.logo).read_text(encoding="utf-8").strip()
    t = re.sub(r'<svg width="44".*?</svg>', lambda m: logo, t, count=1, flags=re.S)
slots = {"{{LANG}}": a.lang, "{{BRAND}}": a.brand, "{{TAGLINE}}": a.tagline,
         "{{PAGE_TITLE}}": a.title, "{{SHORT_TITLE}}": a.short_title or a.title}
for k, v in slots.items():
    t = t.replace(k, v)
if a.script:
    t = t.replace("<!-- Page-specific scripts (calculators, generated plots) go below this line. -->",
                  pathlib.Path(a.script).read_text(encoding="utf-8"))
left = re.findall(r"\{\{[A-Z_]+\}\}", re.sub(r"<!--.*?-->", "", t, flags=re.S))
if left:
    sys.exit("Unfilled slots: " + ", ".join(sorted(set(left))))
out = pathlib.Path(a.out)
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(t, encoding="utf-8")
print(out.resolve())

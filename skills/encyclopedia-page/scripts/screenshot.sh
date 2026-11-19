#!/usr/bin/env bash
# Full-page screenshot of a local HTML file with a headless Chromium-family browser.
# Usage: screenshot.sh <page.html> [out.png] [width=1300] [height=6000]
# Works on Linux, macOS, and WSL (falls back to Windows Chrome/Edge).
set -euo pipefail
page="${1:?usage: screenshot.sh <page.html> [out.png] [width] [height]}"
out="${2:-${page%.*}.png}"
width="${3:-1300}"
height="${4:-6000}"

abs() { (cd "$(dirname "$1")" && printf '%s/%s' "$(pwd)" "$(basename "$1")"); }
page_abs="$(abs "$page")"
mkdir -p "$(dirname "$out")"; out_abs="$(abs "$out")"

candidates=(
  chromium chromium-browser google-chrome google-chrome-stable microsoft-edge
  "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  "/Applications/Chromium.app/Contents/MacOS/Chromium"
  "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge"
  "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe"
  "/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe"
  "/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"
  "/mnt/c/Program Files/Microsoft/Edge/Application/msedge.exe"
)
browser=""
for c in "${candidates[@]}"; do
  if command -v "$c" >/dev/null 2>&1; then browser="$(command -v "$c")"; break; fi
  if [ -x "$c" ]; then browser="$c"; break; fi
done
if [ -z "$browser" ]; then
  # Playwright's bundled Chromium, if present
  pw="$(ls -d "$HOME"/.cache/ms-playwright/chromium-*/chrome-linux/chrome 2>/dev/null | head -1 || true)"
  [ -n "$pw" ] && browser="$pw"
fi
[ -z "$browser" ] && { echo "No Chromium-family browser found; cannot render." >&2; exit 2; }

common=(--headless=new --disable-gpu --hide-scrollbars --window-size="$width,$height" --virtual-time-budget=8000)
if [[ "$browser" == /mnt/* ]]; then
  # Windows browser from WSL: it needs Windows paths and can only write to Windows paths.
  wpage="$(wslpath -w "$page_abs")"; url="file:///${wpage//\\//}"
  wintemp="$(cd /mnt/c && cmd.exe /c "echo %TEMP%" 2>/dev/null | tr -d '\r' | tail -1)"
  tmpwin="$(wslpath -u "$wintemp")/encpage_shot.png"
  "$browser" "${common[@]}" --screenshot="$(wslpath -w "$tmpwin")" "$url" >/dev/null 2>&1 || true
  cp "$tmpwin" "$out_abs"
else
  "$browser" "${common[@]}" --screenshot="$out_abs" "file://$page_abs" >/dev/null 2>&1 || true
fi
[ -s "$out_abs" ] && echo "$out_abs" || { echo "Screenshot failed" >&2; exit 1; }

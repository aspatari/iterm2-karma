# Preview Screenshots — Capture Recipe

This document specifies the exact pipeline used to produce the preview images
referenced from the project README (`assets/karma-dark.webp` and
`assets/karma-light.webp`). The pipeline is fully automated — no GUI capture,
no clicking, no profile switching.

## Overview

```
┌───────────────────┐    ┌──────────────┐    ┌──────────────┐
│ ./preview.sh dark │ →  │  freeze      │ →  │  cwebp       │
│ ./preview.sh light│    │  --execute   │    │  PNG → WebP  │
└───────────────────┘    └──────────────┘    └──────────────┘
   true-color ANSI         macOS chrome         README-ready
   (palette-accurate)      + window controls    (~50 KB each)
```

`preview.sh` emits 24-bit true-color escape codes with the **exact** Karma
palette hex values (no dependence on the active terminal profile). `freeze`
captures the output, renders it with macOS-style window chrome, and saves a
PNG. `cwebp` compresses to WebP for use in the README.

## Tooling

| Tool | Version | Why | Install |
|------|---------|-----|---------|
| `freeze` | 0.2.x | ANSI → PNG renderer with macOS chrome | `brew install charmbracelet/tap/freeze` |
| `cwebp` | 1.x | PNG → WebP compression | `brew install webp` |
| `bash` | macOS default | Runs `preview.sh` | Pre-installed |
| `python3` | 3.x | Optional — only for editing `preview.sh` patterns | Pre-installed |

Optional alternatives:

```bash
# ImageMagick instead of cwebp
magick assets/karma-dark.png -quality 90 assets/karma-dark.webp
```

## End-to-end pipeline

From the project root, run both lines. Total time: ~2 seconds.

```bash
freeze --execute "$PWD/assets/preview.sh dark" \
  --output assets/karma-dark.png \
  --window \
  --font.size 14 --line-height 1.4 \
  --padding "32,40" \
  --background "#0a0e14" \
  --shadow.blur 24 --shadow.x 0 --shadow.y 12

freeze --execute "$PWD/assets/preview.sh light" \
  --output assets/karma-light.png \
  --window \
  --font.size 14 --line-height 1.4 \
  --padding "32,40" \
  --background "#ffffff" \
  --shadow.blur 24 --shadow.x 0 --shadow.y 12

cwebp -q 90 assets/karma-dark.png  -o assets/karma-dark.webp
cwebp -q 90 assets/karma-light.png -o assets/karma-light.webp

rm assets/karma-dark.png assets/karma-light.png
```

The `freeze` invocations use:

| Flag | Purpose |
|------|---------|
| `--execute "$PWD/preview.sh <variant>"` | Run script in PTY; freeze parses ANSI output. **Absolute path** is required — `freeze` won't resolve relative paths inside its own PTY. |
| `--window` | macOS-style traffic-light controls (matches `catppuccin/iterm` style) |
| `--font.size 14` | Default JetBrains Mono at readable size for retina displays |
| `--line-height 1.4` | Comfortable spacing |
| `--padding "32,40"` | 32px vertical, 40px horizontal |
| `--background <hex>` | Theme background (`#0a0e14` Dark, `#ffffff` Light) |
| `--shadow.*` | Subtle drop shadow underneath the window |

> **Don't pass `--font.family "Iosevka Term"`** — `freeze` cannot load fonts
> by name from the system; it would render only the background. Use
> `--font.file path/to/font.ttf` if you really want a custom font, but
> `.ttc` (TrueType Collection) is **not** supported.

> **Don't use stdin pipe** (`./preview.sh | freeze`) — `freeze` auto-detects
> stdin as code requiring syntax highlighting and won't parse ANSI codes.
> `--execute` runs the command in a PTY where ANSI is parsed natively.

## How `preview.sh` works

The script supports two variants — `dark` (default) and `light`:

```bash
./assets/preview.sh dark
./assets/preview.sh light
```

Both produce identical layout, differing only in the embedded palette. The
script uses 24-bit true-color escape codes (`\033[38;2;R;G;Bm`) with the
exact Karma palette hex values from `src/palette/{dark,light}.ts` — this
makes the output identical regardless of the calling terminal's profile.

### ANSI parser quirk: bold-then-color order

When emitting bold + colored text, the bold sequence (`\033[1m`) **must
come before** the color sequence (`\033[38;2;R;G;Bm`). Some ANSI parsers
(including `freeze`'s) reset color state when bold follows color:

```bash
# ❌ Wrong — color is lost in freeze rendering
printf "\033[38;2;252;97;141m\033[1mHello\033[0m"

# ✅ Right — both attributes preserved
printf "\033[1m\033[38;2;252;97;141mHello\033[0m"
```

`preview.sh` follows this convention; if you edit color combinations in
the script, keep `bld` before `fg`.

## Layout

The screenshot is composed of four blocks (top → bottom):

1. **Header band** — left: stylized "K" logo (Karma highlight purple `#a86efd`).
   Right: `karma@iterm2` label (green `karma`, foreground `@`, yellow `iterm2`)
   followed by a `gray.5/6` separator line.
2. **Info table** — 4 rows of key/value pairs:
   - `theme` → "Karma Dark" or "Karma Light"
   - `variant` → "refined ANSI 16"
   - `source` → "sreetamdas/karma"
   - `license` → "MIT"
   Keys in `#fc618d` pink, values in foreground.
3. **ANSI 0–15 strip** — 16 numerical labels, each in its own ANSI color.
   Doubles as a chroma-check.
4. **Prompt** — minimal `~` + `λ` indicator (cyan-blue accent).

## Updating screenshots

When the palette or layout changes:

1. Edit `src/palette/{dark,light}.ts` (palette change) or
   `assets/preview.sh` (layout change).
2. Re-run the pipeline above. Output paths are fixed; existing WebPs are
   overwritten in place.
3. Commit the regenerated `assets/karma-{dark,light}.webp` together with
   the source change.

## Validation

After regeneration:

```bash
ls -lh assets/*.webp
# Target: 30-100 KB per file. >150 KB → drop quality to 75.
# Each WebP should render correctly when opened in Finder Preview
# (sanity-check the layout, colors, and font readability).

# Verify README still references both files:
grep -n 'karma-.*\.webp' README.md
```

## Future ideas (out of scope)

- **Per-language code samples** — mirror `sreetamdas.com/karma`'s demo strip
  with React, Python, Rust, etc. excerpts (would live under `assets/lang/`).
- **Animated SVG / GIF** showing palette switching — overkill for a
  static color preset preview.
- **Iosevka Term in screenshots** — extract a TTF from the Iosevka.ttc
  collection (e.g. via `fonttools`) and pass via `--font.file`. Default
  JetBrains Mono is currently used for simplicity.

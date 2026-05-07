/**
 * Karma Dark — terminal palette.
 *
 * Source of truth: `karma-palette` skill (which itself derives from
 * `sreetamdas/karma` `src/tokens.ts` and `themes/Karma-color-theme.json`).
 *
 * Mapping strategy: the **refined ANSI 16 mapping** from `karma-palette`
 * (variant *b*), not Karma's verbatim `terminal.ansi*` ship values. The
 * verbatim mapping uses orange (`#fd9353`) for both `ansiBlue` and
 * `ansiBrightBlue`, which produces unexpected results in many shells
 * (e.g. directories in `ls --color=auto` show as orange). The refined
 * mapping uses Karma's cyan-blue for ANSI 4 / 12 instead.
 *
 * See: `.opencode/skills/karma-palette/SKILL.md` → "Karma Dark — ANSI 16 (b)".
 */

import type { Palette } from "./types.ts";

export const darkPalette: Palette = {
  name: "Karma Dark",

  ansi: {
    // ANSI 0–7 — standard
    black: "#0a0e14", // tokens.ts: background
    red: "#fc618d", // tokens.ts: red, terminal.ansiRed
    green: "#7bd88f", // tokens.ts: green, terminal.ansiGreen
    yellow: "#fce566", // tokens.ts: yellow, terminal.ansiYellow
    blue: "#5ad4e6", // tokens.ts: blue (refined: skip orange-as-blue)
    magenta: "#af98e6", // tokens.ts: purple, terminal.ansiMagenta
    cyan: "#5ad4e6", // tokens.ts: blue / terminal.ansiCyan
    white: "#bab6c0", // tokens.ts: gray.9 (near-foreground)

    // ANSI 8–15 — bright variants
    brightBlack: "#69676c", // tokens.ts: gray.5, terminal.ansiBrightBlack
    brightRed: "#ff7ba0", // refined: brighter pink
    brightGreen: "#9ce3ab", // refined: brighter green
    brightYellow: "#fce566", // already at peak; reuse
    brightBlue: "#7fe0ee", // refined: brighter cyan-blue
    brightMagenta: "#c3b0f0", // refined: brighter purple
    brightCyan: "#7fe0ee", // refined: brighter cyan
    brightWhite: "#f7f1ff", // tokens.ts: primary (foreground)
  },

  ui: {
    background: "#0a0e14", // tokens.ts: background
    foreground: "#f7f1ff", // tokens.ts: primary
    cursor: "#fce566", // Karma yellow accent (badge/cursor convention)
    cursorText: "#0a0e14", // background, for legibility on yellow cursor
    selection: "#3a384a", // pre-blended `#bab6c0 @ 0x26` over `#0a0e14`
    selectedText: "#f7f1ff", // foreground
    bold: "#ffffff", // brighter than fg for emphasis
    link: "#a86efd", // tokens.ts: highlight (links / line numbers)
  },
};

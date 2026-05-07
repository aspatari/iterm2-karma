/**
 * Palette types — pure data shapes for Karma terminal palettes.
 *
 * No runtime code, no I/O, no imports outside this file.
 * Hex strings are validated at the render boundary via `parseHex`.
 */

/**
 * RGB color components in 0..1 range, as expected by NSColor in iTerm2's
 * `.itermcolors` plist (`Red Component`, `Green Component`, `Blue Component`).
 */
export interface RgbComponents {
  readonly red: number;
  readonly green: number;
  readonly blue: number;
}

/**
 * Full ANSI 16 color set — the eight standard colors plus their "bright"
 * counterparts. Values are 6-digit hex strings (`#rrggbb`, lowercase preferred).
 *
 * Mapping to iTerm2 plist keys: `Ansi 0 Color` (black) ... `Ansi 15 Color`
 * (brightWhite). See `.opencode/skills/itermcolors-format/` for plist details.
 */
export interface AnsiColors {
  readonly black: string;
  readonly red: string;
  readonly green: string;
  readonly yellow: string;
  readonly blue: string;
  readonly magenta: string;
  readonly cyan: string;
  readonly white: string;
  readonly brightBlack: string;
  readonly brightRed: string;
  readonly brightGreen: string;
  readonly brightYellow: string;
  readonly brightBlue: string;
  readonly brightMagenta: string;
  readonly brightCyan: string;
  readonly brightWhite: string;
}

/**
 * iTerm2 system colors — the named entries displayed alongside the ANSI grid
 * in **Preferences → Profiles → Colors** (e.g. Background, Foreground, Cursor,
 * Selection, Bold, Link).
 *
 * All values are 6-digit hex strings; alpha is intentionally omitted at this
 * layer and applied (when needed) during rendering.
 */
export interface UiColors {
  readonly background: string;
  readonly foreground: string;
  readonly cursor: string;
  readonly cursorText: string;
  readonly selection: string;
  readonly selectedText: string;
  readonly bold: string;
  readonly link: string;
}

/**
 * A complete iTerm2 color preset — the source of truth for one variant
 * (e.g. Karma Dark, Karma Light).
 *
 * `name` is the human-readable preset name surfaced inside iTerm2 (e.g.
 * "Karma Dark"). It is also used by the build script to derive the output
 * filename in `colors/`.
 */
export interface Palette {
  readonly name: string;
  readonly ansi: AnsiColors;
  readonly ui: UiColors;
}

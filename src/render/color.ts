/**
 * Color rendering — pure transformations from Karma palette hex strings to
 * the numeric RGB form expected by iTerm2's `.itermcolors` plist.
 *
 * No I/O, no logging, no globals. Throws on invalid input so the build script
 * fails fast at the boundary rather than emitting a silent default color.
 */

import type { RgbComponents } from "../palette/types.ts";

const HEX_PATTERN = /^[0-9a-f]{6}$/;
const MAX_BYTE = 255;

/**
 * Parse a 6-digit hex color string into normalized RGB components in 0..1.
 *
 * Accepts:
 * - With or without leading `#` (e.g. `"#FC618D"` or `"FC618D"`).
 * - Mixed case (input is folded to lowercase before matching).
 * - Surrounding whitespace (input is trimmed).
 *
 * Throws `Error` for any other shape — empty string, 3-digit shorthand,
 * 8-digit hex with alpha, non-hex characters, internal whitespace, etc.
 *
 * @param hex - 6-digit hex color, optionally prefixed with `#`.
 * @returns RGB components in the 0..1 range expected by NSColor.
 * @throws {Error} When `hex` is not a 6-digit hex color.
 */
export function parseHex(hex: string): RgbComponents {
  const cleaned = hex.trim().toLowerCase().replace(/^#/, "");

  if (!HEX_PATTERN.test(cleaned)) {
    throw new Error(
      `Invalid hex color: "${hex}". Expected 6-digit hex like "#fc618d".`,
    );
  }

  return {
    red: parseInt(cleaned.slice(0, 2), 16) / MAX_BYTE,
    green: parseInt(cleaned.slice(2, 4), 16) / MAX_BYTE,
    blue: parseInt(cleaned.slice(4, 6), 16) / MAX_BYTE,
  };
}

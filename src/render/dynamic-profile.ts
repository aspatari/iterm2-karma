/**
 * iTerm2 Dynamic Profile JSON renderer.
 *
 * Format reference: https://iterm2.com/documentation-dynamic-profiles.html
 *
 * Dynamic Profiles are property lists (JSON or XML) dropped into
 * `~/Library/Application Support/iTerm2/DynamicProfiles/`. iTerm2 watches
 * the directory and picks up new / changed files immediately — no manual
 * import step. This makes them ideal for distribution: a user can `cp` a
 * file from this repo into the directory and the profile appears in the
 * Profile menu instantly, with no clicks.
 *
 * Compared to `.itermcolors`:
 * - `.itermcolors` is a *color preset* — only the 24 color cells, applied
 *   to whatever profile the user picks via Color Presets → Import.
 * - A Dynamic Profile is a *complete profile* — all 24 colors plus identity
 *   metadata (Name, Guid, parent profile inheritance). It shows up in the
 *   Profiles menu, not under Color Presets.
 *
 * Both files in this repo use the same `Palette` source — they're two
 * representations of the same data, distributed for two different install
 * UX flows.
 *
 * No I/O, no globals; throws via `parseHex` on invalid palette hex.
 */

import type { Palette, RgbComponents } from "../palette/types.ts";
import type { AnsiColors, UiColors } from "../palette/types.ts";
import { parseHex } from "./color.ts";
import { ANSI_KEY_BY_FIELD, UI_KEY_BY_FIELD } from "./iterm-keys.ts";

/**
 * Inputs that vary per call — Guid (must be stable across builds) and
 * the optional iTerm2 parent profile name.
 */
export interface DynamicProfileOptions {
  /**
   * A globally unique identifier for this profile. Must be stable across
   * builds — changing the Guid duplicates the profile in iTerm2's settings.
   * UUID v4 (random) generated once via `uuidgen` is the recommended source.
   */
  readonly guid: string;
  /**
   * Optional parent profile name. When omitted, iTerm2 silently inherits
   * unspecified attributes from the user's actual default profile.
   *
   * IMPORTANT: do not pass `"Default"` — `"Default"` is the conceptual role,
   * not a profile name. Most users do not have a profile literally named
   * `"Default"`, so iTerm2 logs a warning ("references unknown parent name
   * Default") and falls back to the real default profile anyway. The
   * fallback is correct, but the log spam is noisy. Pass an actual profile
   * name (like the user's specific profile) only when there is a reason
   * to override the default-inheritance behaviour.
   */
  readonly parentProfileName?: string;
}

/**
 * NSColor-shaped dictionary used for every color attribute in a Dynamic
 * Profile. Keys mirror what iTerm2 emits when you "Save Profile as JSON"
 * from the Settings UI. Components are 0..1 floats; alpha is always 1.
 */
interface NsColorDict {
  readonly "Alpha Component": number;
  readonly "Blue Component": number;
  readonly "Color Space": string;
  readonly "Green Component": number;
  readonly "Red Component": number;
}

function nsColor(rgb: RgbComponents): NsColorDict {
  return {
    "Alpha Component": 1,
    "Blue Component": rgb.blue,
    "Color Space": "sRGB",
    "Green Component": rgb.green,
    "Red Component": rgb.red,
  };
}

/**
 * Render a `Palette` plus options into a complete Dynamic Profile JSON
 * document, ready for `Deno.writeTextFile`.
 *
 * The output is a single-profile property list with the 16 ANSI colors,
 * the 8 named UI colors, and the required identity keys (`Name`, `Guid`).
 * It is deterministic — given the same inputs it always produces the same
 * bytes — so committing the result to git and CI-checking idempotency
 * works the same way it does for `.itermcolors` files.
 *
 * @param palette - Source palette (e.g. `darkPalette`).
 * @param options - Per-call data: stable Guid and optional parent profile.
 * @returns A complete JSON property list with a trailing newline.
 */
export function renderDynamicProfile(
  palette: Palette,
  options: DynamicProfileOptions,
): string {
  const colorEntries: Array<[string, NsColorDict]> = [];

  for (const field of Object.keys(ANSI_KEY_BY_FIELD) as Array<keyof AnsiColors>) {
    colorEntries.push([
      ANSI_KEY_BY_FIELD[field],
      nsColor(parseHex(palette.ansi[field])),
    ]);
  }
  for (const field of Object.keys(UI_KEY_BY_FIELD) as Array<keyof UiColors>) {
    colorEntries.push([
      UI_KEY_BY_FIELD[field],
      nsColor(parseHex(palette.ui[field])),
    ]);
  }

  // Lex-sort color keys so diffs across builds are stable. Identity keys
  // are placed first (Name, Guid, parent name) — that's the conventional
  // ordering iTerm2 itself uses when you "Save Profile as JSON".
  colorEntries.sort(([a], [b]) => (a < b ? -1 : a > b ? 1 : 0));

  // Build the profile dict in insertion-order: identity → metadata → colors.
  // JSON.stringify preserves insertion order, so this is the order the user
  // sees in the file.
  //
  // `Dynamic Profile Parent Name` is emitted only when the caller explicitly
  // asks for one. Hardcoding `"Default"` here would make iTerm2 spam a
  // "references unknown parent name Default" warning for every user who
  // does not have a profile literally named "Default" (which is most of
  // them — the default-role profile usually has a different display name).
  // When the key is absent, iTerm2 inherits from the user's actual default
  // profile silently, which is the desired behaviour for a colour theme.
  const profile: Record<string, unknown> = {
    Name: palette.name,
    Guid: options.guid,
  };
  if (options.parentProfileName !== undefined) {
    profile["Dynamic Profile Parent Name"] = options.parentProfileName;
  }
  profile["Custom Command"] = "No";
  profile["Initial Text"] = "";

  for (const [key, value] of colorEntries) {
    profile[key] = value;
  }

  const document = { Profiles: [profile] };
  return JSON.stringify(document, null, 2) + "\n";
}

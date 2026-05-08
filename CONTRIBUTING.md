# Contributing to iTerm2 Karma

Thanks for considering a contribution. This is a small, focused project — the
contribution scope is correspondingly narrow, but quality bars are real.

If you're filing a bug or feature request, the [issue templates](./.github/ISSUE_TEMPLATE/)
will guide you. For code changes, read on.

## Development setup

The only prerequisite is **Deno >= 2.0**:

```bash
# macOS
brew install deno

# verify
deno --version
```

Clone, then run the full pipeline once to make sure everything is green:

```bash
git clone https://github.com/aspatari/iterm2-karma.git
cd iterm2-karma

deno task fmt:check    # formatting (CI gate)
deno task lint         # linting
deno task check        # strict type-check
deno task test         # unit tests
deno task build        # generate colors/*.itermcolors + assets/_preview-data.sh
```

A second run of `deno task build` should produce zero `git diff` — the build
is deterministic by contract. If it isn't, that's a bug.

## Project layout

See [`AGENTS.md`](./AGENTS.md) for the authoritative tour. The short version:

- **`src/palette/`** — pure data. The **only** place hex literals live.
- **`src/render/`** — pure transformations (hex → plist, hex → shell preview data).
  No I/O, no globals, no logging.
- **`build.ts`** — the only file that touches the filesystem (`Deno.writeTextFile`,
  `Deno.mkdir`, `console.log`, `Deno.exit`).

If a change asks you to touch a hex code outside `src/palette/`, that is almost
certainly the wrong file — see the architectural invariants in `AGENTS.md`.

## Common tasks

### Adding a new variant

The recommended pattern is **object-spread overrides** on top of an existing
base palette. See [`src/palette/dark-hc.ts`](./src/palette/dark-hc.ts) for the
canonical example — it imports `darkPalette` and overrides only the cells that
differ.

```ts
import { darkPalette } from "./dark.ts";
import type { Palette } from "./types.ts";

export const darkMyVariantPalette: Palette = {
  name: "Karma Dark MyVariant",
  ansi: { ...darkPalette.ansi, /* overrides */ },
  ui: { ...darkPalette.ui, /* overrides */ },
};
```

Then wire it up in [`build.ts`](./build.ts) — add a target with both the
`.itermcolors` output path and a unique `previewPrefix` for the shell preview
data file.

Finally, regenerate the screenshot using
[`assets/SCREENSHOTS.md`](./assets/SCREENSHOTS.md) and add a row to the README
variants table.

### Tweaking an existing palette

Edit the relevant `src/palette/*.ts`, run `deno task build`, then commit
both the palette source and the regenerated build artifacts (`colors/*.itermcolors`
and `assets/_preview-data.sh`). CI enforces this — uncommitted build output
fails the idempotency check.

### Updating screenshots

```bash
deno task build                                       # refresh _preview-data.sh
# Then run the freeze pipeline from assets/SCREENSHOTS.md
```

Don't try to handcraft `.webp` files in an image editor — the script-driven
pipeline is the source of truth, and it's two seconds per variant.

## Coding conventions

- **TypeScript:** strict mode, no `any`, all palette fields `readonly`.
- **Naming:** `kebab-case.ts` for files, `camelCase` for variables, `PascalCase`
  for types.
- **Hex codes:** lowercase `#rrggbb`. The repo's own ESLint of sorts —
  `src/render/color.ts` will throw at build time for anything else.
- **Errors:** at the render boundary, throw with messages that name the bad
  input (`Invalid hex color: "..."`). No silent defaults.
- **Comments:** explain *why*, not *what*. Document quirks, tradeoffs, and
  non-obvious decisions.

## Commits and PRs

- Use [Conventional Commits](https://www.conventionalcommits.org/) prefixes —
  `feat`, `fix`, `chore`, `docs`, `refactor`, `test`. Recent history is full
  of examples.
- Keep commits atomic. Don't bundle a palette tweak with a CI change.
- The PR template will ask you to confirm the verification gates (fmt, lint,
  check, test, idempotent build, plist validation). Run them locally first.
- Small, focused PRs land faster than big ones.

## What we won't merge

- New dependencies. The build is intentionally dependency-free (`deno.json`
  pulls only `@std/assert` for tests). Any addition needs strong justification.
- Hex literals scattered outside `src/palette/`. The single-source-of-truth
  invariant is non-negotiable.
- Changes to the existing `karma-dark.itermcolors` or `karma-light.itermcolors`
  byte-content without a clearly stated reason — the v1.0.0 / v1.1.0 release
  assets are public artifacts and shouldn't drift silently.
- Generated files committed without their source. If you change `_preview-data.sh`
  by hand or commit screenshots without rerunning the pipeline, CI will catch
  it (or a reviewer will).

## License

By contributing you agree your work is released under the project's
[MIT license](./LICENSE).

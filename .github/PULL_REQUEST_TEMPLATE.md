<!--
Thanks for the contribution. The checklist below mirrors the project's
quality gates so reviews can focus on substance rather than mechanics.
Delete sections that don't apply.
-->

## What & why

<!-- 1–3 sentences: what does this PR change, and what problem does it solve? -->

## Type of change

- [ ] Bug fix (existing variant renders incorrectly, build is non-deterministic, etc.)
- [ ] New variant or palette tweak
- [ ] Build / pipeline improvement
- [ ] Documentation only
- [ ] Other (describe below)

## Verification

- [ ] `deno task fmt:check` passes
- [ ] `deno task lint` passes
- [ ] `deno task check` (type-check) passes
- [ ] `deno task test` passes
- [ ] `deno task build` is idempotent: a second run produces empty `git diff colors/ assets/_preview-data.sh`
- [ ] All `colors/*.itermcolors` validate as Apple property lists (`python3 -c "import plistlib; plistlib.load(open('FILE', 'rb'))"`)
- [ ] (palette change) Updated screenshots in `assets/karma-*.webp` per [`assets/SCREENSHOTS.md`](../assets/SCREENSHOTS.md)
- [ ] (new variant) Added entry to README variants table

## Related

<!-- Closes #N. References #M. -->

## Notes for reviewer

<!-- Anything tricky — design tradeoffs, things you considered and rejected, follow-ups. -->

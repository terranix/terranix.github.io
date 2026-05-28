# Release 2.9.0

Version [2.9.0](https://github.com/terranix/terranix/releases/tag/2.9.0) is released.

This is the first terranix release in 19 months.

For that reason, the list of changes is quite long.

## What's Changed

* Fix documentation for flake-parts module by @Enzime in https://github.com/terranix/terranix/pull/111
* flake: lock `flake-parts` by @Enzime in https://github.com/terranix/terranix/pull/113
* fix: add float to sanitize by @pedorich-n in https://github.com/terranix/terranix/pull/114
* flake-module: allow customizing `extraArgs` by @Enzime in https://github.com/terranix/terranix/pull/116
* feat: Improve flake-parts module by @pedorich-n in https://github.com/terranix/terranix/pull/115
* update matrix channel name by @Lykos153 in https://github.com/terranix/terranix/pull/117
* feat: Support opentofu in flake-parts module by @terlar in https://github.com/terranix/terranix/pull/118
* doc: Become maintainer (remove "unmaintained" message) by @sshine in https://github.com/terranix/terranix/pull/122
* chore: Avoid evaluating terraform package for option docs by @roberth in https://github.com/terranix/terranix/pull/121
* fix: Ensure workspace exists in flake-parts module scripts by @terlar in https://github.com/terranix/terranix/pull/119
* refactor: separate dev inputs by @terlar in https://github.com/terranix/terranix/pull/120
* Expose configuration directly from `flake-parts` module by @typedrat in https://github.com/terranix/terranix/pull/124
* flake-module: fix wrapper for `opentofu` called `terraform` by @Enzime in https://github.com/terranix/terranix/pull/127
* flake-module: fix `devShells` failing to build by @Enzime in https://github.com/terranix/terranix/pull/125
* flake-module: rename `setDevShell` to `exportDevShells` for clarity by @Enzime in https://github.com/terranix/terranix/pull/126
* flake-parts: Fix documentation eval by @roberth in https://github.com/terranix/terranix/pull/128
* feat: ephemeral block by @vdbe in https://github.com/terranix/terranix/pull/129
* flake-parts: Separate `apps` from `packages` output by @shivaraj-bh in https://github.com/terranix/terranix/pull/133
* Fix docs generation by @mmlb in https://github.com/terranix/terranix/pull/134
* fix(flake-parts): Do not require terranix to be in root of inputs by @jan-kouba in https://github.com/terranix/terranix/pull/131
* chore: Summarize commit history in Changelog.md since 2.8.0 by @sshine in https://github.com/terranix/terranix/pull/140
* lib: expose `config` from `terranixConfiguration` by @Enzime in https://github.com/terranix/terranix/pull/144
* Expose core module evaluation by @Padraic-O-Mhuiris in https://github.com/terranix/terranix/pull/148
* feat(core/helpers): Add file helper function similar to ref/template by @sshine in https://github.com/terranix/terranix/pull/138
* chore: Add changelog check on CI by @sshine in https://github.com/terranix/terranix/pull/141
* core: add internal _meta passthru by @oneingan in https://github.com/terranix/terranix/pull/151
* docs: Update "getting started" URL in README.md to new address by @sshine in https://github.com/terranix/terranix/pull/158
* docs: update readme to improve quality by @sshine in https://github.com/terranix/terranix/pull/159
* Add `moved`/`removed` blocks to syntax by @theutz in https://github.com/terranix/terranix/pull/160
* fix(core/terraform-invocs): Use meta.mainProgram instead of hardcoded terraform binary by @sshine in https://github.com/terranix/terranix/pull/156
* chore: Update flake inputs and fix nixpkgs deprecations by @sshine in https://github.com/terranix/terranix/pull/165
* chore: Bump terranix to v2.9.0 by @sshine in https://github.com/terranix/terranix/pull/167

## Contributors

Thanks to

* [@terlar](https://github.com/terlar)
* [@vdbe](https://github.com/vdbe)

for their long-term contributions to terranix.

And thanks to the first-time contributors,

* [@sshine](https://github.com/sshine) — in [#122](https://github.com/terranix/terranix/pull/122)
* [@roberth](https://github.com/roberth) — in [#121](https://github.com/terranix/terranix/pull/121)
* [@mmlb](https://github.com/mmlb) — in [#134](https://github.com/terranix/terranix/pull/134)
* [@theutz](https://github.com/theutz) — in [#160](https://github.com/terranix/terranix/pull/160)
* [@oneingan](https://github.com/oneingan) — in [#151](https://github.com/terranix/terranix/pull/151)
* [@typedrat](https://github.com/typedrat) — in [#124](https://github.com/terranix/terranix/pull/124)
* [@Lykos153](https://github.com/Lykos153) — in [#117](https://github.com/terranix/terranix/pull/117)
* [@Enzime](https://github.com/Enzime) — in [#111](https://github.com/terranix/terranix/pull/111)
* [@pedorich-n](https://github.com/pedorich-n) — in [#114](https://github.com/terranix/terranix/pull/114)
* [@shivaraj-bh](https://github.com/shivaraj-bh) — in [#133](https://github.com/terranix/terranix/pull/133)
* [@Padraic-O-Mhuiris](https://github.com/Padraic-O-Mhuiris) — in [#148](https://github.com/terranix/terranix/pull/148)
* [@jan-kouba](https://github.com/jan-kouba) — in [#131](https://github.com/terranix/terranix/pull/131)

**Full Changelog**: https://github.com/terranix/terranix/compare/2.8.0...v2.9.0

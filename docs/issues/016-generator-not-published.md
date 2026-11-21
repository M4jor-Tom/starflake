# CI cannot regenerate the game's generated code

**Labels:** game, tooling  ·  **Status:** open  ·  **Opened:** 2026-11-21

## Problem

`game/Domain/Generated/` and `game/Design/Generated/` are written by `linkml-csharp`, which `ontology.lock` installs from `git+https://github.com/M4jor-Tom/linkml-csharp`. That repository exists on GitHub but is still empty: its two commits live only in the local checkout. So `tools/sync-ontology.sh` and `tools/sync-design.sh` only regenerate with `LINKML_CSHARP_SOURCE=../../linkml-csharp` (and `UV_NO_CACHE=1`, or uvx serves a stale build), and `just test` checks the synced spec and features but not that the generated classes match the pins.

`linkml-csharp` also still names `main` and `develop` in its CI workflow and `CONTRIBUTING.md`, while its only branch is `master`.

## Proposal

- Push `linkml-csharp`'s `master`, settle its branch names, and tag a release.
- Pin that tag in `game/ontology.lock` (`LINKML_CSHARP=...@<tag>`), which also removes the `ponytail:` note there.
- Make `tools/sync-design.sh --check` and `tools/sync-ontology.sh --content-only` regenerate into a temporary directory and fail when it differs from the committed classes.

## Done when

- `just test` fails in CI when `Domain/Generated/` or `Design/Generated/` does not match its pin.

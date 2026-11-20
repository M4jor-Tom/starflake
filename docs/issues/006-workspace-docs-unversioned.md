# Workspace docs are not versioned

**Labels:** workspace, chore  ·  **Status:** open  ·  **Opened:** 2026-11-20

## Problem

`/home/theta/repos/starflake/docs/` (design documents, plans and these issues) sits outside the three git repositories, so it has no history and no backup.

## Proposal

Either make the workspace root a small repository that holds `docs/` and ignores `game/`, `ontology/` and `design/`, or move these files into GitHub issues on the relevant repositories.

## Done when

- Every file under `docs/` is tracked somewhere.

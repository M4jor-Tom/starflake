# The ontology contains game-development concepts

**Labels:** ontology, refactor, breaking  ·  **Status:** open  ·  **Opened:** 2026-11-20

## Problem

The ontology must describe the universe with no game-development context. It currently defines `GameSession`, `HostingMode`, `Player`, `ContentPack`, `SpawnRegion` and its subclasses, which an inhabitant of the universe would not recognise.

## Proposal

Decide for each class whether it moves to the design schema, gets an in-universe reformulation, or stays. This is a breaking ontology release; `game/Domain/Generated/` and `content/core.json` follow.

## Done when

- Every ontology class passes the inhabitant test, or has a recorded reason to stay.

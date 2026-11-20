# Make game/ consume the design repository

**Labels:** game, enhancement  ·  **Status:** open  ·  **Opened:** 2026-11-20

## Problem

`design/` specifies controls, tuning, HUD, camera and behaviour, but `game/` still hard-codes all of it. Nothing checks that the game matches the spec.

## Proposal

- Add `design.lock` to `game/`, pinning a design release, with a sync script like `tools/sync-ontology.sh`.
- Load `controls.yaml` to register the Godot `InputMap`, replacing `Game/Controls.cs`.
- Load `tuning.yaml`, `hud.yaml` and `camera.yaml` in place of the constants in `LootNode.cs`, `EnemyShipNode.cs`, `Flight.cs`, `Rules.cs`, `Hud.cs` and `ChaseCamera.cs`.
- Run `features/*.feature` with Reqnroll as acceptance tests, replacing the checks in `Game/SelfTest.cs`.

## Done when

- No value present in `design/spec/` is also a literal in `game/`.
- Every scenario runs in the game test suite.

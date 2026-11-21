# Make game/ consume the design repository

**Labels:** game, enhancement  ·  **Status:** open  ·  **Opened:** 2026-11-20

## Problem

`design/` specifies controls, tuning, HUD, camera and behaviour, but `game/` still hard-codes all of it. Nothing checks that the game matches the spec.

## Proposal

- Bump the ontology pin to v0.3.0: regenerate `Domain/Generated/`, migrate `content/core.json` to a `Galaxy` root, and rename in the code (`Pilot`, `PilotShip`, `Raider*`, `FuelPod`, `Region.count`, `fuel_yield`). Scoop radius, tractor range and speed now come from the ship class, and keep distance from the raider type.
- Add `design.lock` to `game/`, pinning design v0.3.0, with a sync script like `tools/sync-ontology.sh`.
- Load `controls.yaml` to register the Godot `InputMap`, replacing `Game/Controls.cs`.
- Load `tuning.yaml`, `hud.yaml` and `camera.yaml` in place of the constants in `LootNode.cs`, `EnemyShipNode.cs`, `Flight.cs`, `Rules.cs`, `Hud.cs` and `ChaseCamera.cs`.
- Load `session.yaml` for the hosting mode, starting ship class and starting system, and fail at startup if either id is missing from the galaxy.
- Load `menus.yaml` and implement the pause menu (`features/pause.feature`).
- Run `features/*.feature` with Reqnroll as acceptance tests, replacing the checks in `Game/SelfTest.cs`.

## Done when

- No value present in `design/spec/` is also a literal in `game/`.
- Every scenario runs in the game test suite.

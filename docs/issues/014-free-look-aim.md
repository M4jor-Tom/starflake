# Free-look aim: the ship follows the camera

**Labels:** design, game, ontology, enhancement  ·  **Status:** open  ·  **Opened:** 2026-11-21

## Problem

`CameraAim` has one value, `parallel_to_nose`: the camera looks where the ship points. A second mode is wanted in which the player aims the camera freely and the ship tries to follow.

## Proposal

- Add a `CameraAim` value in which the camera turns at the player's pace, for example 180 degrees in one second, regardless of the ship.
- The ship then turns toward the camera's aim at its own ship class turn rate, taking the time it needs.
- The ship's guns rotate to shoot where the camera aims while the hull catches up. This needs gun traverse in the ontology (how far and how fast a weapon mount turns) and changes the Combat feature, where projectiles leave along the nose.
- Depends on issue 010 for mouse capture.

## Done when

- `design/` specifies the mode and the ontology models gun traverse.
- The game implements both aim modes.

# Design decisions the first spec does not make

**Labels:** design, enhancement  ·  **Status:** open  ·  **Opened:** 2026-11-20

## Problem

The first version of `design/` records only what the prototype does. These questions have no answer yet:

- Gamepad bindings (and the `InputDevice` values they need).
- A win or end condition.
- Pause, menus and settings.
- Mouse capture and mouse look.

## Also to review

- Whether `loot.pickup_radius`, `loot.magnet_radius`, `loot.magnet_speed` and `enemy_ai.keep_distance` are facts of the universe that belong in the ontology (a ship fuel scoop, an enemy archetype) instead of tuning.
- `Binding.device` is derivable from which of `key` or `button` is set; `CameraAim` has a single value.

## Done when

- Each item is specified in `design/` or explicitly rejected.

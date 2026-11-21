# Meta Quest support

**Labels:** design, game, enhancement  ·  **Status:** open  ·  **Opened:** 2026-11-21

## Problem

The game runs on a flat screen only. Playing in a Meta Quest headset is wanted one day. `Binding.device` is kept in the controls schema so that headset controllers can be added as devices.

## Proposal

- Decide the target (standalone build or PC link) and check Godot's OpenXR support for C# projects on it.
- Add the headset controllers to `InputDevice` and specify their bindings.
- Specify the camera and HUD in a headset; issue 014 (free-look aim) is the natural head-tracking mode.

## Done when

- The game is playable in a Meta Quest headset, as specified in `design/`.

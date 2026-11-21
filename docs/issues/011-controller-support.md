# Controller support

**Labels:** design, game, enhancement  ·  **Status:** open  ·  **Opened:** 2026-11-21

## Problem

The game takes keyboard and mouse input only. `Binding.device` and the `InputDevice` enum are kept in the controls schema for this.

## Proposal

- Add a gamepad to `InputDevice`, with the button and axis enums it needs, and a binding per action in `design/spec/controls.yaml`.
- Decide how `{key:action}` placeholders read when a controller is in use.

## Done when

- Every action can be triggered from a controller, as specified in `design/`.

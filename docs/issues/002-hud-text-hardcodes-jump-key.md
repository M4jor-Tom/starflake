# HUD text hard-codes the jump key

**Labels:** design, bug  ·  **Status:** open  ·  **Opened:** 2026-11-20

## Problem

The readout `jump_route_ready` says "READY, press J" and `controls_help` lists every key. The same keys are bound in `spec/controls.yaml`, so a rebinding leaves the HUD text wrong. Both were copied as they are in the code.

## Proposal

Add a placeholder that resolves to the binding of an action (for example `{key:jump}`), and generate `controls_help` from the action list.

## Done when

- No key name appears in `spec/hud.yaml`.

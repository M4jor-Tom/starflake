# PC controls should use the mouse

**Labels:** design, game, enhancement  ·  **Status:** open  ·  **Opened:** 2026-11-21

## Problem

The ship is flown with the keyboard only; the mouse just fires. Decided on 2026-11-21: the mouse is captured during flight and steers the ship. No design exists for it yet.

## Proposal

- Specify in `design/` how the mouse steers (pitch and yaw), its sensitivity, and which keys keep or lose their role.
- Capture the mouse during flight and release it while a menu is open.
- Issue 014 (free-look aim) changes what the mouse steers; design the two together or in that order.

## Done when

- `design/` specifies mouse steering and capture, and the game implements it.

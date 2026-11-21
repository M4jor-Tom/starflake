# Camera scenario 1 cannot hold for a moving ship

**Labels:** design, bug  ·  **Status:** open  ·  **Opened:** 2026-11-21

## Problem

`features/camera.feature`, first scenario: "Given a pilot ship flying steadily, Then the camera is at the `camera.offset` in the ship's own frame". The second scenario makes the camera close the gap to that position at the `camera.follow_rate`. A camera that follows this way trails a ship moving at constant velocity by about its speed divided by the follow rate (20 metres at 120 metres per second and a rate of 6), so the two scenarios contradict each other for any ship that moves.

`game/` binds "flying steadily" as "at rest and not turning", the only reading under which both hold.

## Proposal

Reword the Given so it says what is meant, for example "a pilot ship at rest", or state the trailing distance of a ship at constant velocity in a Then.

## Done when

- The first camera scenario holds for the ship it describes without a tolerance chosen by the game.

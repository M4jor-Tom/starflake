# Positive-only values accept zero

**Labels:** design, schema  ·  **Status:** open  ·  **Opened:** 2026-11-20

## Problem

The design says `enemy_ai.steering_gain` must be greater than zero. LinkML has no exclusive minimum, so the schema only enforces "at least zero". The same holds for `camera.fov_degrees` and `camera.follow_rate`, where zero makes no sense either.

## Proposal

Add a pytest check for strictly positive slots, or a LinkML annotation that the test reads.

## Done when

- A zero in any of these slots fails `just test`.

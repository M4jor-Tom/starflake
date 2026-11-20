# Minor findings from the first design review

**Labels:** design, test  ·  **Status:** open  ·  **Opened:** 2026-11-20

## Problem

The whole-branch review of `design/` `feat/initial-spec` left these minor points unfixed:

- **Unresolved references are tested indirectly.** `test_unresolved_reference_is_detected` checks that bad names are absent from `known_references()`; it does not run a feature containing them through the real check.
- **Ids are not checked across files.** An action and a HUD readout could share an id, although features refer to both in one namespace. There is no clash today.
- **Reference kind is not checked.** `the player presses "welcome"` (a message id used as an action) would pass.
- **"bolt" vs "projectile".** `combat.feature` says "bolt"; the ontology's `WeaponType` says "projectile". Pick one term.
- **Boundaries are open.** The game uses strict `<` for detection range, keep distance, pickup radius and magnet radius, and an enemy with the player dead astern yaws right. The features say "within" and "farther than" without stating the equal case.

See also `003-exclusive-minimum.md` (`steering_gain` accepts 0), confirmed by the same review.

## Done when

- Each point is fixed in `design/` or explicitly rejected.

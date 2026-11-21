# The game breaks twelve default analyzer rules

**Labels:** game, refactor  ·  **Status:** open  ·  **Opened:** 2026-11-21

## Problem

`game/` now builds with SonarAnalyzer.CSharp. The size and complexity limits pass, but twelve other default rules report 32 findings in code written before the gate. They are switched off in `game/.editorconfig`:

| Rule | Findings | What it reports |
|---|---|---|
| S1104 | 13 | Public fields (`EntityNode`, `PlayerShipNode`, `ProjectileNode`, `StarSystemView`, `ChaseCamera`) |
| S1121 | 4 | Assignments inside expressions (`Main.cs`) |
| S1244 | 3 | Exact floating-point equality (`SelfTest.cs`) |
| S2245 | 3 | `System.Random` is not cryptographically strong (`AsteroidNode.cs`, `SelfTest.cs`) |
| S8969 | 2 | Unneeded null-forgiving operator |
| S112, S927, S1075, S3168, S3267, S3358, S4143 | 1 each | See the build output with the line removed |

## Proposal

Fix the code rule by rule and delete the matching line of `.editorconfig`. S2245 does not apply to a game's spawn randomness: keep it off, with that reason beside it. Issue 001 rewrites several of these files, so do this after it or with it.

## Done when

- `.editorconfig` switches off no rule without a stated reason.

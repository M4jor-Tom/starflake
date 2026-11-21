# Saving and choosing a save

**Labels:** design, game, ontology, enhancement  ·  **Status:** open  ·  **Opened:** 2026-11-21

## Problem

Nothing is saved: quitting loses the galaxy state. The pause menu (`design/spec/menus.yaml`) has only Resume and Quit.

## Proposal

- Persist a `GalaxyState` of the ontology as the save file.
- Add a Save button to the pause menu.
- Add a menu on startup to pick a save file or start a new one.
- Decide what Quit does with unsaved progress.

## Done when

- A session can be saved, quit, picked again on startup and resumed where it was.
- Each of these is a scenario in `design/features/`.

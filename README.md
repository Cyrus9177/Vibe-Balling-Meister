# Vibe-Balling-Meister

Vibe-Balling-Meister is a GitHub Pages repository for a web-playable Godot game and its source project. The repository is organized so visitors can open the public homepage, launch the exported browser build, and inspect the editable Godot project from the same place.

## Live Entry Points

- Homepage: [index.html](index.html)
- Playable web build: [build/ball-meister.html](build/ball-meister.html)
- Godot source project: [dev/ball-meister/project.godot](dev/ball-meister/project.godot)
- Legacy portal page: [Game portal/template/index.html](Game%20portal/template/index.html)

## Repository Layout

- `index.html` is the root GitHub Pages homepage.
- `build/` contains the exported browser version of the game and its runtime files.
- `dev/ball-meister/` contains the Godot 4 project used to develop and export the game.
- `Game portal/` contains the older portal presentation layer and supporting front-end files.

## What Each Folder Is For

### `build/`

This folder holds the published web build of the game. Open [build/ball-meister.html](build/ball-meister.html) in a browser to play the exported version.

### `dev/ball-meister/`

This is the source project. It includes scenes, scripts, resources, and export settings for the game. Open [dev/ball-meister/project.godot](dev/ball-meister/project.godot) in Godot to edit the project.

### `Game portal/`

This folder contains a separate portal-style front end that documents and links into the game. It is part of the repository history and should be kept intact.

## Development Notes

- The project is built with Godot 4.
- The exported web build is the version intended for browser play.
- If you make gameplay changes in `dev/ball-meister/`, re-export the web build into `build/`.
- Keep the root homepage focused on documentation and navigation so GitHub Pages users can find the playable build quickly.

## Suggested Workflow

1. Open the Godot project from [dev/ball-meister/project.godot](dev/ball-meister/project.godot).
2. Edit scenes and scripts under `dev/ball-meister/scenes/` and `dev/ball-meister/scripts/`.
3. Re-export the project for web use.
4. Verify the browser build through [build/ball-meister.html](build/ball-meister.html).
5. Update [index.html](index.html) or this README if the project structure changes.

## Notes

- Do not remove the existing `build/` or `dev/` folders; they are the core project assets.
- The root `index.html` is the public landing page for GitHub Pages.
- The `Game portal/` folder is separate from the exported game build and serves as a documentation-style portal layer.
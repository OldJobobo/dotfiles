# Repository Guidelines

## Project Structure & Module Organization
This repository is a GNU Stow-based dotfiles setup. Each top-level directory is a Stow package that mirrors paths under `$HOME`.

- Package examples: `hypr/`, `waybar/`, `nvim/`, `fish/`, `starship/`, `xdg/`
- Internal layout pattern: `<package>/.config/...` (for example `waybar/.config/waybar/config.jsonc`)
- Helper scripts:
  - `restow`: re-stows all default packages (or selected packages)
  - `bootstrap.sh`: runs `restow` and ensures `~/.config/starship.toml` symlink setup

## Build, Test, and Development Commands
There is no compile/build step; validate by stowing and checking links.

- `./restow`
Applies all default packages with `stow -Rv`.
- `./restow -n`
Dry-run to preview changes without writing links.
- `./restow --adopt <pkg>`
Adopts existing target files into a package before linking (review diffs after).
- `./bootstrap.sh`
Full setup: stow packages and align Starship symlink.
- `stow -Dv <pkg>`
Unstow a package cleanly.

## Coding Style & Naming Conventions
- Shell scripts use Bash with strict mode: `set -euo pipefail`.
- Keep scripts POSIX-leaning unless Bash features are needed.
- Use 2-space indentation in shell `case`/`if` blocks (match existing scripts).
- Name package directories after the tool/app (`waybar`, `hypr`, `lazygit`).
- Preserve XDG-style paths (`.config/...`) inside package directories.

## Testing Guidelines
No formal test framework is configured. Use operational checks:

1. Run `./restow -n` before changes.
2. Apply with `./restow` or `./restow <pkg>`.
3. Verify links, e.g. `ls -l ~/.config/waybar`.
4. For bootstrap changes, run `./bootstrap.sh -n` then `./bootstrap.sh`.

## Commit & Pull Request Guidelines
- Commit style in history is short, imperative, and scoped (for example: `Fix monitor fallback and include hypr/waybar in restow`).
- Keep one logical change per commit.
- PRs should include:
  - what changed and why
  - affected packages
  - validation commands run (`./restow -n`, `./restow`, etc.)
  - screenshots for visible UI changes (Hyprland/Waybar themes)

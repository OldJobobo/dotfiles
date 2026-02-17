#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

if ! command -v stow >/dev/null 2>&1; then
  echo "Error: 'stow' is not installed. Install GNU Stow first." >&2
  exit 1
fi

dry_run=0
adopt=0
while [[ $# -gt 0 ]]; do
  case "$1" in
    -n|--dry-run)
      dry_run=1
      shift
      ;;
    --adopt)
      adopt=1
      shift
      ;;
    -*)
      echo "Unknown option: $1" >&2
      exit 1
      ;;
    *)
      echo "Unexpected argument: $1" >&2
      exit 1
      ;;
  esac
done

restow_args=()
if [[ $dry_run -eq 1 ]]; then
  restow_args+=("--dry-run")
fi
if [[ $adopt -eq 1 ]]; then
  restow_args+=("--adopt")
fi

./restow "${restow_args[@]}"

config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
starship_source="$config_home/starship.dhh"
starship_target="$config_home/starship.toml"

if [[ $dry_run -eq 1 ]]; then
  echo "[dry-run] would ensure $starship_target -> $starship_source"
  exit 0
fi

if [[ ! -e "$starship_source" && ! -L "$starship_source" ]]; then
  echo "Warning: $starship_source not found; skipping starship symlink setup."
  exit 0
fi

mkdir -p "$config_home"

if [[ -L "$starship_target" ]]; then
  current_target="$(readlink "$starship_target")"
  if [[ "$current_target" == "$starship_source" ]]; then
    echo "starship symlink already correct."
    exit 0
  fi
  rm -f "$starship_target"
elif [[ -e "$starship_target" ]]; then
  backup_path="${starship_target}.pre-bootstrap-$(date +%Y%m%d-%H%M%S)"
  mv "$starship_target" "$backup_path"
  echo "Backed up existing $starship_target to $backup_path"
fi

ln -s "$starship_source" "$starship_target"
echo "Linked $starship_target -> $starship_source"

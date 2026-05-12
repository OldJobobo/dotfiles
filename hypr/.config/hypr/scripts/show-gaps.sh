#!/usr/bin/env bash

if ! command -v hyprctl >/dev/null 2>&1; then
  echo "hyprctl is required (Hyprland tools not found)" >&2
  exit 1
fi

if ! command -v wl-copy >/dev/null 2>&1; then
  echo "wl-copy is required (wl-clipboard not found)" >&2
  exit 1
fi

if ! hyprctl -j monitors >/dev/null 2>&1; then
  echo "hyprctl is not responding (is Hyprland running?)" >&2
  exit 1
fi

read_option() {
  local opt="$1"
  local out

  out=$(hyprctl -j getoption "$opt" 2>/dev/null | tr '\n' ' ') || return 1
  [[ -z "$out" ]] && return 1

  if [[ $out =~ \"custom\"[[:space:]]*:[[:space:]]*\"([^\"]+)\" ]]; then
    printf '%s\n' "${BASH_REMATCH[1]}"
    return 0
  fi

  if [[ $out =~ \"int\"[[:space:]]*:[[:space:]]*(-?[0-9]+) ]]; then
    printf '%s\n' "${BASH_REMATCH[1]}"
    return 0
  fi

  return 1
}

normalize_value() {
  local raw="$1"
  local first=""
  local item=""

  for item in $raw; do
    if [[ -z "$first" ]]; then
      first="$item"
      continue
    fi

    if [[ "$item" != "$first" ]]; then
      printf '%s\n' "$raw"
      return 0
    fi
  done

  printf '%s\n' "${first:-$raw}"
}

gaps_in="$(read_option general:gaps_in)"
gaps_out="$(read_option general:gaps_out)"

if [[ -z "$gaps_in" || -z "$gaps_out" ]]; then
  echo "Failed to read live gaps from Hyprland" >&2
  exit 1
fi

gaps_in="$(normalize_value "$gaps_in")"
gaps_out="$(normalize_value "$gaps_out")"

msg="gaps_in=$gaps_in gaps_out=$gaps_out"
printf '%s' "$msg" | wl-copy

if command -v notify-send >/dev/null 2>&1; then
  notify-send -a Hyprland "Window Gaps" "$msg copied to clipboard"
fi

#!/usr/bin/env bash
set -euo pipefail

SHADER_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/shaders"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/hypr"
INDEX_FILE="$STATE_DIR/screen-shader-index"
ENABLED_FILE="$STATE_DIR/screen-shader-enabled"
PERF_FILE="$STATE_DIR/screen-shader-perf"
PERF_ORIG_BLUR_FILE="$STATE_DIR/screen-shader-orig-blur"
PERF_ORIG_SHADOW_FILE="$STATE_DIR/screen-shader-orig-shadow"

notify() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send -a Hyprland "Screen Shader" "$1"
  fi
}

require_hyprctl() {
  if ! command -v hyprctl >/dev/null 2>&1; then
    echo "hyprctl is required (Hyprland tools not found)" >&2
    exit 1
  fi

  if ! hyprctl -j monitors >/dev/null 2>&1; then
    echo "hyprctl is not responding (is Hyprland running?)" >&2
    exit 1
  fi
}

read_option_bool() {
  local opt default out
  opt="$1"
  default="$2"

  out="$(hyprctl -j getoption "$opt" 2>/dev/null | tr '\n' ' ' || true)"

  if [[ $out =~ "int"[[:space:]]*:[[:space:]]*(-?[0-9]+) ]]; then
    if [ "${BASH_REMATCH[1]}" -eq 0 ]; then
      printf '0\n'
    else
      printf '1\n'
    fi
    return 0
  fi

  out="$(hyprctl getoption "$opt" 2>/dev/null || true)"
  if echo "$out" | rg -q "int:[[:space:]]*0"; then
    printf '0\n'
    return 0
  fi
  if echo "$out" | rg -q "int:[[:space:]]*[1-9]"; then
    printf '1\n'
    return 0
  fi

  printf '%s\n' "$default"
}

set_damage_tracking_on() {
  # Needed for many screen shaders (especially ones using the time uniform).
  hyprctl keyword debug:damage_tracking 0 >/dev/null
}

set_damage_tracking_off() {
  # Restore Hyprland default behavior for lower GPU usage when shader is disabled.
  hyprctl keyword debug:damage_tracking 2 >/dev/null
}

save_perf_originals_if_needed() {
  if [ ! -f "$PERF_ORIG_BLUR_FILE" ]; then
    read_option_bool "decoration:blur:enabled" 1 > "$PERF_ORIG_BLUR_FILE"
  fi

  if [ ! -f "$PERF_ORIG_SHADOW_FILE" ]; then
    read_option_bool "decoration:shadow:enabled" 1 > "$PERF_ORIG_SHADOW_FILE"
  fi
}

enable_perf_tweaks() {
  save_perf_originals_if_needed
  hyprctl keyword decoration:blur:enabled false >/dev/null
  hyprctl keyword decoration:shadow:enabled false >/dev/null
}

restore_perf_tweaks() {
  local blur shadow

  if [ -f "$PERF_ORIG_BLUR_FILE" ]; then
    blur="$(cat "$PERF_ORIG_BLUR_FILE")"
  else
    blur=1
  fi

  if [ -f "$PERF_ORIG_SHADOW_FILE" ]; then
    shadow="$(cat "$PERF_ORIG_SHADOW_FILE")"
  else
    shadow=1
  fi

  if [ "$blur" = "1" ]; then
    hyprctl keyword decoration:blur:enabled true >/dev/null
  else
    hyprctl keyword decoration:blur:enabled false >/dev/null
  fi

  if [ "$shadow" = "1" ]; then
    hyprctl keyword decoration:shadow:enabled true >/dev/null
  else
    hyprctl keyword decoration:shadow:enabled false >/dev/null
  fi
}

load_shaders() {
  local f base
  local -a list=()

  shopt -s nullglob
  for f in "$SHADER_DIR"/*.glsl; do
    base="${f##*/}"
    case "$base" in
      common.glsl)
        continue
        ;;
    esac
    list+=("$f")
  done
  shopt -u nullglob

  if [ "${#list[@]}" -eq 0 ]; then
    echo "No shaders found in $SHADER_DIR" >&2
    exit 1
  fi

  mapfile -t SHADERS < <(printf '%s\n' "${list[@]}" | sort)
}

load_state() {
  mkdir -p "$STATE_DIR"

  if [ -f "$INDEX_FILE" ]; then
    INDEX="$(cat "$INDEX_FILE")"
  else
    INDEX=0
  fi

  if [ -f "$ENABLED_FILE" ]; then
    ENABLED="$(cat "$ENABLED_FILE")"
  else
    ENABLED=1
  fi

  if [ -f "$PERF_FILE" ]; then
    PERF="$(cat "$PERF_FILE")"
  else
    PERF=0
  fi

  if ! [[ "$INDEX" =~ ^[0-9]+$ ]]; then
    INDEX=0
  fi

  if ! [[ "$ENABLED" =~ ^[01]$ ]]; then
    ENABLED=1
  fi

  if ! [[ "$PERF" =~ ^[01]$ ]]; then
    PERF=0
  fi
}

save_state() {
  printf '%s\n' "$INDEX" > "$INDEX_FILE"
  printf '%s\n' "$ENABLED" > "$ENABLED_FILE"
  printf '%s\n' "$PERF" > "$PERF_FILE"
}

current_shader() {
  local count idx
  count="${#SHADERS[@]}"
  idx=$(( INDEX % count ))
  printf '%s\n' "${SHADERS[$idx]}"
}

apply_shader() {
  local shader name
  shader="$1"
  name="${shader##*/}"

  set_damage_tracking_on
  if [ "$PERF" = "1" ]; then
    enable_perf_tweaks
  fi

  hyprctl keyword decoration:screen_shader "$shader" >/dev/null

  if [ "$PERF" = "1" ]; then
    notify "Enabled: $name (perf mode)"
  else
    notify "Enabled: $name"
  fi

  echo "enabled:$name"
}

disable_shader() {
  hyprctl keyword decoration:screen_shader '[[EMPTY]]' >/dev/null
  set_damage_tracking_off

  if [ "$PERF" = "1" ]; then
    restore_perf_tweaks
  fi

  notify "Disabled"
  echo "disabled"
}

cmd_next() {
  local count shader
  count="${#SHADERS[@]}"
  INDEX=$(( (INDEX + 1) % count ))
  ENABLED=1
  save_state
  shader="$(current_shader)"
  apply_shader "$shader"
}

cmd_prev() {
  local count shader
  count="${#SHADERS[@]}"
  INDEX=$(( (INDEX + count - 1) % count ))
  ENABLED=1
  save_state
  shader="$(current_shader)"
  apply_shader "$shader"
}

cmd_on() {
  local shader
  ENABLED=1
  save_state
  shader="$(current_shader)"
  apply_shader "$shader"
}

cmd_off() {
  ENABLED=0
  save_state
  disable_shader
}

cmd_toggle() {
  if [ "$ENABLED" = "1" ]; then
    cmd_off
  else
    cmd_on
  fi
}

cmd_perf() {
  local perf_cmd
  perf_cmd="${1:-toggle}"

  case "$perf_cmd" in
    on)
      PERF=1
      save_state
      if [ "$ENABLED" = "1" ]; then
        enable_perf_tweaks
      fi
      notify "Perf mode: ON"
      echo "perf:on"
      ;;
    off)
      PERF=0
      save_state
      if [ "$ENABLED" = "1" ]; then
        restore_perf_tweaks
      fi
      notify "Perf mode: OFF"
      echo "perf:off"
      ;;
    toggle)
      if [ "$PERF" = "1" ]; then
        cmd_perf off
      else
        cmd_perf on
      fi
      ;;
    status)
      if [ "$PERF" = "1" ]; then
        echo "perf:on"
      else
        echo "perf:off"
      fi
      ;;
    *)
      echo "Usage: $0 perf [on|off|toggle|status]" >&2
      exit 1
      ;;
  esac
}

cmd_status() {
  local shader name state perf_state
  shader="$(current_shader)"
  name="${shader##*/}"

  if [ "$ENABLED" = "1" ]; then
    state="on"
  else
    state="off"
  fi

  if [ "$PERF" = "1" ]; then
    perf_state="on"
  else
    perf_state="off"
  fi

  printf 'state=%s perf=%s index=%s shader=%s\n' "$state" "$perf_state" "$INDEX" "$name"
}

main() {
  local cmd
  cmd="${1:-next}"

  require_hyprctl
  load_shaders
  load_state

  case "$cmd" in
    next)
      cmd_next
      ;;
    prev)
      cmd_prev
      ;;
    toggle)
      cmd_toggle
      ;;
    on)
      cmd_on
      ;;
    off)
      cmd_off
      ;;
    perf)
      cmd_perf "${2:-toggle}"
      ;;
    status)
      cmd_status
      ;;
    *)
      echo "Usage: $0 [next|prev|toggle|on|off|perf|status]" >&2
      echo "       $0 perf [on|off|toggle|status]" >&2
      exit 1
      ;;
  esac
}

main "$@"

#!/usr/bin/env bash
set -euo pipefail

direction="${1:-}"
if [[ "$direction" != "up" && "$direction" != "down" ]]; then
  exit 0
fi

HYPRCTL_INSTANCE=()
SCROLL_ORIENTATION="auto"
HYPR_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/hypr/hyprland.conf"

init_hypr_instance() {
  local out sig_path sig dir

  out="$(hyprctl activeworkspace -j 2>/dev/null || true)"
  if jq -e . >/dev/null 2>&1 <<<"$out"; then
    HYPRCTL_INSTANCE=()
    return 0
  fi

  dir="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/hypr"
  if [[ -d "$dir" ]]; then
    for sig_path in "$dir"/*; do
      [[ -e "$sig_path" ]] || continue
      sig="$(basename "$sig_path")"
      out="$(hyprctl -i "$sig" activeworkspace -j 2>/dev/null || true)"
      if jq -e . >/dev/null 2>&1 <<<"$out"; then
        HYPRCTL_INSTANCE=(-i "$sig")
        return 0
      fi
    done
  fi

  return 1
}

hypr_json() {
  hyprctl "${HYPRCTL_INSTANCE[@]}" "$1" -j 2>/dev/null || true
}

hypr_dispatch() {
  hyprctl "${HYPRCTL_INSTANCE[@]}" dispatch "$@" >/dev/null 2>&1 || true
}

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

normalize_workspace_name() {
  local value
  value="$(trim "$1")"
  value="${value#name:}"
  printf '%s' "$value"
}

detect_scroll_orientation() {
  local target_id target_name line body part workspace_token direction
  local -a parts

  [[ -r "$HYPR_CONFIG" ]] || return 1

  target_id="$(trim "$ws_id")"
  target_name="$(normalize_workspace_name "$ws_name")"

  while IFS= read -r line; do
    line="${line%%#*}"
    [[ "$line" =~ ^[[:space:]]*workspace[[:space:]]*= ]] || continue
    [[ "$line" == *"layout:scrolling"* ]] || continue

    body="${line#*=}"
    IFS=',' read -r -a parts <<<"$body"

    workspace_token=""
    direction=""
    for part in "${parts[@]}"; do
      part="$(trim "$part")"
      case "$part" in
        name:*)
          workspace_token="$(normalize_workspace_name "$part")"
          ;;
        layoutopt:direction:*)
          direction="${part#layoutopt:direction:}"
          ;;
      esac
    done

    [[ -n "$workspace_token" && -n "$direction" ]] || continue
    if [[ "$workspace_token" != "$target_id" && "$workspace_token" != "$target_name" ]]; then
      continue
    fi

    case "$direction" in
      left|right)
        printf 'horizontal\n'
        return 0
        ;;
      up|down)
        printf 'vertical\n'
        return 0
        ;;
    esac
  done < "$HYPR_CONFIG"

  return 1
}

cycle_windows() {
  if [[ "$direction" == "down" ]]; then
    hypr_dispatch cyclenext
  else
    hypr_dispatch cyclenext prev
  fi
}

focus_scrolling_nowrap() {
  local active_addr clients_json idx count next_idx target_addr
  local row x y addr min_x max_x min_y max_y
  local -a client_rows ordered_addrs

  active_addr="$(hypr_json activewindow | jq -r '.address // empty')"
  clients_json="$(hypr_json clients)"
  if [[ -z "$active_addr" || -z "$clients_json" ]]; then
    # If state is unavailable, prefer reliable window cycling over layout scroll focus.
    cycle_windows
    return
  fi

  mapfile -t client_rows < <(
    jq -r --argjson ws "$ws_id" '
      .[]
      | select(.workspace.id == $ws)
      | select((.floating // false) | not)
      | select((.hidden // false) | not)
      | select((.mapped // true) == true)
      | "\(.at[0])\t\(.at[1])\t\(.address)"
    ' <<<"$clients_json" \
  )

  count="${#client_rows[@]}"
  if (( count < 2 )); then
    return
  fi

  if [[ "$SCROLL_ORIENTATION" != "horizontal" && "$SCROLL_ORIENTATION" != "vertical" ]]; then
    min_x=
    max_x=
    min_y=
    max_y=

    for row in "${client_rows[@]}"; do
      IFS=$'\t' read -r x y addr <<<"$row"

      [[ -n "$min_x" ]] || min_x="$x"
      [[ -n "$max_x" ]] || max_x="$x"
      [[ -n "$min_y" ]] || min_y="$y"
      [[ -n "$max_y" ]] || max_y="$y"

      (( x < min_x )) && min_x="$x"
      (( x > max_x )) && max_x="$x"
      (( y < min_y )) && min_y="$y"
      (( y > max_y )) && max_y="$y"
    done

    if (( (max_x - min_x) >= (max_y - min_y) )); then
      SCROLL_ORIENTATION="horizontal"
    else
      SCROLL_ORIENTATION="vertical"
    fi
  fi

  mapfile -t ordered_addrs < <(
    printf '%s\n' "${client_rows[@]}" \
    | if [[ "$SCROLL_ORIENTATION" == "horizontal" ]]; then sort -n -k1,1 -k2,2; else sort -n -k2,2 -k1,1; fi \
    | awk -F '\t' '{print $3}'
  )

  idx=-1
  for i in "${!ordered_addrs[@]}"; do
    if [[ "${ordered_addrs[$i]}" == "$active_addr" ]]; then
      idx="$i"
      break
    fi
  done

  if (( idx < 0 )); then
    # Unknown active tile in ordering: fall back to cycling to avoid visual bounce.
    cycle_windows
    return
  fi

  if [[ "$direction" == "down" ]]; then
    (( idx == 0 )) && return
    next_idx=$((idx - 1))
  else
    (( idx == count - 1 )) && return
    next_idx=$((idx + 1))
  fi

  target_addr="${ordered_addrs[$next_idx]:-}"
  [[ -n "$target_addr" ]] || return

  hypr_dispatch focuswindow "address:$target_addr"
}

if ! init_hypr_instance; then
  cycle_windows
  exit 0
fi

ws_json="$(hypr_json activeworkspace)"
if ! jq -e . >/dev/null 2>&1 <<<"$ws_json"; then
  cycle_windows
  exit 0
fi

layout="$(jq -r '.tiledLayout // empty' <<<"$ws_json")"
ws_id="$(jq -r '.id // empty' <<<"$ws_json")"
ws_name="$(jq -r '.name // empty' <<<"$ws_json")"

# On scrolling workspaces, use no-wrap directional focus.
if [[ "$layout" == scrolling* ]]; then
  SCROLL_ORIENTATION="$(detect_scroll_orientation || printf 'auto\n')"
  focus_scrolling_nowrap
else
  cycle_windows
fi

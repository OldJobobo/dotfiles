#!/usr/bin/env bash
set -euo pipefail

direction="${1:-}"
if [[ "$direction" != "up" && "$direction" != "down" ]]; then
  exit 0
fi

HYPRCTL_INSTANCE=()
SCROLL_ORIENTATION="vertical"

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

cycle_windows() {
  if [[ "$direction" == "down" ]]; then
    hypr_dispatch cyclenext
  else
    hypr_dispatch cyclenext prev
  fi
}

focus_scrolling_nowrap() {
  local active_addr clients_json idx count target
  local -a ordered_addrs

  active_addr="$(hypr_json activewindow | jq -r '.address // empty')"
  clients_json="$(hypr_json clients)"
  if [[ -z "$active_addr" || -z "$clients_json" ]]; then
    # Fallback to simple scrolling behavior.
    if [[ "$SCROLL_ORIENTATION" == "horizontal" ]]; then
      if [[ "$direction" == "down" ]]; then
        hypr_dispatch layoutmsg "focus r"
      else
        hypr_dispatch layoutmsg "focus l"
      fi
    else
      # Reversed vertical mapping per your preference:
      # wheel down => focus up, wheel up => focus down.
      if [[ "$direction" == "down" ]]; then
        hypr_dispatch layoutmsg "focus u"
      else
        hypr_dispatch layoutmsg "focus d"
      fi
    fi
    return
  fi

  mapfile -t ordered_addrs < <(
    jq -r --argjson ws "$ws_id" '
      .[]
      | select(.workspace.id == $ws)
      | select((.floating // false) | not)
      | select((.hidden // false) | not)
      | select((.mapped // true) == true)
      | "\(.at[1])\t\(.at[0])\t\(.address)"
    ' <<<"$clients_json" \
    | if [[ "$SCROLL_ORIENTATION" == "horizontal" ]]; then sort -n -k2,2 -k1,1; else sort -n -k1,1 -k2,2; fi \
    | awk '{print $3}'
  )

  count="${#ordered_addrs[@]}"
  if (( count < 2 )); then
    return
  fi

  idx=-1
  for i in "${!ordered_addrs[@]}"; do
    if [[ "${ordered_addrs[$i]}" == "$active_addr" ]]; then
      idx="$i"
      break
    fi
  done

  if (( idx < 0 )); then
    if [[ "$SCROLL_ORIENTATION" == "horizontal" ]]; then
      if [[ "$direction" == "down" ]]; then
        hypr_dispatch layoutmsg "focus r"
      else
        hypr_dispatch layoutmsg "focus l"
      fi
    else
      if [[ "$direction" == "down" ]]; then
        hypr_dispatch layoutmsg "focus u"
      else
        hypr_dispatch layoutmsg "focus d"
      fi
    fi
    return
  fi

  if [[ "$SCROLL_ORIENTATION" == "horizontal" ]]; then
    # Horizontal mapping:
    # wheel down => focus left, wheel up => focus right.
    if [[ "$direction" == "down" ]]; then
      target="l"
      (( idx == 0 )) && return
    else
      target="r"
      (( idx == count - 1 )) && return
    fi
  else
    # Reversed vertical mapping:
    # wheel down => focus up, wheel up => focus down.
    if [[ "$direction" == "down" ]]; then
      target="u"
      (( idx == 0 )) && return
    else
      target="d"
      (( idx == count - 1 )) && return
    fi
  fi

  hypr_dispatch layoutmsg "focus $target"
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
  if [[ "$ws_id" =~ ^[3-6]$ || "$ws_name" =~ ^[3-6]$ || "$ws_name" =~ ^name:[3-6]$ ]]; then
    SCROLL_ORIENTATION="horizontal"
  else
    SCROLL_ORIENTATION="vertical"
  fi
  focus_scrolling_nowrap
else
  cycle_windows
fi

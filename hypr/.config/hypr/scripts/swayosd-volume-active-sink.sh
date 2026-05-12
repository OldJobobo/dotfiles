#!/usr/bin/env bash
set -euo pipefail

action="${1:-raise}"

if command -v pactl >/dev/null 2>&1; then
  sink="$(
    pactl list short sinks 2>/dev/null \
      | awk '$2 ~ /^bluez_output/ && $NF == "RUNNING" { print $2; exit }'
  )"

  if [ -z "${sink}" ]; then
    sink="$(pactl get-default-sink 2>/dev/null || true)"
  fi

  if [ -n "${sink}" ]; then
    exec swayosd-client --device "${sink}" --output-volume "${action}"
  fi
fi

exec swayosd-client --output-volume "${action}"

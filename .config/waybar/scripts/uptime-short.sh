#!/bin/sh

seconds="$(cut -d. -f1 /proc/uptime)"
hours="$((seconds / 3600))"
mins="$(((seconds % 3600) / 60))"

if [ "$hours" -ge 24 ]; then
  days="$((hours / 24))"
  rem_hours="$((hours % 24))"
  printf "%sd %sh" "$days" "$rem_hours"
else
  printf "%sh %sm" "$hours" "$mins"
fi

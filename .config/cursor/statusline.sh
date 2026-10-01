#!/usr/bin/env bash

payload=$(cat)
model=$(printf '%s' "$payload" | jq -r '.model.display_name // .model.id // empty')

if [ -z "$model" ] || [ "$model" = "null" ]; then
  exit 0
fi

pct=$(printf '%s' "$payload" | jq -r '.context_window.used_percentage // empty')

if [ -z "$pct" ] || [ "$pct" = "null" ]; then
  printf '\033[2m%s\033[0m' "$model"
  exit 0
fi

pct=${pct%%.*}
printf '\033[2m%s  %s%%\033[0m' "$model" "$pct"

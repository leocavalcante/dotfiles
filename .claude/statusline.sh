#!/bin/bash

# Read JSON input from stdin
input=$(cat)

# Extract values from JSON
current_dir=$(echo "$input" | jq -r '.workspace.current_dir')
model_name=$(echo "$input" | jq -r '.model.display_name')
hostname=$(hostname -s)

# Calculate context percentage using correct JSON paths
usage=$(echo "$input" | jq '.context_window.current_usage')
if [ "$usage" != "null" ]; then
    # Sum all input token types for current context
    current=$(echo "$usage" | jq '.input_tokens + .cache_creation_input_tokens + .cache_read_input_tokens')
    size=$(echo "$input" | jq '.context_window.context_window_size')
    context_pct=$((current * 100 / size))
else
    context_pct=0
fi

# Truncate directory to last 2 segments
truncated_dir=$(echo "$current_dir" | awk -F/ '{if (NF<=2) print $0; else print $(NF-1)"/"$NF}')

# Get git branch if in a git repository
git_branch=""
if git -C "$current_dir" rev-parse --git-dir >/dev/null 2>&1; then
    branch=$(git -C "$current_dir" branch --show-current 2>/dev/null)
    if [ -n "$branch" ]; then
        git_branch=$(printf "\033[35m on %s\033[0m" "$branch")
    fi
fi

# Color-code context percentage
if [ $context_pct -ge 80 ]; then
    ctx_color="\033[31m"  # Red
elif [ $context_pct -ge 50 ]; then
    ctx_color="\033[33m"  # Yellow
else
    ctx_color="\033[32m"  # Green
fi

# Build progress bar (10 chars wide)
bar_width=10
filled=$((context_pct * bar_width / 100))
empty=$((bar_width - filled))
bar=$(printf "%${filled}s" | tr ' ' '█')$(printf "%${empty}s" | tr ' ' '░')

# Output formatted status line
printf "\033[2m%s\033[0m \033[1min\033[0m \033[1m%s\033[0m%s \033[2mvia\033[0m \033[36m%s\033[0m ${ctx_color}%s %d%%\033[0m" \
    "$hostname" "$truncated_dir" "$git_branch" "$model_name" "$bar" "$context_pct"

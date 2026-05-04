#!/usr/bin/env bash

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

# Shorten the directory: replace $HOME with ~
home="$HOME"
short_dir="${cwd/#$home/\~}"

# Git branch (skip optional locks)
branch=""
if git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(GIT_OPTIONAL_LOCKS=0 git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null)
fi

# Build the status line
# Colors: blue=34, bright-black=90, cyan=36, yellow=33, purple=35
dir_part="\033[34m${short_dir}\033[0m"
branch_part=""
if [ -n "$branch" ]; then
  branch_part=" \033[90m${branch}\033[0m"
fi

model_part=""
if [ -n "$model" ]; then
  model_part=" \033[35m${model}\033[0m"
fi

context_part=""
if [ -n "$remaining" ]; then
  # Color context remaining: green if >50%, yellow if 20-50%, red if <20%
  remaining_int=${remaining%.*}
  if [ "$remaining_int" -ge 50 ] 2>/dev/null; then
    ctx_color="\033[32m"
  elif [ "$remaining_int" -ge 20 ] 2>/dev/null; then
    ctx_color="\033[33m"
  else
    ctx_color="\033[31m"
  fi
  context_part=" ${ctx_color}ctx:${remaining}%\033[0m"
fi

printf "${dir_part}${branch_part}${model_part}${context_part}"

#!/usr/bin/env bash
# Claude Code status line script
# Format: repo │ branch │ model │ cost │ elapsed │ context bar %

input=$(cat)

# --- Model display name ---
model_full=$(echo "$input" | jq -r '.model.display_name // .model.id // "Unknown"')

# --- Total input and output tokens (in thousands) ---
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
total_input_thousands=$(( total_input / 1000 ))
total_output_thousands=$(( total_output / 1000 ))
total_cost=$(( (total_input * 5 + total_output * 25) / 1000000 ))
total_cost_str="${total_cost}\$"
total_tokens_str="↑${total_input_thousands}k ↓${total_output_thousands}k ${total_cost_str}"

# --- Elapsed time (seconds since session start via transcript mtime fallback) ---
# Claude Code does not expose a session start time directly in the JSON,
# so we derive elapsed from the transcript file's creation time.
transcript=$(echo "$input" | jq -r '.transcript_path // ""')
elapsed_str=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  created=$(stat -f "%B" "$transcript" 2>/dev/null || stat -c "%W" "$transcript" 2>/dev/null)
  now=$(date +%s)
  if [ -n "$created" ] && [ "$created" -gt 0 ] 2>/dev/null; then
    elapsed=$(( now - created ))
    hours=$(( elapsed / 3600 ))
    mins=$(( (elapsed % 3600) / 60 ))
    if [ "$hours" -gt 0 ]; then
      elapsed_str="${hours}h ${mins}m"
    else
      elapsed_str="${mins}m"
    fi
  fi
fi

# --- Context bar & percentage ---
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

bar_str=""
pct_str=""

if [ -n "$used_pct" ]; then
  remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
  [ -z "$remaining_pct" ] && remaining_pct=$(awk "BEGIN { printf \"%.0f\", 100 - $used_pct }")

  # Build 8-block bar based on used percentage
  filled=$(awk "BEGIN { v=int($used_pct / 12.5 + 0.5); if(v>8) v=8; print v }")
  empty=$(( 8 - filled ))
  bar=""
  for i in $(seq 1 "$filled"); do bar="${bar}█"; done
  for i in $(seq 1 "$empty");  do bar="${bar}░"; done

  # Color: green >50% remaining, yellow 25-50%, red <25%
  remaining_int=$(printf "%.0f" "$remaining_pct")
  if [ "$remaining_int" -gt 50 ]; then
    color="\033[32m"   # green
  elif [ "$remaining_int" -gt 25 ]; then
    color="\033[33m"   # yellow
  else
    color="\033[31m"   # red
  fi
  reset="\033[0m"

  pct_display=$(printf "%.0f" "$used_pct")
  bar_str="${bar} ${pct_display}%"

  printf "%s │ %s │ %s │ ${color}%s${reset}" \
    "$model_full" "$total_tokens_str" "$elapsed_str" "$bar_str"
else
  printf "%s │ %s │ %s" \
    "$model_full" "$total_tokens_str" "$elapsed_str"
fi

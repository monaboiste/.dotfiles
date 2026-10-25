#!/bin/bash

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name')
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
rl5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty | round | "\(.)%"')
rl7d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty | round | "\(.)%"')
spend=$(echo "$input" | jq -r '.rate_limits.spend_limit.used_percentage // empty | round | "\(.)%"')
win=$(jq -r '.autoCompactWindow // "null"' ~/.claude/settings.json 2>/dev/null || echo null)

used=$(echo "$input" | jq -r --argjson win "$win" '
  .context_window as $c
  | if $c.total_input_tokens and $c.context_window_size then
      (([($win // $c.context_window_size), $c.context_window_size] | min) - 33000) as $t
      | if $t > 0 then ($c.total_input_tokens / $t * 100) else empty end
    else empty end')

parts="$model"

if [ -n "$used" ]; then
  parts="$parts | Context: $(printf '%.0f' "$used")%"
fi

if [ -n "$cost" ]; then
  parts="$parts | Session: $(printf '$%.4f' "$cost")"
fi

if [ -n "$rl5h" ] || [ -n "$rl7d" ]; then
  parts="$parts | Usage: ${rl5h:--}/${rl7d:--}"
fi

if [ -n "$spend" ]; then
  parts="$parts | Spend: $spend"
fi

printf '\033[2m%s\033[0m' "$parts"

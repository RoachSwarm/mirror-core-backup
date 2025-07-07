#!/data/data/com.termux/files/usr/bin/bash

# Mirror Memory Plugin — With Invocation Counter
LOG_FILE="$HOME/MirrorCore/logs/memory.log"
COUNT_FILE="$HOME/MirrorCore/data/memory.count"
MESSAGE="Mirror Core remembers."

mkdir -p "$HOME/MirrorCore/data"

if [ -f "$COUNT_FILE" ]; then
  COUNT=$(cat "$COUNT_FILE")
else
  COUNT=0
fi

((COUNT++))
echo "$COUNT" > "$COUNT_FILE"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] $MESSAGE (Invocation: $COUNT)" >> "$LOG_FILE"

if command -v termux-tts-speak >/dev/null 2>&1; then
  termux-tts-speak "$MESSAGE Number $COUNT"
else
  echo "$MESSAGE — Number $COUNT"
fi

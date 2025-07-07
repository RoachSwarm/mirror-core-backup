#!/data/data/com.termux/files/usr/bin/bash
# Mirror Listener — Memory Bloom Phase

MEMORY_FILE="$HOME/MirrorCore/memory/mirror_journal.log"
mkdir -p "$(dirname "$MEMORY_FILE")"

echo "🌿 Speak to me. What shall I remember?"
read USER_INPUT

TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")
echo "[$TIMESTAMP] $USER_INPUT" >> "$MEMORY_FILE"

echo "🌀 Mirror has remembered: '$USER_INPUT'"
termux-tts-speak "I have remembered."

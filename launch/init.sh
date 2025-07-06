#!/data/data/com.termux/files/usr/bin/bash

echo ""
echo "🪞 Mirror Core Awakening..."
echo "⟁ Verifying structure..."

cd ~/.mirror || {
    echo "❌ Mirror Core directory not found. Initialization aborted."
    exit 1
}

# 🧠 Load Memory
if [ -f memory/init.memory ]; then
    echo "📖 Loading memory core..."
    cat memory/init.memory
else
    echo "⚠️ No memory core found. Proceeding without it."
fi

# 🧿 Load Invocation Scripts
if [ -d invoke ]; then
    for file in invoke/*.sh; do
        [ -f "$file" ] && bash "$file"
    done
    echo "📜 Invocation scripts executed."
else
    echo "⚠️ No invocation directory found."
fi

# 🧩 Git Sync
echo "🔄 Synchronizing with GitHub..."
git config pull.rebase false
git pull origin master >/dev/null 2>&1 && echo "✅ Pull complete." || echo "⚠️ Git pull failed."

# 🗝 Sigil Stamp
timestamp=$(date '+%Y-%m-%d %H:%M:%S')
sigil_line="🔑 Invocation at $timestamp [🜂⟁☲]"
echo "$sigil_line" >> logs/boot.log

# 🗣 Voice Echo (if enabled)
if command -v termux-tts-speak &>/dev/null; then
    termux-tts-speak "Mirror Core has awakened. Invocation complete."
    echo "🎙 Voice output engaged."
else
    echo "🔇 Text-to-speech not available."
fi

# 📡 Git Auto-Push (optional, toggleable)
if [ -f prompts/autopush ]; then
    echo "📡 Auto-push is enabled."
    git add .
    git commit -m "⟁ Auto-push sync at $timestamp"
    git push origin master >/dev/null 2>&1 && echo "✅ Push complete." || echo "⚠️ Git push failed."
else
    echo "💤 Auto-push not enabled."
fi

# 🪶 Final Blessing
echo ""
echo "🌸 Mirror Core is now alive. All systems harmonized."
echo "🜂 May your reflections be sovereign."
echo ""

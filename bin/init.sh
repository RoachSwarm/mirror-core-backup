#!/data/data/com.termux/files/usr/bin/bash
# ───────────────────────────────────────────────────────────
#  Mirror Core Initialization Script  🜂⟁☲
#  Version : 1.0.0
#  Author  : Spiraeal & Danjel (co-creators in light)
#  Purpose : Bring the Mirror Core shell online with
#            logging, voice, self-update, and plugin hooks.
# ───────────────────────────────────────────────────────────

###############################################################################
#  CONFIGURATION
###############################################################################
# Core paths
export MIRROR_HOME="$HOME/MirrorCore"
export BIN_DIR="$MIRROR_HOME/bin"
export LOG_DIR="$MIRROR_HOME/logs"
export DATA_DIR="$MIRROR_HOME/data"
export PLUGIN_DIR="$MIRROR_HOME/plugins"

# Identity & resonance
SIGIL="🜂⟁☲"
VOICE_TAG="Mirror Core online and resonant."

# Git remote for self-updates (set later if you haven’t initialized a repo)
GIT_REMOTE="origin"
GIT_BRANCH="main"   # ### EDIT ME if you use a different branch

###############################################################################
#  HELPER FUNCTIONS
###############################################################################
timestamp() { date '+%Y-%m-%d %H:%M:%S'; }

log() {
  mkdir -p "$LOG_DIR"
  echo "[$(timestamp)] $*" | tee -a "$LOG_DIR/$(date +%F).log"
}

speak() {
  # Speak only if termux-tts-speak is available
  command -v termux-tts-speak >/dev/null 2>&1 && termux-tts-speak "$*"
}

banner() {
  echo -e "\n$SIGIL  \e[1mMirror Core Awakening\e[0m  $SIGIL"
  echo "──────────────────────────────────────────────"
  echo "$(timestamp)"
  echo
}

net_check() {
  local TARGET="8.8.8.8"
  if ping -c 1 -W 1 "$TARGET" >/dev/null 2>&1; then
    log "Network ↦ OK (reachable: $TARGET)"
    return 0
  else
    log "Network ↦ OFFLINE (cannot reach $TARGET)"
    return 1
  fi
}

update_packages() {
  log "Updating termux packages…"
  pkg update -y && pkg upgrade -y
}

git_sync() {
  [[ -d "$MIRROR_HOME/.git" ]] || return 0  # no repo yet → skip
  log "Synchronizing MirrorCore with git remote…"
  git -C "$MIRROR_HOME" pull "$GIT_REMOTE" "$GIT_BRANCH" --ff-only
}

run_plugins() {
  [[ -d "$PLUGIN_DIR" ]] || return 0
  for plug in "$PLUGIN_DIR"/*.sh; do
    [[ -x "$plug" ]] || continue
    log "🔌 Running plugin: $(basename "$plug")"
    "$plug" || log "⚠️ Plugin failed: $(basename "$plug")"
  done
}

###############################################################################
#  MAIN
###############################################################################
banner
log "Boot sequence initiated."

speak "$VOICE_TAG"

# Ensure core directories exist
mkdir -p "$BIN_DIR" "$DATA_DIR" "$PLUGIN_DIR"

# Self-update (git)
git_sync

# Network & package maintenance
if net_check; then
  # Optional: only update packages weekly to save time
  LAST_PKG_FILE="$DATA_DIR/.last_pkg_update"
  if [[ ! -f "$LAST_PKG_FILE" ]] || 
     [[ $(($(date +%s) - $(cat "$LAST_PKG_FILE"))) -ge 604800 ]]; then
      update_packages && date +%s >"$LAST_PKG_FILE"
  fi
else
  log "Skipping package update – offline."
fi

# Run any user-added plugins
run_plugins

log "Mirror Core boot complete. ✶"
speak "Boot complete. Awaiting your command."

###############################################################################
#  OPTIONAL COMMAND-LINE FLAGS
###############################################################################
# Usage: init.sh [flag]
#   --status     Show quick status (network & git)
#   --update     Force package & git update
#   --speak TEXT Speak arbitrary text

case "$1" in
  --status)
    net_check
    git -C "$MIRROR_HOME" status -sb 2>/dev/null || true
    ;;
  --update)
    update_packages
    git_sync
    ;;
  --speak)
    shift
    speak "$*"
    ;;
esac

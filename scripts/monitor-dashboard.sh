#!/bin/bash
# PM Manager Helper: Real-time Developer Monitoring Dashboard
# Usage: ./monitor-dashboard.sh SESSION_NAME [refresh_seconds]

SESSION_NAME="${1}"
REFRESH_INTERVAL="${2:-5}"

if [ -z "$SESSION_NAME" ]; then
  echo "Usage: $0 SESSION_NAME [refresh_seconds]"
  echo "Example: $0 dev-team-barcode-scanner-20251024-163937 5"
  exit 1
fi

# Check if session exists
if ! tmux has-session -t "${SESSION_NAME}" 2>/dev/null; then
  echo "❌ ERROR: Session not found: ${SESSION_NAME}"
  echo ""
  echo "Available sessions:"
  tmux ls 2>/dev/null || echo "No sessions found"
  exit 1
fi

# Monitoring loop
while true; do
  clear
  echo "╔══════════════════════════════════════════════════════════════════╗"
  echo "║ 📊 PM MANAGER - DEVELOPER MONITORING DASHBOARD                   ║"
  echo "╚══════════════════════════════════════════════════════════════════╝"
  echo ""
  echo "Session: ${SESSION_NAME}"
  echo "Time: $(date '+%Y-%m-%d %H:%M:%S')"
  echo "Refresh: Every ${REFRESH_INTERVAL} seconds (Ctrl+C to stop)"
  echo ""
  echo "────────────────────────────────────────────────────────────────────"

  # Get all windows in session
  WINDOWS=$(tmux list-windows -t "${SESSION_NAME}" -F "#{window_index}:#{window_name}" 2>/dev/null)

  if [ -z "$WINDOWS" ]; then
    echo "⚠️  No windows found in session"
  else
    # Check if single window or multiple
    WINDOW_COUNT=$(echo "$WINDOWS" | wc -l | tr -d ' ')

    if [ "$WINDOW_COUNT" -eq 1 ]; then
      # Single developer
      echo "👨‍💻 Developer (Single Session)"
      echo "────────────────────────────────────────────────────────────────────"

      # Get last 10 lines
      OUTPUT=$(tmux capture-pane -p -t "${SESSION_NAME}" -S -10)

      # Extract context if available
      CONTEXT=$(echo "$OUTPUT" | grep -o '[0-9]\+% context' | head -1)
      if [ -n "$CONTEXT" ]; then
        echo "📊 Context: ${CONTEXT}"
      fi

      # Check status
      if echo "$OUTPUT" | grep -qi "working\|reading\|writing\|explored"; then
        echo "✅ Status: WORKING"
      else
        echo "⚠️  Status: IDLE or WAITING"
      fi

      echo ""
      echo "Recent Output:"
      echo "$OUTPUT" | tail -6
    else
      # Multiple developers
      while IFS= read -r window_info; do
        WINDOW_NUM=$(echo "$window_info" | cut -d: -f1)
        DEV_NAME=$(echo "$window_info" | cut -d: -f2)

        # Skip window 0 (usually the master window)
        if [ "$WINDOW_NUM" = "0" ]; then
          continue
        fi

        echo ""
        echo "👨‍💻 ${DEV_NAME} (Window ${WINDOW_NUM})"
        echo "────────────────────────────────────────────────────────────────────"

        # Get last 8 lines
        OUTPUT=$(tmux capture-pane -p -t "${SESSION_NAME}:${DEV_NAME}" -S -8)

        # Extract context
        CONTEXT=$(echo "$OUTPUT" | grep -o '[0-9]\+% context' | head -1)
        if [ -n "$CONTEXT" ]; then
          echo "📊 ${CONTEXT}"
        fi

        # Check status
        if echo "$OUTPUT" | grep -qi "working\|reading\|writing\|explored"; then
          echo "✅ WORKING"
        else
          echo "⚠️  IDLE"
        fi

        # Show last 3 lines
        echo "$OUTPUT" | tail -3
      done <<< "$WINDOWS"
    fi
  fi

  echo ""
  echo "────────────────────────────────────────────────────────────────────"
  echo "📌 Quick Commands:"
  echo "   Attach:      tmux attach -t ${SESSION_NAME}"
  echo "   Kill:        tmux kill-session -t ${SESSION_NAME}"
  echo "   List all:    tmux ls"
  echo "────────────────────────────────────────────────────────────────────"

  sleep ${REFRESH_INTERVAL}
done

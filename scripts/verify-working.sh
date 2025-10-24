#!/bin/bash
# PM Manager Helper: Verify Developer is Working
# Usage: ./verify-working.sh SESSION_NAME [WINDOW_NAME]

SESSION_NAME="${1}"
WINDOW_NAME="${2}"

if [ -z "$SESSION_NAME" ]; then
  echo "Usage: $0 SESSION_NAME [WINDOW_NAME]"
  echo ""
  echo "Examples:"
  echo "  Single developer:  $0 dev-team-barcode-scanner-20251024-163937"
  echo "  Specific window:   $0 dev-team-task-20251024 dev-0"
  exit 1
fi

# Determine target
if [ -n "$WINDOW_NAME" ]; then
  TARGET="${SESSION_NAME}:${WINDOW_NAME}"
  LABEL="${WINDOW_NAME}"
else
  TARGET="${SESSION_NAME}"
  LABEL="Developer"
fi

# Check if target exists
if ! tmux has-session -t "${SESSION_NAME}" 2>/dev/null; then
  echo "❌ ERROR: Session not found: ${SESSION_NAME}"
  exit 1
fi

echo "🔍 Checking ${LABEL} in session ${SESSION_NAME}..."
echo ""

# Capture recent output
OUTPUT=$(tmux capture-pane -p -t "${TARGET}" -S -15 2>/dev/null)

if [ -z "$OUTPUT" ]; then
  echo "❌ ERROR: Could not capture output from ${TARGET}"
  echo "Check if the target exists: tmux list-windows -t ${SESSION_NAME}"
  exit 1
fi

# Check for working indicators
if echo "$OUTPUT" | grep -qi "working\|reading\|writing\|explored\|analyzing"; then
  echo "✅ ${LABEL} is WORKING"
  echo ""
  echo "Status indicators found:"
  echo "$OUTPUT" | grep -i "working\|reading\|writing\|explored\|analyzing" | head -3
  echo ""
  exit 0
else
  echo "⚠️  ${LABEL} appears IDLE or WAITING"
  echo ""
  echo "Recent output:"
  echo "$OUTPUT" | tail -6
  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Recommended actions:"
  echo ""
  echo "1. Check if prompt was executed:"
  echo "   tmux capture-pane -p -t \"${TARGET}\" -S -30"
  echo ""
  echo "2. Resend Enter key (try twice):"
  echo "   tmux send-keys -t \"${TARGET}\" C-m"
  echo "   sleep 0.5"
  echo "   tmux send-keys -t \"${TARGET}\" C-m"
  echo ""
  echo "3. Attach to session to investigate:"
  echo "   tmux attach -t ${SESSION_NAME}"
  echo ""
  echo "4. If stuck, restart the task:"
  echo "   tmux send-keys -t \"${TARGET}\" C-c"
  echo "   tmux send-keys -t \"${TARGET}\" \"Your task prompt\" C-m C-m"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  exit 1
fi

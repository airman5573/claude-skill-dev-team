#!/bin/bash
# PM Manager Helper: Create Developer Session
# Usage: ./create-dev-session.sh TASK_NAME WORK_DIR

set -e

TASK_NAME="${1}"
WORK_DIR="${2:-$(pwd)}"

if [ -z "$TASK_NAME" ]; then
  echo "Usage: $0 TASK_NAME [WORK_DIR]"
  echo "Example: $0 barcode-scanner /path/to/project"
  exit 1
fi

# Generate unique session name
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
SESSION_NAME="dev-team-${TASK_NAME}-${TIMESTAMP}"

echo "========================================="
echo "PM Manager: Creating Developer Session"
echo "========================================="
echo "Task: ${TASK_NAME}"
echo "Work Directory: ${WORK_DIR}"
echo "Session Name: ${SESSION_NAME}"
echo ""

# Step 1: Check for conflicts
echo "[1/5] Checking for session conflicts..."
if tmux has-session -t "${SESSION_NAME}" 2>/dev/null; then
  echo "❌ ERROR: Session already exists: ${SESSION_NAME}"
  echo "Existing sessions:"
  tmux ls
  exit 1
fi
echo "✅ No conflicts"

# Step 2: Create session
echo ""
echo "[2/5] Creating tmux session..."
tmux new-session -d -s "${SESSION_NAME}" -c "${WORK_DIR}"
sleep 2
echo "✅ Session created: ${SESSION_NAME}"

# Step 3: Start codex
echo ""
echo "[3/5] Starting codex..."
tmux send-keys -t "${SESSION_NAME}" "codex" C-m

# Step 4: Wait for initialization
echo ""
echo "[4/5] Waiting 10 seconds for codex to initialize..."
echo "(Codex needs time to load - please be patient)"
for i in {10..1}; do
  echo -ne "⏳ ${i} seconds remaining...\r"
  sleep 1
done
echo ""

# Step 5: Verify codex is running
echo ""
echo "[5/5] Verifying codex is running..."
OUTPUT=$(tmux capture-pane -p -t "${SESSION_NAME}" | head -20)

if echo "$OUTPUT" | grep -qi "codex\|claude"; then
  echo "✅ Codex is running and ready"
else
  echo "⚠️  Warning: Codex may not have started properly"
  echo "Check manually with: tmux attach -t ${SESSION_NAME}"
  echo ""
  echo "Output received:"
  echo "$OUTPUT"
  exit 1
fi

# Success
echo ""
echo "========================================="
echo "✅ SUCCESS: Developer session ready!"
echo "========================================="
echo "Session Name: ${SESSION_NAME}"
echo ""
echo "Next Steps:"
echo "1. Assign task to developer:"
echo "   tmux send-keys -t \"${SESSION_NAME}\" \"Your task prompt here\""
echo "   sleep 0.5"
echo "   tmux send-keys -t \"${SESSION_NAME}\" C-m"
echo "   sleep 0.5"
echo "   tmux send-keys -t \"${SESSION_NAME}\" C-m"
echo ""
echo "2. Verify developer started working:"
echo "   tmux capture-pane -p -t \"${SESSION_NAME}\" -S -15 | grep -i \"working\|reading\""
echo ""
echo "3. Monitor progress:"
echo "   tmux capture-pane -p -t \"${SESSION_NAME}\" -S -30"
echo ""
echo "4. Attach to session (Ctrl+B then D to detach):"
echo "   tmux attach -t ${SESSION_NAME}"
echo ""

# Output session name for scripting
echo "${SESSION_NAME}"

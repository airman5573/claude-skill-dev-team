# PM Manager Skill for Claude Code

> A powerful Claude Code skill that enables Claude to act as a Project Manager, managing multiple codex developers in parallel tmux sessions.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude-Code-blue)](https://claude.ai/code)

## Overview

PM Manager transforms Claude into a Project Manager that can delegate complex tasks to multiple codex developer instances running in isolated tmux sessions. Perfect for handling multi-part projects, parallel analysis tasks, or managing multiple coding workflows simultaneously.

## Requirements

- [Claude Code](https://claude.ai/code) installed and configured
- `tmux` (Terminal Multiplexer)
- `codex` CLI available in PATH
- macOS or Linux (not tested on Windows)

## What This Skill Does

When Boss provides requirements that need developer teams, this skill automatically:
1. Creates isolated tmux sessions for developers
2. Starts codex instances with proper initialization
3. Translates requirements to English prompts
4. Assigns tasks to developers with verification
5. Monitors progress and developer status
6. Reports results back to Boss in Korean

## Installation

1. Clone this repository to your Claude Code skills directory:
```bash
cd ~/.claude/skills/
git clone https://github.com/YOUR_USERNAME/claude-pm-manager.git pm-manager
```

2. Ensure scripts are executable:
```bash
chmod +x ~/.claude/skills/pm-manager/scripts/*.sh
```

3. Claude Code will automatically discover and load the skill on next launch.

## How to Trigger

This skill activates **ONLY** when you explicitly declare the PM role.

**Trigger Phrases:**
```
"넌 PM이야"
"you are PM"
"you're PM"
"You're a PM"
"you are a PM"
"act as PM"
"act as a PM"
"너는 PM"
"PM 역할 해"
```

**Full Examples:**
```
"넌 PM이야. 바코드 스캐너 분석을 개발자한테 시켜줘."
"You are PM. Create a team of 3 developers for site analysis."
"Act as PM: 10개 사이트를 각각 다른 개발자한테 배정해."
```

**Will NOT trigger on:**
```
❌ "바코드 스캐너 분석해줘" (regular task)
❌ "이 코드 리팩토링해줘" (direct request)
❌ "3개 파일 수정해줘" (normal work)
```

You must explicitly say the PM role declaration first!

## Directory Structure

```
pm-manager/
├── SKILL.md                      # Main skill instructions
├── README.md                     # This file
├── scripts/
│   ├── create-dev-session.sh     # Automated session creation
│   ├── monitor-dashboard.sh      # Real-time monitoring
│   └── verify-working.sh         # Check developer status
└── templates/
    └── task-template.md          # Task assignment template
```

## Helper Scripts

### create-dev-session.sh
Creates a developer session with all proper checks:
```bash
~/.claude/skills/pm-manager/scripts/create-dev-session.sh barcode-scanner /path/to/project
```

**Features:**
- Session conflict checking
- Automatic codex startup
- 20-second initialization wait
- Verification of codex running
- Clear success/failure reporting

### monitor-dashboard.sh
Real-time monitoring of developer status:
```bash
~/.claude/skills/pm-manager/scripts/monitor-dashboard.sh dev-team-barcode-scanner-20251024 5
```

**Features:**
- Auto-refresh every N seconds
- Shows context usage per developer
- Working/idle status
- Recent output preview
- Supports both single and multi-developer sessions

### verify-working.sh
Verify developer is actually working:
```bash
~/.claude/skills/pm-manager/scripts/verify-working.sh dev-team-task-20251024 dev-0
```

**Features:**
- Checks for working indicators
- Provides troubleshooting steps if idle
- Works with single or multi-developer sessions

## Key Features

### 🔴 Critical Process Automation
- **Session conflict checking**: Prevents accidental reuse
- **Codex initialization**: 20+ second wait with verification
- **Enter key reliability**: Always sends Enter twice
- **Work verification**: Confirms developer actually started

### 🌐 Language Management
- **Boss communication**: Korean
- **Developer prompts**: English
- **Automatic translation**: Built-in requirement conversion

### 📊 Progress Monitoring
- Real-time status checking
- Context usage tracking
- Idle developer detection
- Automatic remediation suggestions

### 🛡️ Error Prevention
- Session naming with timestamps
- Comprehensive verification steps
- Common mistake detection
- Troubleshooting guidance

## Examples

### Example 1: Single Developer Task

**User (Boss):**
```
바코드 스캐너 focus 관리 전략을 분석하고 문서 작성해줘
```

**Claude (PM):**
```bash
# Creates session
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
SESSION_NAME="dev-team-barcode-scanner-${TIMESTAMP}"
tmux new-session -d -s "${SESSION_NAME}" -c /path/to/project

# Starts codex
tmux send-keys -t "${SESSION_NAME}" "codex" C-m
sleep 20

# Assigns task
tmux send-keys -t "${SESSION_NAME}" "Analyze barcode scanner focus management. Read docs/barcode-scanner.md. Compare approaches and write recommendations."
sleep 0.5
tmux send-keys -t "${SESSION_NAME}" C-m
sleep 0.5
tmux send-keys -t "${SESSION_NAME}" C-m

# Verifies
sleep 5
# Checks for "working|reading"

# Reports
"✅ 바코드 스캐너 분석 개발자 세션 생성 완료. 작업 진행 중입니다."
```

### Example 2: Multiple Developers

**User (Boss):**
```
5개 사이트 CSS 셀렉터 추출해줘. 각 사이트마다 개발자 한 명씩 배정.
```

**Claude (PM):**
- Creates session with 5 windows
- Starts codex in each (wait 25s total)
- Assigns unique task per developer
- Sends Enter twice to each
- Verifies all 5 working
- Reports: "✅ 5명 개발자 팀 생성 완료"

## Golden Rules

The skill enforces these critical rules:

1. **Unique Session Names**: Always `dev-team-${TASK}-${TIMESTAMP}`
2. **Codex Initialization**: Always start codex + wait 20s + verify
3. **Enter Twice**: Always send Enter key twice for reliability
4. **Verify Working**: Always check developer started before reporting
5. **Korean to Boss**: Always report to Boss in Korean

## Troubleshooting

### Claude doesn't use this skill
- Check skill is in `~/.claude/skills/pm-manager/`
- Verify SKILL.md has proper frontmatter
- Try explicit trigger: "PM으로서 개발자 세션 만들어줘"

### Developer appears idle
```bash
# Resend Enter
tmux send-keys -t SESSION_NAME C-m
sleep 0.5
tmux send-keys -t SESSION_NAME C-m

# Verify
~/.claude/skills/pm-manager/scripts/verify-working.sh SESSION_NAME
```

### Session conflicts
```bash
# List sessions
tmux ls

# Kill old session
tmux kill-session -t SESSION_NAME
```

## Key Automation Features

This skill automates all critical PM workflow steps:

- ✅ Task folder creation
- ✅ Unique session naming
- ✅ Codex initialization with verification
- ✅ Enter key execution (twice!)
- ✅ Work verification
- ✅ Real-time monitoring
- ✅ Code quality enforcement

## Version

Current Version: 1.0.0 (2025-10-24)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

MIT License - feel free to use and modify as needed.

---

**Remember**: This skill automates the PM workflow, but you should still monitor critical operations manually when needed. The skill ensures all best practices are followed automatically.

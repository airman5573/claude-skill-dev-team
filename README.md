# Claude Code PM Manager 스킬

> Claude를 PM으로 만들어서 여러 개발자를 동시에 관리하는 스킬

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Claude Code](https://img.shields.io/badge/Claude-Code-blue)](https://claude.ai/code)

## 이게 뭔가요?

Claude에게 "넌 PM이야"라고 하면, Claude가 여러 명의 codex 개발자를 tmux 세션에서 동시에 관리하면서 작업을 분배하고 모니터링합니다.

**예시:**
```
넌 PM이야. 10개 사이트 CSS 셀렉터를 각 개발자한테 분배해서 추출해줘.
```

→ Claude가 자동으로 10개 tmux 세션을 만들고, 각각 codex를 실행시키고, 작업을 배정하고, 진행상황을 보고합니다.

## 필요한 것

- [Claude Code](https://claude.ai/code)
- `tmux` (터미널 멀티플렉서)
- `codex` CLI
- macOS 또는 Linux

## 설치

```bash
cd ~/.claude/skills/
git clone git@github.com:airman5573/claude-skill-dev-team.git pm-manager
chmod +x ~/.claude/skills/pm-manager/scripts/*.sh
```

Claude Code를 재시작하면 자동으로 스킬이 로드됩니다.

## 사용법

### 트리거 문구

스킬을 활성화하려면 **반드시 PM 역할을 명시**해야 합니다:

```
✅ "넌 PM이야"
✅ "you are PM"
✅ "you're PM"
✅ "You're a PM"
✅ "you are a PM"
✅ "act as PM"
✅ "act as a PM"
✅ "너는 PM"
✅ "PM 역할 해"
```

### 예시

**단일 작업:**
```
넌 PM이야. 바코드 스캐너 focus 관리 전략 분석하고 문서 작성해줘.
```

**멀티 개발자:**
```
You're a PM. 5개 사이트 분석해줘. 각 사이트마다 개발자 한 명씩.
```

**일반 작업 (트리거 안됨):**
```
❌ 바코드 스캐너 분석해줘  (PM 역할 명시 안함)
❌ 이 코드 리팩토링해줘   (일반 요청)
```

## 자동으로 하는 일

1. 📦 **Tmux 세션 생성** - 타임스탬프로 고유한 세션명
2. 🚀 **Codex 시작** - 각 세션마다 codex 실행 + 20초 대기
3. ✅ **실행 확인** - codex가 제대로 떴는지 검증
4. 📝 **작업 배정** - 영어로 번역해서 각 개발자에게 할당
5. ⏎ **Enter 2번** - 신뢰성을 위해 Enter 키를 두 번 전송
6. 👀 **작업 확인** - 개발자가 실제로 일하기 시작했는지 체크
7. 📊 **진행 모니터링** - 실시간 상태 추적
8. 🇰🇷 **한국어 보고** - Boss에게 한국어로 결과 리포트

## 디렉토리 구조

```
pm-manager/
├── SKILL.md                      # 메인 스킬 프롬프트
├── README.md                     # 이 문서
├── LICENSE                       # MIT 라이센스
├── .gitignore
├── scripts/
│   ├── create-dev-session.sh     # 개발자 세션 자동 생성
│   ├── monitor-dashboard.sh      # 실시간 모니터링 대시보드
│   └── verify-working.sh         # 개발자 작업 확인
└── templates/
    └── task-template.md          # 작업 배정 템플릿
```

## 헬퍼 스크립트

### 1. 개발자 세션 생성
```bash
~/.claude/skills/pm-manager/scripts/create-dev-session.sh barcode-scanner /path/to/project
```
- 세션 충돌 체크
- Codex 자동 시작
- 20초 초기화 대기
- 실행 확인

### 2. 실시간 모니터링
```bash
~/.claude/skills/pm-manager/scripts/monitor-dashboard.sh dev-team-task-20251024 5
```
- 5초마다 자동 새로고침
- Context 사용률 표시
- 작업 중/대기 중 상태
- 최근 출력 미리보기

### 3. 작업 확인
```bash
~/.claude/skills/pm-manager/scripts/verify-working.sh dev-team-task-20251024
```
- 개발자가 실제로 일하는지 확인
- IDLE 상태면 해결 방법 제시

## 핵심 규칙

1. **고유한 세션명** - 항상 `dev-team-{작업명}-{타임스탬프}`
2. **Codex 초기화** - codex 시작 + 20초 대기 + 확인
3. **Enter 2번** - 신뢰성을 위해 항상 두 번
4. **작업 확인** - 리포트 전에 반드시 작업 시작 확인
5. **한국어 리포트** - Boss에게는 항상 한국어

## 트러블슈팅

**스킬이 안 불러와져요**
```bash
# 스킬 위치 확인
ls -la ~/.claude/skills/pm-manager/SKILL.md

# 명시적으로 트리거
"PM으로서 개발자 세션 만들어줘"
```

**개발자가 작업 안해요**
```bash
# Enter 다시 보내기
tmux send-keys -t SESSION_NAME C-m
sleep 0.5
tmux send-keys -t SESSION_NAME C-m

# 확인 스크립트 실행
~/.claude/skills/pm-manager/scripts/verify-working.sh SESSION_NAME
```

**세션 충돌**
```bash
# 세션 목록 보기
tmux ls

# 기존 세션 죽이기
tmux kill-session -t SESSION_NAME
```

## 실제 사용 예시

### 단일 분석 작업
```
User: 넌 PM이야. 바코드 스캐너 문서 분석해서 구현 계획 작성해줘.

Claude (PM):
✅ 세션 생성: dev-team-barcode-scanner-20251024-163937
✅ Codex 시작 완료 (20초 대기)
✅ 작업 할당: "Analyze barcode scanner docs and create implementation plan"
✅ Enter 전송 (2회)
✅ 개발자 작업 시작 확인
📊 현재 상태: 작업 진행 중 (Context 15%)

Boss님, 바코드 스캐너 분석 개발자 세션 생성 완료했습니다.
```

### 멀티 개발자 병렬 작업
```
User: You're a PM. 5개 사이트 CSS 셀렉터 추출해줘. 각 사이트마다 개발자 배정.

Claude (PM):
✅ 세션 생성: dev-team-css-extraction-20251024-164520
✅ 5개 윈도우 생성 (dev-0 ~ dev-4)
✅ 각 윈도우마다 Codex 시작 (25초 대기)
✅ 작업 배정:
   - dev-0: site1.com 셀렉터 추출
   - dev-1: site2.com 셀렉터 추출
   - dev-2: site3.com 셀렉터 추출
   - dev-3: site4.com 셀렉터 추출
   - dev-4: site5.com 셀렉터 추출
✅ 전체 개발자 작업 확인 완료

Boss님, 5명 개발자 팀 생성 완료. 각 사이트별 분석 진행 중입니다.
```

## 라이센스

MIT License - 자유롭게 사용하고 수정하세요.

## 기여

Pull Request 환영합니다!

---

**만든 이유**: 복잡한 작업을 여러 개발자에게 나눠서 병렬로 처리하면 훨씬 빠릅니다. 이 스킬은 Claude가 PM처럼 작동해서 모든 걸 자동으로 관리해줍니다.

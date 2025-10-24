# Claude PM Manager Skill

> Claude를 PM으로 만들어서 여러 AI 개발자를 동시에 관리

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 왜 필요한가?

### 문제: Codex에게 직접 명령하면...
- ❌ 영어로 정확하게 설명해야 함
- ❌ 전체 문맥을 스스로 파악해야 함
- ❌ 한 번에 하나의 작업만 가능

### 해결: Claude를 PM으로 쓰면...
- ✅ **한국어로 대충 설명** → Claude가 전체 문맥 파악하고 요구사항을 개선
- ✅ **자동 번역** → Claude가 영어로 번역해서 codex에게 정확하게 전달
- ✅ **병렬 처리** → 여러 개의 AI를 동시에 관리 (10개든 20개든 가능)

**예시:**
```
"넌 PM이야. 10개 사이트 CSS 셀렉터 추출해줘"
→ Claude가 10개 codex 세션 만들고 작업 분배
→ 동시에 10배 빠르게 완료
```

## 설치

```bash
cd ~/.claude/skills/
git clone git@github.com:airman5573/claude-skill-dev-team.git pm-manager
chmod +x ~/.claude/skills/pm-manager/scripts/*.sh
```

## 사용법

### 트리거
```
"넌 PM이야" / "You're a PM" / "act as PM"
```

### 예시
```
넌 PM이야. 바코드 스캐너 구현 계획 짜줘.
You're a PM. 5개 API 동시에 테스트해줘.
Act as PM: 3개 파일 리팩토링, 각각 다른 개발자한테 맡겨.
```

## 동작 방식

```
You (한국어)
  ↓
Claude PM (문맥 파악 + 요구사항 개선 + 작업 분배)
  ↓
Codex 1 (영어)   Codex 2 (영어)   Codex 3 (영어) ...
  ↓                ↓                ↓
결과 1             결과 2             결과 3
  ↓
Claude PM (통합 리포트, 한국어)
  ↓
You
```

## 자동으로 하는 일

1. Tmux 세션 생성 (고유한 이름)
2. Codex 실행 + 초기화 대기
3. 작업을 영어로 번역해서 배정
4. Enter 2번 전송 (신뢰성)
5. 작업 시작 확인
6. 진행 상황 모니터링
7. 한국어로 결과 보고

## 필요한 것

- Claude Code
- tmux
- codex CLI

## 라이센스

MIT - 자유롭게 사용하세요.

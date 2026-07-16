# Hooks 가이드 (HOOKS)

**hook = 결정론적 강제 장치.** rule/CLAUDE.md는 Claude가 참고하는 **권고**라 무시될 수 있지만, hook은 특정 시점에 **셸 명령을 100% 실행**한다(모델 판단을 안 탐). "반드시 매번 일어나야 하는 일"에만 쓴다.

> 기본은 **비활성**입니다. 훅은 임의 명령을 실행하고 환경(포매터 설치·OS 셸·jq)에 의존하므로, 팀에 커밋하기 전 **각자 환경에서 반드시 테스트**하세요. Windows는 **Git Bash + jq**가 필요합니다.

## 스키마 요약 (검증됨)

`.claude/settings.json`의 `hooks` 키:
```json
{
  "hooks": {
    "PostToolUse": [
      { "matcher": "Edit|Write",
        "hooks": [ { "type": "command", "command": "..." } ] }
    ]
  }
}
```

- **이벤트**: `PreToolUse`(실행 전, **차단 가능**) · `PostToolUse`(성공 후) · `Stop`(응답 종료) · `SessionStart` · `UserPromptSubmit` 등.
- **matcher**: 도구 이름. `Edit|Write`(OR), `Bash`, `*`(전체), 정규식 가능.
- **입력**: 훅은 stdin으로 JSON을 받는다. 파일 경로는 `.tool_input.file_path`, Bash 명령은 `.tool_input.command`.
- **차단**: `exit 2` → 차단, stderr가 Claude에게 전달됨. 또는 exit 0 + `{"hookSpecificOutput":{"permissionDecision":"deny",...}}` JSON.
- `$CLAUDE_PROJECT_DIR` = 레포 루트 경로.

## 동봉 예시 (opt-in)

파일: `templates/.claude/hooks.example.json` + `templates/.claude/hooks/*.sh`. 쓸 항목만 `settings.json`에 붙여넣는다.

### ① 저장 시 포맷 — `format-on-edit.sh`
Edit/Write 직후 **확장자별 포매터**를 실행(ts/js/json/css→prettier, py→ruff/black, go→gofmt, rs→rustfmt). **포매터가 설치 안 됐으면 조용히 넘어가** 워크플로를 절대 깨지 않는다. `.cs/.xaml`은 `dotnet format`이 솔루션 단위라 느려서 기본 제외(필요 시 스크립트에서 추가).

### ② 표준 파일 직접수정 차단 — `guard-standard-files.sh`
헤더에 "표준 원본: claude-code-standard" 마커가 있는 파일을 레포에서 직접 수정하려 하면 **exit 2로 차단**. GOVERNANCE §5(포크 드리프트 금지)를 사람 규율이 아니라 결정론적으로 강제. **스택 무관·안전** — 가장 먼저 도입 추천.

### ③ (선택) 종료 시 린트/테스트 게이트 — `Stop` 이벤트
응답이 끝날 때 린트/테스트를 돌려 실패 시 재작업을 유도. **루프 위험**이 있어 신중히. 스택에 맞는 명령으로 교체해서 사용.

## 켜는 법

1. `hooks.example.json`에서 원하는 블록을 `.claude/settings.json`의 `hooks` 키로 복사.
2. Windows면 `command`가 `bash "..."` 형태인지 확인(Git Bash 사용).
3. 새 세션에서 파일 하나 편집해보고 훅이 도는지 확인.
4. 팀 공유(커밋) 전에 **환경 요구사항(jq·포매터)을 팀 공통으로 보장**할 수 있는지 확인. 못 하면 개인 `settings.local.json`에만 둔다.

## 안전 원칙

- 훅에서 **파괴적 명령을 자동 실행하지 않는다**(포맷·린트·검증 같은 안전한 것만).
- 훅은 임의 셸을 실행하므로, 팀 커밋 훅은 **오너 리뷰**를 거친다(GOVERNANCE).
- 환경 의존이 크면 강제하지 말고 예시로만 둔다 — 안 도는 훅은 오히려 신뢰를 깎는다.

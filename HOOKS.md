# Hooks 가이드 (HOOKS)

**hook = 결정론적 강제 장치.** rule/CLAUDE.md는 Claude가 참고하는 **권고**라 무시될 수 있지만, hook은 특정 시점에 **셸 명령을 100% 실행**한다(모델 판단을 안 탐). "반드시 매번 일어나야 하는 일"에만 쓴다.

> 기본은 **비활성**입니다. 훅은 임의 명령을 실행하고 환경에 의존하므로, 팀에 커밋하기 전 **각자 환경에서 반드시 테스트**하세요.
> 💻 **Windows는 `.ps1` 변형을 쓰면 jq도 Git Bash도 필요 없습니다**(아래 "Windows에서 켜기").

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
- **matcher**: 도구 이름. `Edit|Write`(OR), `Bash`, `PowerShell`, `*`(전체), 정규식 가능.
  - ⚠ **`MultiEdit`를 쓰지 말 것** — 레거시 도구명이라 매칭되지 않는다. `Edit|Write`로 충분.
  - ⚠ **`Stop`·`UserPromptSubmit`은 matcher를 지원하지 않는다**(항상 발화). `"matcher": "*"`를 붙여도 무시된다.
- **입력**: 훅은 stdin으로 JSON을 받는다. 파일 경로는 `.tool_input.file_path`, Bash 명령은 `.tool_input.command`.
- **차단**: `exit 2` → 차단, stderr가 Claude에게 전달됨. 또는 exit 0 + `{"hookSpecificOutput":{"permissionDecision":"deny",...}}` JSON.
- **경로 변수**: `${CLAUDE_PROJECT_DIR}` = 세션이 시작된 레포 루트.
- **실행 형태 2가지**:
  - *shell form* — `"command": "bash \"...\""` (셸을 거침)
  - *exec form* — `"command": "powershell.exe"` + `"args": [...]` (셸을 안 거치고 직접 실행. **Windows 권장**)

## 동봉 예시 (opt-in)

파일: `templates/.claude/hooks.example.json` + `templates/.claude/hooks/*.sh` · `*.ps1`.
쓸 항목만 `settings.json`에 붙여넣는다. **같은 기능의 bash/PowerShell 변형을 둘 다 켜면 두 번 돈다** — 하나만.

### ① 저장 시 포맷 — `format-on-edit.sh` / `.ps1`
Edit/Write 직후 **확장자별 포매터**를 실행(ts/js/json/css→prettier, py→ruff/black, go→gofmt, rs→rustfmt). **포매터가 설치 안 됐으면 조용히 넘어가** 워크플로를 절대 깨지 않는다. `.cs/.xaml`은 `dotnet format`이 솔루션 단위라 느려서 기본 제외(필요 시 스크립트에서 추가).

### ② 표준 파일 직접수정 차단 — `guard-standard-files.sh` / `.ps1`
헤더에 `claude-code-standard` 마커가 있는 파일을 레포에서 직접 수정하려 하면 **exit 2로 차단**. GOVERNANCE §5(포크 드리프트 금지)를 사람 규율이 아니라 결정론적으로 강제. **스택 무관·안전 — 가장 먼저 도입 추천.**

> 참고: `.claude/`·`.vscode/`·`.git/`는 **protected paths**라 어떤 모드에서도 자동 승인되지 않고 매번 확인을 받는다.
> 즉 이 훅이 없어도 몰래 수정되지는 않는다. 훅의 가치는 "확인을 거쳐도 **아예 못 하게**" 만드는 데 있다.

### ③ (선택) 종료 시 린트/테스트 게이트 — `Stop` 이벤트
응답이 끝날 때 린트/테스트를 돌려 실패 시 재작업을 유도한다. **루프 위험**이 있어 신중히.
`Stop`은 matcher를 받지 않으므로 아래처럼 쓴다(스택에 맞는 명령으로 교체):

```json
"Stop": [
  { "hooks": [
      { "type": "command",
        "command": "powershell.exe",
        "args": ["-NoProfile","-ExecutionPolicy","Bypass","-Command",
                 "ruff check . ; if ($LASTEXITCODE -ne 0) { [Console]::Error.WriteLine('lint 실패 — 고치고 다시'); exit 2 }"] }
  ] }
]
```

## Windows에서 켜기 (권장 경로)

1. `hooks.example.json`에서 **`*_powershell` 표시가 있는 블록**을 `.claude/settings.json`의 `hooks` 키로 복사.
2. 형태 확인 — exec form이라 `command`가 `"powershell.exe"`이고 `args`에 `-File ${CLAUDE_PROJECT_DIR}/...ps1` 이 들어간다.
3. 새 세션에서 파일 하나를 편집해 훅이 도는지 확인.
4. 동봉 `.ps1`은 **UTF-8 with BOM**으로 저장되어 있다 — PowerShell 5.1이 한글을 깨지 않게 하려면 필요하다. 수정 후 저장할 때 인코딩을 유지할 것.

Git Bash가 팀 전원에게 보장된다면 `.sh` 변형(+`jq` 필요)을 써도 된다. 못 하면 강제하지 말고 `.ps1`만 쓴다.

## 주의: VS Code `autosave`와의 상호작용

VS Code 확장은 기본적으로 Claude가 파일을 읽거나 쓰기 전에 **에디터의 미저장 변경을 저장**한다(`claudeCode.autosave`).
여기에 포맷 훅이 붙으면 *저장 → Claude 편집 → 훅 포맷 → 에디터 리로드* 가 연달아 일어난다.
편집 중인 파일에 포맷 훅을 걸 때는 한 번 눈으로 확인하고 도입할 것.

## 안전 원칙

- 훅에서 **파괴적 명령을 자동 실행하지 않는다**(포맷·린트·검증 같은 안전한 것만).
- 훅은 임의 셸을 실행하므로, 팀 커밋 훅은 **오너 리뷰**를 거친다(GOVERNANCE).
- 환경 의존이 크면 강제하지 말고 예시로만 둔다 — 안 도는 훅은 오히려 신뢰를 깎는다.
- PreToolUse 훅이 `"allow"`를 반환해도 **critical path 삭제**(드라이브 루트·홈·작업 디렉토리 등)는 내장 차단기가 막는다. 훅으로 안전장치를 우회하려 하지 말 것.

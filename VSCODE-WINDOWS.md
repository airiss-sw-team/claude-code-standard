# VS Code + Windows 가이드 (VSCODE-WINDOWS)

우리 팀 대부분은 **Windows에서 VS Code 확장**으로 개발합니다. CLI 기준으로 쓰인 일반 문서와
**실제로 다르게 동작하는 지점**만 모았습니다. 일상 사용법은 [GUIDE.md](GUIDE.md), 적용 절차는 [ADOPTION.md](ADOPTION.md).

---

## 1. 설치 — 확장과 CLI를 **둘 다** 깐다

| | 하는 일 | 없으면 |
|---|---|---|
| **VS Code 확장** (`anthropic.claude-code`) | 일상 개발. 인라인 diff, 플랜 리뷰, 체크포인트, `@` 멘션 | 개발 불가 |
| **CLI** (`claude`) | `claude mcp add` · `claude doctor` · `claude plugin` · `claude --resume` · 전체 슬래시 명령 | 위 명령들을 못 씀 |

> ⚠ **확장을 설치해도 터미널의 `claude` 명령은 생기지 않습니다.** 확장은 CLI 사본을 내부에 품고 있을 뿐
> PATH에 등록하지 않습니다. `claude --version`이 안 된다고 설치가 실패한 게 아닙니다.

```powershell
# CLI 설치 (PowerShell)
irm https://claude.ai/install.ps1 | iex
claude --version
```

**Git for Windows 설치를 권장합니다.** 없으면 Claude Code는 Bash 도구 없이 **PowerShell 도구**만 씁니다(2절).
설치했는데 못 찾으면 `~/.claude/settings.json`에:

```json
{ "env": { "CLAUDE_CODE_GIT_BASH_PATH": "C:\Program Files\Git\bin\bash.exe" } }
```

통합 터미널(`` Ctrl+` ``)에서 `claude`를 실행하면 IDE와 자동 연동됩니다(diff 뷰어·진단 공유).
외부 터미널이면 세션 안에서 `/ide`로 연결하세요.

---

## 2. 권한 — Bash와 PowerShell을 **병기**해야 한다

Claude Code가 셸 명령을 실행하는 도구는 환경에 따라 **둘 중 하나 또는 둘 다**입니다.

| 환경 | 셸 도구 |
|---|---|
| Git for Windows 없음 | **PowerShell 도구만** |
| Git for Windows 있음 | Bash + PowerShell (claude.ai/Console 계정은 PowerShell 기본 ON) |
| WSL | Bash |

따라서 `.claude/settings.json`에 `Bash(...)`만 써두면 **Git Bash 없는 팀원에게는 허용목록이 하나도 매칭되지 않습니다.**
표준 baseline은 이미 병기해 두었습니다. 스택 명령을 추가할 때도 같은 규칙:

```json
"allow": [
  "Bash(dotnet build:*)", "PowerShell(dotnet build *)",
  "Bash(dotnet test:*)",  "PowerShell(dotnet test *)"
]
```

PowerShell 규칙은 **별칭이 정규화**되므로 cmdlet 이름으로 쓰면 됩니다(`Get-ChildItem` 규칙이 `ls`·`dir`·`gci`를 다 커버).

### 이미 내장으로 막혀 있는 것 (직접 deny 쓸 필요 없음)

- `rm`/`rmdir`이 **파일시스템 루트, 홈, Windows 드라이브 루트(`C:\`)와 그 최상위, 작업 디렉토리와 그 상위**를 지우려 하면
  allow 규칙이나 PreToolUse 훅이 허용해도 **내장 차단기**가 막습니다.
- PowerShell `Remove-Item`은 더 엄격 — 시스템 경로와 와일드카드(`*`, `\*`)는 **모든 모드에서 무조건 거부**.
- `.git`·`.vscode`·`.claude`·`.idea` 등은 **protected paths**라 어떤 모드에서도 자동 승인되지 않습니다.
  `Edit(.claude/**)` 같은 allow 규칙을 써도 이 보호는 풀리지 않습니다.

→ 우리가 직접 써야 하는 건 `rm` 방어가 아니라 **장비·DB·배포 명령의 `ask` 규칙**입니다. `ask`는 auto 모드에서도
분류기를 건너뛰고 사람에게 묻습니다.

---

## 3. ⚠ 권한 **시작 모드**는 레포가 정할 수 없다

VS Code 확장이 새 대화의 권한 모드를 정하는 순서:

1. `claudeCode.initialPermissionMode` — **VS Code 사용자 설정만**. 워크스페이스(`.vscode/settings.json`) 값은 **무시**
2. 확장에서 이전에 직접 고른 모드
3. `permissions.defaultMode` — **managed settings 또는 `~/.claude/settings.json`** 에서만
4. 내장 기본값 — **Pro/Max/Team 플랜은 `auto`**

> **즉 VS Code 대화는 프로젝트의 `.claude/settings.json`을 시작 모드 결정에 쓰지 않습니다.**
> 레포에 무엇을 커밋해도 팀원의 시작 모드는 바뀌지 않고, 기본은 **Auto 모드**(사람 대신 분류기가 검토)입니다.

**장비 제어·DB가 걸린 레포라면 팀 차원의 결정이 필요합니다.** 통제 수단은 두 가지뿐:

- **개인**: VS Code 사용자 설정에 `"claudeCode.initialPermissionMode": "default"`(Manual) 또는 `"plan"`
- **조직**: managed settings (5절)

`.claude/settings.json`의 `permissions.allow`/`ask`/`deny` 자체는 **모드와 무관하게 잘 동작합니다.**
`deny`·`ask`는 폴더 신뢰 전에도 즉시 적용되고, `allow`만 신뢰 수락 후 적용됩니다.

### 대신 레포가 강제할 수 있는 것

`.vscode/settings.json`(커밋됨)의 워크스페이스 값은 사용자 값을 이깁니다:

```json
{ "claudeCode.allowDangerouslySkipPermissions": false }
```

이 한 줄이 **Bypass permissions 모드를 모드 선택기에서 제거**합니다. 표준 템플릿에 포함되어 있습니다 — 완화 금지.

---

## 4. 훅은 PowerShell 변형을 쓴다

동봉 훅은 `.sh`(Git Bash + jq 필요)와 `.ps1`(PowerShell만 필요) **두 벌**입니다.
Windows 팀은 `.ps1` 변형을 쓰면 jq도 Git Bash도 필요 없습니다.

```json
{
  "type": "command",
  "command": "powershell.exe",
  "args": ["-NoProfile", "-ExecutionPolicy", "Bypass",
           "-File", "${CLAUDE_PROJECT_DIR}/.claude/hooks/guard-standard-files.ps1"]
}
```

- `.ps1` 파일은 **UTF-8 with BOM**으로 저장되어 있습니다(PowerShell 5.1이 한글을 깨지 않게 하려면 필요).
- `matcher`에 `MultiEdit`를 쓰지 마세요 — 레거시 도구명이라 매칭되지 않습니다. `Edit|Write`로 충분.
- `Stop` 이벤트는 `matcher`를 지원하지 않습니다(항상 발화).
- 확장의 `claudeCode.autosave`(기본 켜짐)와 포맷 훅이 겹칠 수 있습니다 — 편집 중인 파일에 훅을 걸 땐 확인하세요.

자세한 건 [HOOKS.md](HOOKS.md).

---

## 5. 조직 차원 강제 (managed settings)

VS Code 팀에게 **시작 권한 모드를 통제할 유일한 수단**입니다. GPO/MDM으로 배포합니다.

- 설정: `C:\ProgramData\ClaudeCode\managed-settings.json`
- 전사 지침: `C:\Program Files\ClaudeCode\CLAUDE.md` (또는 managed settings의 `claudeMd` 키)

```json
{
  "permissions": {
    "defaultMode": "default",
    "disableAutoMode": "disable",
    "deny": ["Read(**/.env)", "Read(**/*.pem)", "Read(**/*.pfx)"]
  },
  "requiredMinimumVersion": "2.1.200"
}
```

managed 레이어는 **모든 설정을 이기고 개인이 완화할 수 없습니다.** [GOVERNANCE.md](GOVERNANCE.md) §2의
"deny 삭제 금지"를 사람 규율이 아니라 기술적으로 강제하는 방법입니다.
`disableAutoMode: "disable"`은 Auto 모드를 선택지에서 아예 제거합니다.

---

## 6. 샌드박스는 없다 — 대신 체크포인트

| 환경 | 샌드박싱 |
|---|---|
| 네이티브 Windows | **미지원** |
| WSL 2 | 지원 |
| WSL 1 | 미지원 |

업계 표준 처방인 "허용목록 + 샌드박스 + 훅"에서 우리는 **가운데가 없습니다.**
대신 VS Code 확장의 **체크포인트(되감기)** 가 실질적인 undo입니다 — 메시지에 마우스를 올리면
*코드만 되감기 / 대화 분기 / 둘 다* 를 고를 수 있습니다. 큰 변경 전에 이걸 기억해 두세요.

---

## 7. 알아두면 좋은 VS Code 기능

| 동작 | 방법 |
|---|---|
| 에디터 ↔ Claude 포커스 토글 | `Ctrl+Esc` |
| 선택 영역을 `@파일#줄범위`로 삽입 | `Alt+K` |
| 새 대화를 에디터 탭으로 | `Ctrl+Shift+Esc` |
| 닫은 세션 복구 | `Ctrl+Shift+T` |
| 도구 호출 접기(Focus view) | `Ctrl+Alt+F` |
| **터미널 출력 넘기기** | 프롬프트에 `@terminal:<터미널명>` — 빌드 로그를 복붙 없이 전달 |
| 플러그인 관리 | 프롬프트에 `/plugins` (Plugins / Marketplaces 탭) |
| 플랜 리뷰 | Plan 모드에서 플랜이 Markdown 문서로 열리고 **인라인 코멘트**로 피드백 가능 |
| IDE 진단 읽기 | Claude가 `mcp__ide__getDiagnostics`로 Problems 패널을 직접 봅니다 |

> 💡 **IDE 진단 덕분에 LSP 플러그인(`csharp-lsp` 등)은 대체로 불필요합니다.** C# Dev Kit·Pylance가
> 이미 채워주는 Problems 패널을 Claude가 그대로 읽습니다.

### 선택 영역이 자동으로 전송된다

확장이 붙어 있으면 **현재 에디터 선택 영역과 활성 파일 경로가 매 프롬프트에 자동 포함**됩니다
(대화에 `⧉ Selected N lines from ...`로 표시). 이걸 막는 방법은 **`Read` deny 규칙**뿐입니다 —
deny가 걸린 파일은 선택 텍스트도, 열린 파일 알림도 Claude에게 가지 않습니다.

→ `.claude/settings.json`의 `Read(**/.env)` 류 deny는 "읽기 금지"만이 아니라
**"실수로 열어둔 시크릿 파일이 프롬프트에 딸려가지 않게" 하는 장치**입니다. 팀 시크릿 파일 패턴을 빠짐없이 넣으세요.

---

## 8. CLI가 필요한 순간

VS Code 확장은 슬래시 명령의 **부분집합**만 노출하고, `!` bash 단축과 Tab 자동완성이 없습니다.
아래는 통합 터미널에서 `claude`로:

- `claude doctor` — 설정 파일 검증 (채택 직후 1회 필수)
- `claude mcp add ...` — MCP 서버 추가
- `claude plugin validate ./plugin` — 플러그인 검증
- `claude --resume` — 확장에서 하던 대화를 CLI에서 이어받기 (기록 공유됨)

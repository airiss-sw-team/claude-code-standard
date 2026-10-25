# 적용 플레이북 (ADOPTION)
> **독자**: 레포에 표준을 적용하는 사람. **읽는 시점**: 레포당 1회, 수동 적용이나 검증이 필요할 때

레포에 이 표준을 적용하는 절차. 두 경우로 나뉩니다.

> **빠른 길**: `templates/` 내용을 복사한 뒤 레포에서 **`/adopt-standard`** 를 실행하면 아래 절차(스택 감지 → rule 정리/생성 → CLAUDE.md 채움 → gitignore → 검증)를 Claude가 자동으로 수행합니다. 아래는 수동 절차이자 자동 실행의 명세입니다.
>
> **아이디어/기획 단계라면**: 코드가 없어도 시작할 수 있습니다. 기획서와 아이디어 메모를 `docs/10_Raw_Sources/`에 넣고, `architecture.md`에 설계 의도를 먼저 적으세요. 스택이 정해지는 순간 `/adopt-standard`로 rule을 생성하면 됩니다.
>
> 💻 Windows + VS Code에서 다르게 동작하는 부분은 [VSCODE-WINDOWS.md](VSCODE-WINDOWS.md).

## `.template` 파일이 뭔가요? (처음이라면 여기부터)

이름이 `.template`로 끝나는 파일은 **아직 채우지 않은 뼈대**입니다. 안에 `{{ONE_LINE_SUMMARY}}` 처럼 `{{ }}`로 감싼 **자리표시자(placeholder)**가 들어 있어요.
`.template` 확장자가 붙은 이유: Claude가 이걸 진짜 `CLAUDE.md`로 착각해 자동으로 읽어버리는 사고를 막기 위해서입니다. **채우기 전엔 로드 안 됨.**

**쓰는 법 = 2단계:**

```
① 이름에서 .template 를 뗀다   →  CLAUDE.md.template  ⟶  CLAUDE.md
② 안의 {{...}} 를 실제 값으로 채운다
```

②를 채우는 방법은 두 가지 — **둘 중 하나만** 하면 됩니다:

| | 방법 | 언제 |
|---|---|---|
| **권장** | 레포에서 **`/adopt-standard`** 실행 (또는 *"이 레포 기준으로 CLAUDE.md.template 채워서 CLAUDE.md로 만들어줘"*) | Claude가 코드를 스캔해 **①이름변경 + ②채움**을 자동으로. 대부분 이걸 쓰세요 |
| 수동 | 직접 이름 바꾸고 `{{...}}`를 타이핑 | 자동 결과를 손보거나, 소규모라 직접 하고 싶을 때 |

**끝났는지 확인**: 파일에 `{{` 가 하나도 안 남아 있으면 완료. 남아 있으면 아직 안 채운 것입니다.
(같은 방식이 `architecture.md.template`, `CLAUDE.local.md.template` 에도 똑같이 적용됩니다.)

---

## 공통: 복사 맵

`templates/` 안의 내용을 대상 레포 루트로 복사한 뒤, 아래처럼 처리한다:

| 원본 (templates/ 안) | 대상 레포에서 |
|---|---|
| `.claude/` | 그대로 `<repo>/.claude/` |
| `.vscode/` | 그대로 `<repo>/.vscode/`. **이미 있으면 덮어쓰지 말고 `claudeCode.*` 키만 병합** |
| `docs/` | 그대로 `<repo>/docs/` |
| `CLAUDE.md.template` | `CLAUDE.md`로 **이름 변경** 후 placeholder 채움 |
| `docs/20_The_Wiki/architecture.md.template` | `architecture.md`로 **이름 변경** 후 채움 |
| `gitignore.snippet` | `.gitignore`에 **내용 append 후 스니펫 파일 삭제** |
| `CLAUDE.local.md.template` | (선택) 개인 메모를 원하면 `CLAUDE.local.md`로 이름 변경, 아니면 삭제 |

⚠ **gitignore 주의**: 대상 레포에 스택 표준 `.gitignore`(예: .NET의 `bin/`, `obj/`, `.vs/`, Node의 `node_modules/`, Python의 `__pycache__/`)가 없으면 **그걸 먼저 만들고** 스니펫을 append 한다. 스니펫은 Claude 관련 항목만 담고 있다.
⚠ 레포가 `.vscode/`를 통째로 무시하고 있다면 `!.vscode/settings.json`, `!.vscode/extensions.json` 예외를 뚫는다.

## 공통: 스택 rule 선택

`.claude/rules/`의 **`.md` 파일은 전부 자동 로드**되므로, `general-engineering.md`(항상 유지) + 이 레포 스택 파일만 남기고 **나머지는 반드시 삭제**한다.
(`_README.txt`와 `_TEMPLATE-new-stack.md.template`은 `.md`가 아니라 로드되지 않으므로 그대로 둬도 무방하다.)

| 이 레포가… | 남길 rule | settings.json allow에 추가할 예시 (Bash + PowerShell 병기) |
|---|---|---|
| 웹 **프론트엔드** (React/Next 등) | `web-react-next.md` | `Bash(npm run build:*)` + `PowerShell(npm run build *)` |
| **Python** (FastAPI 등 웹 백엔드, CLI, 스크립트, ML 포함) | `python.md` | `Bash(pytest:*)` + `PowerShell(pytest *)`, `ruff`, `uv run` |
| 모바일/앱 (iOS, Android, Flutter, RN, Electron) | `mobile-app.md` | `Bash(flutter:*)` + `PowerShell(flutter *)`, `gradle`, `xcodebuild` |
| .NET / WPF 데스크톱 | `dotnet-wpf-prism.md` | `Bash(dotnet build:*)` + `PowerShell(dotnet build *)`, `dotnet test`, `dotnet format` |
| 그 외 스택 (Go, Rust, …) | 새 파일 추가(예: `go.md`) | 해당 스택 빌드/테스트 명령 |

⚠ **allow는 Bash와 PowerShell을 반드시 병기한다.** 네이티브 Windows에서 Git for Windows가 없으면 **Bash 도구 자체가 없어** `Bash(...)` 규칙이 하나도 매칭되지 않는다. 병기하지 않으면 팀원마다 승인 프롬프트 경험이 갈린다.

⚠ **deny와 ask 규칙은 삭제하거나 완화하지 않는다** — 필요하면 표준 레포 PR로(GOVERNANCE §2). 파괴적이거나 장비를 움직이는 명령(DB 마이그레이션, 장비 제어, 배포)은 `ask`에 추가한다 — `ask`는 auto 모드에서도 분류기를 건너뛰고 사람에게 묻는다.

### skills와 agents는 손대지 않는다

`.claude/skills/`(8개)와 `.claude/agents/`는 **스택 무관**이라 그대로 두면 된다. 삭제 대상은 rules 뿐이다.
스킬은 필요할 때만 로드되므로 안 쓰는 게 있어도 컨텍스트 비용이 거의 없다.
이 레포 고유 절차가 생기면 `.claude/skills/<이름>/SKILL.md` 로 추가한다.

### rule 파일 작성 규약

- **짧고 실행 가능하게.** 이 레포에서 실제로 지킬 것만. 안 지킬 규칙은 쓰지 않는다.
- **원칙은 rule, 절차는 skill.** 여러 단계를 밟는 작업을 rule에 적으면 매 세션 컨텍스트를 먹는다.
- 특정 파일에만 적용하려면 frontmatter에 `paths:`를 쓴다. 이러면 해당 패턴 파일을 다룰 때만 로드되어 컨텍스트를 아낀다:
  ```markdown
  ---
  paths:
    - "**/*.xaml"
  ---
  # XAML 전용 규칙...
  ```
- 프로젝트 고유 규칙은 이 폴더에 **새 파일**로 추가한다(표준에서 복사된 파일을 고치지 않는다).
- 범용화 가치가 있으면 표준 레포로 승격한다.
- 새 스택은 `_TEMPLATE-new-stack.md.template`을 복사해 10분 안에 작성한다.

---

## A. 신규 프로젝트 (코드가 거의 없을 때)

1. 위 **복사 맵**대로 복사, 이름변경, append를 수행한다.
2. 위 **스택 rule 선택**을 수행한다.
3. `CLAUDE.md`의 placeholder를 채운다. 빌드, 테스트, 실행 명령은 초안이라도 적는다.
4. `docs/20_The_Wiki/architecture.md`를 채운다(초기에는 설계 의도 수준이면 충분).
5. (선택) 레포 루트에서 `/init` 실행 → Claude가 CLAUDE.md 초안을 보강.
6. **검증**(아래 "검증 절차") 후 **커밋**: `CLAUDE.md`, `.claude/`, `.vscode/`, `docs/`, `.gitignore`. (`*.local.*`은 자동 제외됨)

## B. 기존 프로젝트 (이미 코드가 큰 레포)

1. 위 **복사 맵** + **스택 rule 선택**을 동일하게 수행한다.
2. **역설계로 CLAUDE.md 채우기**: 다음을 실제 코드 기준으로 기입.
   - 스택/프레임워크 (예: Next.js, FastAPI, Flutter, .NET/WPF — 이 레포의 실제 스택)
   - 빌드, 테스트, 실행 명령 (**실제로 한 번 돌려서 확인**)
   - **구조 지도**: 주요 디렉토리/모듈/서비스가 각각 무슨 역할인지 1줄씩
   - 코드 컨벤션 (네이밍, 폴더 규칙, 이 레포의 아키텍처 패턴)
3. **아키텍처 위키 작성**: `architecture.md`에 모듈 카탈로그와 계층도를 정리. `[[문서명]]`으로 상호 링크.
4. **권한 이관(중요)**: global `~/.claude/settings.json`에 흩어진 **이 레포 전용 allow 규칙**(빌드/테스트 등)을 레포 `.claude/settings.json`으로 옮긴다(Bash+PowerShell 병기).
   - (선택) 훅을 쓰려면 [HOOKS.md](HOOKS.md) 참고해 `hooks.example.json`에서 골라 settings.json에 붙인다. 기본 비활성이므로 안 쓰면 그대로 둬도 무방. **Windows는 `.ps1` 변형**을 쓰면 jq와 Git Bash가 필요 없다.
5. **검증**(아래) 수행.
6. **커밋**: A-6과 동일.

---

## 검증 절차 (양쪽 공통)

채택 직후 아래를 실제로 확인한다. "될 것이다"로 넘어가지 않는다.

1. **폴더 신뢰 수락** — 첫 세션에 뜨는 신뢰 다이얼로그를 수락한다.
   ⚠ 수락 전에는 `permissions.allow`가 **적용되지 않아** 계속 승인 프롬프트가 뜬다(`deny`와 `ask`는 즉시 적용).
2. **`claude doctor`** (통합 터미널) — 설정 파일에 Settings Error가 없는지.
3. **`/context`** — **Memory files** 목록에 `CLAUDE.md`와 **의도한 rule만** 로드됐는지. 삭제했어야 할 스택 rule이 남아 있으면 여기서 드러난다.
4. **`/`** 입력 — 이 레포의 커스텀 명령이 보이는지. (VS Code 확장은 명령 부분집합만 노출하므로, 안 보이면 통합 터미널의 CLI로.)
5. **빌드 명령 1회 실행** — CLAUDE.md에 적은 명령이 실제로 도는지.
6. **`git status`** — 공유/개인 파일이 의도대로 분리됐는지.

---

## 채택 후 유지 (업데이트 절차)

`git subtree`는 채택 시 파일명이 바뀌므로(`*.template` → 실파일) 쓸 수 없다. 대신:

1. 표준이 바뀌면 [CHANGELOG.md](CHANGELOG.md)에 기록되고 [VERSION](VERSION)이 올라간다.
2. 각 레포는 **분기 1회** 자기 `.claude/rules/`, `skills/`, `agents/`를 표준 레포의 `templates/` 버전과 **diff 비교**해 반영한다:
   ```bash
   diff -ru <repo>/.claude/rules/ <standard>/templates/.claude/rules/
   ```
3. 각 rule 파일 하단의 출처 표기(`표준 원본: claude-code-standard vX.Y`)로 어느 버전에서 왔는지 추적한다.
   ⚠ 표준 레포에서 rule 내용을 고칠 때는 **이 표기도 함께 올린다.** 안 그러면 추적 메커니즘이 무효가 된다.
4. 레포 고유 규칙은 **별도 파일**로 둔다. 표준에서 복사된 파일은 레포에서 직접 수정하지 않는다(수정이 필요하면 표준 레포에 PR).

## 체크리스트 (복붙용)

```
[ ] templates/ 내용 복사 (.claude/ + .vscode/ + docs/ 포함)
[ ] CLAUDE.md.template → CLAUDE.md 이름 변경
[ ] architecture.md.template → architecture.md 이름 변경
[ ] gitignore.snippet → .gitignore에 append 후 스니펫 삭제 (스택 표준 gitignore 먼저!)
[ ] .vscode/ 가 gitignore되고 있다면 settings.json, extensions.json 예외 뚫기
[ ] CLAUDE.local.md.template → 쓸 거면 이름 변경, 아니면 삭제
[ ] rules/에서 스택에 안 맞는 .md 삭제 (자동 로드되므로 필수)
[ ] CLAUDE.md placeholder 전부 치환
[ ] settings.json allow에 빌드/테스트 명령 추가 — Bash + PowerShell 병기
[ ] 위험 명령(DB 마이그레이션, 장비 제어, 배포)을 ask에 추가
[ ] 폴더 신뢰 다이얼로그 수락
[ ] claude doctor 실행 (Settings Error 없음)
[ ] /context 로 로드된 rule 확인
[ ] 빌드/테스트 명령 실제 실행으로 확인
[ ] (기존 레포) global settings.json → repo settings.json 권한 이관
[ ] docs/20_The_Wiki/architecture.md 작성
[ ] git status로 공유/개인 분리 확인 후 커밋
```

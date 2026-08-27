# 거버넌스 (GOVERNANCE)
> **독자**: 표준 오너 · 레포 메인테이너 · **읽는 시점**: 분기 점검 · 규칙을 바꾸거나 무엇을 커밋할지 정할 때

"무엇을 공유하고 무엇을 개인으로 두는가"와 표준 운영 규칙.

## 1. 공유(커밋) vs 개인(gitignore)

| 파일/폴더 | 성격 | git |
|---|---|---|
| `CLAUDE.md` | 프로젝트 오버뷰(팀 공유) | ✅ 커밋 |
| `.claude/rules/` | 코딩 규칙(팀 공유, `.md`는 자동 로드) | ✅ 커밋 |
| `.claude/skills/` | 슬래시 명령·절차(팀 공유) | ✅ 커밋 |
| `.claude/agents/` | 서브에이전트(팀 공유) | ✅ 커밋 |
| `.claude/settings.json` | 팀 공통 권한·설정 | ✅ 커밋 |
| `.vscode/settings.json` | VS Code 확장 팀 공통 설정 | ✅ 커밋 |
| `.vscode/extensions.json` | 권장 확장(onboarding) | ✅ 커밋 |
| `docs/10_Raw_Sources/` | 기획·리서치 원천 | ✅ 커밋(민감정보 제외) |
| `docs/20_The_Wiki/` | AI가 관리하는 아키텍처 위키 | ✅ 커밋 |
| `CLAUDE.local.md` | 개인 메모·실험 | ❌ gitignore |
| `.claude/settings.local.json` | 개인 권한·오버라이드 | ❌ gitignore |

**레포 밖(사용자 전역·머신 로컬)에 저장되어 관리 대상이 아닌 것**:

- 세션·플랜·히스토리 — `~/.claude/`
- **auto memory** — `~/.claude/projects/<project>/memory/`. Claude가 대화 중 스스로 기록하는 메모로 **기본 켜짐**이며 팀에 공유되지 않는다. 무엇이 저장됐는지 `/memory`로 주기적으로 확인하고, 민감정보가 들어갔으면 지운다. 끄려면 `settings.json`에 `"autoMemoryEnabled": false`.
- VS Code 사용자 설정(`claudeCode.initialPermissionMode` 등) — 워크스페이스 값이 무시되는 키가 있다([VSCODE-WINDOWS.md](VSCODE-WINDOWS.md) 3절).

**원칙**: 커밋되는 것은 **비밀이 없어야** 한다. API 키·비밀번호·토큰은 절대 `settings.json`이나 `CLAUDE.md`에 넣지 않는다(개인 `settings.local.json` 또는 별도 시크릿 관리).

## 2. settings.json 분리 규약

- **공유 `settings.json`**: 팀 전체가 동일하게 필요한 안전한 권한만. 예) 해당 레포의 빌드/테스트/조회 명령. **Bash와 PowerShell을 병기**한다.
- **개인 `settings.local.json`**: 개인 취향·실험적 권한·머신 특화 경로. 커밋 안 됨.
- 위험한 권한(광범위 삭제, 무제한 네트워크 등)은 공유에 넣지 않는다.
- **`deny` 규칙은 레포에서 추가만 가능, 삭제 금지.** 표준 baseline의 deny(예: `.env` 읽기 금지)를 완화하려면 표준 레포 PR로만 한다.
- **위험 명령은 `ask`에 넣는다.** `ask`는 auto 모드에서도 분류기를 건너뛰고 사람에게 묻는다. `deny`·`ask`는 폴더 신뢰 전에도 즉시 적용되지만 `allow`는 신뢰 수락 후에 적용된다.
- **`.vscode/settings.json`의 `claudeCode.allowDangerouslySkipPermissions: false`는 완화 금지.** 워크스페이스 값이 개인 값을 이기므로, 이 한 줄이 레포 차원의 skip-permissions 방어다.

> ⚠ **VS Code 승인 카드 주의**: 권한 프롬프트에서 "다시 묻지 않음"을 고를 때, VS Code 확장은 저장 위치로
> **프로젝트 공유 파일(`.claude/settings.json`)** 을 선택할 수 있게 해준다(CLI는 개인 파일에만 쓴다).
> 기본은 항상 **Local(`settings.local.json`)** 을 고르고, 공유 규칙 추가는 PR로. 공유 파일이 바뀌면
> `git status`에 잡히므로 커밋 전에 확인할 것.

### 조직 차원 강제 (managed settings) — 검토 중

문서로 부탁하는 대신 **기술적으로 강제**하는 계층이 있다. GPO/MDM으로 배포한다.

- `C:\ProgramData\ClaudeCode\managed-settings.json` — 모든 설정을 이기고 개인이 완화할 수 없다.
- `C:\Program Files\ClaudeCode\CLAUDE.md` — 전사 지침(개인 설정으로 제외 불가).

특히 **VS Code 확장은 프로젝트 `.claude/settings.json`을 시작 권한 모드 결정에 쓰지 않으므로**,
시작 모드를 조직 차원에서 통제하려면 managed settings가 유일한 수단이다. 상세: [VSCODE-WINDOWS.md](VSCODE-WINDOWS.md) 5절.

## 3. 소유권 & 변경 절차

- **표준 레포(claude-code-standard) 오너**: **airiss-hgko** (표준 도입 주도자. 변경 시 이 줄을 갱신할 것.)
- 범용 규칙(rules 코어, 템플릿) 변경은 이 레포에서 PR로. 머지 시 [CHANGELOG.md](CHANGELOG.md) 기록 + [VERSION](VERSION) 증가.
- **레포별 규칙**: 각 레포의 `.claude/`는 그 레포 메인테이너가 관리. 단, **표준에서 복사된 파일은 레포에서 직접 수정하지 않는다** — 수정이 필요하면 표준 레포에 PR 후 재배포. 레포 고유 규칙은 별도 파일로.
- **전파**: 표준 변경 → 각 레포가 분기 diff 점검으로 반영([ADOPTION.md](ADOPTION.md) "채택 후 유지").

## 4. 리뷰 주기

- **분기 1회** 표준 점검: 죽은 규칙 제거, Claude Code 신기능 반영, 실제로 안 지켜지는 규칙 현실화, 각 레포 drift 점검.
- **다음 점검 예정: 2026-11** (직전 점검: 2026-08, v0.7 — VS Code/Windows 정합성 감사)
- 점검 시 확인할 것: 공식 문서 변경(권한 문법·훅 이벤트·기본 권한 모드), 각 rule 파일의 출처 버전 표기가 [VERSION](VERSION)과 맞는지, 안 쓰는 rule이 남은 레포가 있는지.
- CLAUDE.md가 **길어지면 경고 신호**. 상세는 `rules/`로 밀고 CLAUDE.md는 포인터로 유지. `/doctor`가 가지치기를 제안해준다.
- **문서 개수 임계**: 표준 레포 루트의 `.md` 가 **10개를 넘으면** `guides/` 폴더로 분리한다. 그 전까지는 루트 평면 유지(GitHub 랜딩에서의 발견성이 더 중요하다).
- **단일 출처 점검**: 같은 절차가 두 문서에 적혀 있으면 하나를 링크로 바꾼다. 복사본은 반드시 낡는다.

## 5. 안티패턴 (하지 말 것)

- ❌ CLAUDE.md에 모든 규칙을 다 넣어 비대하게 만들기 → 항상 로드되어 컨텍스트 낭비. rules/로 분리.
- ❌ 스택에 안 맞는 rule을 남겨두기 → **자동 로드되므로 그대로 적용되어 오염됨.** 반드시 삭제.
- ❌ `.claude/rules/`에 사람용 안내 문서를 `.md`로 두기 → 그것도 매 세션 로드된다. 안내는 `.txt`나 표준 레포 문서로.
- ❌ **여러 단계를 밟는 절차를 rule에 적기** → rule은 항상 로드되므로 컨텍스트를 먹는다. 절차는 `skills/`로(필요할 때만 로드).
- ❌ 같은 설명을 여러 문서에 복사 → 단일 출처를 정하고 나머지는 링크.
- ❌ 개인 실험 권한을 공유 settings.json에 커밋 → 팀 전체에 강요됨.
- ❌ 비밀을 커밋 파일에 기입.
- ❌ 표준에서 복사된 rule을 레포에서 직접 수정(포크 drift) → diff 동기화가 깨짐. 표준 레포 PR로.
- ❌ 표준 baseline의 deny 규칙을 레포에서 삭제.

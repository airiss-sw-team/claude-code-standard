# Changelog

표준 변경 이력. 버전은 [VERSION](VERSION)과 동기.

## 0.7.0 — 2026-08-27

**Windows + VS Code 정합성 감사 반영.** 공식 문서와 전면 대조해 사실이 틀렸거나 우리 환경에서 작동하지 않던 부분을 수정.

### 추가
- **[VSCODE-WINDOWS.md](VSCODE-WINDOWS.md) 신설** — 우리 팀 기본 환경(Windows + VS Code 확장)에서 CLI 기준 문서와 다르게 동작하는 지점만 모음: 설치(확장은 `claude`를 PATH에 넣지 않음)·Bash/PowerShell 도구 분기·시작 권한 모드·훅·managed settings·샌드박스 미지원·체크포인트.
- **`templates/.vscode/settings.json` + `extensions.json`** — `extensions.json`으로 원클릭 온보딩. `settings.json`의 `claudeCode.allowDangerouslySkipPermissions: false`는 워크스페이스 값이 개인 값을 이기므로 **레포 차원의 skip-permissions 방어**가 된다.
- **PowerShell 훅 변형** `format-on-edit.ps1` · `guard-standard-files.ps1` — jq·Git Bash 없이 동작. UTF-8 BOM 저장(PS 5.1 한글). Windows에서 실제 실행 검증 완료.
- ADOPTION에 **검증 절차** 신설 — 폴더 신뢰 수락 → `claude doctor` → `/context` → `/` 명령 확인 → 빌드 1회.
- GUIDE에 **빌트인 명령 표**(`/code-review` `/security-review` `/context` `/doctor` `/plugins` `/usage`)와 체크포인트·`@terminal:`·VS Code 단축키.

### 수정 (동작이 틀렸던 것)
- **권한 규칙에 `PowerShell(...)` 병기** — 네이티브 Windows에서 Git for Windows가 없으면 Bash 도구 자체가 없어 기존 `Bash(...)` 전용 allow가 **하나도 매칭되지 않았다.**
- **`Bash(rm -rf /:*)` deny 삭제** — `:*`는 trailing wildcard라 `rm -rf /`로 시작하는 문자열만 매칭했다. 게다가 드라이브 루트·홈·작업 디렉토리 삭제는 **내장 차단기**가 이미 allow 규칙과 훅을 무시하고 막는다. 대신 `git push`·`git reset --hard` 등을 **`ask`** 로, 시크릿 파일 패턴을 `deny`로 확장(`.pfx`·`.p12`·`appsettings.Production.json` 추가).
- **`Read(**)` allow 삭제** — 읽기는 작업 디렉토리 내에서 기본 승인이라 무의미했다.
- **hooks.example.json 3건** — `MultiEdit` matcher(레거시 도구명이라 무효) 제거, `Stop`의 `matcher`(미지원) 제거, 붙여넣어도 아무 일도 안 하던 빈 `"hooks": []` 블록 제거. `$CLAUDE_PROJECT_DIR` → `${CLAUDE_PROJECT_DIR}`.
- **`.claude/rules/_index.md` 제거** → `_README.txt`로 대체. `.md`는 전부 자동 로드되므로 40줄짜리 사람용 안내가 **매 세션 컨텍스트를 먹고 있었다.** 내용은 ADOPTION "rule 파일 작성 규약"으로 이관.
- **rule 출처 표기 v0.1 → v0.7 동기화** — VERSION은 0.6.0인데 표기가 v0.1에 멈춰 있어 "출처 버전으로 추적" 메커니즘이 이미 무효였다. ADOPTION에 "내용 수정 시 표기도 함께 올린다" 명시.
- **`/review`(gstack) → `/code-review`(빌트인) 통일** — START-HERE는 "gstack 없어도 된다"면서 gstack 명령을 안내하고 있었다.
- **Plan 모드 안내 분리** — `Shift+Tab`은 CLI 제스처. VS Code는 모드 인디케이터 클릭(+ 플랜을 Markdown 문서로 열어 인라인 코멘트).
- **START-HERE 0단계 재작성** — 확장만 설치하면 `claude --version`이 실패한다는 사실(확장은 PATH에 등록하지 않음)이 빠져 있어 초보자가 첫 단계에서 막혔다. PowerShell 명령 병기(`&&`는 PS 5.1에서 파서 에러).
- **`AR.App.*` 내부 모듈 접두사 제거**(BENCHMARKS) — 이 레포는 public.

### 문서화된 새 사실
- **`allow`는 폴더 신뢰 수락 후에만 적용**되고 `deny`·`ask`는 즉시 적용된다 → "clone만 하면 동일 권한"은 부정확했다.
- **VS Code 확장은 프로젝트 `.claude/settings.json`을 시작 권한 모드 결정에 쓰지 않는다.** Pro/Max/Team 기본은 `auto`. 조직 통제는 managed settings뿐 → GOVERNANCE §2에 managed settings 절 신설.
- **VS Code 승인 카드는 공유 `settings.json`에 직접 쓸 수 있다**(CLI는 개인 파일에만) → 새 안티패턴.
- **선택 영역·열린 파일이 매 프롬프트에 자동 포함**되며, 이를 막는 유일한 수단이 `Read` deny 규칙 → deny 목록의 의미가 커졌다.
- **`.claude`·`.vscode`·`.git`은 protected paths** — 어떤 모드에서도 자동 승인되지 않는다.
- **네이티브 Windows는 샌드박스 미지원**(WSL2만) → 대신 체크포인트(되감기)를 팀 기본기로.
- **IDE 진단**(`mcp__ide__getDiagnostics`)으로 Problems 패널을 Claude가 직접 읽는다 → LSP 플러그인은 대체로 불필요. `general-engineering.md` 검증 항목에 추가.

### 미도입 (다음 버전 후보)
- 슬래시 명령 → **Skills** 이전(`.claude/commands/`는 계속 동작하지만 공식적으로 skills에 통합됨)
- **플러그인 + 사설 marketplace** 배포 모델 — 채택되면 분기 diff·출처 표기·포크 드리프트 훅이 모두 불필요해진다
- managed settings 실제 배포(GPO/MDM) — 팀 결정 필요
- 헤드리스/CI 통합


## 0.6.0 — 2026-07-16

- **START-HERE.md 추가 (초보자용 단계별 튜토리얼)** — 그동안 문서가 전부 레퍼런스라 "처음부터 끝까지 따라갈 단일 가이드"가 없던 문제 해소. 30초 흐름도(mermaid) + 용어 3개 + 준비물 + 새 프로젝트 5단계(아이디어→gstack 설계→템플릿 복사→/adopt-standard→리뷰→개발) + 기존 프로젝트 경로 + FAQ + 문서 지도. README 최상단에서 첫 진입점으로 강조.

## 0.5.0 — 2026-07-16

- **GUIDE.md gstack 섹션 대폭 보강** — 스킬 8개 카테고리(기획/설계/디자인/코드품질/QA/배포/안전장치/회고), 자주 쓰는 워크플로 조합 2종(새 기능 풀사이클·버그수정)과 그 외, 꿀팁(계획 우선·프로덕션엔 /careful·/retro→CLAUDE.md 선순환), 비용/Windows 주의. 사내 정리글(tistory 540 설치·549 워크플로) 링크.

## 0.4.1 — 2026-07-16

- **`.template` 사용법 문서화** — ADOPTION.md에 "`.template` 파일이 뭔가요?" 섹션 추가(2단계: 이름변경 → 채움, 수동 vs `/adopt-standard` 자동). README 채택 3단계에도 명시 + 링크. 팀원 온보딩 시 헤매지 않도록.

## 0.4.0 — 2026-07-16

- **general-engineering.md에 "핵심 행동 원칙" 추가** — Think Before Coding · Simplicity First · Surgical Changes · Goal-Driven. 특히 "코딩 전 추측 금지·트레이드오프 먼저 드러내기"(기존 rule의 공백). A. Karpathy 원칙(F. Chang 정리) + 사내 정리글 각색, 출처 표기. 모든 레포에 자동 적용.

## 0.3.0 — 2026-07-16

- **HOOKS.md + 훅 예시 추가** — 결정론적 강제 장치. 검증된 스키마 요약, opt-in 예시 2종:
  - `format-on-edit.sh` — 저장 시 확장자별 포맷(포매터 없으면 무해하게 skip, 스택 무관)
  - `guard-standard-files.sh` — "표준 원본" 마커 파일 직접수정 차단(포크 드리프트 방지, exit 2)
  - `hooks.example.json` — 기본 비활성. 환경 테스트 후 settings.json에 opt-in.
- rule vs hook 갭(v0.2에서 지적) 해소. README/GUIDE 링크 반영.

## 0.2.0 — 2026-07-16

- **GUIDE.md 추가** — 실전 사용 가이드: 팀 공통 기본기, 상황별 레시피(신규/기존/일상), gstack·디자인 스킬 활용(`/teach-impeccable` 등), rule vs hook 차이, 안티패턴.
- **BENCHMARKS.md 추가** — 타사/Anthropic 검증 패턴 7종 + 실패 사례 5종 + 우리 팀 우선 적용 3종. 전부 1차 출처 링크 포함.
- README에 GUIDE/BENCHMARKS 링크·트리 반영.

## 0.1.0 — 2026-07-16

최초 릴리스.

- 2-tier 구조(Global 개인 / Repo 팀 공유) + 스택 무관 코어 rule + 스택 모듈 설계
- rules: `general-engineering`(항상) + `web-react-next` · `python` · `mobile-app` · `dotnet-wpf-prism`
- commands: `/doc-sync` · `/fix-issue` · `/scaffold-feature` (스택 무관)
- agents: `code-reviewer`
- 문서: README · ADOPTION · GOVERNANCE, docs 위키 골격(10_Raw_Sources / 20_The_Wiki)
- **생성기 메커니즘**: `/adopt-standard`(스택 자동 감지 → rule 정리/생성 → CLAUDE.md 자동 채움) + `_TEMPLATE-new-stack.md.template`(임의 스택 rule 10분 작성 뼈대). 동봉 스택 rule 4종은 예시일 뿐, 어떤 스택이든 채택 시점에 rule 생성.
- 교차 검증(사양 정합성 + 일관성·온보딩 리허설) 반영:
  - `.claude/rules/` 자동 로드 사실 반영(안 쓰는 rule 삭제 필수로 명시)
  - gitignore 스니펫에서 사용자 전역 산출물 항목 제거
  - `architecture.md.template` 추가(신규 채택 깨진 링크 방지)
  - docs 골격을 `templates/` 아래로 통합(복사 출처 단일화)
  - VERSION/CHANGELOG/오너 지정, deny 완화 금지 규칙

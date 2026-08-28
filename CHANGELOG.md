# Changelog

표준 변경 이력. 버전은 [VERSION](VERSION)과 동기.

## 0.10.0 — 2026-08-28

**일일 업무로그 스킬 + 플러그인 설치 정책.**

### `/work-log` 스킬 신규
팀 업무 시트("SW 개발팀 업무 정리")의 **[업무 상세 내용(일일로그)] 칸에 그대로 붙여넣을 텍스트만** 만든다.
날짜·이름·프로젝트명·카테고리·상태·성과 칸은 건드리지 않는다.

- git 커밋에서 근거를 뽑되, 커밋 제목만으로 모호하면 `git show`로 본문을 확인한다. **파일명으로 추측하지 않는다.**
- **커밋이 없는 작업을 "작업 없음"으로 단정하지 않고 물어본다** — 기기 제작·납품 준비·물품 검수·문서 작성·인증 서류·회의·기술 지원·센서 조사 등 이 팀 업무의 상당수는 커밋이 남지 않는다.
- **프로젝트가 다르면 시트에서 행이 나뉘므로** 프로젝트 단위로 블록을 나눠 출력한다.
- 문체는 **실제 시트를 따랐다**: 한 줄 = 한 작업, 명사형 종결(`~ 추가` `~ 수정` `~ 정리`), 부연은 괄호로 짧게,
  버그는 "무엇이 안 되던 것"을 증상 중심으로, 미완은 `~ 진행 중`.
- 팀 공용어(V/H·캔버스·톤·드립·Detector·PLC·SAT)는 **그대로 쓰고**, 코드 안에서만 쓰는 이름(클래스·enum·필드)은 풀어 쓴다.
- 커밋 1개당 1줄이 아니라 **같은 주제 커밋은 한 줄로 합친다**. 오타·머지 같은 사소한 것은 뺀다.
- 마지막에 붙여넣을 텍스트와 구분해, 커밋으로 확인 안 된 작업이나 추측이 섞인 줄을 밝힌다.

※ 개인 전역에 있던 `daily-log`와 목적이 겹치지만 출력이 다르다(불릿 요약 vs 시트 셀 텍스트). 이름이 달라 충돌하지 않는다.

### GOVERNANCE §2에 "플러그인·마켓플레이스 설치 정책" 신설
플러그인은 **사용자 권한으로 임의 코드를 실행**한다(공식 문서 경고). 장비 제어 코드와 DB 접속 정보가 있는 개발 머신에서는 개인 노트북과 기준이 달라야 한다.

- 공식 마켓플레이스와 **오너 승인분만** 설치. SNS·블로그에서 본 이름으로 마켓플레이스를 추가하지 않는다.
- 조직 차원 잠금은 managed settings의 `strictKnownMarketplaces`.
- **많이 까는 게 좋은 게 아니다** — 플러그인은 매 턴 컨텍스트를 먹는다. `/plugin` 화면이 **Context cost**를 표시하고 2주 이상 미사용분을 **Not used recently**로 모아주는 이유. CLAUDE.md 비대화를 경계하는 것과 같은 이유다.
- 분기 점검 때 안 쓰는 플러그인 정리.

### GUIDE 5장에 `codex-plugin-cc` 검토 항목 추가
교차 모델 검증(4장 ③번)에 해당해 값어치가 있으나 **공식 마켓플레이스가 아니므로 오너 승인 후** 도입. gstack을 쓰면 `/codex`로 같은 효과.

## 0.9.0 — 2026-08-27

**검증(교차검증·다중 에이전트)을 표준에 편입.** 팀에서 이미 손으로 하던 것을 규격화했다.

### `verifier` 서브에이전트 신규
"검토"가 아니라 **반증(refute)** 을 하는 에이전트. 빌트인·공식 플러그인이 덮지 않는 영역이라 만들 값어치가 있다.

- **검증 대상은 하나의 명확한 주장이어야 한다.** 주장이 없으면("이거 검토해줘") 진행하지 않고 되묻는다.
- 절차: 주장 재진술 → **반증 조건 정의**(무엇이 관찰되면 틀린 것인가) → 증거 수집 → 판정.
  반증 조건을 먼저 적게 한 이유는, 이걸 안 정하고 코드를 읽으면 인상 비평이 되기 때문.
- 판정 3종: **반증됨**(구체적 입력→잘못된 결과가 있을 때만) / **버팀**(반증 시도 실패) / **판정 불가**(증거 부족 + 무엇이 더 필요한지).
- **불확실할 때 기본값은 "판정 불가"** — "반증됨"이 아니다. 서브에이전트에게 "문제 찾아줘"라고 하면 없어도 만들어내는 문제(BENCHMARKS 패턴 7의 caveat)를 프롬프트 차원에서 막는다.
  단 검증 대상이 *"다른 에이전트가 찾은 문제가 진짜다"* 인 경우엔 판정 불가 = 그 지적을 채택하지 않음.
- 금지: 가정한 시나리오로 반증하기, 스타일·취향 보고, 코드를 안 읽은 일반론.

### `code-reviewer` 에 `memory: project`
반복 지적 패턴이 세션을 넘어 누적된다. 같은 지적을 매번 처음부터 하지 않게 된다.
※ 이 기억은 **개인 머신에 쌓이며 git으로 팀 공유되지 않는다.** 팀 전체가 알아야 할 규칙이면 `.claude/rules/`로 승격하도록 에이전트 프롬프트에 명시.

### GUIDE 4장 "검증을 요구하는 법" 신설
그동안 GUIDE에는 *"code-reviewer로 검토해줘"* 한 줄뿐이라 팀에 공유된 기준이 없었다.

1. 검증 대상은 **하나의 명확한 주장**이어야 한다
2. **같은 프롬프트로 N마리는 검증이 아니라 반복** — 같은 편향이라 같이 틀린다. 렌즈를 다르게
3. 더 강한 방법은 **모델을 바꾸는 것**(오류 상관관계가 낮다) — gstack `/codex`
4. "문제 찾아줘"는 없는 문제를 만든다 → `verifier`로 프롬프트를 뒤집는다
5. 여러 플랜을 **합치지 말고 고르고 접붙인다**(합치면 무난한 중간값으로 수렴)
- 끝은 항상 **실행 가능한 증거**(빌드 출력·테스트 결과·재현 절차)
- **언제 쓰고 언제 낭비인가** 표 — *판정 가능하면 판정하고, 판정 불가능할 때만 에이전트를 늘린다*
- 이미 만들어진 것부터 쓰기: `/code-review ultra`(클라우드 다중 에이전트, 사용자 실행·별도 과금) · `pr-review-toolkit` · `/codex` · `verifier`

### 기타
- GUIDE 1장에 **서브에이전트 2종 표**(언제·부르는 법), 일상 루프에 verifier 한 줄, 안티패턴 2개 추가
  (같은 프롬프트 N마리 / 판정 가능한 걸 에이전트에게 묻기).
- 기존 4~8장을 5~9장으로 이동.
- rule·agent 출처 표기 v0.8 → **v0.9**.

## 0.8.0 — 2026-08-27

**`.claude/` 최신화 + 팀 워크플로 스킬 확충 + 문서 구조 정리.**

### commands → skills 이전 (구식 구조 탈피)
공식 문서: *"Custom commands have been merged into skills."* `.claude/commands/`는 계속 동작하지만
보조 파일·`disable-model-invocation`·모델 자동 호출을 못 쓴다. 8개 전부 `skills/<이름>/SKILL.md` 로.
사용법(`/adopt-standard` 등)은 그대로 — 팀원 입장에서 바뀌는 게 없다.

- `/adopt-standard` `/commit` `/open-pr` → **`disable-model-invocation: true`** (부작용이 커서 사용자만 호출)
- `/scaffold-feature` `/fix-issue` `/refactor` `/plan-feature` `/doc-sync` → 모델 자동 호출 허용
- `/doc-sync` `/commit` `/open-pr` `/plan-feature` → `allowed-tools` 로 읽기 전용 git 명령 선승인(프롬프트 감소)

### 신규 스킬 4종 (가장 많이 쓰이는 워크플로)
- **`/plan-feature`** — 조사 → 선택지·트레이드오프 → 플랜(목표·변경파일·검증방법·**안 하는 것**·위험) → 승인 후 구현
- **`/commit`** — **시크릿 검사** → 의도치 않은 파일 확인(빌드 산출물·`.claude/settings.json`) → 의미 단위 분리 → Conventional Commits → 기본 브랜치 직접 커밋 방지
- **`/open-pr`** — 브랜치 전체 변경 요약, 검증 체크리스트(실제로 한 것만), 레포 PR 템플릿 우선, `gh pr create`
- **`/refactor`** — 왜 지금 하는지 확인 → 안전망(테스트·검증 수단) 확보 → 작은 단계 → 각 단계 검증. 추측성 추상화·동작 변경 끼워넣기 금지

### rules 보강
- **`general-engineering.md`** — "작업 순서"(조사→플랜→승인→구현→검증), **"코드 품질"**(이름·함수 크기·3회 규칙·죽은 코드·에러 삼키기 금지·매직넘버), **"프로젝트 구조"**(새 파일 자리·의존 방향), 커밋 규약(Conventional Commits) 추가. 63줄 유지.
- **`documentation.md` 신규** — `paths: ["**/*.md","docs/**"]` 스코프라 **문서를 다룰 때만 로드**된다(항상 로드 아님). 사실만 쓰기·단일 출처·표/목록·언어 명시·PowerShell 병기.

### 문서 구조 정리
- **README를 "지도"로 축소** — 채택 절차 설명을 걷어내고 **역할별 "무엇을 읽어야 하나" 표**로 대체. 절차의 단일 출처는 START-HERE / ADOPTION 두 곳뿐(이전엔 세 곳에 중복되어 `.vscode/` 추가 때 세 곳을 다 고쳐야 했다).
- **문서 지도 단일화** — START-HERE 하단의 중복 표를 제거하고 README로 위임.
- **각 문서 첫 줄에 "독자 / 읽는 시점"** 표기 — 목록만 훑고도 내가 읽을 문서인지 판단되게.
- GOVERNANCE에 **문서 개수 임계 규칙**(루트 `.md` 10개 초과 시 `guides/`로 분리)과 단일 출처 점검 항목 추가.

### 도구 설치 가이드 (요청 반영)
- **gstack** — 공식 README 기준 실제 설치 명령, 요구사항(Bun + **Windows는 Node.js도 필수**), Windows 주의(**Git Bash/WSL에서 셋업**, 개발자 모드 꺼져 있으면 `git pull` 후 `./setup` 재실행), `/gstack-upgrade`.
- **Impeccable** — `npx impeccable install` → `/impeccable init`, 프로젝트당 1회 `/teach-impeccable`.
- **Claude Design** — 슬라이드·목업·문서.
- 사내 블로그 정리글 링크 보강: 도구 비교(610) · Impeccable 설치(551)/사용(550) · Claude Design(609·611·612·613) · AI 코딩 잘 시키는 법(605·606·608).

### 공식 플러그인 안내 신설
`security-guidance`(코딩 중 취약점 검사·수정) · `pr-review-toolkit` · `commit-commands`(우리 것과 겹침) · `github` MCP ·
LSP 플러그인(**VS Code면 대체로 불필요** — IDE Problems 패널을 Claude가 이미 읽음).

### 기타
- `CLAUDE.md.template` — 활성 rule 목록에 `documentation.md`, "자주 쓰는 스킬" 절, Windows 명령 병기 안내 추가.
- rule·agent 출처 표기 v0.7 → **v0.8** 동기화.
- `.claude/rules/_README.txt` — **rule(원칙) vs skill(절차) 구분 기준** 명시.
- GOVERNANCE·gitignore.snippet·ADOPTION의 `commands/` 참조를 `skills/`로 갱신.

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

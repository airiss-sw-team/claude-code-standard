# 실전 사용 가이드 (GUIDE)

구조 설명은 [README.md](README.md), 적용 절차는 [ADOPTION.md](ADOPTION.md).
**Windows + VS Code 환경 차이**는 [VSCODE-WINDOWS.md](VSCODE-WINDOWS.md).
이 문서는 **"그래서 매일 어떻게 쓰는가"** — 상황별 레시피와 스킬 활용법입니다.

---

## 1. Claude Code 기본기 (팀 공통 기준)

팀원이라면 이것만은 알고 쓰기:

| 기능 | 언제 | 방법 |
|---|---|---|
| **Plan 모드** | 큰 변경·설계가 필요한 작업 시작 전 | **VS Code**: 프롬프트 박스 아래 모드 인디케이터 클릭 (플랜이 Markdown 문서로 열리고 **인라인 코멘트**로 피드백 가능) · **CLI**: `Shift+Tab` |
| **체크포인트(되감기)** | 큰 변경 전/후, 잘못된 방향으로 갔을 때 | 메시지에 마우스 올리면 되감기 버튼 — *코드만 되감기 / 대화 분기 / 둘 다*. **Windows엔 샌드박스가 없으므로 이게 실질적 undo** |
| **CLAUDE.md** | 세션마다 자동 로드됨 | 레포의 CLAUDE.md가 곧 "팀 온보딩 문서". 낡으면 고쳐서 커밋 |
| **`/context`** | "규칙이 진짜 먹고 있나?" | **Memory files** 목록에 로드된 파일이 그대로 나옴. 컨텍스트 사용량도 확인 |
| **`claude doctor`** | 설정을 바꾼 뒤 | 설정 파일 오류(Settings Error)를 세션 시작 없이 검사 (CLI 전용) |
| **`/init`** | CLAUDE.md가 없는 레포에서 | Claude가 코드를 스캔해 초안 생성 |
| **권한** | 위험한 명령 실행 전 물어봄 | 반복 승인이 귀찮으면 개인은 `settings.local.json`, 팀 공통은 레포 `settings.json`에(PR로). ⚠ VS Code 승인 카드는 **공유 파일에 직접 쓸 수 있으니** 저장 위치를 보고 고를 것 |
| **커스텀 명령** | `.claude/commands/*.md` = `/명령` | 우리 표준: `/adopt-standard` `/doc-sync` `/fix-issue` `/scaffold-feature` |
| **서브에이전트** | 리뷰·탐색을 분리 실행 | 우리 표준: `code-reviewer` — "code-reviewer로 지금 변경 검토해줘" |
| **`@terminal:이름`** | 빌드 로그를 보여줄 때 | 터미널 출력을 복붙 없이 프롬프트에 첨부 |

**원칙**: 결과를 무조건 믿지 말 것. "빌드 돌려서 확인했어?"라고 묻는 습관 — 우리 rule에도 "실행으로 검증"이 있다.

### 알아두면 좋은 빌트인 명령 (gstack 없이도 됨)

| 명령 | 용도 |
|---|---|
| `/code-review` | 현재 diff를 정확성·단순화 관점으로 리뷰 |
| `/security-review` | 브랜치 변경분 보안 검토 |
| `/context` · `/memory` | 로드된 규칙·메모 확인 및 편집 |
| `/doctor` | 설정 점검 + 비대해진 CLAUDE.md 가지치기 제안 |
| `/plugins` | 플러그인·마켓플레이스 관리 (VS Code는 GUI) |
| `/usage` | 플랜 사용량 확인 |

> **rule vs hook 차이 (중요)**: rule/CLAUDE.md는 **권고**라서 Claude가 무시할 수 있다. "반드시 매번 실행되어야 하는 것"(저장 시 포매터, 표준 파일 수정 금지, 커밋 전 린트)은 `.claude/settings.json`의 **hooks**로 강제해야 100% 보장된다. 이건 결정론적 셸 실행이라 모델 판단을 안 탄다. 동봉 예시(저장 시 포맷 · 표준파일 수정차단)와 켜는 법은 **[HOOKS.md](HOOKS.md)**. Windows는 `.ps1` 변형을 쓰면 jq·Git Bash 없이 된다. 근거: [Best Practices](https://code.claude.com/docs/en/best-practices).

> **권한 3종의 차이**: `allow`는 **폴더 신뢰 수락 후에만** 적용되고, `deny`·`ask`는 **즉시** 적용된다. 그리고 `ask`는 auto 모드에서도 분류기를 건너뛰고 사람에게 묻는다 → **위험 명령은 `ask`에 넣는다.**

---

## 2. 상황별 레시피

### 🟢 새 프로젝트 시작 (아이디어 단계부터)

```
1. 레포 생성 → claude-code-standard/templates/ 내용 복사
2. 기획서·아이디어 메모·레퍼런스를 docs/10_Raw_Sources/에 넣는다
3. Claude에게: "10_Raw_Sources 읽고 architecture.md에 설계 초안을 잡아줘"
   → 뭘 만들지 정리가 안 됐어도, 여기서 Claude와 대화하며 정리하면 된다
4. 스택이 정해지면: /adopt-standard 실행
   → 스택 감지, rule 생성, CLAUDE.md 채움까지 자동
5. /context 로 로드 확인 → 커밋 → 이후 합류하는 팀원은 clone만 하면 같은 환경
```

### 🟡 진행 중인 기존 프로젝트에 도입

```
1. templates/ 복사 → /adopt-standard 실행
   → 코드를 역설계해 CLAUDE.md(구조 지도·빌드 명령)와 architecture.md를 채워줌
2. 나온 초안을 팀이 검토·수정 (Claude의 역설계가 100% 정확하진 않다)
3. 자주 쓰는 빌드/테스트 권한을 레포 settings.json에 추가 (Bash + PowerShell 병기!)
4. claude doctor + /context 로 검증 → 커밋. 이후 문서가 낡으면 /doc-sync
```

### 🔵 일상 개발 루프

```
기능 개발:  Plan 모드로 시작 → 승인 → 구현 → "빌드/테스트 돌려 확인해줘"
버그 수정:  /fix-issue <이슈번호 or 설명>  (근본원인 규명 → 최소수정 → 검증)
새 모듈:    /scaffold-feature <이름>  (기존 패턴을 찾아 따라 만듦)
커밋 전:    /code-review  또는 "code-reviewer로 검토해줘"
문서 갱신:  /doc-sync  (코드↔위키 어긋난 부분 동기화)
```

---

## 3. gstack 스킬 활용 (선택 도구)

gstack(Y Combinator Garry Tan 공개)은 Claude Code를 **가상 엔지니어링 팀**으로 만드는 23+개 슬래시 커맨드다. **개인별 설치**(`~/.claude/skills/`)이며 레포에 커밋되지 않는다. 표준 필수는 아니지만, 설치했다면 아래처럼 쓴다.
📖 사내 정리: [설치 가이드(Windows)](https://hgko-dev.tistory.com/540) · [실전 워크플로 8가지](https://hgko-dev.tistory.com/549)

> ⚠ **비용 주의**: gstack 커맨드 하나가 보통 **수만~수십만 토큰**을 쓴다. 남발하지 말고 필요한 국면에만.
> ⚠ **Windows**: PowerShell 대신 **Git Bash/WSL**에서 셋업하면 `.exe` 인식·Playwright 이슈를 피한다(블로그 540 참고).
> ⚠ **이름 충돌**: gstack의 `/review`와 빌트인 `/code-review`는 다른 것이다. 표준 문서는 빌트인 `/code-review` 기준으로 쓴다.

### 스킬 카테고리 (언제 무엇을)

| 국면 | 스킬 | 용도 |
|---|---|---|
| **기획/전략** | `/office-hours` · `/plan-ceo-review` | 아이디어 브레인스토밍 · 기능 전략 검토 |
| **설계 리뷰** | `/plan-eng-review` · `/plan-design-review` · `/autoplan` | 아키텍처·디자인 플랜 검토 (`/autoplan`=CEO+Eng+Design 자동) |
| **디자인** | `/design-consultation` · `/frontend-design` · `/design-review` | 디자인 시스템 상담 · UI 구현 · 시각 QA |
| **코드 품질** | `/review` · `/simplify` · `/investigate` · `/codex` | PR 리뷰 · 정리 · 버그 원인분석 · 독립 이중검증 |
| **QA** | `/qa` · `/qa-only` · `/wpf-audit` · `/audit` | 웹앱 자동 QA · WPF 품질감사 · 웹 접근성/성능 감사 |
| **배포/운영** | `/ship` · `/land-and-deploy` · `/canary` · `/cso` | PR 생성 · 머지+배포+헬스체크 · 배포후 모니터 · 보안감사 |
| **안전장치** | `/careful` · `/freeze [경로]` · `/unfreeze` | 위험작업 경고 · 범위 외 편집 차단 |
| **회고/상태** | `/retro` · `/checkpoint` | 주간 커밋 회고 · 작업상태 저장·복원 |

### 자주 쓰는 워크플로 조합 (이 두 개면 일상의 ~70%)

**① 새 기능 개발 (풀 사이클)**
```
/office-hours → (plan.md) → /autoplan → 코딩 → /simplify → /review → /qa → /ship → /land-and-deploy
```
**② 빠른 버그 수정**
```
/careful → /investigate [버그] → 수정 → /review → /ship
```
그 외: **안전 리팩토링** `/freeze → /careful → 작업 → /unfreeze → /review` · **보안 점검** `/cso → 수정 → /review` · **성능** `/benchmark → 개선 → /benchmark(비교)`.

### 디자인 계열 (웹/UI 프로젝트)

- **`/teach-impeccable`** 또는 **`/design-consultation`** — **프로젝트당 1회**. 디자인 컨텍스트(톤·타이포·색·간격)를 수집해 저장 → 이후 UI 생성물이 일관. `DESIGN.md`를 만들면 CLAUDE.md에서 참조.
- `/frontend-design`(구현) → `/design-review` + `/polish`(마감). 부분 개선: `/typeset` `/colorize` `/distill` `/animate`.

### 꿀팁 (블로그 549)

- **계획 우선**: 5분 투자로 몇 시간 재작업 방지 — 큰 작업은 `/autoplan`·`/plan-eng-review` 없이 코딩 시작하지 말 것.
- **`/setup-deploy`는 프로젝트당 1회** → 이후 배포 명령이 자동 연결.
- **프로덕션/DB/라이브 작업엔 항상 `/careful` 먼저.**
- **`/retro`로 반복 버그·시간낭비 패턴을 찾아 CLAUDE.md에 기록** — 스킬 결과가 표준을 개선하는 선순환.
- 인증 필요한 페이지 QA는 `/setup-browser-cookies` → `/qa` 순서.

---

## 4. 안티패턴 (팀 공통 금지)

- ❌ 검증 없이 "Claude가 됐다고 했다"로 PR 올리기 → 빌드·테스트 실행 확인이 먼저
- ❌ CLAUDE.md에 규칙 계속 쌓기 → rules/로 분리 (CLAUDE.md는 지도, rules는 법)
- ❌ 안 쓰는 스택 rule 방치 → 자동 로드되어 오염됨
- ❌ 위험 권한을 편하다고 공유 settings.json에 커밋
- ❌ **VS Code 승인 카드에서 저장 위치를 "프로젝트 공유"로 무심코 고르기** → 클릭 한 번이 팀 전체 규칙이 된다. 기본은 항상 Local, 공유는 PR로
- ❌ 표준에서 복사된 rule을 레포에서 직접 수정 → 표준 레포 PR로
- ❌ Bash 규칙만 쓰고 PowerShell 규칙을 빼먹기 → Git Bash 없는 팀원에게 허용목록이 통째로 무효

## 5. 타사 활용 사례

→ [BENCHMARKS.md](BENCHMARKS.md) — 업계에서 검증된 패턴과 실패 사례, 우리 팀 적용 포인트.

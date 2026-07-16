# 실전 사용 가이드 (GUIDE)

구조 설명은 [README.md](README.md), 적용 절차는 [ADOPTION.md](ADOPTION.md).
이 문서는 **"그래서 매일 어떻게 쓰는가"** — 상황별 레시피와 스킬 활용법입니다.

---

## 1. Claude Code 기본기 (팀 공통 기준)

팀원이라면 이것만은 알고 쓰기:

| 기능 | 언제 | 방법 |
|---|---|---|
| **Plan 모드** | 큰 변경·설계가 필요한 작업 시작 전 | Shift+Tab으로 전환. Claude가 코드를 조사하고 플랜을 승인받은 뒤에만 수정 시작 → 엉뚱한 방향 방지 |
| **CLAUDE.md** | 세션마다 자동 로드됨 | 레포의 CLAUDE.md가 곧 "팀 온보딩 문서". 낡으면 고쳐서 커밋 |
| **`/init`** | CLAUDE.md가 없는 레포에서 | Claude가 코드를 스캔해 초안 생성 |
| **권한** | 위험한 명령 실행 전 물어봄 | 반복 승인이 귀찮으면 개인은 `settings.local.json`, 팀 공통은 레포 `settings.json`에(PR로) |
| **커스텀 명령** | `.claude/commands/*.md` = `/명령` | 우리 표준: `/adopt-standard` `/doc-sync` `/fix-issue` `/scaffold-feature` |
| **서브에이전트** | 리뷰·탐색을 분리 실행 | 우리 표준: `code-reviewer` — "code-reviewer로 지금 변경 검토해줘" |

**원칙**: 결과를 무조건 믿지 말 것. "빌드 돌려서 확인했어?"라고 묻는 습관 — 우리 rule에도 "실행으로 검증"이 있다.

> **rule vs hook 차이 (중요)**: rule/CLAUDE.md는 **권고**라서 Claude가 무시할 수 있다. "반드시 매번 실행되어야 하는 것"(저장 시 포매터, 표준 파일 수정 금지, 커밋 전 린트)은 `.claude/settings.json`의 **hooks**로 강제해야 100% 보장된다. 이건 결정론적 셸 실행이라 모델 판단을 안 탄다. 동봉 예시(저장 시 포맷 · 표준파일 수정차단)와 켜는 법은 **[HOOKS.md](HOOKS.md)**. 기본 비활성이며 환경 테스트 후 opt-in. 근거: [Best Practices](https://code.claude.com/docs/en/best-practices).

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
5. 커밋 → 이후 합류하는 팀원은 clone만 하면 같은 환경
```

### 🟡 진행 중인 기존 프로젝트에 도입

```
1. templates/ 복사 → /adopt-standard 실행
   → 코드를 역설계해 CLAUDE.md(구조 지도·빌드 명령)와 architecture.md를 채워줌
2. 나온 초안을 팀이 검토·수정 (Claude의 역설계가 100% 정확하진 않다)
3. 자주 쓰는 빌드/테스트 권한을 레포 settings.json에 추가
4. 커밋 → 완료. 이후 문서가 낡으면 /doc-sync
```

### 🔵 일상 개발 루프

```
기능 개발:  Plan 모드로 시작 → 승인 → 구현 → "빌드/테스트 돌려 확인해줘"
버그 수정:  /fix-issue <이슈번호 or 설명>  (근본원인 규명 → 최소수정 → 검증)
새 모듈:    /scaffold-feature <이름>  (기존 패턴을 찾아 따라 만듦)
커밋 전:    "code-reviewer로 검토해줘" 또는 /code-review
문서 갱신:  /doc-sync  (코드↔위키 어긋난 부분 동기화)
```

---

## 3. gstack 스킬 활용 (선택 도구)

gstack(Y Combinator Garry Tan 공개)은 Claude Code를 **가상 엔지니어링 팀**으로 만드는 23+개 슬래시 커맨드다. **개인별 설치**(`~/.claude/skills/`)이며 레포에 커밋되지 않는다. 표준 필수는 아니지만, 설치했다면 아래처럼 쓴다.
📖 사내 정리: [설치 가이드(Windows)](https://hgko-dev.tistory.com/540) · [실전 워크플로 8가지](https://hgko-dev.tistory.com/549)

> ⚠ **비용 주의**: gstack 커맨드 하나가 보통 **수만~수십만 토큰**을 쓴다. 남발하지 말고 필요한 국면에만.
> ⚠ **Windows**: PowerShell 대신 **Git Bash/WSL**에서 셋업하면 `.exe` 인식·Playwright 이슈를 피한다(블로그 540 참고).

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
- ❌ 표준에서 복사된 rule을 레포에서 직접 수정 → 표준 레포 PR로

## 5. 타사 활용 사례

→ [BENCHMARKS.md](BENCHMARKS.md) — 업계에서 검증된 패턴과 실패 사례, 우리 팀 적용 포인트.

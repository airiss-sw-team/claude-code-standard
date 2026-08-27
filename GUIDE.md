# 실전 사용 가이드 (GUIDE)

> **독자**: 표준이 적용된 레포에서 매일 일하는 팀원 · **읽는 시점**: 처음 한 번 훑고, 필요할 때 다시

구조와 문서 지도는 [README.md](README.md), 적용 절차는 [ADOPTION.md](ADOPTION.md),
Windows + VS Code 환경 차이는 [VSCODE-WINDOWS.md](VSCODE-WINDOWS.md).
이 문서는 **"그래서 매일 어떻게 쓰는가"** 입니다.

---

## 1. 팀 공통 스킬 (표준에 동봉됨)

`/이름` 을 입력하면 실행됩니다. clone만 하면 팀원 전원이 같은 걸 갖습니다.

| 스킬 | 언제 쓰나 | 자동 호출 |
|---|---|---|
| **`/plan-feature`** | 큰 작업 시작 전. 조사 → 선택지·트레이드오프 → 플랜 → 승인 | ✅ |
| **`/scaffold-feature`** | 새 기능·모듈. 이 레포의 기존 패턴을 찾아 그대로 따라 만듦 | ✅ |
| **`/fix-issue`** | 버그. 근본 원인 규명 → 최소 수정 → 재현으로 검증 | ✅ |
| **`/refactor`** | 동작은 그대로, 구조만 개선. 안전망 확보 → 작은 단계 → 검증 | ✅ |
| **`/commit`** | 커밋. **시크릿 검사** → 의미 단위 분리 → Conventional Commits | ❌ 사용자만 |
| **`/open-pr`** | PR 생성. 브랜치 전체 변경 요약 + 검증 체크리스트 | ❌ 사용자만 |
| **`/doc-sync`** | 코드 ↔ `docs/20_The_Wiki` 동기화 | ✅ |
| **`/adopt-standard`** | 표준 적용 (레포당 1회) | ❌ 사용자만 |

> **자동 호출** = Claude가 상황을 보고 알아서 꺼내 씁니다. *"결제 모듈 새로 만들어줘"* 라고만 해도
> `/scaffold-feature`가 걸립니다. 부작용이 큰 것(커밋·PR·표준 적용)은 **사용자가 직접 부를 때만** 돕니다.

**서브에이전트 2종** — 메인 대화 맥락을 물려받지 않는 "신선한 눈"입니다.

| 에이전트 | 언제 | 부르는 법 |
|---|---|---|
| **`code-reviewer`** | 커밋 전 변경 리뷰 (정확성 → 재사용 → 우리 rules 위반 순) | "code-reviewer로 지금 변경 검토해줘" |
| **`verifier`** | **하나의 주장을 반증**하고 싶을 때 | "verifier로 이 주장을 반증해줘: <주장>" |

쓰는 법과 함정은 [4장](#4-검증을-요구하는-법-교차검증--다중-에이전트)에 정리했습니다.

---

## 2. Claude Code 기본기 (팀 공통 기준)

| 기능 | 언제 | 방법 |
|---|---|---|
| **Plan 모드** | 큰 변경·설계 전 | **VS Code**: 모드 인디케이터 클릭 (플랜이 Markdown 문서로 열려 **인라인 코멘트** 가능) · **CLI**: `Shift+Tab` |
| **체크포인트(되감기)** | 잘못된 방향으로 갔을 때 | 메시지에 마우스 올리면 되감기 버튼 — *코드만 / 대화 분기 / 둘 다*. **Windows엔 샌드박스가 없으므로 이게 실질적 undo** |
| **CLAUDE.md** | 세션마다 자동 로드 | 레포의 CLAUDE.md = 팀 온보딩 문서. 낡으면 고쳐서 커밋 |
| **`/context`** | "규칙이 진짜 먹고 있나?" | **Memory files** 목록에 로드된 파일이 그대로 나옴 |
| **`claude doctor`** | 설정을 바꾼 뒤 | 설정 파일 오류 검사 (CLI 전용) |
| **`@terminal:이름`** | 빌드 로그를 보여줄 때 | 터미널 출력을 복붙 없이 첨부 |
| **권한** | 위험한 명령 실행 전 | 개인은 `settings.local.json`, 팀 공통은 레포 `settings.json`(PR로). ⚠ VS Code 승인 카드는 **공유 파일에 직접 쓸 수 있으니** 저장 위치를 보고 고를 것 |

### 빌트인 명령 (설치 없이 바로)

| 명령 | 용도 |
|---|---|
| `/code-review` | 현재 diff를 정확성·단순화 관점으로 리뷰 |
| `/security-review` | 브랜치 변경분 보안 검토 |
| `/context` · `/memory` | 로드된 규칙·메모 확인·편집 |
| `/doctor` | 설정 점검 + 비대해진 CLAUDE.md 가지치기 제안 |
| `/plugins` | 플러그인·마켓플레이스 관리 (VS Code는 GUI) |
| `/init` · `/usage` | CLAUDE.md 초안 생성 · 플랜 사용량 |

> **rule vs skill vs hook — 어디에 무엇을 넣나**
> - **rule** (`.claude/rules/`) = *항상 지킬 원칙*. 매 세션 자동 로드 → **짧게**. 예: 이름 짓기, 커밋 규약
> - **skill** (`.claude/skills/`) = *여러 단계를 밟는 절차*. 필요할 때만 로드 → 길어도 됨. 예: `/commit`
> - **hook** (`settings.json`) = *반드시 매번 일어나야 하는 일*. 결정론적 셸 실행이라 모델 판단을 안 탐 → [HOOKS.md](HOOKS.md)
>
> rule과 CLAUDE.md는 **권고**라 Claude가 무시할 수 있습니다. 강제가 필요하면 hook이나 `deny`/`ask` 권한으로.

> **권한 3종의 차이**: `allow`는 **폴더 신뢰 수락 후에만** 적용되고, `deny`·`ask`는 **즉시** 적용됩니다.
> `ask`는 auto 모드에서도 분류기를 건너뛰고 사람에게 묻습니다 → **위험 명령은 `ask`에.**

---

## 3. 상황별 레시피

### 🟢 새 프로젝트 (아이디어 단계부터)
```
1. 레포 생성 → templates/ 복사 → /adopt-standard
2. 기획서·메모·레퍼런스를 docs/10_Raw_Sources/ 에 넣는다
3. "10_Raw_Sources 읽고 architecture.md에 설계 초안을 잡아줘"
4. /context 로 규칙 로드 확인 → 커밋
```

### 🟡 기존 프로젝트에 도입
```
1. templates/ 복사 → /adopt-standard  (코드를 역설계해 CLAUDE.md·architecture.md 작성)
2. 나온 초안을 팀이 검토·수정 (역설계가 100% 정확하진 않다)
3. 빌드/테스트 권한을 settings.json 에 추가 — Bash + PowerShell 병기
4. claude doctor + /context 로 검증 → 커밋
```

### 🔵 일상 개발 루프
```
큰 작업:   /plan-feature <무엇> → 승인 → 구현 → "빌드/테스트 돌려 확인해줘"
새 모듈:   /scaffold-feature <이름>
버그:      /fix-issue <이슈번호 or 증상>
정리:      /refactor <대상>
커밋 전:   /code-review   (또는 "code-reviewer로 검토해줘")
의심될 때: "verifier로 이 주장을 반증해줘: <주장>"
커밋:      /commit  →  /open-pr
문서:      /doc-sync
```

---

## 4. 검증을 요구하는 법 (교차검증 · 다중 에이전트)

"한 번 더 확인해줘"는 검증이 아닙니다. 아래 다섯 가지만 지키면 같은 토큰으로 훨씬 정확해집니다.

### ① 검증 대상은 **하나의 명확한 주장**이어야 한다

주장이 없으면 교차검증이 성립하지 않습니다. *"이거 검토해줘"* 는 검증이 아니라 또 다른 생성일 뿐입니다.

```
❌ "이 PR 한 번 더 봐줘"
✅ "다음 주장을 검증해줘: 이 변경은 기존 호출부 3곳을 깨지 않는다"
```

### ② 같은 프롬프트로 N마리는 검증이 아니라 반복이다

같은 모델 + 같은 프롬프트 = **같은 편향**. 상관된 오류는 다수결로 안 걸러집니다. 셋이 사이좋게 같이 틀립니다.
**렌즈를 다르게 주세요.**

```
❌ "검토해줘" × 3
✅ ① 정확성: 이 로직이 틀리는 입력을 찾아라
   ② 재현성: 이 주장이 실제로 재현되는지 확인해라
   ③ 영향범위: 이 변경이 깨뜨릴 수 있는 호출부를 찾아라
```

### ③ 더 강한 방법 — **모델을 바꾼다**

같은 모델 3마리보다 **다른 모델 1마리**가 낫습니다. 오류의 상관관계가 훨씬 낮기 때문입니다.
gstack의 `/codex`(OpenAI Codex로 독립 이중검증)가 이 패턴입니다. 중요한 판단에는 이쪽이 값어치가 큽니다.

### ④ "문제 찾아줘"라고 하면 **없어도 만들어낸다**

프롬프트를 뒤집으세요. 우리 표준에는 이게 **`verifier` 서브에이전트**로 들어 있습니다:

```
"verifier로 이 주장을 반증해줘: <구체적 주장>"
```

`verifier`는 판정을 셋으로 나눕니다 — **반증됨**(구체적 입력→결과가 있을 때만) / **버팀**(반증 시도 실패) / **판정 불가**(증거 부족).
**불확실하면 기본값은 "판정 불가"** 입니다. "반증됨"이 아닙니다 — 그래야 없는 문제를 만들지 않습니다.
단, 검증 대상이 *"다른 에이전트가 찾은 문제가 진짜다"* 인 경우엔 **판정 불가 = 그 지적을 채택하지 않음**으로 씁니다.

### ⑤ 합치지 말고 **고르고 접붙인다**

여러 플랜을 "합치면" 가장 무난한 중간값이 나옵니다. 좋은 답은 보통 극단에 있고요.

```
합치기 ❌  →  하나를 승자로 고른다 (왜 이겼는지 명시)
              + 나머지에서 좋은 조각만 이식한다 (무엇을 왜 가져왔는지)
              + 버린 것도 왜 버렸는지 남긴다
```

### 끝은 항상 **실행 가능한 증거**

에이전트가 "확인했습니다"라고 하는 걸 믿으면 검증 층이 하나 더 생겼을 뿐입니다.
체인의 끝은 반드시 **빌드 출력 · 테스트 결과 · 재현 절차** 처럼 사람이 볼 수 있는 물증이어야 합니다.

---

### 언제 쓰고 언제 안 쓰나

| 쓸 값어치가 있다 | 낭비다 |
|---|---|
| 되돌리기 어려운 결정(아키텍처, 장비 제어, DB 마이그레이션) | 사실 조회, 이미 정해진 것, 기계적 수정 |
| 해답 공간이 넓을 때(설계가 여럿 가능) | **빌드·테스트로 판정 가능한 것** |
| 틀리면 비싼 것 | 검증할 "주장"이 아직 없는 단계 |
| **검증 수단이 약한 영역** — WPF·장비 연동처럼 자동 테스트가 어려운 곳 | 순차 의존 작업(병렬 이득 0) |

> **한 문장으로**: 판정 가능하면 판정하고, **판정 불가능할 때만** 에이전트를 늘린다.
> 에이전트 3마리보다 테스트 1개가 낫고 쌉니다.

### 이미 만들어져 있는 것부터

손으로 팬아웃하기 전에 아래를 먼저 쓰세요.

| 도구 | 무엇 |
|---|---|
| **`/code-review ultra`** | 클라우드 다중 에이전트 심층 리뷰. `/code-review ultra <PR번호>` 도 가능. **사용자가 직접 실행해야 하고 별도 과금** |
| **`pr-review-toolkit`** (공식 플러그인) | 관점별 전문 에이전트 묶음 — 렌즈 다양화를 대신 해줌 |
| **`/codex`** (gstack) | 교차 모델 검증 |
| **`verifier`** (우리 표준) | 단일 주장 반증 |

## 5. 공식 플러그인 (선택, 무료)

`/plugins` 로 설치합니다. VS Code는 GUI, CLI는 `/plugin install <이름>@claude-plugins-official`.

| 플러그인 | 무엇 | 우리 팀 유용도 |
|---|---|---|
| **`security-guidance`** | Claude가 코드를 짜는 동안 취약점을 검사하고 그 자리에서 고침 | ⭐ 높음 |
| **`pr-review-toolkit`** | PR 리뷰 전용 에이전트 묶음 | 높음 |
| **`commit-commands`** | 커밋·푸시·PR 워크플로 | 우리 `/commit`·`/open-pr`과 겹침 — 둘 중 하나만 |
| **`github`** | GitHub MCP (이슈·PR 조회) | 이슈 트래커를 쓴다면 |
| **`csharp-lsp` 등 LSP** | 언어 서버 연동 | **VS Code면 대체로 불필요** — IDE Problems 패널을 Claude가 이미 읽음 |

---

## 6. gstack · Impeccable · Claude Design (선택 도구)

셋 다 **개인별 설치**(`~/.claude/`)이며 레포에 커밋되지 않습니다. 표준 필수가 아닙니다.
📖 **뭘 언제 쓰나** 비교: [AI 디자인 도구 3개 정리](https://hgko-dev.tistory.com/610)

### gstack — 가상 엔지니어링 팀 (23+ 스킬)

Y Combinator Garry Tan이 공개한 본인의 Claude Code 셋업입니다.

**요구사항**: Claude Code · Git · **Bun v1.0+** · **Node.js (Windows는 필수)**

```bash
# 전역 설치 — Claude Code 세션이나 Git Bash 에 붙여넣기
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack \
  && cd ~/.claude/skills/gstack && ./setup
```

**Windows 주의** (공식 README 기준):
- Windows 11에서 **Git Bash 또는 WSL**로 동작. PowerShell에서 셋업하지 말 것.
- Playwright 제약 때문에 **Bun과 별개로 Node.js도 필요**합니다.
- **개발자 모드(Developer Mode)가 꺼져 있으면** 심볼릭 링크가 복사본으로 굳으므로, `git pull` 할 때마다 `./setup` 을 다시 돌려야 합니다.

**업데이트**: 세션에서 `/gstack-upgrade` (또는 `gstack-config set auto_upgrade true`)
📖 사내 정리: [설치 가이드(Windows)](https://hgko-dev.tistory.com/540) · [실전 워크플로 8가지](https://hgko-dev.tistory.com/549)

> ⚠ **비용**: 커맨드 하나가 보통 **수만~수십만 토큰**을 씁니다. 남발하지 말고 필요한 국면에만.
> ⚠ **이름 충돌**: gstack의 `/review`와 빌트인 `/code-review`는 다릅니다. 표준 문서는 빌트인 기준입니다.

**언제 무엇을**

| 국면 | 스킬 |
|---|---|
| 기획/전략 | `/office-hours` · `/plan-ceo-review` |
| 설계 리뷰 | `/autoplan`(CEO+Eng+Design 자동) · `/plan-eng-review` · `/plan-design-review` |
| 코드 품질 | `/review` · `/simplify` · `/investigate` · `/codex`(독립 이중검증) |
| QA | `/qa` · `/qa-only` · `/wpf-audit` · `/audit` |
| 배포/운영 | `/ship` · `/land-and-deploy` · `/canary` · `/cso` |
| 안전장치 | `/careful` · `/freeze [경로]` · `/unfreeze` |
| 회고/상태 | `/retro` · `/checkpoint` |

**자주 쓰는 조합** (이 둘이 일상의 ~70%)
```
① 새 기능:  /office-hours → /autoplan → 코딩 → /simplify → /review → /qa → /ship
② 버그:     /careful → /investigate [버그] → 수정 → /review → /ship
```

### Impeccable — AI가 만든 뻔한 UI 고치기 (웹/UI 프로젝트)

20개 디자인 스킬 + 안티패턴 사전. `/audit` `/polish` `/critique` `/typeset` `/colorize` 등.

```bash
# 프로젝트 루트에서
npx impeccable install
# 그 다음 Claude Code 세션에서
/impeccable init
```

**프로젝트당 1회 `/teach-impeccable`** 로 디자인 컨텍스트(대상·용도·브랜드 톤)를 먼저 심어두면
이후 생성되는 UI가 일관됩니다. `DESIGN.md`를 만들면 CLAUDE.md에서 참조하세요.
📖 사내 정리: [설치 가이드](https://hgko-dev.tistory.com/551) · [사용 가이드](https://hgko-dev.tistory.com/550)

### Claude Design — 슬라이드·목업·문서

말로 발표 슬라이드·UI 목업을 만드는 기능. 설치 없이 씁니다.
📖 사내 정리: [사용법](https://hgko-dev.tistory.com/609) · [UI 목업 만들기](https://hgko-dev.tistory.com/611) · [템플릿 14개](https://hgko-dev.tistory.com/612) · [기존 PPT 개선](https://hgko-dev.tistory.com/613)

### 꿀팁

- **계획 우선**: 5분 투자로 몇 시간 재작업 방지. 큰 작업은 `/plan-feature`(표준) 또는 `/autoplan`(gstack) 없이 코딩 시작하지 말 것.
- **프로덕션/DB/장비 작업엔 항상 `/careful` 먼저.**
- **`/retro`로 반복 버그·시간낭비 패턴을 찾아 CLAUDE.md에 기록** — 스킬 결과가 표준을 개선하는 선순환.
- 인증 필요한 페이지 QA는 `/setup-browser-cookies` → `/qa` 순서.

---

## 7. AI 코딩 잘 시키는 법 (사내 정리)

- [프롬프트를 '스펙'으로 쓰는 5가지](https://hgko-dev.tistory.com/605)
- [AI가 짠 코드 리뷰하는 법 — 겉보기 멀쩡한데 틀린 코드 잡는 6단계](https://hgko-dev.tistory.com/606)
- [AI에게 테스트 코드 제대로 짜게 하는 법](https://hgko-dev.tistory.com/608)

---

## 8. 안티패턴 (팀 공통 금지)

- ❌ 검증 없이 "Claude가 됐다고 했다"로 PR 올리기 → 빌드·테스트 실행 확인이 먼저
- ❌ 조사 없이 바로 코딩 → 큰 작업은 `/plan-feature` 부터
- ❌ CLAUDE.md에 규칙 계속 쌓기 → rules/로, 절차면 skills/로
- ❌ 안 쓰는 스택 rule 방치 → 자동 로드되어 오염됨
- ❌ **VS Code 승인 카드에서 저장 위치를 "프로젝트 공유"로 무심코 고르기** → 클릭 한 번이 팀 전체 규칙이 된다
- ❌ Bash 규칙만 쓰고 PowerShell 규칙 빼먹기 → Git Bash 없는 팀원에게 허용목록이 통째로 무효
- ❌ 표준에서 복사된 rule을 레포에서 직접 수정 → 표준 레포 PR로
- ❌ 한 커밋에 기능 변경 + 무관한 리팩토링 섞기
- ❌ **같은 프롬프트로 에이전트 N마리 돌리고 "교차검증했다"고 하기** → 같은 편향이라 같이 틀린다. 렌즈를 다르게 줄 것(4장)
- ❌ 빌드·테스트로 판정 가능한 걸 에이전트에게 물어보기 → 판정 가능하면 판정한다

## 9. 타사 활용 사례

→ [BENCHMARKS.md](BENCHMARKS.md) — 업계 검증 패턴과 실패 사례, 우리 팀 적용 포인트.

# 🚀 여기서 시작하세요 (START HERE)

> **이 문서 하나만 따라 하면 됩니다.** Claude Code를 처음 써보는 사람도 순서대로 복붙하면 프로젝트에 표준이 적용됩니다.
> 다른 문서(README·ADOPTION·GUIDE…)는 "더 알고 싶을 때" 참고용입니다. 지금은 이 문서만.

---

## 📌 30초 요약 — 전체 흐름 한눈에

```mermaid
flowchart LR
    A([아이디어]) --> B[1. gstack로<br/>설계·구조 잡기]
    B --> C[2. 표준 템플릿<br/>복사]
    C --> D[3. /adopt-standard<br/>자동 셋업]
    D --> E[4. 설계·디자인<br/>리뷰]
    E --> F[5. 개발 →<br/>검증 → 커밋]
    F --> G([팀 공유 완료])
    style A fill:#e8f5e9
    style G fill:#e3f2fd
    style D fill:#fff3e0
```

**핵심**: 1·4번은 gstack(선택), **2·3번이 이 표준의 본체**, 5번은 일상. gstack이 없어도 2·3·5만으로 충분히 돌아갑니다.

---

## 🧩 먼저 알아둘 3가지 용어 (1분)

| 용어 | 쉽게 말하면 |
|---|---|
| **Claude Code** | 터미널/에디터에서 대화로 코드를 짜주는 AI 도구 |
| **슬래시 명령 (`/이름`)** | 미리 짜둔 작업 묶음을 한 번에 부르는 단축키. 예: `/adopt-standard` |
| **CLAUDE.md** | Claude가 세션 시작 때 자동으로 읽는 "이 프로젝트 설명서". = 팀 온보딩 문서 |

---

## 0️⃣ 준비물 (처음 한 번만)

1. **Claude Code 설치** — 이미 이 문서를 Claude Code에서 보고 있다면 완료된 것.
   설치 확인: 터미널에서 `claude --version`
2. **git** — `git --version` 으로 확인. 없으면 [git 설치](https://git-scm.com).
3. **(선택) gstack** — 설계·리뷰·QA·배포 자동화 스킬 묶음. 없어도 표준은 동작.
   설치법(Windows): 사내 정리 [gstack 설치 가이드](https://hgko-dev.tistory.com/540) 참고.

> 👉 gstack이 없으면 **1번과 4번 단계를 건너뛰고** 2·3·5번만 하면 됩니다. 나중에 설치해도 됩니다.

---

## 🟢 새 프로젝트 시작하기 (5단계)

> 이미 코드가 있는 기존 프로젝트라면 → 아래 [기존 프로젝트](#-이미-진행-중인-프로젝트라면) 로.

### 1단계 — 아이디어를 구조로 (gstack, 선택)

머릿속 아이디어를 설계로 바꾸는 단계. Claude Code 세션에서:

```
/office-hours          ← 아이디어 브레인스토밍 (뭘 만들지 같이 정리)
/plan-ceo-review       ← "이 기능이 전략적으로 맞나" 검토
```

**결과물**: 정리된 계획. 이걸 나중에 `docs/10_Raw_Sources/` 에 넣어둘 겁니다(원천 자료).
가진 게 기획서·메모뿐이어도 OK — 그걸 Claude에게 보여주며 정리하면 됩니다.

### 2단계 — 표준 템플릿 복사

이 표준을 프로젝트에 입히는 단계.

```bash
# (1) 프로젝트 폴더 만들고 이동
mkdir my-project && cd my-project
git init

# (2) 이 표준의 templates/ 안의 내용을 통째로 복사해 넣는다
#     (claude-code-standard 를 clone 해뒀다고 가정)
cp -r /path/to/claude-code-standard/templates/. .
```

이제 내 프로젝트에 `CLAUDE.md.template`, `.claude/`, `docs/` 등이 생깁니다.
`.template` 이 붙은 파일은 **아직 안 채운 뼈대**라는 뜻 (다음 단계에서 자동으로 채웁니다).

### 3단계 — `/adopt-standard` 한 방 (자동 셋업) ⭐

이 표준의 **핵심**. 복사만 한 상태에서 Claude Code 세션을 열고:

```
/adopt-standard
```

그러면 Claude가 **자동으로**:
- 🔍 이 레포 코드를 스캔해 **스택 감지**(웹? Python? .NET? …)
- 🧹 안 맞는 스택 rule 삭제, 없는 스택이면 rule **새로 생성**
- ✍️ `CLAUDE.md.template` → `CLAUDE.md` 로 이름 바꾸고 **내용까지 채움**(빌드 명령·구조 지도)
- ⚙️ `.gitignore` 정리, 권한 예시 안내

**즉, "복사 + `/adopt-standard`" 이 두 단계가 셋업의 전부입니다.** ("스킬만 입력해라"가 아니라, 이 명령이 실제로 코드를 읽고 문서를 만들어 줍니다.)

> 자동 결과가 100% 완벽하진 않습니다. 나온 `CLAUDE.md`를 눈으로 훑고 틀린 곳만 손보세요.

### 4단계 — 설계·디자인 리뷰 (gstack, 선택)

본격 코딩 전에 설계를 점검:

```
/autoplan              ← CEO + 엔지니어 + 디자이너 관점 자동 리뷰 (한 방)
# 또는 개별로:
/plan-eng-review       ← 아키텍처 관점
/plan-design-review    ← 디자인 관점
```

웹/UI 프로젝트면 디자인 기준도 한 번 잡아두면 좋습니다:
```
/design-consultation   ← 폰트·색·톤 기준 잡기 (프로젝트당 1회) → DESIGN.md
```

### 5단계 — 개발 → 검증 → 커밋

이제 일상 개발. 표준이 깔려 있으니 Claude가 규칙을 지킵니다.

```
# 기능 만들 때:  Plan 모드(Shift+Tab)로 시작 → 승인 → 구현
# 새 모듈:       /scaffold-feature <이름>
# 버그:          /fix-issue <설명>
# 커밋 전:       "code-reviewer로 검토해줘"  또는  /review
# 문서 갱신:     /doc-sync
```

마지막으로 **커밋**하면 끝. 이제 팀원이 이 레포를 clone하면 **같은 CLAUDE.md·규칙·명령**을 자동으로 갖게 됩니다.

```bash
git add -A
git commit -m "표준 적용 + 초기 구조"
```

✅ **완료!** 여기까지 하면 팀 전체가 일관된 환경에서 개발합니다.

---

## 🟡 이미 진행 중인 프로젝트라면

새로 만드는 게 아니라 **기존 코드가 큰 레포**에 도입하는 경우도 거의 같습니다:

1. 2단계처럼 `templates/` 복사.
2. `/adopt-standard` 실행 → Claude가 **기존 코드를 역설계**해서 CLAUDE.md(구조 지도·빌드 명령)와 `docs/20_The_Wiki/architecture.md`를 채워 줍니다.
3. 나온 초안을 팀이 검토·수정.
4. 커밋. 끝.

> 실제 적용 예시: 이 표준은 44개 프로젝트 규모의 대형 WPF 솔루션에 먼저 적용해봤습니다. 그 결과물이 레퍼런스입니다.

---

## ❓ 자주 막히는 지점 (FAQ)

**Q. `.template` 파일은 어떻게 해요?**
→ 손대지 마세요. `/adopt-standard`가 이름 변경(+`.template` 제거)과 내용 채움을 자동으로 합니다. 수동으로 하려면: 이름에서 `.template`을 떼고 `{{...}}`를 채우면 됩니다. → 상세 [ADOPTION.md](ADOPTION.md).

**Q. `/adopt-standard` 안 쓰고 수동으로 하고 싶어요.**
→ 됩니다. [ADOPTION.md](ADOPTION.md)의 "복사 맵"과 "스택 rule 선택"을 순서대로 따라 하면 됩니다.

**Q. 규칙이 진짜 적용되는지 확인하려면?**
→ 레포에서 새 세션을 열고 *"이 프로젝트 코딩 규칙이 뭐야?"* 라고 물어보세요. `.claude/rules/` 내용이 답에 나오면 정상 (rules는 세션 시작 시 자동 로드).

**Q. gstack 꼭 필요해요?**
→ 아니요. 2·3·5단계(복사 → `/adopt-standard` → 개발)만으로 표준은 완전히 동작합니다. gstack은 설계·리뷰·QA·배포를 더 편하게 해주는 선택 도구입니다. 커맨드당 토큰을 많이 쓰니(수만~수십만) 필요할 때만.

**Q. 안 쓰는 스택 rule을 안 지우면?**
→ `.claude/rules/`는 **전부 자동 로드**되므로, 예를 들어 웹 레포에 WPF 규칙이 남아 있으면 엉뚱하게 적용됩니다. 꼭 지우세요(`/adopt-standard`가 대신 해줍니다).

---

## 📚 다음에 읽을 것 (문서 지도)

지금은 이 문서로 충분합니다. 더 깊이 들어갈 때:

| 문서 | 언제 읽나 |
|---|---|
| [README.md](README.md) | 표준이 뭔지·왜 이렇게 설계했는지 개요 |
| [ADOPTION.md](ADOPTION.md) | 수동 적용 절차·체크리스트 상세 |
| [GUIDE.md](GUIDE.md) | 매일 쓰는 레시피 · gstack 스킬 · 안티패턴 |
| [HOOKS.md](HOOKS.md) | 저장 시 포맷 등 자동화(훅) 켜기 |
| [GOVERNANCE.md](GOVERNANCE.md) | 무엇을 커밋/개인으로 두나, 규칙 변경 절차 |
| [BENCHMARKS.md](BENCHMARKS.md) | 타사(Anthropic·Rakuten…) 검증 패턴 |

막히면 그냥 Claude Code에게 *"START-HERE 대로 하는 중인데 여기서 막혔어"* 라고 물어보세요.

# 🚀 여기서 시작하세요 (START HERE)

> **이 문서 하나만 따라 하면 됩니다.** Claude Code를 처음 써보는 사람도 순서대로 복붙하면 프로젝트에 표준이 적용됩니다.
> 다른 문서(README·ADOPTION·GUIDE…)는 "더 알고 싶을 때" 참고용입니다. 지금은 이 문서만.
>
> 💻 우리 팀 기본 환경은 **Windows + VS Code 확장**입니다. 아래 명령은 그 기준으로 적었습니다.

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
| **Claude Code** | 에디터/터미널에서 대화로 코드를 짜주는 AI 도구 |
| **슬래시 명령 (`/이름`)** | 미리 짜둔 작업 묶음을 한 번에 부르는 단축키. 예: `/adopt-standard` |
| **CLAUDE.md** | Claude가 세션 시작 때 자동으로 읽는 "이 프로젝트 설명서". = 팀 온보딩 문서 |

---

## 0️⃣ 준비물 (처음 한 번만)

### 1. Claude Code — 확장과 CLI를 **둘 다** 설치

**① VS Code 확장** (일상 개발용, 필수)
확장 탭(`Ctrl+Shift+X`)에서 **"Claude Code"** 검색 → 설치. 사이드바에 아이콘이 생기면 완료.

**② CLI** (일부 명령 전용, 권장)
```powershell
irm https://claude.ai/install.ps1 | iex
claude --version
```

> ⚠ **확장만 설치하면 터미널의 `claude` 명령은 생기지 않습니다.** 확장은 CLI 사본을 내부에 품고 있을 뿐
> PATH에 등록하지 않아요. `claude --version`이 안 된다고 설치 실패가 아닙니다 — 위 ②를 하면 됩니다.
> `claude doctor`, `claude mcp add`, `claude plugin` 은 CLI에서만 됩니다.

### 2. git
```powershell
git --version
```
없으면 [Git for Windows](https://git-scm.com/downloads/win) 설치. **이건 그냥 git이 아니라 꼭 필요합니다** —
Git Bash가 없으면 Claude Code가 Bash 도구 없이 PowerShell 도구만 쓰게 되고, 동작이 미묘하게 달라집니다
(자세히는 [VSCODE-WINDOWS.md](VSCODE-WINDOWS.md) 2절).

### 3. (선택) gstack
설계·리뷰·QA·배포 자동화 스킬 묶음. 없어도 표준은 동작.
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

**PowerShell (우리 팀 기본)**
```powershell
# (1) 프로젝트 폴더 만들고 이동
New-Item -ItemType Directory my-project
Set-Location my-project
git init

# (2) 이 표준의 templates/ 안의 내용을 통째로 복사해 넣는다
#     (claude-code-standard 를 clone 해뒀다고 가정 — 경로는 각자 위치로)
Copy-Item -Path "D:\path\to\claude-code-standard\templates\*" -Destination . -Recurse -Force
```

> ⚠ PowerShell 5.1에서는 `&&`가 안 됩니다(`cmd`/bash 문법). 위처럼 줄을 나누거나 `;`로 이으세요.

**Git Bash를 쓴다면**
```bash
mkdir my-project && cd my-project && git init
cp -r /d/path/to/claude-code-standard/templates/. .
```

이제 내 프로젝트에 `CLAUDE.md.template`, `.claude/`, `.vscode/`, `docs/` 등이 생깁니다.
`.template` 이 붙은 파일은 **아직 안 채운 뼈대**라는 뜻 (다음 단계에서 자동으로 채웁니다).

### 3단계 — `/adopt-standard` 한 방 (자동 셋업) ⭐

이 표준의 **핵심**. 복사만 한 상태에서 VS Code에서 Claude 패널을 열고:

```
/adopt-standard
```

그러면 Claude가 **자동으로**:
- 🔍 이 레포 코드를 스캔해 **스택 감지**(웹? Python? .NET? …)
- 🧹 안 맞는 스택 rule 삭제, 없는 스택이면 rule **새로 생성**
- ✍️ `CLAUDE.md.template` → `CLAUDE.md` 로 이름 바꾸고 **내용까지 채움**(빌드 명령·구조 지도)
- ⚙️ `.gitignore`·`.vscode` 정리, 권한(Bash+PowerShell 병기) 추가

**즉, "복사 + `/adopt-standard`" 이 두 단계가 셋업의 전부입니다.**

> **첫 세션에 "이 폴더를 신뢰하시겠습니까?" 다이얼로그가 뜨면 수락하세요.**
> 수락 전에는 레포의 `allow` 권한 규칙이 적용되지 않아 계속 승인 프롬프트가 뜹니다
> (`deny`·`ask`는 신뢰와 무관하게 즉시 적용됩니다).

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
# 기능 만들 때:  Plan 모드로 시작 → 승인 → 구현
#                (VS Code: 프롬프트 박스 아래 모드 인디케이터 클릭 / CLI: Shift+Tab)
# 큰 작업:      /plan-feature <무엇을 만들지>   (조사 → 플랜 → 승인 → 구현)
# 새 모듈:      /scaffold-feature <이름>
# 버그:         /fix-issue <설명>
# 코드 정리:    /refactor <대상>
# 커밋 전:      /code-review   또는  "code-reviewer로 검토해줘"
# 커밋 · PR:    /commit  →  /open-pr
# 문서 갱신:    /doc-sync
#
# 스킬 전체 목록과 설명: GUIDE.md 1장
```

**되돌리고 싶으면**: 메시지에 마우스를 올리면 **되감기** 버튼이 나옵니다
(코드만 되감기 / 대화 분기 / 둘 다). Windows에는 샌드박스가 없으니 이게 실질적인 undo입니다.

마지막으로 **커밋**하면 끝. 이제 팀원이 이 레포를 clone하면 **같은 CLAUDE.md·규칙·명령**을 자동으로 갖게 됩니다.

```powershell
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

> 실제 적용 예시: 이 표준은 수십 개 프로젝트 규모의 대형 WPF 솔루션에 먼저 적용해봤습니다. 그 결과물이 레퍼런스입니다.

---

## ❓ 자주 막히는 지점 (FAQ)

**Q. `claude --version`이 "명령을 찾을 수 없음"이라고 나와요.**
→ VS Code 확장만 설치한 상태입니다. 확장은 `claude`를 PATH에 넣지 않아요. 정상입니다.
CLI도 쓰려면 준비물 0️⃣의 ②를 실행하세요.

**Q. `.template` 파일은 어떻게 해요?**
→ 손대지 마세요. `/adopt-standard`가 이름 변경(+`.template` 제거)과 내용 채움을 자동으로 합니다. 수동으로 하려면: 이름에서 `.template`을 떼고 `{{...}}`를 채우면 됩니다. → 상세 [ADOPTION.md](ADOPTION.md).

**Q. `/adopt-standard` 안 쓰고 수동으로 하고 싶어요.**
→ 됩니다. [ADOPTION.md](ADOPTION.md)의 "복사 맵"과 "스택 rule 선택"을 순서대로 따라 하면 됩니다.

**Q. 규칙이 진짜 적용되는지 확인하려면?**
→ **`/context`** 를 실행하고 **Memory files** 목록을 보세요. `CLAUDE.md`와 의도한 rule 파일이 거기 있으면 정상입니다.
(예전엔 "물어보세요"라고 안내했지만, `/context`가 실제 로드 여부를 정확히 보여줍니다.)
설정 파일에 오류가 없는지는 터미널에서 `claude doctor`.

**Q. `/` 를 눌렀는데 우리 명령이 안 보여요.**
→ VS Code 확장은 슬래시 명령의 **부분집합**만 노출합니다. 안 보이면 통합 터미널(`` Ctrl+` ``)에서 `claude`를 띄워 쓰세요.

**Q. 승인 프롬프트가 계속 떠요.**
→ ① 폴더 신뢰 다이얼로그를 수락했는지 확인(allow 규칙은 신뢰 후 적용). ② Git for Windows가 없으면
Bash 대신 PowerShell 도구가 쓰이는데 허용목록에 `PowerShell(...)`이 없으면 다 물어봅니다 → [VSCODE-WINDOWS.md](VSCODE-WINDOWS.md) 2절.

**Q. gstack 꼭 필요해요?**
→ 아니요. 2·3·5단계(복사 → `/adopt-standard` → 개발)만으로 표준은 완전히 동작합니다. gstack은 선택 도구입니다. 커맨드당 토큰을 많이 쓰니(수만~수십만) 필요할 때만.

**Q. 안 쓰는 스택 rule을 안 지우면?**
→ `.claude/rules/`의 `.md`는 **전부 자동 로드**되므로, 예를 들어 웹 레포에 WPF 규칙이 남아 있으면 엉뚱하게 적용됩니다. 꼭 지우세요(`/adopt-standard`가 대신 해줍니다).

---

## 📚 다음에 읽을 것

지금은 이 문서로 충분합니다. 더 깊이 들어갈 때 **어떤 문서를 읽어야 하는지**는
[README.md](README.md) 의 "무엇을 읽어야 하나(역할별)" 표에 정리되어 있습니다.

당장 도움이 될 두 개만 꼽자면:

- [VSCODE-WINDOWS.md](VSCODE-WINDOWS.md) — 권한 프롬프트가 계속 뜨거나 훅이 안 돌 때
- [GUIDE.md](GUIDE.md) — 팀 공통 스킬 8개와 매일 쓰는 레시피

막히면 그냥 Claude Code에게 *"START-HERE 대로 하는 중인데 여기서 막혔어"* 라고 물어보세요.

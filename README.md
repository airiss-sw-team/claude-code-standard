# Claude Code 회사 표준 (claude-code-standard)

AIRISS 개발팀이 **Claude Code를 일관되게** 쓰기 위한 표준 템플릿 팩입니다.
**스택 무관** — 웹 · 모바일/앱 · Python · .NET/WPF · 그 외 무엇이든 어떤 레포에도 **복사 → 살 붙이기**로 적용합니다. 특정 스택에 특화되어 있지 않으며, 스택별 규칙은 갈아 끼우는 모듈입니다.

> ## 👉 처음이세요? **[START-HERE.md](START-HERE.md)** 부터 보세요.
> 아무것도 몰라도 **순서대로 따라 하면 되는 단계별 튜토리얼**입니다 (흐름도 + 복붙 명령 + FAQ). 아래 README는 "구조 개요"이고, 손에 잡히는 시작은 START-HERE에 있습니다.
>
> 💻 우리 팀 기본 환경은 **Windows + VS Code 확장**입니다 → [VSCODE-WINDOWS.md](VSCODE-WINDOWS.md)

**현재 버전**: [VERSION](VERSION) · 변경 이력: [CHANGELOG.md](CHANGELOG.md) · 오너: [GOVERNANCE.md](GOVERNANCE.md) §3

## 이게 뭔가

Claude Code는 여러 곳에서 설정을 읽습니다. 이 표준은 그중 **레포(repo) 단위**를 표준화합니다.

| 계층 | 위치 | 성격 | 이 표준의 관심사 |
|---|---|---|---|
| 조직(managed) | `C:\ProgramData\ClaudeCode\` | 회사 전체(개인이 완화 불가) | 검토 중 — GOVERNANCE §2 |
| Global | `~/.claude/` | 사람 단위(모든 레포 공통) | 회사 공통 기본값 1장만 |
| **Repo** | `<repo>/CLAUDE.md`, `<repo>/.claude/`, `<repo>/.vscode/` | **프로젝트 단위(git 커밋 = 팀 공유)** | **← 핵심** |
| 개인 | `*.local.md`, `settings.local.json` | 개인(gitignore) | 각자 자유 |

핵심 아이디어: **레포에 `.claude/`를 커밋하면, clone하는 모든 팀원이 동일한 규칙·명령·리뷰 기준을 자동으로 갖는다.**

## 채택 3단계 (요약)

1. **복사**: `templates/` 안의 내용을 대상 레포 루트로 복사한다. (`.claude/`, `.vscode/`, `docs/` 폴더 포함 — 전부 `templates/` 안에 있음)
2. **`.template` 채우기**: `*.template` 파일은 **① 확장자(`.template`)를 떼고 → ② 안의 `{{...}}`를 채운다.** 손으로 해도 되지만, **레포에서 `/adopt-standard`를 실행하면 Claude가 코드를 스캔해 자동으로 이름변경+채움**을 해줍니다(권장). `gitignore.snippet`은 `.gitignore`에 append 후 삭제. → 자세한 설명은 [ADOPTION.md](ADOPTION.md#template-파일이-뭔가요-처음이라면-여기부터).
3. **스택 rule 정리**: `.claude/rules/`에서 이 레포 스택에 안 맞는 `.md` 파일을 **반드시 삭제**한다(rules는 자동 로드되므로 남기면 그대로 적용됨).

> 💡 **가장 쉬운 길**: 1번 복사만 하고 레포에서 **`/adopt-standard`** 한 번 실행하면 2·3번을 Claude가 알아서 처리합니다.

채택 직후에는 **폴더 신뢰 수락 → `claude doctor` → `/context`** 로 검증하세요([ADOPTION.md](ADOPTION.md) "검증 절차").

자세한 절차·체크리스트는 **[ADOPTION.md](ADOPTION.md)** 참고.
무엇을 커밋하고 무엇을 개인으로 두는지는 **[GOVERNANCE.md](GOVERNANCE.md)** 참고.
**매일 어떻게 쓰는지**(상황별 레시피 · gstack/디자인 스킬 · 안티패턴)는 **[GUIDE.md](GUIDE.md)** 참고.
업계 활용 사례·검증된 패턴은 **[BENCHMARKS.md](BENCHMARKS.md)** 참고.

## 디렉토리

```
claude-code-standard/
├── START-HERE.md        # ⭐ 초보자용 단계별 튜토리얼 (여기부터)
├── VSCODE-WINDOWS.md    # 💻 우리 팀 기본 환경(Windows+VS Code)에서 다른 점
├── README.md            # 이 문서 (구조 개요)
├── ADOPTION.md          # 신규/기존 프로젝트 적용 플레이북 + 검증 절차
├── GUIDE.md             # 실전 사용 가이드 (레시피·스킬·안티패턴)
├── HOOKS.md             # 훅(결정론적 강제) 가이드 — bash/PowerShell 두 벌
├── BENCHMARKS.md        # 타사 활용 사례·검증된 패턴
├── GOVERNANCE.md        # 공유 vs 개인, 소유권, 리뷰 주기
├── VERSION              # 표준 버전 (채택 레포가 출처 표기에 사용)
├── CHANGELOG.md         # 표준 변경 이력
└── templates/           # ★ 각 레포로 복사할 것 전부 여기
    ├── CLAUDE.md.template
    ├── CLAUDE.local.md.template   # (선택) 개인 메모 뼈대
    ├── gitignore.snippet          # append 후 삭제
    ├── .vscode/
    │   ├── settings.json          # 팀 공통 VS Code 확장 설정 (커밋)
    │   └── extensions.json        # 권장 확장 = 원클릭 온보딩
    ├── .claude/
    │   ├── settings.json          # 권한 baseline (Bash + PowerShell 병기)
    │   ├── rules/     # general(항상) + 스택 모듈(web/python/app/.net…) — 필요한 것만
    │   ├── commands/  # 팀 공통 슬래시 명령 (스택 무관)
    │   ├── agents/    # 팀 공통 서브에이전트
    │   ├── hooks/     # 훅 스크립트 (.sh + .ps1, opt-in)
    │   └── hooks.example.json  # 훅 설정 예시 (기본 비활성)
    └── docs/          # 지식관리(위키) 골격
        ├── 10_Raw_Sources/   # (읽기전용) 기획·리서치 원천
        └── 20_The_Wiki/      # (AI 관리) 아키텍처 위키 + architecture.md.template
```

## 설계 철학 (짧게)

- **CLAUDE.md는 짧게, 규칙은 rules/로.** 항상 로드되는 CLAUDE.md는 오버뷰+포인터만. `.claude/rules/*.md`는 세션 시작 시 자동 로드된다(그래서 사람용 안내 문서는 `.md`로 두지 않는다 — `_README.txt`).
- **카탈로그가 아니라 생성기.** 동봉된 스택 rule 4종(web/python/app/.NET)은 자주 쓰는 **예시**일 뿐이다. 실제 개발은 훨씬 다양하다(Go·Rust·C++·임베디드·ML·펌웨어…). 새 프로젝트를 시작할 때 `/adopt-standard`를 실행하면 **그 레포의 실제 코드에서 스택을 감지해 rule을 그 자리에서 생성**한다(`_TEMPLATE-new-stack.md.template` 기반). rule은 미리 만들어두는 게 아니라 **프로젝트가 시작될 때 태어난다.**
- **공유와 개인을 물리적으로 분리.** 커밋되는 것과 gitignore되는 것을 파일명으로 구분.
- **권고와 강제를 구분.** rule/CLAUDE.md는 권고, hook과 `deny`/`ask` 권한은 강제. 반드시 지켜야 할 것은 후자에 둔다.

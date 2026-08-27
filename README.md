# Claude Code 회사 표준 (claude-code-standard)

AIRISS 개발팀이 **Claude Code를 일관되게** 쓰기 위한 표준 템플릿 팩입니다.
어떤 레포에도 **복사 → `/adopt-standard` 한 번**으로 적용됩니다. 스택 무관(웹·앱·Python·.NET·그 외).

> # 👉 **[START-HERE.md](START-HERE.md)** 부터 보세요
> 처음이라면 이것 하나만 따라 하면 됩니다. 이 README는 "무엇이 어디 있는지"를 알려주는 **지도**입니다.

**버전** [VERSION](VERSION) · **변경 이력** [CHANGELOG.md](CHANGELOG.md) · **오너** [GOVERNANCE.md](GOVERNANCE.md) §3

---

## 📖 무엇을 읽어야 하나 (역할별)

| 나는… | 읽을 것 | 시간 |
|---|---|---|
| **팀에 처음 왔다 / 내 프로젝트에 적용하고 싶다** | **[START-HERE.md](START-HERE.md)** | 15분, 따라 하면서 |
| **매일 쓰는데 뭐가 있는지 모르겠다** | [GUIDE.md](GUIDE.md) — 레시피·스킬 목록·안티패턴 | 훑어보기 10분 |
| **Windows/VS Code에서 뭔가 안 된다** | [VSCODE-WINDOWS.md](VSCODE-WINDOWS.md) — 권한·훅·모드가 CLI와 다른 지점 | 문제 생겼을 때 |
| **큰 레포에 수동으로 적용해야 한다** | [ADOPTION.md](ADOPTION.md) — 절차·검증·체크리스트 | 레포당 1회 |
| **자동화(훅)를 켜고 싶다** | [HOOKS.md](HOOKS.md) | 선택 |
| **표준을 고치거나 관리한다** | [GOVERNANCE.md](GOVERNANCE.md) — 공유/개인 분리, 변경 절차 | 분기 |
| **"왜 이렇게 하나"가 궁금하다 / 팀을 설득해야 한다** | [BENCHMARKS.md](BENCHMARKS.md) — 업계 검증 패턴·실패 사례 | 근거가 필요할 때 |

---

## 🧩 이게 뭔가

Claude Code는 여러 계층에서 설정을 읽습니다. 이 표준은 그중 **레포(repo) 단위**를 표준화합니다.

| 계층 | 위치 | 성격 | 이 표준의 관심사 |
|---|---|---|---|
| 조직(managed) | `C:\ProgramData\ClaudeCode\` | 회사 전체(개인이 완화 불가) | 검토 중 — [GOVERNANCE](GOVERNANCE.md) §2 |
| Global | `~/.claude/` | 사람 단위(모든 레포 공통) | 회사 공통 기본값 1장만 |
| **Repo** | `<repo>/CLAUDE.md` · `.claude/` · `.vscode/` | **프로젝트 단위 (git 커밋 = 팀 공유)** | **← 핵심** |
| 개인 | `*.local.md` · `settings.local.json` | 개인(gitignore) | 각자 자유 |

**핵심 아이디어**: 레포에 `.claude/`를 커밋하면, clone하는 모든 팀원이 **동일한 규칙·스킬·리뷰 기준**을 자동으로 갖는다.

적용 절차는 [START-HERE.md](START-HERE.md)(따라 하기) 또는 [ADOPTION.md](ADOPTION.md)(상세·수동)에 있습니다.
**절차 설명은 그 두 문서에만 있습니다** — 여기에 복사해두면 반드시 낡기 때문입니다.

---

## 📂 무엇이 들어 있나

```
claude-code-standard/
├── START-HERE.md · GUIDE.md · VSCODE-WINDOWS.md      ← 쓰는 사람용
├── ADOPTION.md · HOOKS.md · GOVERNANCE.md · BENCHMARKS.md  ← 적용·관리·근거
├── VERSION · CHANGELOG.md
└── templates/          ★ 각 레포로 복사할 것 전부 여기
    ├── CLAUDE.md.template          # 프로젝트 오버뷰 뼈대
    ├── CLAUDE.local.md.template    # (선택) 개인 메모 뼈대
    ├── gitignore.snippet           # .gitignore에 append 후 삭제
    ├── .vscode/                    # 팀 공통 VS Code 설정 + 권장 확장
    ├── .claude/
    │   ├── settings.json           # 권한 baseline (Bash + PowerShell 병기)
    │   ├── rules/                  # 항상 지킬 규칙 (자동 로드)
    │   ├── skills/                 # 절차 = 슬래시 명령 (필요할 때만 로드)
    │   ├── agents/                 # 서브에이전트 (code-reviewer · verifier)
    │   ├── hooks/                  # 훅 스크립트 (.sh + .ps1, opt-in)
    │   └── hooks.example.json
    └── docs/                       # 지식관리(위키) 골격
        ├── 10_Raw_Sources/         # (읽기전용) 기획·리서치 원천
        └── 20_The_Wiki/            # (AI 관리) 아키텍처 위키
```

### 동봉된 팀 공통 스킬 8개

| 스킬 | 언제 |
|---|---|
| `/adopt-standard` | 표준 적용 (레포당 1회) |
| `/plan-feature` | 큰 작업 — 코딩 전 조사·설계 |
| `/scaffold-feature` | 새 기능·모듈 뼈대 |
| `/fix-issue` | 버그 수정 (근본 원인 → 최소 수정 → 검증) |
| `/refactor` | 동작 그대로, 구조만 개선 |
| `/commit` | 시크릿 검사 → 의미 단위 커밋 |
| `/open-pr` | PR 생성 |
| `/doc-sync` | 코드 ↔ 위키 동기화 |

---

## 🎯 설계 철학 (짧게)

- **CLAUDE.md는 지도, rules는 법, skills는 절차.** 항상 로드되는 것(CLAUDE.md·rules)은 짧게 유지하고, 여러 단계를 밟는 작업은 skills로 내려 **필요할 때만 로드**되게 한다.
- **권고와 강제를 구분한다.** rules/CLAUDE.md는 Claude가 무시할 수 있는 권고, hook과 `deny`/`ask` 권한은 강제. 반드시 지켜야 할 것은 후자에 둔다.
- **카탈로그가 아니라 생성기.** 동봉 스택 rule 4종은 **예시**일 뿐이다. `/adopt-standard`가 그 레포의 실제 코드에서 스택을 감지해 **rule을 그 자리에서 생성**한다. rule은 미리 만들어두는 게 아니라 프로젝트가 시작될 때 태어난다.
- **공유와 개인을 물리적으로 분리한다.** 커밋되는 것과 gitignore되는 것을 파일명으로 구분.
- **단일 출처.** 같은 설명을 두 문서에 복사하지 않는다. 복사본은 반드시 낡는다.

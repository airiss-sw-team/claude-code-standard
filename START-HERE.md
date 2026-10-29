# 🚀 여기서 시작하세요 (START HERE)

> 이 문서 하나만 위에서부터 따라 하면 내 프로젝트에 표준이 적용됩니다. 약 20분.
> 기준 환경은 **Windows + VS Code 확장**입니다. 다른 문서는 다 끝난 뒤에 필요할 때만 봅니다.

## 명령을 어디에 입력하나요?

| 표시 | 어디에 |
|---|---|
| **[터미널]** | VS Code 메뉴 **터미널 → 새 터미널** (`` Ctrl+` ``) |
| **[Claude]** | VS Code 왼쪽 Claude 아이콘으로 연 대화창. `/`로 시작하는 명령도 여기에 |

- **CLAUDE.md**: Claude가 대화를 시작할 때마다 읽는 "이 프로젝트 설명서"
- **`/이름` 명령(스킬)**: 미리 짜 둔 작업 절차. 예: `/adopt-standard`

## 1. 준비물 (처음 한 번)

| 필요한 것 | 확인 | 없으면 |
|---|---|---|
| VS Code 확장 "Claude Code" | 왼쪽에 Claude 아이콘이 있다 | 확장 탭(`Ctrl+Shift+X`)에서 "Claude Code" 설치 후 로그인 |
| Git for Windows | [터미널] `git --version` | [git-scm.com](https://git-scm.com/downloads/win)에서 설치. 없으면 Claude가 Bash 대신 PowerShell만 써서 동작이 달라집니다 |
| (권장) Claude Code CLI | [터미널] `claude --version` | [터미널] `irm https://claude.ai/install.ps1 \| iex`. `claude doctor` 같은 일부 명령에만 필요합니다 |

## 2. 표준 받기 (처음 한 번)

회사 GitHub 계정에 접근 권한이 있어야 합니다. [터미널]에서:

```powershell
git clone https://github.com/airiss-sw-team/claude-code-standard.git D:\claude-code-standard
```

다른 곳에 받았다면 아래 명령의 `D:\claude-code-standard`를 그 경로로 바꿉니다. 표준이 바뀌면 그 폴더에서 `git pull`.

## 3. 내 프로젝트에 복사하기

VS Code로 **적용할 프로젝트 폴더**를 열고 [터미널]에서 둘 중 하나를 실행합니다.

**새 프로젝트** (빈 폴더)

```powershell
git init
Copy-Item -Path "D:\claude-code-standard\templates\*" -Destination . -Recurse -Force
```

**이미 코드가 있는 프로젝트** — 이미 있는 파일은 건너뛰고 복사합니다. 위 `Copy-Item`을 쓰면 기존 설정이 덮어써지니 쓰지 마세요.

```powershell
git switch -c chore/claude-standard
robocopy D:\claude-code-standard\templates . /E /XC /XN /XO
```

복사가 끝나면 `CLAUDE.md.template`, `.claude/`, `.vscode/`, `docs/`가 생깁니다. `.template`은 아직 안 채운 뼈대라는 뜻이고, 다음 단계에서 자동으로 채웁니다.

## 4. `/adopt-standard` 실행 ⭐

[Claude]에서:

```
/adopt-standard
```

- "이 폴더를 신뢰하시겠습니까?"가 뜨면 **신뢰**를 누릅니다. 안 누르면 승인 창이 계속 뜹니다.
- Claude가 코드를 보고 스택을 감지해 맞는 규칙만 남기고, `CLAUDE.md`를 채우고, 권한과 `.gitignore`를 정리합니다.
- 빈 폴더면 어떤 스택으로 만들지 묻습니다. 기존 프로젝트면 원래 있던 `CLAUDE.md`와 설정 파일에 표준을 **합칩니다**. 표준 위치를 물으면 `D:\claude-code-standard`라고 답합니다.

끝나면 `CLAUDE.md`를 한 번 읽고 틀린 곳만 고칩니다.

## 5. 확인하고 커밋

1. [Claude]에서 **새 대화**를 열고 `/context`를 입력합니다. **Memory files**에 `CLAUDE.md`와 우리 스택 규칙이 보이면 정상입니다.
2. [Claude]에서 `/commit`. Claude가 바뀐 파일을 확인하고 나눠 커밋합니다.

✅ 끝입니다. 이제 팀원이 이 프로젝트를 clone하면 같은 규칙과 명령을 갖게 됩니다.

## 다음부터 매일 쓰는 것

| 할 일 | [Claude]에 입력 |
|---|---|
| 큰 작업 시작 | `/plan-feature 무엇을 만들지` → 계획 확인 후 승인 |
| 버그 수정 | `/fix-issue 증상이나 이슈 번호` |
| 커밋 전 검토 | `/code-review` |
| 커밋과 PR | `/commit` → `/open-pr` |

잘못된 방향으로 가면 메시지에 마우스를 올려 **되감기**를 누릅니다. 나머지 명령과 선택 도구(gstack 등)는 [GUIDE.md](GUIDE.md)에 있습니다.

## 막힐 때

| 증상 | 해결 |
|---|---|
| `claude --version`이 "찾을 수 없음" | VS Code 확장만 설치한 상태입니다. 정상이고, CLI가 필요하면 1번 표의 명령으로 설치 |
| `/adopt-standard`나 `/context`가 안 보인다 | 3번 복사가 됐는지(`.claude/skills/`가 있는지) 확인하고 새 대화를 엽니다. 그래도 없으면 VS Code 확장이 일부 명령만 보여 주는 것이니, [터미널]에서 `claude`를 실행해 거기에 입력합니다 |
| 승인 창이 계속 뜬다 | 폴더 신뢰를 눌렀는지 확인. 그래도면 [VSCODE-WINDOWS.md](VSCODE-WINDOWS.md) 2절 |
| 자동 말고 직접 적용하고 싶다 | [ADOPTION.md](ADOPTION.md)의 "복사 맵"과 "스택 rule 선택" |

그 밖에는 [Claude]에 *"START-HERE대로 하는 중인데 여기서 막혔어"*라고 물어보세요.

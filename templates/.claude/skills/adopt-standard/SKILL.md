---
description: 이 레포에 회사 Claude Code 표준을 적용한다 (스택 감지 → rule 정리/생성 → CLAUDE.md 채움 → 검증). 표준 템플릿을 복사한 직후 1회 실행.
disable-model-invocation: true
---
# /adopt-standard

이 레포에 claude-code-standard를 적용한다. 표준 레포 ADOPTION.md의 수동 절차를 자동화한 것.
전제: `templates/` 내용이 이미 이 레포에 복사되어 있다(없으면 먼저 복사 위치를 사용자에게 확인).
기존 레포는 이미 있던 파일(`CLAUDE.md`, `.claude/settings.json`, `.vscode/settings.json`)을 건너뛰고 복사했을 수 있다. 그 파일에 표준 내용을 합쳐야 하면 표준 레포 위치(예: `D:\claude-code-standard`)를 사용자에게 묻고 그곳의 `templates/`를 읽는다.

절차:

1. **스택 감지**: 레포를 스캔해 실제 스택을 판별한다.
   근거: 매니페스트(package.json, *.csproj/.sln, pyproject.toml/requirements, go.mod, Cargo.toml, CMakeLists.txt, pubspec.yaml, build.gradle 등) + 주요 소스 확장자 분포. 복수 스택(모노레포)이면 전부 나열하고 사용자에게 확인.
   코드가 아직 없어 감지할 것이 없으면 어떤 스택으로 만들지 사용자에게 묻는다. 답이 없으면 `general-engineering.md`만 남기고 나머지 단계는 스택 무관한 것만 진행한 뒤, "스택이 정해지면 다시 실행"을 보고한다.

2. **rule 정리**: `.claude/rules/`에서
   - `general-engineering.md`는 유지.
   - 감지된 스택과 맞는 rule은 유지, **안 맞는 스택 rule은 삭제**(자동 로드되므로 필수).
   - 감지된 스택의 rule이 **없으면** `_TEMPLATE-new-stack.md.template`을 복사해 `<스택>.md`를 만들고, **이 레포 코드에서 관찰되는 실제 관례**(포매터 설정, 폴더 구조, 에러 처리 패턴)를 근거로 채운다. 추측 금지 — 코드에서 확인된 것만. 확인 안 되는 섹션은 사용자에게 물어본다.
     새로 만든 파일은 이 레포 고유 규칙이므로 상단의 `※ 표준 원본: ...` 줄을 `※ 이 레포 고유 규칙 — 레포에서 직접 수정한다.`로 바꾼다. 표준 원본 표기가 남으면 표준 파일 보호 훅이 이 파일 수정을 막는다.
   - `_TEMPLATE-new-stack.md.template` 자체는 사용 후 삭제(`.template` 확장자라 자동 로드는 안 되지만 잔재 정리). `_README.txt`는 `.md`가 아니라 로드되지 않으므로 그대로 둔다.

3. **CLAUDE.md 채움**: `CLAUDE.md`가 이미 있으면 기존 내용을 지우지 않고, 템플릿에서 빠진 섹션만 알맞은 위치에 추가한 뒤 `CLAUDE.md.template`을 삭제한다. 없으면 `CLAUDE.md.template`을 `CLAUDE.md`로 이름 변경 후, placeholder를 역설계로 채운다:
   - 한 줄 요약, 스택, 구조 지도 — 실제 코드/폴더 기준.
   - 빌드, 테스트, 실행 명령 — **실제로 실행해 확인한 것만 기입**(장비 연동 등 위험한 실행은 제외하고 그 사실을 명시).
   - 활성 rule 목록을 2번 결과와 일치시킨다.

4. **gitignore**: 스택 표준 무시 규칙(bin/obj, node_modules, __pycache__ 등)이 없으면 먼저 추가하고, `gitignore.snippet` 내용을 append 후 스니펫 삭제. `.vscode/`를 통째로 무시하고 있으면 `!.vscode/settings.json`, `!.vscode/extensions.json` 예외를 뚫는다. `architecture.md.template`도 이름 변경.

5. **settings.json**: 이 스택의 빌드/테스트 명령을 allow에 추가한다. 예: 웹은 `npm run build`, Python은 `pytest`·`ruff`·`uv run`, 모바일은 `flutter`·`gradle`, .NET은 `dotnet build`·`dotnet test`·`dotnet format`.
   - **Bash와 PowerShell을 반드시 병기한다.** 네이티브 Windows에서 Git for Windows가 없으면 Bash 도구 자체가 없어 `Bash(...)` 규칙이 하나도 매칭되지 않는다. 예: `"Bash(dotnet build:*)"` 와 `"PowerShell(dotnet build *)"`.
   - 이 레포에 **파괴적/장비성 명령**(DB 마이그레이션, 장비 제어, 배포)이 있으면 `ask`에 추가한다. `ask`는 auto 모드에서도 사람에게 묻는다.
   - **deny는 절대 삭제하지 않는다.** 이 레포에 시크릿 파일 패턴이 더 있으면 `Read(...)`와 `Edit(...)` deny를 짝으로 추가한다.
   - 레포에 이미 `.claude/settings.json`이 있으면 표준의 `ask`, `deny`, `disableBypassPermissionsMode`를 빠짐없이 병합한다. 기존 `allow`에 `git restore`처럼 표준이 `ask`로 옮긴 명령이 있어도 `ask`가 이기므로 그대로 둬도 된다.

6. **VS Code 설정**: `.vscode/settings.json`, `.vscode/extensions.json`이 복사되었는지 확인한다. 레포에 이미 `.vscode/settings.json`이 있으면 **덮어쓰지 말고 `claudeCode.*` 키만 병합**한다.

7. **검증**: 직접 할 수 있는 것은 실행하고, 나머지는 사용자가 확인하도록 안내한다.
   - 직접: 바꾼 JSON 파일(`.claude/settings.json`)을 파싱해 문법 오류가 없는지, `.claude/rules/`에 남은 `.md`가 2번 결과와 같은지, `{{`가 남은 곳이 없는지.
   - 사용자에게 안내 (Claude가 대신 할 수 없음): 새 대화를 연 뒤 Claude 입력창에서 `/context`로 **Memory files**에 `CLAUDE.md`와 의도한 rule만 있는지, `/`를 입력해 이 레포 명령이 보이는지. CLI가 있으면 터미널에서 `claude doctor`로 Settings Error가 없는지.

8. **보고**: 무엇을 감지했고, 무엇을 삭제/생성/채웠는지 요약. 남은 수동 항목(권한 이관, 폴더 신뢰 수락, 커밋)을 체크리스트로 제시. 커밋은 사용자 요청 시에만.

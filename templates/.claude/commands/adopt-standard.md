---
description: 이 레포에 회사 Claude Code 표준을 자동 적용 (스택 감지 → rule 정리/생성 → CLAUDE.md 채움)
---

# /adopt-standard

이 레포에 claude-code-standard를 적용한다. ADOPTION.md의 수동 절차를 자동화한 것.
전제: `templates/` 내용이 이미 이 레포에 복사되어 있다(없으면 먼저 복사 위치를 사용자에게 확인).

절차:

1. **스택 감지**: 레포를 스캔해 실제 스택을 판별한다.
   근거: 매니페스트(package.json, *.csproj/.sln, pyproject.toml/requirements, go.mod, Cargo.toml, CMakeLists.txt, pubspec.yaml, build.gradle 등) + 주요 소스 확장자 분포. 복수 스택(모노레포)이면 전부 나열하고 사용자에게 확인.

2. **rule 정리**: `.claude/rules/`에서
   - `general-engineering.md`는 유지.
   - 감지된 스택과 맞는 rule은 유지, **안 맞는 스택 rule은 삭제**(자동 로드되므로 필수).
   - 감지된 스택의 rule이 **없으면** `_TEMPLATE-new-stack.md.template`을 복사해 `<스택>.md`를 만들고, **이 레포 코드에서 관찰되는 실제 관례**(포매터 설정, 폴더 구조, 에러 처리 패턴)를 근거로 채운다. 추측 금지 — 코드에서 확인된 것만. 확인 안 되는 섹션은 사용자에게 물어본다.
   - `_TEMPLATE-new-stack.md.template` 자체는 사용 후 삭제(`.template` 확장자라 자동 로드는 안 되지만 잔재 정리).

3. **CLAUDE.md 채움**: `CLAUDE.md.template`이 남아있으면 `CLAUDE.md`로 이름 변경 후, placeholder를 역설계로 채운다:
   - 한 줄 요약·스택·구조 지도 — 실제 코드/폴더 기준.
   - 빌드·테스트·실행 명령 — **실제로 실행해 확인한 것만 기입**(장비 연동 등 위험한 실행은 제외하고 그 사실을 명시).
   - 활성 rule 목록을 2번 결과와 일치시킨다.

4. **gitignore**: 스택 표준 무시 규칙(bin/obj, node_modules, __pycache__ 등)이 없으면 먼저 추가하고, `gitignore.snippet` 내용을 append 후 스니펫 삭제. `architecture.md.template`도 이름 변경.

5. **settings.json**: 이 스택의 빌드/테스트 명령을 allow에 추가(ADOPTION.md 표 참조). **deny는 절대 삭제하지 않는다.**

6. **보고**: 무엇을 감지했고, 무엇을 삭제/생성/채웠는지 요약. 남은 수동 항목(권한 이관, 커밋)을 체크리스트로 제시. 커밋은 사용자 요청 시에만.

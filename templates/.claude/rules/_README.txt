이 폴더(.claude/rules/)의 *.md 파일은 세션 시작 시 전부 자동 로드됩니다.

  → 이 레포 스택에 안 맞는 rule 파일은 반드시 삭제하세요. 남기면 그대로 적용됩니다.
  → general-engineering.md 는 항상 유지합니다(모든 레포 공통).
  → documentation.md 는 frontmatter 의 paths: 로 스코프되어 있어
     문서(*.md, docs/**)를 다룰 때만 로드됩니다. 항상 로드되지 않으므로 그대로 두세요.
  → 특정 파일에만 적용하고 싶은 규칙은 같은 방식으로 paths: 를 씁니다.
  → 새 스택 rule 은 _TEMPLATE-new-stack.md.template 을 복사해 만듭니다.

rule(권고) vs skill(절차)의 구분:
  - "항상 지켜야 하는 원칙"  → rules/     (예: 이름 짓기, 커밋 규약)
  - "여러 단계를 밟는 작업"   → skills/    (예: /commit, /plan-feature, /refactor)

작성 규약과 전체 설명: 표준 레포의 ADOPTION.md "스택 rule 선택" 절.
(이 안내를 .md 로 두면 그것마저 매 세션 로드되므로 .txt 로 둡니다.)

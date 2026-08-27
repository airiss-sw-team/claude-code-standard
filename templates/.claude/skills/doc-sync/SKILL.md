---
description: 코드 변경을 docs/20_The_Wiki 아키텍처 위키에 반영한다. 모듈 추가·삭제·역할 변경 후 문서가 코드와 어긋났을 때 사용.
allowed-tools:
  - Bash(git diff:*)
  - Bash(git log:*)
  - PowerShell(git diff *)
  - PowerShell(git log *)
---
# /doc-sync

현재 레포의 코드와 `docs/20_The_Wiki/`의 문서를 동기화한다.

절차:
1. 최근 변경(또는 지정된 모듈)을 파악한다. `git diff`/`git log`로 무엇이 바뀌었는지 확인.
2. `docs/20_The_Wiki/`의 관련 문서(특히 `architecture.md`)를 읽는다.
3. 코드와 문서가 어긋난 부분을 찾는다: 새 모듈/삭제된 모듈, 바뀐 역할, 새 계층.
4. 문서를 코드 현실에 맞게 갱신한다. 모듈 간 관계는 `[[모듈명]]` 위키링크로 연결한다.
5. `docs/10_Raw_Sources/`(읽기전용 원천)는 **수정하지 않는다** — 읽기만 한다.
6. 변경 요약을 사용자에게 보고한다(커밋은 요청 시에만).

주의: 추측으로 문서를 채우지 말고, 코드에서 확인된 사실만 기록한다.

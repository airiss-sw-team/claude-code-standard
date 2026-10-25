---
description: 변경분을 검토해 의미 단위로 커밋한다. 시크릿 검사 → 변경 요약 → Conventional Commits 메시지 → 커밋. 푸시는 하지 않는다.
disable-model-invocation: true
allowed-tools:
  - Bash(git status)
  - Bash(git diff:*)
  - Bash(git log:*)
  - PowerShell(git status)
  - PowerShell(git diff *)
  - PowerShell(git log *)
---

# /commit

현재 변경분을 커밋한다. **푸시는 하지 않는다**(원하면 사용자가 따로 요청).

## 1. 검토

- `git status` + `git diff`(스테이징 안 된 것 포함)로 **무엇이 바뀌었는지 실제로 읽는다.**
- ⚠ **시크릿 검사**: 키, 토큰, 비밀번호, 커넥션 스트링, `.env`, 인증서가 섞여 있지 않은지 확인한다.
  발견하면 **커밋하지 말고 즉시 알린다.**
- ⚠ 의도치 않은 파일이 섞였는지 확인한다: 빌드 산출물, 로컬 설정, **`.claude/settings.json`**
  (VS Code 승인 카드가 공유 파일에 권한을 써넣었을 수 있다), 디버그용 임시 코드.
- 최근 커밋 메시지 스타일을 `git log --oneline -10` 으로 확인해 **이 레포 관례를 따른다.**

## 2. 쪼개기

변경이 **서로 다른 목적**을 담고 있으면 나눠서 커밋할지 제안한다.
"기능 추가 + 무관한 리팩토링"이 한 커밋에 섞이면 되돌리기 어렵다.

## 3. 메시지

이 레포에 기존 관례가 있으면 그것을 따른다. 없으면 **Conventional Commits**:

```
<타입>: <무엇을 왜> (한 줄, 명령형, 72자 이내)

(필요할 때만) 본문 — 왜 이렇게 했는지, 대안을 왜 안 골랐는지.
```

타입: `feat` `fix` `refactor` `docs` `test` `chore` `perf` `build`

- **무엇을 했는지가 아니라 무엇이 달라지는지**를 쓴다.
- 이슈 번호가 있으면 본문에 참조한다.
- 한국어/영어는 이 레포 기존 커밋을 따른다.

## 4. 커밋

- 스테이징할 파일을 **명시적으로** 지정한다. 의도 확인 없이 `git add -A` 하지 않는다.
- **기본 브랜치(main/master)에 바로 커밋할지는 레포 `CLAUDE.md` 가 정한다.** 정하지 않았으면 먼저 브랜치를 만들 것을 제안한다.
- 훅(pre-commit 등)이 실패하면 **우회하지 말고**(`--no-verify` 금지) 원인을 고친다.
- 커밋 후 `git log --oneline -1` 로 결과를 보여준다.

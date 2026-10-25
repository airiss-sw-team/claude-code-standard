---
description: 현재 브랜치로 GitHub Pull Request를 만든다. 브랜치 전체 변경을 요약해 PR 본문을 작성하고 gh CLI로 생성한다.
disable-model-invocation: true
allowed-tools:
  - Bash(git log:*)
  - Bash(git diff:*)
  - Bash(git status)
  - PowerShell(git log *)
  - PowerShell(git diff *)
  - PowerShell(git status)
---

# /open-pr

현재 브랜치의 작업을 PR로 만든다. 전제: `gh` CLI 설치와 인증 완료(`gh auth status`).

## 1. 상태 확인

- 기본 브랜치 대비 **브랜치 전체 변경**을 본다(마지막 커밋만이 아니라):
  `git log <base>..HEAD --oneline` + `git diff <base>...HEAD --stat`
- 커밋 안 된 변경이 남아 있으면 알리고, 포함할지 묻는다.
- 원격에 브랜치가 없으면 푸시가 필요하다는 것을 **먼저 알리고 승인받는다.**

## 2. PR 본문

```markdown
## 무엇을
(한 문단 — 이 PR이 무엇을 바꾸는가)

## 왜
(배경과 문제. 이슈가 있으면 `Closes #123`)

## 어떻게 검증했나
- [ ] 빌드 통과 (실행한 명령을 적는다)
- [ ] 테스트 통과 / 수동 확인 절차
- [ ] (UI면) 화면 확인

## 리뷰어가 봐줬으면 하는 곳
(자신 없는 부분, 트레이드오프를 택한 지점)
```

- **실제로 검증한 것만 체크**한다. 안 돌려봤으면 안 돌려봤다고 쓴다.
- 레포에 `.github/PULL_REQUEST_TEMPLATE.md` 가 있으면 **그것을 우선** 따른다.

## 3. 생성

```bash
gh pr create --base <base> --title "..." --body-file <임시파일>
```

- 생성 후 URL을 사용자에게 보여준다.
- 머지는 **하지 않는다.** 사용자가 따로 요청할 때만.

> 💡 리뷰는 빌트인 `/code-review`(현재 diff)나 공식 플러그인 `pr-review-toolkit`을 쓴다.

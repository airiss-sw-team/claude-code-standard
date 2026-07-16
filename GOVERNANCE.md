# 거버넌스 (GOVERNANCE)

"무엇을 공유하고 무엇을 개인으로 두는가"와 표준 운영 규칙.

## 1. 공유(커밋) vs 개인(gitignore)

| 파일/폴더 | 성격 | git |
|---|---|---|
| `CLAUDE.md` | 프로젝트 오버뷰(팀 공유) | ✅ 커밋 |
| `.claude/rules/` | 코딩 규칙(팀 공유, 자동 로드) | ✅ 커밋 |
| `.claude/commands/` | 슬래시 명령(팀 공유) | ✅ 커밋 |
| `.claude/agents/` | 서브에이전트(팀 공유) | ✅ 커밋 |
| `.claude/settings.json` | 팀 공통 권한·설정 | ✅ 커밋 |
| `docs/10_Raw_Sources/` | 기획·리서치 원천 | ✅ 커밋(민감정보 제외) |
| `docs/20_The_Wiki/` | AI가 관리하는 아키텍처 위키 | ✅ 커밋 |
| `CLAUDE.local.md` | 개인 메모·실험 | ❌ gitignore |
| `.claude/settings.local.json` | 개인 권한·오버라이드 | ❌ gitignore |

(세션·플랜·히스토리는 레포가 아닌 `~/.claude/` 사용자 전역에 저장되므로 관리 대상이 아니다.)

**원칙**: 커밋되는 것은 **비밀이 없어야** 한다. API 키·비밀번호·토큰은 절대 `settings.json`이나 `CLAUDE.md`에 넣지 않는다(개인 `settings.local.json` 또는 별도 시크릿 관리).

## 2. settings.json 분리 규약

- **공유 `settings.json`**: 팀 전체가 동일하게 필요한 안전한 권한만. 예) 해당 레포의 빌드/테스트/조회 명령.
- **개인 `settings.local.json`**: 개인 취향·실험적 권한·머신 특화 경로. 커밋 안 됨.
- 위험한 권한(광범위 삭제, 무제한 네트워크 등)은 공유에 넣지 않는다.
- **deny 규칙은 레포에서 추가만 가능, 삭제 금지.** 표준 baseline의 deny(예: `.env` 읽기 금지)를 완화하려면 표준 레포 PR로만 한다.

## 3. 소유권 & 변경 절차

- **표준 레포(claude-code-standard) 오너**: **airiss-hgko** (표준 도입 주도자. 변경 시 이 줄을 갱신할 것.)
- 범용 규칙(rules 코어, 템플릿) 변경은 이 레포에서 PR로. 머지 시 [CHANGELOG.md](CHANGELOG.md) 기록 + [VERSION](VERSION) 증가.
- **레포별 규칙**: 각 레포의 `.claude/`는 그 레포 메인테이너가 관리. 단, **표준에서 복사된 파일은 레포에서 직접 수정하지 않는다** — 수정이 필요하면 표준 레포에 PR 후 재배포. 레포 고유 규칙은 별도 파일로.
- **전파**: 표준 변경 → 각 레포가 분기 diff 점검으로 반영([ADOPTION.md](ADOPTION.md) "채택 후 유지").

## 4. 리뷰 주기

- **분기 1회** 표준 점검: 죽은 규칙 제거, Claude Code 신기능 반영, 실제로 안 지켜지는 규칙 현실화, 각 레포 drift 점검.
- CLAUDE.md가 **길어지면 경고 신호**. 상세는 `rules/`로 밀고 CLAUDE.md는 포인터로 유지.

## 5. 안티패턴 (하지 말 것)

- ❌ CLAUDE.md에 모든 규칙을 다 넣어 비대하게 만들기 → 항상 로드되어 컨텍스트 낭비. rules/로 분리.
- ❌ 스택에 안 맞는 rule을 남겨두기 → **자동 로드되므로 그대로 적용되어 오염됨.** 반드시 삭제.
- ❌ 개인 실험 권한을 공유 settings.json에 커밋 → 팀 전체에 강요됨.
- ❌ 비밀을 커밋 파일에 기입.
- ❌ 표준에서 복사된 rule을 레포에서 직접 수정(포크 drift) → diff 동기화가 깨짐. 표준 레포 PR로.
- ❌ 표준 baseline의 deny 규칙을 레포에서 삭제.

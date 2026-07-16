# 타사 활용 사례 & 검증된 패턴 (BENCHMARKS)

우리 표준이 "감"이 아니라 업계 검증 위에 서 있음을 보이는 근거 문서.
출처는 Anthropic 공식 문서·엔지니어링 블로그 + 실제 고객 사례.
(조사일 2026-07-16. 각 항목 끝 링크가 1차 출처.)

---

## 1. 업계에서 검증된 핵심 패턴 7가지

| # | 패턴 | 누가 | 우리 표준의 대응 |
|---|---|---|---|
| 1 | **CLAUDE.md는 git 공유하되 "짧게"** — 매 세션 로드되므로 길면 중요 규칙이 묻혀 무시됨. "이 줄 지우면 Claude가 실수하나?"로 계속 가지치기 | Anthropic 공식 + 내부 팀 전반 | ✅ "CLAUDE.md는 지도, 규칙은 rules/로" 원칙 그대로 |
| 2 | **모노레포 계층형 CLAUDE.md** — 루트(전사) + 패키지별. 각 오너가 유지보수 | Anthropic 대규모 코드베이스 가이드 | ✅ Global(개인) + Repo(팀) 2-tier. AR.App.* 멀티프로젝트에 적합 |
| 3 | **`.claude/`(commands·agents·skills·.mcp.json)를 커밋해 표준화** — "중앙 팀이 설정하고 체크인해 전원이 혜택". 원클릭 진입장벽이 확산의 핵심 | Anthropic 엔터프라이즈 가이드 + 커뮤니티 | ✅ 이 표준의 본체가 정확히 이것 |
| 4 | **탐색→플랜→구현→검증 루프 + 검증수단 제공** — 검증 루프 없으면 사람이 병목 | Anthropic 공식 + Rakuten(vLLM 1,250만 라인에서 7시간 무인 자율코딩) | ✅ Plan 모드 + rule의 "실행으로 검증" |
| 5 | **허용목록+샌드박스+훅으로 권한 관리** (skip-permissions 아님) — 사용자는 프롬프트 93%를 승인 → 프롬프트가 안전장치 역할 못함 | Anthropic 공식 + auto mode 설계 | ✅ 공유 settings.json 허용목록 + deny 삭제금지 |
| 6 | **헤드리스(`claude -p`) CI 통합·대량 마이그레이션·자동 PR 리뷰** | Anthropic 내부, HubSpot(수개월 마이그레이션 가속), CircleCI(엔지니어 90% 일상 사용) | ⏳ 향후 확장 여지(현재 표준은 로컬 중심) |
| 7 | **서브에이전트 분리 + 적대적 리뷰** — 신선한 컨텍스트가 리뷰 품질↑. 단 "갭 찾으라면 항상 찾으므로" 정확성 영향만 보고 | Anthropic 공식 + Rakuten(AI 코드리뷰 표준화) | ✅ `code-reviewer` 에이전트가 이 패턴 |

**출처**: [Best Practices(공식)](https://code.claude.com/docs/en/best-practices) · [엔지니어링 원문](https://www.anthropic.com/engineering/claude-code-best-practices) · [대규모 코드베이스](https://code.claude.com/docs/en/large-codebases) · [Scaling Agentic Coding](https://resources.anthropic.com/scaling-agentic-coding) · [Anthropic 팀 활용기](https://claude.com/blog/how-anthropic-teams-use-claude-code) · [Rakuten](https://claude.com/customers/rakuten) · [HubSpot](https://claude.com/customers/hubspot) · [CircleCI](https://claude.com/customers/circleci) · [auto mode](https://www.anthropic.com/engineering/claude-code-auto-mode)

---

## 2. 실패 사례 (우리가 피하려는 것)

1. **비대한 CLAUDE.md** — 길어지면 "Claude가 절반을 무시". 규칙을 어겨도 CLAUDE.md에 추가하지 말고 가지치기하거나 훅으로 전환하라는 게 공식 처방. → 우리: rules/ 분리 + 자동로드 경고.
2. **`--dangerously-skip-permissions` 남용** — 2025.12 문서화된 사례: Claude가 `rm -rf ... ~/`(홈 포함) 생성. Anthropic 내부도 "원격 브랜치 삭제, 토큰 업로드, 프로덕션 DB 마이그레이션 시도" 인시던트 기록 → auto mode 탄생 계기. → 우리: skip-permissions 금지, deny baseline. **특히 PLC 장비제어·DB 걸린 우리 코드베이스에 직결.**
3. **승인 피로** — 프롬프트 93% 승인 = "열 번째부터는 검토 아닌 클릭". auto mode 분류기조차 과잉행동 17%를 놓침 → 무인 실행엔 git+샌드박스+검증 게이트 필수. → 우리: 위험 실행은 rule에서 "먼저 확인".
4. **키친싱크 세션 / 무한 탐색** — 무관 작업 섞기, 범위 없는 "조사해줘"로 컨텍스트 오염. 2번 이상 교정했으면 `/clear` 후 새 프롬프트가 낫다. → 우리: GUIDE의 상황별 레시피로 세션 목적 분리.
5. **검증 없는 신뢰** — 그럴듯하나 엣지케이스 놓친 구현 배포("검증 못하면 배포 마라"). Intercom 전사배포도 "1,000명이 스킬 기여 시 품질저하 방지"가 미해결 과제. → 우리: GOVERNANCE의 표준 오너십 + 검증 우선 rule.

**출처**: [Best Practices](https://code.claude.com/docs/en/best-practices) · [skip-permissions 사고 분석](https://blog.promptlayer.com/claude-dangerously-skip-permissions/) · [auto mode](https://www.anthropic.com/engineering/claude-code-auto-mode) · [Intercom 전사배포](https://ideas.fin.ai/p/we-gave-claude-code-to-everyone-at)

---

## 3. 우리 팀 우선 적용 3가지 (검증된 저위험·고효과順)

1. **레포별 CLAUDE.md + `.claude/` 커밋부터 (최고 ROI, 1주 내)** — 지금 하고 있는 그것. AR.App.* 멀티프로젝트 구조에 계층형 CLAUDE.md가 정확히 맞음(패턴 1·3).
2. **"검증 수단 먼저" + 허용목록 권한** — WPF는 자동테스트가 약하니 최소 "빌드 성공 + 화면 스크린샷"을 Claude가 스스로 확인. Python/웹은 pytest·린터를 게이트로. skip-permissions 대신 허용목록(패턴 4·5, 실패 2·3).
3. **온보딩 도구로 공식화** — "이 ViewModel이 어디서 바인딩되나", "이 파이프라인 업스트림이 뭐냐"를 신규자가 Claude Code에 먼저 묻게. Anthropic 내부·공식 문서가 검증한 저위험·고효과 진입점.

**전체 출처**: 위 링크 + [Classmethod(rulesync 99%를 Claude Code로)](https://claude.com/customers/classmethod) · [모노레포 가이드](https://code.claude.com/docs/en/large-codebases)

> 참고: Canva는 Claude "디자인" 파트너십은 있으나 엔지니어링 조직의 Claude Code 도입 문서는 확인 안 돼 제외. 검증 안 된 사례는 싣지 않음.

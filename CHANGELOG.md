# Changelog

표준 변경 이력. 버전은 [VERSION](VERSION)과 동기.

## 0.4.0 — 2026-07-16

- **general-engineering.md에 "핵심 행동 원칙" 추가** — Think Before Coding · Simplicity First · Surgical Changes · Goal-Driven. 특히 "코딩 전 추측 금지·트레이드오프 먼저 드러내기"(기존 rule의 공백). A. Karpathy 원칙(F. Chang 정리) + 사내 정리글 각색, 출처 표기. 모든 레포에 자동 적용.

## 0.3.0 — 2026-07-16

- **HOOKS.md + 훅 예시 추가** — 결정론적 강제 장치. 검증된 스키마 요약, opt-in 예시 2종:
  - `format-on-edit.sh` — 저장 시 확장자별 포맷(포매터 없으면 무해하게 skip, 스택 무관)
  - `guard-standard-files.sh` — "표준 원본" 마커 파일 직접수정 차단(포크 드리프트 방지, exit 2)
  - `hooks.example.json` — 기본 비활성. 환경 테스트 후 settings.json에 opt-in.
- rule vs hook 갭(v0.2에서 지적) 해소. README/GUIDE 링크 반영.

## 0.2.0 — 2026-07-16

- **GUIDE.md 추가** — 실전 사용 가이드: 팀 공통 기본기, 상황별 레시피(신규/기존/일상), gstack·디자인 스킬 활용(`/teach-impeccable` 등), rule vs hook 차이, 안티패턴.
- **BENCHMARKS.md 추가** — 타사/Anthropic 검증 패턴 7종 + 실패 사례 5종 + 우리 팀 우선 적용 3종. 전부 1차 출처 링크 포함.
- README에 GUIDE/BENCHMARKS 링크·트리 반영.

## 0.1.0 — 2026-07-16

최초 릴리스.

- 2-tier 구조(Global 개인 / Repo 팀 공유) + 스택 무관 코어 rule + 스택 모듈 설계
- rules: `general-engineering`(항상) + `web-react-next` · `python` · `mobile-app` · `dotnet-wpf-prism`
- commands: `/doc-sync` · `/fix-issue` · `/scaffold-feature` (스택 무관)
- agents: `code-reviewer`
- 문서: README · ADOPTION · GOVERNANCE, docs 위키 골격(10_Raw_Sources / 20_The_Wiki)
- **생성기 메커니즘**: `/adopt-standard`(스택 자동 감지 → rule 정리/생성 → CLAUDE.md 자동 채움) + `_TEMPLATE-new-stack.md.template`(임의 스택 rule 10분 작성 뼈대). 동봉 스택 rule 4종은 예시일 뿐, 어떤 스택이든 채택 시점에 rule 생성.
- 교차 검증(사양 정합성 + 일관성·온보딩 리허설) 반영:
  - `.claude/rules/` 자동 로드 사실 반영(안 쓰는 rule 삭제 필수로 명시)
  - gitignore 스니펫에서 사용자 전역 산출물 항목 제거
  - `architecture.md.template` 추가(신규 채택 깨진 링크 방지)
  - docs 골격을 `templates/` 아래로 통합(복사 출처 단일화)
  - VERSION/CHANGELOG/오너 지정, deny 완화 금지 규칙

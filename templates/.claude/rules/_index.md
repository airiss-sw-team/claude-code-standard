# rules/ 사용법

이 폴더의 `.md` 규칙 파일들은 **세션 시작 시 자동 로드**됩니다.
(`paths:` frontmatter로 특정 파일 패턴에 스코프를 걸지 않는 한, `.claude/rules/*.md`는 CLAUDE.md와 같은 우선순위로 항상 로드됨. CLAUDE.md의 `@.claude/rules/...` 참조는 필수가 아니라 "이 레포가 어떤 규칙을 쓰는지" 명시하는 문서화 목적.)

**따라서 중요**: 이 폴더에 있는 파일은 전부 로드되므로, **이 레포 스택에 안 맞는 rule 파일은 반드시 삭제**해야 한다. 남겨두면 그대로 적용된다.

## 설계: 스택 무관 코어 + 스택 모듈
- **`general-engineering.md`는 모든 레포에 항상** 적용(스택 무관 공통).
- 나머지는 **스택 모듈**이다. 이 레포에 해당하는 것만 남긴다.
- **아래 목록은 닫힌 집합이 아니다.** 웹·앱·Python·.NET·Go·Rust 등 무엇이든, 필요한 스택 파일을 추가하면 된다.

## 특정 파일에만 적용하고 싶을 때
frontmatter에 `paths:`를 쓰면 해당 패턴의 파일을 다룰 때만 로드된다:

```markdown
---
paths:
  - "**/*.xaml"
---
# XAML 전용 규칙...
```

## 규칙 파일 (예시 — 스택마다 추가/삭제)
| 파일 | 언제 |
|---|---|
| `general-engineering.md` | **항상** (스택 무관 공통) |
| `web-react-next.md` | 웹 프론트엔드(React/Next 등) |
| `python.md` | Python(FastAPI 등 웹 백엔드·CLI·스크립트·ML 포함) |
| `mobile-app.md` | 모바일/데스크톱 앱(iOS·Android·Flutter·RN·Electron) |
| `dotnet-wpf-prism.md` | .NET / WPF / Prism 데스크톱 |
| *(추가)* | *새 스택(Go·Rust·C++·임베디드·ML…)은 `_TEMPLATE-new-stack.md.template`을 복사해 10분 안에 작성. `/adopt-standard`가 자동으로 해줌* |

**위 4개는 카탈로그가 아니라 자주 쓰는 예시일 뿐이다.** 표준의 본체는 "코어 + 스택 모듈" 구조이지 특정 스택 목록이 아니다.

## 원칙
- **안 쓰는 스택 rule은 삭제**한다 — 자동 로드되므로 남기면 오염된다.
- 프로젝트 고유 규칙은 이 폴더에 새 파일로 추가한다.
- 범용화 가치가 있으면 표준 레포(claude-code-standard)로 승격한다.
- 규칙은 **짧고 실행 가능**하게. 지켜지지 않을 규칙은 쓰지 않는다.

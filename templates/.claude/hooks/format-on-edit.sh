#!/usr/bin/env bash
# format-on-edit.sh — Claude가 파일을 Edit/Write 한 직후 확장자에 맞는 포매터를 실행.
# 스택 무관: 확장자로 분기하며, 해당 포매터가 설치돼 있지 않으면 조용히 넘어간다(워크플로를 절대 깨지 않음).
# 연결: .claude/settings.json 의 PostToolUse(Edit|Write) 훅에서 이 스크립트를 호출.
# 요구: bash + jq. (Windows는 Git Bash에서 실행)

set -euo pipefail

# stdin JSON에서 편집된 파일 경로를 읽는다.
input="$(cat)"
file="$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null || true)"
[ -z "$file" ] && exit 0
[ -f "$file" ] || exit 0

have() { command -v "$1" >/dev/null 2>&1; }

case "$file" in
  *.ts|*.tsx|*.js|*.jsx|*.json|*.css|*.scss|*.md|*.html)
    have npx && npx --no-install prettier --write "$file" >/dev/null 2>&1 || true
    ;;
  *.py)
    if have ruff; then ruff format "$file" >/dev/null 2>&1 || true
    elif have black; then black -q "$file" >/dev/null 2>&1 || true
    fi
    ;;
  *.go)
    have gofmt && gofmt -w "$file" >/dev/null 2>&1 || true
    ;;
  *.rs)
    have rustfmt && rustfmt "$file" >/dev/null 2>&1 || true
    ;;
  # .cs/.xaml 은 dotnet format 이 솔루션 단위라 파일별 실행이 느려 기본 제외.
  # 필요하면 여기 case 를 추가하되, 성능을 확인하고 결정할 것.
  *)
    : ;;
esac

exit 0

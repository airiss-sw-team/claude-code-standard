#!/usr/bin/env bash
# guard-standard-files.sh — 표준 레포에서 복사된 파일(헤더에 "표준 원본" 표기가 있는 rule 등)을
# 레포에서 직접 수정하려 하면 차단한다. GOVERNANCE의 "포크 드리프트 금지"를 결정론적으로 강제.
# 연결: .claude/settings.json 의 PreToolUse(Edit|Write) 훅.
# 요구: bash + jq. (Windows는 Git Bash)
# exit 2 = 차단, stderr 메시지가 Claude에게 전달됨.

set -euo pipefail

input="$(cat)"
file="$(printf '%s' "$input" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null || true)"
[ -z "$file" ] && exit 0
[ -f "$file" ] || exit 0

# "표준 원본" 마커가 있는 파일이면 직접 수정을 막는다.
if grep -q "표준 원본: claude-code-standard" "$file" 2>/dev/null; then
  echo "차단: '$file' 은 표준 레포에서 복사된 파일입니다. 레포에서 직접 수정하지 말고 claude-code-standard 에 PR 하세요(GOVERNANCE §5). 레포 고유 규칙은 별도 파일로 만드세요." >&2
  exit 2
fi

exit 0

# guard-standard-files.ps1 — 표준 레포에서 복사된 파일을 레포에서 직접 수정하려 하면 차단 (Windows / PowerShell 변형)
# GOVERNANCE의 "포크 드리프트 금지"를 결정론적으로 강제한다.
# 연결: .claude/settings.json 의 PreToolUse(Edit|Write) 훅에서 exec 형태로 호출.
# 요구: PowerShell 5.1 이상. jq·Git Bash 불필요.
# exit 2 = 차단, stderr 메시지가 Claude에게 전달된다.
# ※ 이 파일은 UTF-8 with BOM 으로 저장되어 있다.
# ※ 마커 검색은 ASCII 부분('claude-code-standard')만 쓴다 — 파일 인코딩에 상관없이 매칭되도록.

$ErrorActionPreference = 'SilentlyContinue'

$raw = [Console]::In.ReadToEnd()
if (-not $raw) { exit 0 }
try { $payload = $raw | ConvertFrom-Json } catch { exit 0 }

$file = $payload.tool_input.file_path
if (-not $file) { $file = $payload.tool_input.path }
if (-not $file) { exit 0 }
if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { exit 0 }

$hit = Select-String -LiteralPath $file -Pattern 'claude-code-standard' -SimpleMatch -Quiet
if ($hit) {
    [Console]::Error.WriteLine("차단: '$file' 은 표준 레포에서 복사된 파일입니다. 레포에서 직접 수정하지 말고 claude-code-standard 에 PR 하세요(GOVERNANCE §5). 레포 고유 규칙은 별도 파일로 만드세요.")
    exit 2
}

exit 0

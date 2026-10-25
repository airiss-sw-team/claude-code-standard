# format-on-edit.ps1 — Claude가 파일을 Edit/Write 한 직후 확장자에 맞는 포매터를 실행 (Windows / PowerShell 변형)
# 스택 무관: 확장자로 분기하며, 해당 포매터가 없으면 조용히 넘어간다(워크플로를 절대 깨지 않음).
# 연결: .claude/settings.json 의 PostToolUse(Edit|Write) 훅에서 exec 형태로 호출.
#   "command": "powershell.exe",
#   "args": ["-NoProfile","-ExecutionPolicy","Bypass","-File","${CLAUDE_PROJECT_DIR}/.claude/hooks/format-on-edit.ps1"]
# 요구: PowerShell 5.1 이상. jq와 Git Bash 불필요.
# ※ 이 파일은 UTF-8 with BOM 으로 저장되어 있다(PowerShell 5.1이 한글 주석을 깨지 않게 하려면 BOM이 필요).

$ErrorActionPreference = 'SilentlyContinue'

$raw = [Console]::In.ReadToEnd()
if (-not $raw) { exit 0 }
try { $payload = $raw | ConvertFrom-Json } catch { exit 0 }

$file = $payload.tool_input.file_path
if (-not $file) { $file = $payload.tool_input.path }
if (-not $file) { exit 0 }
if (-not (Test-Path -LiteralPath $file -PathType Leaf)) { exit 0 }

function Have([string]$name) {
    return $null -ne (Get-Command $name -ErrorAction SilentlyContinue)
}

switch -Regex ($file) {
    '\.(ts|tsx|js|jsx|json|css|scss|md|html)$' {
        if (Have 'npx') { npx --no-install prettier --write $file *> $null }
        break
    }
    '\.py$' {
        if (Have 'ruff') { ruff format $file *> $null }
        elseif (Have 'black') { black -q $file *> $null }
        break
    }
    '\.go$'  { if (Have 'gofmt')   { gofmt -w $file *> $null };  break }
    '\.rs$'  { if (Have 'rustfmt') { rustfmt $file *> $null };   break }
    # .cs/.xaml 은 dotnet format 이 솔루션 단위라 파일별 실행이 느려 기본 제외.
    # 필요하면 여기 분기를 추가하되, 성능을 확인하고 결정할 것.
}

exit 0

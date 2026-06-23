# build.ps1 — Compile eu4_autoseige.ahk → eu4_autoseige.exe
# Run from project root: .\build.ps1
#
# Ahk2Exe search order:
#   1. .\Ahk2Exe.exe               (dropped next to this script)
#   2. .\Compiler\Ahk2Exe.exe      (local Compiler/ subfolder)
#   3. C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe  (standard install)
#
# Download Ahk2Exe.exe from:
#   https://github.com/AutoHotkey/Ahk2Exe/releases

$candidates = @(
    (Join-Path $PSScriptRoot "Ahk2Exe.exe"),
    (Join-Path $PSScriptRoot "Compiler\Ahk2Exe.exe"),
    "C:\Program Files\AutoHotkey\Compiler\Ahk2Exe.exe"
)

$Ahk2Exe = $candidates | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $Ahk2Exe) {
    Write-Error @"
Ahk2Exe.exe not found in any of:
  $($candidates -join "`n  ")

Download it from:
  https://github.com/AutoHotkey/Ahk2Exe/releases
Then drop Ahk2Exe.exe next to this build.ps1 and re-run.
"@
    exit 1
}

$Script = Join-Path $PSScriptRoot "eu4_standard_pack.ahk"
$Out    = Join-Path $PSScriptRoot "eu4_standard_pack.exe"

$Bin = "C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe"
if (-not (Test-Path $Bin)) {
    Write-Error "AHK v2 runtime not found at: $Bin"
    exit 1
}

Write-Host "Using compiler: $Ahk2Exe"
Write-Host "Using runtime:  $Bin"
Write-Host "Compiling $Script ..."

# Use Start-Process + -PassThru so exit code is captured reliably for GUI exes
$proc = Start-Process -FilePath $Ahk2Exe `
    -ArgumentList "/in `"$Script`" /out `"$Out`" /bin `"$Bin`"" `
    -Wait -PassThru -NoNewWindow

if ($proc.ExitCode -eq 0) {
    Write-Host "OK: $Out"
} else {
    Write-Error "Compilation failed (exit $($proc.ExitCode))"
    exit $proc.ExitCode
}

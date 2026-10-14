$ErrorActionPreference = "Stop"
Clear-Host

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)

if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process powershell.exe -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}

$installPath = "$env:ProgramData\BootSwitcher"
New-Item -ItemType Directory -Path $installPath -Force | Out-Null

$bootScript = @'
param(
    [string]$Choice
)

$ErrorActionPreference = "Stop"
$entries = @()
$output = & bcdedit.exe /enum firmware 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "Could not read firmware boot entries. Run this on a UEFI-based Windows installation." -ForegroundColor Red
    exit 1
}

$blocks = ($output -join "`n") -split "(?:\r?\n){2,}"

foreach ($block in $blocks) {
    $idMatch = [regex]::Match($block, "(?m)^\s*identifier\s+({[^}]+})\s*$")
    $nameMatch = [regex]::Match($block, "(?m)^\s*description\s+(.+?)\s*$")

    if ($idMatch.Success -and $nameMatch.Success) {
        $entries += [PSCustomObject]@{
            Id = $idMatch.Groups[1].Value.Trim()
            Name = $nameMatch.Groups[1].Value.Trim()
        }
    }
}

if ($entries.Count -eq 0) {
    Write-Host ""
    Write-Host "No firmware boot entries detected." -ForegroundColor Red
    Write-Host "Check that Windows uses UEFI and that firmware entries are available." -ForegroundColor Yellow
    exit 1
}

if ([string]::IsNullOrWhiteSpace($Choice)) {
    Write-Host ""
    Write-Host "Available firmware boot entries:" -ForegroundColor Cyan
    Write-Host ""

    for ($i = 0; $i -lt $entries.Count; $i++) {
        Write-Host "[$i] $($entries[$i].Name)"
    }

    Write-Host ""
    Write-Host "Usage: boot [number]" -ForegroundColor Yellow
    Write-Host "This lists firmware entries; it may include entries that are not operating systems."
    Write-Host ""
    exit 0
}

if ($Choice -notmatch "^\d+$") {
    Write-Host "Invalid selection. Run 'boot' to see the list." -ForegroundColor Red
    exit 1
}

$index = [int]$Choice

if ($index -ge $entries.Count) {
    Write-Host "Invalid selection. Run 'boot' to see the list." -ForegroundColor Red
    exit 1
}

$selected = $entries[$index]

Write-Host ""
Write-Host "Selected: $($selected.Name)" -ForegroundColor Cyan
Write-Host "Setting next boot entry..." -ForegroundColor Yellow

& bcdedit.exe /set "{fwbootmgr}" bootsequence $selected.Id
if ($LASTEXITCODE -ne 0) {
    Write-Host "Failed to set the next boot entry. Try running the terminal as Administrator." -ForegroundColor Red
    exit 1
}

Write-Host "Restarting now..." -ForegroundColor Green
& shutdown.exe /r /t 0
'@

Set-Content -Path "$installPath\boot.ps1" -Value $bootScript -Encoding UTF8

$bootCommand = @'
@echo off
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%ProgramData%\BootSwitcher\boot.ps1" %*
'@
Set-Content -Path "$installPath\boot.cmd" -Value $bootCommand -Encoding ASCII

$currentPath = [Environment]::GetEnvironmentVariable("Path", "Machine")
$pathEntries = @($currentPath -split ';' | Where-Object { $_ -ne "" })

if ($pathEntries -notcontains $installPath) {
    $newPath = if ([string]::IsNullOrWhiteSpace($currentPath)) { $installPath } else { "$currentPath;$installPath" }
    [Environment]::SetEnvironmentVariable("Path", $newPath, "Machine")
}

Write-Host ""
Write-Host "Boot Switcher installed successfully." -ForegroundColor Green
Write-Host "Close this window, open a new PowerShell or Command Prompt, then type:"
Write-Host "boot" -ForegroundColor Cyan
Write-Host ""
Read-Host "Press Enter to finish"

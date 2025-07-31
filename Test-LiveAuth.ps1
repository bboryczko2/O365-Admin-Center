# Live Authentication Test for O365 Admin Center
# This demonstrates how to test the modern authentication in practice

Write-Host "=== Live Authentication Test ===" -ForegroundColor Cyan
Write-Host ""

# Load the modern auth module
Import-Module ".\ModernAuth.psm1" -Force
. ".\Globals.ps1"

Write-Host "Step 1: Check module installation status..." -ForegroundColor Yellow
$modulesInstalled = Test-ModernModulesInstalled
if (-not $modulesInstalled) {
    Write-Host "⚠️  Modern modules not installed. The app would normally prompt to install them." -ForegroundColor DarkYellow
    Write-Host ""
    Write-Host "To install manually, run:" -ForegroundColor Gray
    Write-Host "Install-Module Microsoft.Graph -Scope CurrentUser -Force" -ForegroundColor White
    Write-Host "Install-Module ExchangeOnlineManagement -Scope CurrentUser -Force" -ForegroundColor White
    Write-Host ""
} else {
    Write-Host "✅ All modern modules are installed!" -ForegroundColor Green
    Write-Host ""
    
    Write-Host "Step 2: Test connection (this would prompt for authentication)..." -ForegroundColor Yellow
    Write-Host "⚠️  Skipping actual connection to avoid authentication prompt in test" -ForegroundColor DarkYellow
    Write-Host ""
    Write-Host "To test live connection, run:" -ForegroundColor Gray
    Write-Host "Connect-O365Modern -UseDeviceCodeAuth" -ForegroundColor White
    Write-Host ""
}

Write-Host "Step 3: Check connection status..." -ForegroundColor Yellow
$connectionStatus = Get-O365ConnectionStatus
Write-Host "Connection Status:" -ForegroundColor Gray
$connectionStatus | Format-List

Write-Host ""
Write-Host "=== How to Test the Full Authentication Flow ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Option 1 - PowerShell Testing:" -ForegroundColor Yellow
Write-Host "1. Import-Module .\ModernAuth.psm1 -Force" -ForegroundColor White
Write-Host "2. Connect-O365Modern -UseDeviceCodeAuth" -ForegroundColor White
Write-Host "3. Get-O365UserModern -All | Select-Object -First 5" -ForegroundColor White
Write-Host "4. Disconnect-O365Modern" -ForegroundColor White
Write-Host ""

Write-Host "Option 2 - Application Testing:" -ForegroundColor Yellow
Write-Host "1. Open the O365 Admin Center application (.psf file)" -ForegroundColor White
Write-Host "2. Select a service (Exchange Online, SharePoint, etc.)" -ForegroundColor White
Write-Host "3. Click 'Connect to O365' button" -ForegroundColor White
Write-Host "4. Follow the device code authentication prompts" -ForegroundColor White
Write-Host "5. Test user operations like 'Get List of Users'" -ForegroundColor White
Write-Host ""

Write-Host "Expected Behavior:" -ForegroundColor Yellow
Write-Host "• If modules missing: Prompt to install Microsoft Graph SDK" -ForegroundColor Gray
Write-Host "• Authentication: Device code flow with MFA support" -ForegroundColor Gray
Write-Host "• User operations: Use Microsoft Graph instead of MSOnline" -ForegroundColor Gray
Write-Host "• Partner access: Modern tenant-specific authentication" -ForegroundColor Gray

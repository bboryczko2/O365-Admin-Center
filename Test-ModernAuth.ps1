# Test Script for O365 Admin Center Modern Authentication
# This script tests the modernization changes without requiring full module installation

Write-Host "=== O365 Admin Center Modernization Test ===" -ForegroundColor Cyan
Write-Host ""

# Test 1: Module Loading
Write-Host "1. Testing ModernAuth module loading..." -ForegroundColor Yellow
try {
    Import-Module ".\ModernAuth.psm1" -Force
    $functions = Get-Command -Module ModernAuth
    Write-Host "   ✅ ModernAuth module loaded successfully" -ForegroundColor Green
    Write-Host "   📋 Available functions: $($functions.Name -join ', ')" -ForegroundColor Gray
} catch {
    Write-Host "   ❌ Failed to load ModernAuth module: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 2: Globals.ps1 Integration
Write-Host "2. Testing Globals.ps1 integration..." -ForegroundColor Yellow
try {
    . ".\Globals.ps1"
    Write-Host "   ✅ Globals.ps1 loaded successfully" -ForegroundColor Green
    if (Get-Command -Name Connect-O365Modern -ErrorAction SilentlyContinue) {
        Write-Host "   ✅ Modern auth functions available globally" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Modern auth functions not found globally" -ForegroundColor Orange
    }
} catch {
    Write-Host "   ❌ Failed to load Globals.ps1: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 3: Module Installation Check
Write-Host "3. Testing module installation check..." -ForegroundColor Yellow
try {
    $moduleStatus = Test-ModernModulesInstalled
    if ($moduleStatus) {
        Write-Host "   ✅ All required modern modules are installed" -ForegroundColor Green
    } else {
        Write-Host "   ⚠️  Some modern modules are missing (this is expected for first run)" -ForegroundColor Orange
        Write-Host "   📝 The application will prompt to install them when needed" -ForegroundColor Gray
    }
} catch {
    Write-Host "   ❌ Error checking module status: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host ""

# Test 4: Prerequisite Form Check
Write-Host "4. Testing prerequisite form..." -ForegroundColor Yellow
if (Test-Path ".\PreReq_MicrosoftGraph.psf") {
    Write-Host "   ✅ Modern prerequisite form (PreReq_MicrosoftGraph.psf) exists" -ForegroundColor Green
    
    # Check if it has the right structure
    $formContent = Get-Content ".\PreReq_MicrosoftGraph.psf" -Raw
    if ($formContent -like "*Microsoft.Graph*" -and $formContent -like "*ExchangeOnlineManagement*") {
        Write-Host "   ✅ Prerequisite form contains modern module references" -ForegroundColor Green
    } else {
        Write-Host "   ❌ Prerequisite form missing modern module references" -ForegroundColor Red
    }
} else {
    Write-Host "   ❌ Modern prerequisite form not found" -ForegroundColor Red
}

Write-Host ""

# Test 5: Main Form Updates Check
Write-Host "5. Testing main form updates..." -ForegroundColor Yellow
if (Test-Path ".\O365 Admin Center.psf") {
    $mainFormContent = Get-Content ".\O365 Admin Center.psf" -Raw
    
    $modernFeatures = @(
        @{Name="Modern Connect Function"; Pattern="Connect-O365Modern"},
        @{Name="Modern User Function"; Pattern="Get-O365UserModern"},
        @{Name="Device Code Auth"; Pattern="UseDeviceCodeAuth"},
        @{Name="Module Check"; Pattern="Test-ModernModulesInstalled"}
    )
    
    foreach ($feature in $modernFeatures) {
        if ($mainFormContent -like "*$($feature.Pattern)*") {
            Write-Host "   ✅ $($feature.Name) implemented" -ForegroundColor Green
        } else {
            Write-Host "   ❌ $($feature.Name) missing" -ForegroundColor Red
        }
    }
} else {
    Write-Host "   ❌ Main form file not found" -ForegroundColor Red
}

Write-Host ""

# Test 6: Documentation Check
Write-Host "6. Testing documentation updates..." -ForegroundColor Yellow
if (Test-Path ".\README.md") {
    $readmeContent = Get-Content ".\README.md" -Raw
    if ($readmeContent -like "*v5.0*" -and $readmeContent -like "*Modern Authentication*") {
        Write-Host "   ✅ README.md updated for modern authentication" -ForegroundColor Green
    } else {
        Write-Host "   ❌ README.md not updated" -ForegroundColor Red
    }
} else {
    Write-Host "   ❌ README.md not found" -ForegroundColor Red
}

Write-Host ""
Write-Host "=== Test Summary ===" -ForegroundColor Cyan
Write-Host "The modernization foundation has been implemented." -ForegroundColor White
Write-Host ""
Write-Host "Next Steps for Full Testing:" -ForegroundColor Yellow
Write-Host "1. Install modern modules (or let the app install them)" -ForegroundColor Gray
Write-Host "2. Run the application and test the connection flow" -ForegroundColor Gray
Write-Host "3. Test MFA authentication with device code flow" -ForegroundColor Gray
Write-Host "4. Verify partner tenant functionality (if applicable)" -ForegroundColor Gray
Write-Host ""
Write-Host "To install modules manually:" -ForegroundColor Yellow
Write-Host "Install-Module Microsoft.Graph -Scope CurrentUser" -ForegroundColor Gray
Write-Host "Install-Module ExchangeOnlineManagement -Scope CurrentUser" -ForegroundColor Gray

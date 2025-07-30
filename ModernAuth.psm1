# Modern Authentication Module for O365 Admin Center
# Replaces deprecated MSOnline module with Microsoft Graph PowerShell SDK

# Global variables for authentication state
$global:GraphConnected = $false
$global:ExchangeConnected = $false
$global:SharePointConnected = $false
$global:TeamsConnected = $false
$global:CurrentTenantId = $null
$global:CurrentUserPrincipalName = $null
$global:PartnerMode = $false

function Test-ModernModulesInstalled {
    <#
    .SYNOPSIS
    Checks if required modern PowerShell modules are installed
    #>
    
    $requiredModules = @(
        'Microsoft.Graph',
        'ExchangeOnlineManagement',
        'Microsoft.Online.SharePoint.PowerShell',
        'MicrosoftTeams'
    )
    
    $missingModules = @()
    
    foreach ($module in $requiredModules) {
        if (-not (Get-Module -ListAvailable -Name $module)) {
            $missingModules += $module
        }
    }
    
    if ($missingModules.Count -gt 0) {
        Write-Warning "Missing required modules: $($missingModules -join ', ')"
        return $false
    }
    
    return $true
}

function Connect-O365Modern {
    <#
    .SYNOPSIS
    Modern authentication connection to Office 365 services
    .PARAMETER TenantId
    Tenant ID for partner scenarios
    .PARAMETER UseDeviceCodeAuth
    Use device code authentication for MFA scenarios
    #>
    
    param(
        [string]$TenantId,
        [switch]$UseDeviceCodeAuth
    )
    
    try {
        # Check if modules are installed
        if (-not (Test-ModernModulesInstalled)) {
            throw "Required modules are not installed. Please run the prerequisite check."
        }
        
        Write-Host "Connecting to Microsoft Graph..."
        
        # Determine connection method
        $connectParams = @{
            Scopes = @(
                'User.Read.All',
                'Directory.Read.All',
                'UserAuthenticationMethod.Read.All',
                'Organization.Read.All',
                'Domain.Read.All',
                'Group.Read.All',
                'RoleManagement.Read.All'
            )
        }
        
        if ($TenantId) {
            $connectParams.TenantId = $TenantId
            $global:PartnerMode = $true
            $global:CurrentTenantId = $TenantId
        }
        
        if ($UseDeviceCodeAuth) {
            $connectParams.UseDeviceAuthentication = $true
        }
        
        # Connect to Microsoft Graph
        Connect-MgGraph @connectParams
        
        # Verify connection
        $context = Get-MgContext
        if ($context) {
            $global:GraphConnected = $true
            $global:CurrentTenantId = $context.TenantId
            Write-Host "Successfully connected to Microsoft Graph (Tenant: $($context.TenantId))" -ForegroundColor Green
        }
        
        # Connect to Exchange Online
        Write-Host "Connecting to Exchange Online..."
        $exchangeParams = @{}
        if ($TenantId) {
            $exchangeParams.DelegatedOrganization = $TenantId
        }
        if ($UseDeviceCodeAuth) {
            $exchangeParams.Device = $true
        }
        
        Connect-ExchangeOnline @exchangeParams -ShowBanner:$false
        $global:ExchangeConnected = $true
        Write-Host "Successfully connected to Exchange Online" -ForegroundColor Green
        
        return $true
    }
    catch {
        Write-Error "Failed to connect to Office 365: $($_.Exception.Message)"
        return $false
    }
}

function Disconnect-O365Modern {
    <#
    .SYNOPSIS
    Disconnects from all Office 365 services
    #>
    
    try {
        if ($global:GraphConnected) {
            Disconnect-MgGraph
            $global:GraphConnected = $false
            Write-Host "Disconnected from Microsoft Graph" -ForegroundColor Yellow
        }
        
        if ($global:ExchangeConnected) {
            Disconnect-ExchangeOnline -Confirm:$false
            $global:ExchangeConnected = $false
            Write-Host "Disconnected from Exchange Online" -ForegroundColor Yellow
        }
        
        if ($global:SharePointConnected) {
            # SharePoint disconnection is automatic
            $global:SharePointConnected = $false
            Write-Host "Disconnected from SharePoint Online" -ForegroundColor Yellow
        }
        
        if ($global:TeamsConnected) {
            Disconnect-MicrosoftTeams
            $global:TeamsConnected = $false
            Write-Host "Disconnected from Microsoft Teams" -ForegroundColor Yellow
        }
        
        # Reset global variables
        $global:CurrentTenantId = $null
        $global:CurrentUserPrincipalName = $null
        $global:PartnerMode = $false
        
        Write-Host "All Office 365 connections closed" -ForegroundColor Green
    }
    catch {
        Write-Warning "Error during disconnection: $($_.Exception.Message)"
    }
}

function Get-O365UserModern {
    <#
    .SYNOPSIS
    Gets user information using Microsoft Graph (replaces Get-MsolUser)
    .PARAMETER UserPrincipalName
    Specific user to retrieve
    .PARAMETER All
    Get all users
    .PARAMETER TenantId
    Tenant ID for partner scenarios
    #>
    
    param(
        [string]$UserPrincipalName,
        [switch]$All,
        [string]$TenantId
    )
    
    try {
        if (-not $global:GraphConnected) {
            throw "Not connected to Microsoft Graph. Please connect first."
        }
        
        if ($UserPrincipalName) {
            # Get specific user
            $user = Get-MgUser -UserId $UserPrincipalName -Property DisplayName,UserPrincipalName,AccountEnabled,CreatedDateTime,UserType,AssignedLicenses
            return $user
        }
        elseif ($All) {
            # Get all users with pagination
            $users = Get-MgUser -All -Property DisplayName,UserPrincipalName,AccountEnabled,CreatedDateTime,UserType,AssignedLicenses
            return $users
        }
        else {
            throw "Please specify either -UserPrincipalName or -All parameter"
        }
    }
    catch {
        Write-Error "Failed to retrieve user information: $($_.Exception.Message)"
        return $null
    }
}

function Get-O365ConnectionStatus {
    <#
    .SYNOPSIS
    Returns the current connection status
    #>
    
    return @{
        GraphConnected = $global:GraphConnected
        ExchangeConnected = $global:ExchangeConnected
        SharePointConnected = $global:SharePointConnected
        TeamsConnected = $global:TeamsConnected
        CurrentTenantId = $global:CurrentTenantId
        PartnerMode = $global:PartnerMode
    }
}

function Set-O365UserBlockCredentialModern {
    <#
    .SYNOPSIS
    Blocks or unblocks user credentials (replaces Set-MsolUser -BlockCredential)
    .PARAMETER UserPrincipalName
    User to modify
    .PARAMETER BlockCredential
    True to block, False to unblock
    #>
    
    param(
        [string]$UserPrincipalName,
        [bool]$BlockCredential
    )
    
    try {
        if (-not $global:GraphConnected) {
            throw "Not connected to Microsoft Graph. Please connect first."
        }
        
        # In Microsoft Graph, blocking credentials means disabling the account
        Update-MgUser -UserId $UserPrincipalName -AccountEnabled (-not $BlockCredential)
        
        $status = if ($BlockCredential) { "blocked" } else { "unblocked" }
        Write-Host "Successfully $status credentials for $UserPrincipalName" -ForegroundColor Green
        
        return $true
    }
    catch {
        Write-Error "Failed to modify user credentials: $($_.Exception.Message)"
        return $false
    }
}

function Test-O365ConnectionModern {
    <#
    .SYNOPSIS
    Tests if we have a valid connection to Office 365 services
    #>
    
    try {
        if ($global:GraphConnected) {
            # Test Graph connection
            $context = Get-MgContext
            if ($context) {
                return $true
            }
        }
        return $false
    }
    catch {
        return $false
    }
}

# Export functions for use in the main application
Export-ModuleMember -Function @(
    'Test-ModernModulesInstalled',
    'Connect-O365Modern',
    'Disconnect-O365Modern',
    'Get-O365UserModern',
    'Get-O365ConnectionStatus',
    'Set-O365UserBlockCredentialModern',
    'Test-O365ConnectionModern'
)

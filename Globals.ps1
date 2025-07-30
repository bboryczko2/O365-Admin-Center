#--------------------------------------------
# Declare Global Variables and Functions here
#--------------------------------------------

#Sample function that provides the location of the script
function Get-ScriptDirectory
{
<#
	.SYNOPSIS
		Get-ScriptDirectory returns the proper location of the script.

	.OUTPUTS
		System.String
	
	.NOTES
		Returns the correct path within a packaged executable.
#>
	[OutputType([string])]
	param ()
	try {
		if ($null -ne $hostinvocation)
		{
			Split-Path $hostinvocation.MyCommand.path
		}
		else
		{
			Split-Path $script:MyInvocation.MyCommand.Path
		}
	}
	catch {
		# Fallback to current location
		$PWD.Path
	}
}

#Sample variable that provides the location of the script
[string]$ScriptDirectory = Get-ScriptDirectory

# Import Modern Authentication Module
try {
	$ModernAuthPath = Join-Path $ScriptDirectory "ModernAuth.psm1"
	if (Test-Path $ModernAuthPath) {
		Import-Module $ModernAuthPath -Force
		Write-Host "Modern Authentication module loaded successfully" -ForegroundColor Green
	}
	else {
		Write-Warning "ModernAuth.psm1 not found. Some features may not work correctly."
	}
}
catch {
	Write-Warning "Failed to load Modern Authentication module: $($_.Exception.Message)"
}

# Global variables for backward compatibility
$global:o365credentials = $null
$global:TenantText = $null



# O365 Admin Center (Modernized)

v5.0.0 - **Updated for Modern Authentication**

___

## 🚀 What's New in v5.0

This version has been completely modernized to work with current Microsoft 365 authentication and API standards:

- **Modern Authentication**: Uses Microsoft Graph PowerShell SDK instead of deprecated MSOnline module
- **MFA Support**: Full Multi-Factor Authentication support with device code authentication  
- **Partner Center**: Updated for modern partner delegation workflows
- **Current APIs**: All commands updated to use supported Microsoft Graph and Exchange Online Management APIs
- **Security**: Enhanced security with OAuth 2.0 and modern consent flows

___

## 📋 Prerequisites

The application will automatically check for and offer to install these modern modules:

- **Microsoft.Graph** - Microsoft Graph PowerShell SDK (replaces MSOnline)
- **ExchangeOnlineManagement** - Modern Exchange Online management
- **Microsoft.Online.SharePoint.PowerShell** - SharePoint Online management  
- **MicrosoftTeams** - Microsoft Teams management

### Manual Installation
If you prefer to install modules manually:
```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
Install-Module ExchangeOnlineManagement -Scope CurrentUser  
Install-Module Microsoft.Online.SharePoint.PowerShell -Scope CurrentUser
Install-Module MicrosoftTeams -Scope CurrentUser
```

___

## 🔐 Authentication

### MFA/Modern Authentication
- **Device Code Authentication**: Supports MFA out of the box
- **Conditional Access**: Works with all Conditional Access policies
- **Modern Consent**: Uses current Microsoft identity platform

### Partner Access
- Modern partner delegation requires proper Microsoft Partner Center setup
- Uses current partner APIs instead of deprecated MSOnline partner commands
- Supports tenant-specific connections with proper delegated admin privileges

___

## 📖 Description
The O365 Admin Center is a PowerShell-based application that lets administrators easily manage their Microsoft 365 environment. It provides a graphical interface for common administrative tasks across Exchange Online, SharePoint, Teams, and Compliance Center.

**Key Features:**
- Modern authentication with full MFA support
- Partner tenant management for MSPs
- Interactive PowerShell command execution
- Export results to various formats
- Pre-built administrative workflows

___

## ⚙️ Migration Notes

This modernized version replaces:
- `Connect-MsolService` → `Connect-MgGraph`
- `Get-MsolUser` → `Get-MgUser` 
- `Set-MsolUser` → `Update-MgUser`
- Legacy Exchange PowerShell → `ExchangeOnlineManagement` module
- Partner contract enumeration → Modern partner center APIs

The application will detect if you're using legacy modules and guide you through the upgrade process.

___

## 🔧 Troubleshooting

### Common Issues:
1. **Module Not Found**: Run the prerequisite check to install required modules
2. **Authentication Failures**: Ensure you have appropriate admin permissions
3. **Partner Access**: Verify Partner Center configuration and delegated admin privileges

### Legacy Support:
While this version focuses on modern authentication, it maintains backward compatibility where possible. However, we strongly recommend migrating to the new authentication methods for security and reliability.

___

## 🤝 Community & Support

- [Original Website](http://o365admin.center/)
- [Community Forum](http://o365admin.center/community/) 
- [Report Issues](https://github.com/your-repo/issues)

___

*This project has been modernized to ensure compatibility with current Microsoft 365 security standards and API deprecation timelines.*

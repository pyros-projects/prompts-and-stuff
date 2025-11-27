# ☁️ Azure Scripts

**PowerShell scripts for Azure cloud management**

---

## ExportAPIM_interactive.ps1

A comprehensive tool for exporting Azure API Management (APIM) instances to JSON format. Supports both interactive mode with guided prompts and full command-line automation.

### Features

- **Complete APIM export** — APIs, products, subscriptions, users, policies, and 20+ component types
- **Interactive mode** — Guided prompts for Azure login, APIM selection, and component filtering
- **Command-line mode** — Full automation support for CI/CD pipelines
- **Flexible output** — Single consolidated JSON or separate files per component
- **Smart filtering** — Include/exclude specific components (skip slow operations like Users export)

### Prerequisites

```powershell
# Install required PowerShell modules (run as Administrator for AllUsers):
Install-Module -Name Az.Accounts -Force -AllowClobber
Install-Module -Name Az.ApiManagement -Force -AllowClobber

# Or for current user only (no admin needed):
Install-Module -Name Az.Accounts -Force -AllowClobber -Scope CurrentUser
Install-Module -Name Az.ApiManagement -Force -AllowClobber -Scope CurrentUser
```

### Usage

#### Interactive Mode (Recommended for First Use)

```powershell
.\ExportAPIM_interactive.ps1
```

The script will guide you through:
1. Azure authentication (or use existing session)
2. APIM instance selection (lists available instances)
3. Component selection (interactive menu with toggle)
4. Output path and format selection

#### Command-Line Mode (For Automation)

```powershell
# Full export
.\ExportAPIM_interactive.ps1 `
    -TenantId "your-tenant-id" `
    -SubscriptionId "your-subscription-id" `
    -ResourceGroupName "your-resource-group" `
    -ServiceName "your-apim-name"

# With component filtering
.\ExportAPIM_interactive.ps1 `
    -TenantId "xxx" `
    -SubscriptionId "xxx" `
    -ResourceGroupName "rg" `
    -ServiceName "apim" `
    -Exclude "Users"  # Skip slow user export

# Export to specific path as separate files
.\ExportAPIM_interactive.ps1 `
    -TenantId "xxx" `
    -SubscriptionId "xxx" `
    -ResourceGroupName "rg" `
    -ServiceName "apim" `
    -OutputPath "./exports" `
    -SingleFile:$false
```

### Exportable Components

| Component | Description | Notes |
|-----------|-------------|-------|
| **APIs** | APIs with operations, policies, schemas, revisions | Includes per-operation policies |
| **Products** | Products with associated APIs, policies, groups | |
| **Subscriptions** | API subscriptions | |
| **Users** | Users with groups and subscriptions | ⚠️ SLOW for large user bases |
| **Groups** | User groups | |
| **NamedValues** | Named values / properties | |
| **Backends** | Backend configurations | |
| **Certificates** | Uploaded certificates | |
| **Loggers** | Logger configurations | |
| **Diagnostics** | Diagnostic settings | |
| **AuthorizationServers** | OAuth authorization servers | |
| **OpenIdConnectProviders** | OpenID Connect providers | |
| **IdentityProviders** | Identity providers (AAD, etc.) | |
| **ApiVersionSets** | API version sets | |
| **Tags** | Tags | |
| **Caches** | External cache configurations | |
| **Gateways** | Self-hosted gateways | |
| **GlobalPolicy** | Global/service-level policy | |
| **PortalDelegation** | Developer portal delegation settings | |
| **PortalSignup** | Developer portal signup settings | |
| **TenantAccess** | Direct management API access settings | |
| **TenantGitAccess** | Git configuration access | |

### Parameters

| Parameter | Required | Description |
|-----------|----------|-------------|
| `-TenantId` | No* | Azure AD tenant ID or domain |
| `-SubscriptionId` | No* | Azure subscription ID or name |
| `-ResourceGroupName` | No* | Resource group containing APIM |
| `-ServiceName` | No* | APIM service name |
| `-OutputPath` | No | Output directory (default: current) |
| `-SingleFile` | No | Export as single JSON (default) or separate files |
| `-Include` | No | Components to include (comma-separated) |
| `-Exclude` | No | Components to exclude (comma-separated) |

\* Required for command-line mode, prompted in interactive mode

### Output Format

**Single File Mode** (default):
```
your-apim-export-20231127-143022.json
```

**Multi-File Mode**:
```
your-apim-export-20231127-143022/
├── 00-service-info.json
├── 01-apis.json
├── 02-products.json
├── 03-subscriptions.json
└── ...
```

### Performance Tips

- **Skip Users export** for faster runs: `-Exclude "Users"`
- Use **Fast mode** in interactive menu (`F` key) to auto-exclude slow components
- For large APIs with many operations, policy export can be slow

### Example Use Cases

**Backup before migration:**
```powershell
.\ExportAPIM_interactive.ps1 -ServiceName "prod-apim" -OutputPath "./backups"
```

**Compare environments:**
```powershell
.\ExportAPIM_interactive.ps1 -ServiceName "dev-apim" -OutputPath "./dev"
.\ExportAPIM_interactive.ps1 -ServiceName "prod-apim" -OutputPath "./prod"
# Then diff the JSON files
```

**CI/CD documentation:**
```powershell
.\ExportAPIM_interactive.ps1 `
    -ServiceName "apim" `
    -Include "APIs,Products,NamedValues" `
    -SingleFile
```

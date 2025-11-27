#Requires -Modules Az.ApiManagement, Az.Accounts

<#
.SYNOPSIS
    Exports a complete Azure API Management instance to JSON.
    Interactive mode or command-line arguments supported.

================================================================================
INSTALLATION
================================================================================

    # Install required PowerShell modules (run as Administrator for AllUsers):
    Install-Module -Name Az.Accounts -Force -AllowClobber
    Install-Module -Name Az.ApiManagement -Force -AllowClobber

    # Or for current user only (no admin needed):
    Install-Module -Name Az.Accounts -Force -AllowClobber -Scope CurrentUser
    Install-Module -Name Az.ApiManagement -Force -AllowClobber -Scope CurrentUser

================================================================================
USAGE
================================================================================

    # Interactive mode (guided prompts):
    .\Export-AzureAPIM.ps1

    # Full command-line mode:
    .\Export-AzureAPIM.ps1 -TenantId "xxx" -SubscriptionId "xxx" -ResourceGroupName "rg" -ServiceName "apim"

    # With component filtering:
    .\Export-AzureAPIM.ps1 -TenantId "xxx" -SubscriptionId "xxx" -ResourceGroupName "rg" -ServiceName "apim" -Exclude "Users"

================================================================================
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$TenantId,

    [Parameter(Mandatory = $false)]
    [string]$SubscriptionId,

    [Parameter(Mandatory = $false)]
    [string]$ResourceGroupName,

    [Parameter(Mandatory = $false)]
    [string]$ServiceName,

    [Parameter(Mandatory = $false)]
    [string]$OutputPath = ".",

    [Parameter(Mandatory = $false)]
    [switch]$SingleFile,

    [Parameter(Mandatory = $false)]
    [string[]]$Include,

    [Parameter(Mandatory = $false)]
    [string[]]$Exclude
)

$ErrorActionPreference = "Stop"

# All available components with descriptions
$script:ComponentInfo = [ordered]@{
    "APIs"                   = "APIs with operations, policies, schemas, revisions"
    "Products"               = "Products with associated APIs, policies, groups"
    "Subscriptions"          = "API subscriptions"
    "Users"                  = "Users with groups and subscriptions (SLOW!)"
    "Groups"                 = "User groups"
    "NamedValues"            = "Named values / properties"
    "Backends"               = "Backend configurations"
    "Certificates"           = "Uploaded certificates"
    "Loggers"                = "Logger configurations"
    "Diagnostics"            = "Diagnostic settings"
    "AuthorizationServers"   = "OAuth authorization servers"
    "OpenIdConnectProviders" = "OpenID Connect providers"
    "IdentityProviders"      = "Identity providers (AAD, etc.)"
    "ApiVersionSets"         = "API version sets"
    "Tags"                   = "Tags"
    "Caches"                 = "External cache configurations"
    "Gateways"               = "Self-hosted gateways"
    "GlobalPolicy"           = "Global/service-level policy"
    "PortalDelegation"       = "Developer portal delegation settings"
    "PortalSignup"           = "Developer portal signup settings"
    "TenantAccess"           = "Direct management API access settings"
    "TenantGitAccess"        = "Git configuration access"
}

$script:AllComponents = @($script:ComponentInfo.Keys)

#region Helper Functions

function Write-Banner {
    param([string]$Text)
    $line = "=" * 70
    Write-Host ""
    Write-Host $line -ForegroundColor Cyan
    Write-Host " $Text" -ForegroundColor Cyan
    Write-Host $line -ForegroundColor Cyan
    Write-Host ""
}

function Write-Log {
    param([string]$Message, [string]$Level = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $color = switch ($Level) {
        "ERROR"    { "Red" }
        "WARN"     { "Yellow" }
        "SUCCESS"  { "Green" }
        "PROGRESS" { "Cyan" }
        "SKIP"     { "DarkGray" }
        default    { "White" }
    }
    Write-Host "[$timestamp] [$Level] $Message" -ForegroundColor $color
}

function Read-UserInput {
    param(
        [string]$Prompt,
        [string]$Default = "",
        [switch]$Required
    )
    
    $displayPrompt = if ($Default) { "$Prompt [$Default]" } else { $Prompt }
    
    do {
        Write-Host "$displayPrompt : " -NoNewline -ForegroundColor Yellow
        $userInput = Read-Host
        
        if ([string]::IsNullOrWhiteSpace($userInput)) {
            $userInput = $Default
        }
        
        if ($Required -and [string]::IsNullOrWhiteSpace($userInput)) {
            Write-Host "  This field is required." -ForegroundColor Red
        }
    } while ($Required -and [string]::IsNullOrWhiteSpace($userInput))
    
    return $userInput.Trim()
}

function Show-ComponentMenu {
    param([string[]]$CurrentSelection)
    
    Write-Banner "Select Components to Export"
    
    Write-Host "  Current selection: " -NoNewline
    if ($CurrentSelection.Count -eq $script:AllComponents.Count) {
        Write-Host "ALL" -ForegroundColor Green
    } else {
        Write-Host "$($CurrentSelection.Count) components" -ForegroundColor Yellow
    }
    Write-Host ""
    
    $i = 1
    foreach ($comp in $script:AllComponents) {
        $selected = if ($comp -in $CurrentSelection) { "[X]" } else { "[ ]" }
        $color = if ($comp -in $CurrentSelection) { "Green" } else { "Gray" }
        $warn = if ($comp -eq "Users") { " (SLOW!)" } else { "" }
        Write-Host "  $i. " -NoNewline
        Write-Host $selected -NoNewline -ForegroundColor $color
        Write-Host " $comp$warn" -NoNewline
        Write-Host " - $($script:ComponentInfo[$comp])" -ForegroundColor DarkGray
        $i++
    }
    
    Write-Host ""
    Write-Host "  Commands:" -ForegroundColor Cyan
    Write-Host "    [number]  - Toggle component"
    Write-Host "    A         - Select ALL"
    Write-Host "    N         - Select NONE"
    Write-Host "    F         - Fast mode (exclude Users)"
    Write-Host "    D         - Done / Continue"
    Write-Host "    Q         - Quit"
    Write-Host ""
}

function Get-ComponentSelection {
    param([string[]]$InitialSelection)
    
    $selection = [System.Collections.ArrayList]@($InitialSelection)
    
    while ($true) {
        Clear-Host
        Show-ComponentMenu -CurrentSelection $selection
        
        Write-Host "Enter choice: " -NoNewline -ForegroundColor Yellow
        $choice = Read-Host
        
        switch -Regex ($choice.ToUpper()) {
            "^D$" { 
                if ($selection.Count -eq 0) {
                    Write-Host "  Please select at least one component." -ForegroundColor Red
                    Start-Sleep -Seconds 1
                } else {
                    return $selection
                }
            }
            "^Q$" { 
                Write-Host "Exiting..." -ForegroundColor Yellow
                exit 0 
            }
            "^A$" { 
                $selection = [System.Collections.ArrayList]@($script:AllComponents)
            }
            "^N$" { 
                $selection = [System.Collections.ArrayList]@()
            }
            "^F$" { 
                $selection = [System.Collections.ArrayList]@($script:AllComponents | Where-Object { $_ -ne "Users" })
            }
            "^\d+$" {
                $num = [int]$choice
                if ($num -ge 1 -and $num -le $script:AllComponents.Count) {
                    $comp = $script:AllComponents[$num - 1]
                    if ($comp -in $selection) {
                        $selection.Remove($comp)
                    } else {
                        $selection.Add($comp) | Out-Null
                    }
                }
            }
            default {
                # Check if it's a component name
                $match = $script:AllComponents | Where-Object { $_ -ieq $choice }
                if ($match) {
                    if ($match -in $selection) {
                        $selection.Remove($match)
                    } else {
                        $selection.Add($match) | Out-Null
                    }
                }
            }
        }
    }
}

function ConvertTo-SafeHashtable {
    param([object]$InputObject)
    
    if ($null -eq $InputObject) { return $null }
    
    if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string] -and $InputObject -isnot [hashtable]) {
        $result = @()
        foreach ($item in $InputObject) {
            $result += ConvertTo-SafeHashtable $item
        }
        return $result
    }
    
    if ($InputObject -is [ValueType] -or $InputObject -is [string]) {
        return $InputObject
    }
    
    if ($InputObject -is [hashtable]) {
        $result = @{}
        foreach ($key in $InputObject.Keys) {
            if ($key -notin @('Context', 'ResourceGroupName', 'ServiceName')) {
                $result[$key] = ConvertTo-SafeHashtable $InputObject[$key]
            }
        }
        return $result
    }
    
    $result = [ordered]@{}
    $excludeProps = @('Context', 'ResourceGroupName', 'ServiceName', 'PSObject', 'PSTypeNames', 
                      'BaseObject', 'ImmediateBaseObject', 'Members', 'Properties', 'Methods')
    
    foreach ($prop in $InputObject.PSObject.Properties) {
        if ($prop.Name -in $excludeProps) { continue }
        if ($prop.Name -match '^_') { continue }
        
        $value = $prop.Value
        
        if ($null -ne $value) {
            $typeName = $value.GetType().FullName
            if ($typeName -match 'Azure\.ResourceManager|Microsoft\.Azure\.Management|Microsoft\.Rest') {
                continue
            }
        }
        
        try {
            if ($null -eq $value) {
                $result[$prop.Name] = $null
            }
            elseif ($value -is [ValueType] -or $value -is [string]) {
                $result[$prop.Name] = $value
            }
            elseif ($value -is [System.Collections.IEnumerable] -and $value -isnot [string]) {
                $result[$prop.Name] = @(ConvertTo-SafeHashtable $value)
            }
            elseif ($value.PSObject.Properties) {
                $result[$prop.Name] = ConvertTo-SafeHashtable $value
            }
            else {
                $result[$prop.Name] = $value.ToString()
            }
        }
        catch { }
    }
    
    return $result
}

#endregion

#region Main Script

Clear-Host
Write-Banner "Azure APIM Export Tool"

# Determine if we're in interactive mode
$Interactive = -not ($TenantId -and $SubscriptionId -and $ResourceGroupName -and $ServiceName)

if ($Interactive) {
    Write-Host "  Running in interactive mode. Press Ctrl+C to exit at any time." -ForegroundColor Gray
    Write-Host ""
}

# Step 1: Azure Authentication
Write-Banner "Step 1: Azure Authentication"

$context = Get-AzContext -ErrorAction SilentlyContinue

if ($context) {
    Write-Host "  Currently logged in as: " -NoNewline
    Write-Host $context.Account.Id -ForegroundColor Green
    Write-Host "  Tenant: $($context.Tenant.Id)"
    Write-Host "  Subscription: $($context.Subscription.Name)"
    Write-Host ""
    
    if ($Interactive) {
        Write-Host "  Use current session? (Y/n): " -NoNewline -ForegroundColor Yellow
        $useExisting = Read-Host
        if ($useExisting -ieq 'n') {
            $context = $null
        }
    }
}

if (-not $context -or $TenantId -or $SubscriptionId) {
    if ($Interactive -and -not $TenantId) {
        $TenantId = Read-UserInput -Prompt "Tenant ID (GUID or domain)" -Required
    }
    if ($Interactive -and -not $SubscriptionId) {
        $SubscriptionId = Read-UserInput -Prompt "Subscription ID or Name" -Required
    }
    
    Write-Log "Connecting to Azure..."
    
    $connectParams = @{}
    if ($TenantId) { $connectParams['Tenant'] = $TenantId }
    if ($SubscriptionId) { $connectParams['Subscription'] = $SubscriptionId }
    
    Connect-AzAccount @connectParams | Out-Null
    $context = Get-AzContext
    
    Write-Log "Connected as: $($context.Account.Id)" -Level "SUCCESS"
}

# Step 2: APIM Selection
Write-Banner "Step 2: Select APIM Instance"

if ($Interactive -and -not $ResourceGroupName) {
    Write-Log "Searching for APIM instances in subscription... (this may take a moment)"
    $apimInstances = Get-AzApiManagement -ErrorAction SilentlyContinue
    
    if ($apimInstances -and $apimInstances.Count -gt 0) {
        Write-Host ""
        Write-Host "  Available APIM instances:" -ForegroundColor Cyan
        $i = 1
        foreach ($apim in $apimInstances) {
            Write-Host "    $i. $($apim.Name) (RG: $($apim.ResourceGroupName), SKU: $($apim.Sku))"
            $i++
        }
        Write-Host ""
        
        $selection = Read-UserInput -Prompt "Select instance (number) or enter manually (m)"
        
        if ($selection -match '^\d+$') {
            $idx = [int]$selection - 1
            if ($idx -ge 0 -and $idx -lt $apimInstances.Count) {
                $ResourceGroupName = $apimInstances[$idx].ResourceGroupName
                $ServiceName = $apimInstances[$idx].Name
            }
        }
    }
}

if (-not $ResourceGroupName) {
    if ($Interactive) {
        $ResourceGroupName = Read-UserInput -Prompt "Resource Group Name" -Required
    } else {
        Write-Error "ResourceGroupName is required"
        exit 1
    }
}

if (-not $ServiceName) {
    if ($Interactive) {
        $ServiceName = Read-UserInput -Prompt "APIM Service Name" -Required
    } else {
        Write-Error "ServiceName is required"
        exit 1
    }
}

Write-Log "Selected: $ServiceName in $ResourceGroupName" -Level "SUCCESS"

# Validate APIM exists
Write-Log "Validating APIM instance..."
$script:apimContext = New-AzApiManagementContext -ResourceGroupName $ResourceGroupName -ServiceName $ServiceName
$apimService = Get-AzApiManagement -ResourceGroupName $ResourceGroupName -Name $ServiceName
Write-Log "APIM found - SKU: $($apimService.Sku), Location: $($apimService.Location)" -Level "SUCCESS"

# Step 3: Component Selection
Write-Banner "Step 3: Select Components"

$ComponentsToExport = @($script:AllComponents)

if ($Include -and $Include.Count -gt 0) {
    $ComponentsToExport = @()
    foreach ($item in $Include) {
        $parts = $item -split ','
        foreach ($part in $parts) {
            $match = $script:AllComponents | Where-Object { $_ -ieq $part.Trim() }
            if ($match) { $ComponentsToExport += $match }
        }
    }
}

if ($Exclude -and $Exclude.Count -gt 0) {
    foreach ($item in $Exclude) {
        $parts = $item -split ','
        foreach ($part in $parts) {
            $match = $script:AllComponents | Where-Object { $_ -ieq $part.Trim() }
            if ($match) { $ComponentsToExport = $ComponentsToExport | Where-Object { $_ -ne $match } }
        }
    }
}

if ($Interactive -and -not $Include -and -not $Exclude) {
    $ComponentsToExport = @(Get-ComponentSelection -InitialSelection $script:AllComponents)
}

Clear-Host
Write-Banner "Step 4: Export"

Write-Host "  APIM: $ServiceName" -ForegroundColor White
Write-Host "  Resource Group: $ResourceGroupName" -ForegroundColor White
Write-Host "  Components: $($ComponentsToExport.Count) selected" -ForegroundColor White
Write-Host "  Output: $OutputPath" -ForegroundColor White
Write-Host ""

if ($Interactive) {
    $newPath = Read-UserInput -Prompt "Output path" -Default $OutputPath
    if ($newPath) { $OutputPath = $newPath }
    
    Write-Host "  Single file or separate files? (S/m): " -NoNewline -ForegroundColor Yellow
    $fileChoice = Read-Host
    if ($fileChoice -ieq 'm') { $SingleFile = $false } else { $SingleFile = $true }
}

Write-Host ""
Write-Host "  Press Enter to start export..." -ForegroundColor Yellow
Read-Host

Write-Host ""
Write-Log "Starting export... please wait" -Level "PROGRESS"
Write-Host ""

# Initialize export data - use script scope to ensure visibility
$script:exportData = [ordered]@{
    ExportMetadata = [ordered]@{
        ExportedAt         = (Get-Date -Format "o")
        ExportedBy         = $context.Account.Id
        ServiceName        = $ServiceName
        ResourceGroup      = $ResourceGroupName
        SubscriptionId     = $context.Subscription.Id
        SubscriptionName   = $context.Subscription.Name
        ComponentsExported = $ComponentsToExport -join ", "
    }
    ServiceInfo = ConvertTo-SafeHashtable $apimService
}

#region Export Components

# APIs
if ("APIs" -in $ComponentsToExport) {
    Write-Log "Exporting APIs..."
    try {
        $apis = @(Get-AzApiManagementApi -Context $script:apimContext)
        Write-Log "  Processing $($apis.Count) APIs..." -Level "PROGRESS"
        
        $processed = 0
        foreach ($api in $apis) {
            $processed++
            Write-Log "  [$processed/$($apis.Count)] API: $($api.Name)" -Level "PROGRESS"
            
            try {
                $operations = @(Get-AzApiManagementOperation -Context $script:apimContext -ApiId $api.ApiId)
                $api | Add-Member -NotePropertyName "Operations" -NotePropertyValue $operations -Force
                
                $opCount = 0
                foreach ($op in $operations) {
                    $opCount++
                    try {
                        $opPolicy = Get-AzApiManagementPolicy -Context $script:apimContext -ApiId $api.ApiId -OperationId $op.OperationId -ErrorAction SilentlyContinue
                        if ($opPolicy) { $op | Add-Member -NotePropertyName "Policy" -NotePropertyValue $opPolicy -Force }
                    } catch { }
                    if ($opCount % 50 -eq 0) { Write-Log "      Policies: $opCount/$($operations.Count)" -Level "PROGRESS" }
                }
            } catch { }
            
            try {
                $apiPolicy = Get-AzApiManagementPolicy -Context $script:apimContext -ApiId $api.ApiId -ErrorAction SilentlyContinue
                if ($apiPolicy) { $api | Add-Member -NotePropertyName "Policy" -NotePropertyValue $apiPolicy -Force }
            } catch { }
            
            try {
                $schemas = @(Get-AzApiManagementApiSchema -Context $script:apimContext -ApiId $api.ApiId -ErrorAction SilentlyContinue)
                if ($schemas.Count -gt 0) { $api | Add-Member -NotePropertyName "Schemas" -NotePropertyValue $schemas -Force }
            } catch { }
            
            try {
                $revisions = @(Get-AzApiManagementApiRevision -Context $script:apimContext -ApiId $api.ApiId -ErrorAction SilentlyContinue)
                if ($revisions.Count -gt 0) { $api | Add-Member -NotePropertyName "Revisions" -NotePropertyValue $revisions -Force }
            } catch { }
            
            if ($api.ApiVersionSetId) {
                try {
                    $versionSetId = $api.ApiVersionSetId -replace ".*/apiVersionSets/", ""
                    $versionSet = Get-AzApiManagementApiVersionSet -Context $script:apimContext -ApiVersionSetId $versionSetId -ErrorAction SilentlyContinue
                    if ($versionSet) { $api | Add-Member -NotePropertyName "VersionSet" -NotePropertyValue $versionSet -Force }
                } catch { }
            }
        }
        $script:exportData["APIs"] = ConvertTo-SafeHashtable $apis
        Write-Log "APIs : Found $($apis.Count) items" -Level "SUCCESS"
    }
    catch {
        Write-Log "Failed to export APIs: $_" -Level "WARN"
        $script:exportData["APIs"] = @()
    }
} else {
    Write-Log "Skipping APIs (not selected)" -Level "SKIP"
}

# Products
if ("Products" -in $ComponentsToExport) {
    Write-Log "Exporting Products..."
    try {
        $products = @(Get-AzApiManagementProduct -Context $script:apimContext)
        Write-Log "  Processing $($products.Count) Products..." -Level "PROGRESS"
        
        $processed = 0
        foreach ($product in $products) {
            $processed++
            Write-Log "  [$processed/$($products.Count)] Product: $($product.Title)" -Level "PROGRESS"
            
            try {
                $productApis = @(Get-AzApiManagementProductApi -Context $script:apimContext -ProductId $product.ProductId -ErrorAction SilentlyContinue)
                $product | Add-Member -NotePropertyName "APIs" -NotePropertyValue $productApis -Force
            } catch { }
            
            try {
                $productPolicy = Get-AzApiManagementPolicy -Context $script:apimContext -ProductId $product.ProductId -ErrorAction SilentlyContinue
                if ($productPolicy) { $product | Add-Member -NotePropertyName "Policy" -NotePropertyValue $productPolicy -Force }
            } catch { }
            
            try {
                $productGroups = @(Get-AzApiManagementProductGroup -Context $script:apimContext -ProductId $product.ProductId -ErrorAction SilentlyContinue)
                $product | Add-Member -NotePropertyName "Groups" -NotePropertyValue $productGroups -Force
            } catch { }
        }
        $script:exportData["Products"] = ConvertTo-SafeHashtable $products
        Write-Log "Products : Found $($products.Count) items" -Level "SUCCESS"
    }
    catch {
        Write-Log "Failed to export Products: $_" -Level "WARN"
        $script:exportData["Products"] = @()
    }
} else {
    Write-Log "Skipping Products (not selected)" -Level "SKIP"
}

# Subscriptions
if ("Subscriptions" -in $ComponentsToExport) {
    Write-Log "Exporting Subscriptions..."
    try {
        Write-Log "  Fetching subscriptions..." -Level "PROGRESS"
        $subs = @(Get-AzApiManagementSubscription -Context $script:apimContext)
        $script:exportData["Subscriptions"] = ConvertTo-SafeHashtable $subs
        Write-Log "Subscriptions : Found $($subs.Count) items" -Level "SUCCESS"
    }
    catch {
        Write-Log "Failed to export Subscriptions: $_" -Level "WARN"
        $script:exportData["Subscriptions"] = @()
    }
} else {
    Write-Log "Skipping Subscriptions (not selected)" -Level "SKIP"
}

# Users
if ("Users" -in $ComponentsToExport) {
    Write-Log "Exporting Users..."
    try {
        $users = @(Get-AzApiManagementUser -Context $script:apimContext)
        Write-Log "  Processing $($users.Count) Users (this may take a while)..." -Level "PROGRESS"
        
        $processed = 0
        $startTime = Get-Date
        foreach ($user in $users) {
            $processed++
            
            if ($processed % 50 -eq 0) {
                $elapsed = (Get-Date) - $startTime
                $rate = if ($elapsed.TotalSeconds -gt 0) { $processed / $elapsed.TotalSeconds } else { 1 }
                $remaining = [math]::Round(($users.Count - $processed) / $rate)
                Write-Log "  [$processed/$($users.Count)] ~${remaining}s remaining" -Level "PROGRESS"
            }
            
            try {
                $userGroups = @(Get-AzApiManagementUserGroup -Context $script:apimContext -UserId $user.UserId -ErrorAction SilentlyContinue)
                $user | Add-Member -NotePropertyName "Groups" -NotePropertyValue $userGroups -Force
            } catch { }
            
            try {
                $userSubs = @(Get-AzApiManagementSubscription -Context $script:apimContext -UserId $user.UserId -ErrorAction SilentlyContinue)
                $user | Add-Member -NotePropertyName "Subscriptions" -NotePropertyValue $userSubs -Force
            } catch { }
        }
        $script:exportData["Users"] = ConvertTo-SafeHashtable $users
        Write-Log "Users : Found $($users.Count) items" -Level "SUCCESS"
    }
    catch {
        Write-Log "Failed to export Users: $_" -Level "WARN"
        $script:exportData["Users"] = @()
    }
} else {
    Write-Log "Skipping Users (not selected)" -Level "SKIP"
}

# Simple components - direct export without complex processing
$simpleExports = @{
    "Groups"                 = { Get-AzApiManagementGroup -Context $script:apimContext }
    "NamedValues"            = { Get-AzApiManagementNamedValue -Context $script:apimContext }
    "Backends"               = { Get-AzApiManagementBackend -Context $script:apimContext }
    "Certificates"           = { Get-AzApiManagementCertificate -Context $script:apimContext }
    "Loggers"                = { Get-AzApiManagementLogger -Context $script:apimContext }
    "Diagnostics"            = { Get-AzApiManagementDiagnostic -Context $script:apimContext }
    "AuthorizationServers"   = { Get-AzApiManagementAuthorizationServer -Context $script:apimContext }
    "OpenIdConnectProviders" = { Get-AzApiManagementOpenIdConnectProvider -Context $script:apimContext }
    "IdentityProviders"      = { Get-AzApiManagementIdentityProvider -Context $script:apimContext }
    "ApiVersionSets"         = { Get-AzApiManagementApiVersionSet -Context $script:apimContext }
    "Tags"                   = { Get-AzApiManagementTag -Context $script:apimContext }
    "Caches"                 = { Get-AzApiManagementCache -Context $script:apimContext }
    "Gateways"               = { Get-AzApiManagementGateway -Context $script:apimContext }
    "GlobalPolicy"           = { try { Get-AzApiManagementPolicy -Context $script:apimContext } catch { $null } }
    "PortalDelegation"       = { Get-AzApiManagementPortalDelegationSettings -Context $script:apimContext }
    "PortalSignup"           = { Get-AzApiManagementPortalSignupSettings -Context $script:apimContext }
    "TenantAccess"           = { Get-AzApiManagementTenantAccess -Context $script:apimContext }
    "TenantGitAccess"        = { Get-AzApiManagementTenantGitAccess -Context $script:apimContext }
}

foreach ($compName in $simpleExports.Keys) {
    if ($compName -in $ComponentsToExport) {
        Write-Log "Exporting $compName..."
        try {
            Write-Log "  Fetching $compName..." -Level "PROGRESS"
            $data = & $simpleExports[$compName]
            $script:exportData[$compName] = ConvertTo-SafeHashtable $data
            $count = if ($data -is [array]) { $data.Count } else { if ($null -eq $data) { 0 } else { 1 } }
            Write-Log "$compName : Found $count items" -Level "SUCCESS"
        }
        catch {
            Write-Log "Failed to export ${compName}: $_" -Level "WARN"
            $script:exportData[$compName] = @()
        }
    } else {
        Write-Log "Skipping $compName (not selected)" -Level "SKIP"
    }
}

#endregion

# Write output
Write-Banner "Writing Output"

Write-Log "Preparing output..." -Level "PROGRESS"

if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath -Force | Out-Null
}
$OutputPath = (Resolve-Path $OutputPath).Path

$timestamp = Get-Date -Format "yyyyMMdd-HHmmss"

# Debug: show what we're exporting
Write-Log "Export data keys: $($script:exportData.Keys -join ', ')" -Level "PROGRESS"

if ($SingleFile) {
    $outputFile = Join-Path $OutputPath "$ServiceName-export-$timestamp.json"
    Write-Log "Writing to: $outputFile"
    Write-Log "Serializing JSON (may take a moment for large exports)..." -Level "PROGRESS"
    $script:exportData | ConvertTo-Json -Depth 50 | Out-File -FilePath $outputFile -Encoding UTF8
    Write-Log "Export complete!" -Level "SUCCESS"
    Write-Host ""
    Write-Host "  Output: $outputFile" -ForegroundColor Green
}
else {
    $exportDir = Join-Path $OutputPath "$ServiceName-export-$timestamp"
    New-Item -ItemType Directory -Path $exportDir -Force | Out-Null
    
    Write-Log "Writing to: $exportDir"
    
    Write-Log "Writing service info..." -Level "PROGRESS"
    @{
        ExportMetadata = $script:exportData.ExportMetadata
        ServiceInfo = $script:exportData.ServiceInfo
    } | ConvertTo-Json -Depth 30 | Out-File (Join-Path $exportDir "00-service-info.json") -Encoding UTF8
    
    $i = 1
    foreach ($comp in $script:AllComponents) {
        if ($script:exportData.ContainsKey($comp) -and $null -ne $script:exportData[$comp]) {
            Write-Log "Writing $comp..." -Level "PROGRESS"
            $filename = "{0:D2}-{1}.json" -f $i, $comp.ToLower()
            $script:exportData[$comp] | ConvertTo-Json -Depth 50 | Out-File (Join-Path $exportDir $filename) -Encoding UTF8
        }
        $i++
    }
    
    Write-Log "Export complete!" -Level "SUCCESS"
    Write-Host ""
    Write-Host "  Output: $exportDir" -ForegroundColor Green
}

# Summary
Write-Banner "Export Summary"

foreach ($key in $script:exportData.Keys) {
    if ($key -notin @("ExportMetadata", "ServiceInfo")) {
        $data = $script:exportData[$key]
        $count = if ($data -is [array]) { $data.Count } else { if ($null -eq $data) { 0 } else { 1 } }
        Write-Host "  $key : $count"
    }
}

Write-Host ""
Write-Host "Done!" -ForegroundColor Green
Write-Host ""

#endregion
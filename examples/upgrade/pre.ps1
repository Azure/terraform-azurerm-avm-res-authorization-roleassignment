#Requires -Version 7.4
<#
Deploys this example with v0.3.1 of the module into the example's own state file, so the E2E run upgrades real v0.3.1 state.

The E2E runner runs this hook before terraform init and apply. check policy also runs it, so it deploys only in the E2E job for this example, or when AVM_UPGRADE_FIXTURE is 'true'.
#>
$ErrorActionPreference = 'Stop'

if ($env:E2E_EXAMPLE -ne 'upgrade' -and $env:AVM_UPGRADE_FIXTURE -ne 'true') {
    Write-Host 'Skipping the v0.3.1 fixture outside the upgrade E2E run.'
    exit 0
}

$legacyVersion = '0.3.1'
$exampleDir = $PSScriptRoot

$terraform = (Get-Command terraform -ErrorAction SilentlyContinue)?.Source
if (-not $terraform -and $env:AVM_HOME) {
    $terraform = Get-ChildItem -Path (Join-Path $env:AVM_HOME 'tools' 'terraform') -Recurse -File -ErrorAction SilentlyContinue |
        Where-Object { $_.BaseName -eq 'terraform' } |
        Sort-Object FullName -Descending |
        Select-Object -First 1 -ExpandProperty FullName
}
if (-not $terraform) {
    throw 'terraform was not found on PATH or under AVM_HOME.'
}

$workDir = Join-Path ([System.IO.Path]::GetTempPath()) ("avm-upgrade-{0}" -f [guid]::NewGuid())
New-Item -ItemType Directory -Path $workDir | Out-Null

# Same configuration, pointed at the published release. v0.3.1 has no location input.
foreach ($file in Get-ChildItem -Path $exampleDir -Filter '*.tf' -File) {
    if ($file.Name -eq 'terraform.tf') { continue }
    $lines = Get-Content -Path $file.FullName | Where-Object { $_ -notmatch 'pre\.ps1 removes this line' }
    $content = ($lines -join "`n").Replace('source = "../../"', "source  = `"Azure/avm-res-authorization-roleassignment/azurerm`"`n  version = `"$legacyVersion`"")
    Set-Content -Path (Join-Path $workDir $file.Name) -Value $content
}

$statePath = (Join-Path $exampleDir 'terraform.tfstate').Replace('\', '/')
Set-Content -Path (Join-Path $workDir 'terraform.tf') -Value @"
terraform {
  required_version = "~> 1.6"

  backend "local" {
    path = "$statePath"
  }

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.12"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.46, < 4.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71, < 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
  resource_provider_registrations = "none"
}
"@

function Invoke-Terraform {
    param([string[]] $Arguments)
    & $terraform @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "terraform $($Arguments[0]) failed with exit code $LASTEXITCODE."
    }
}

Push-Location -Path $workDir
try {
    Invoke-Terraform @('init', '-input=false', '-no-color')
    try {
        Invoke-Terraform @('apply', '-auto-approve', '-input=false', '-no-color')
    }
    catch {
        # The runner skips its own destroy when this hook fails, so clean up here.
        Write-Warning "v0.3.1 apply failed; destroying the fixture. $_"
        & $terraform destroy -auto-approve -input=false -no-color
        throw
    }
}
finally {
    Pop-Location
}

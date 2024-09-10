# PowerShell 7 Profile with posh-git and Oh My Posh
# Function to safely import a module
function Import-ModuleSafely {
    param (
        [string]$ModuleName
    )
    if (Get-Module -ListAvailable -Name $ModuleName) {
        Import-Module $ModuleName
        return $true
    } else {
        Write-Host "Module $ModuleName is not installed. To install, run: Install-Module $ModuleName -Scope CurrentUser -Force" -ForegroundColor Yellow
        return $false
    }
}

# Set custom environment variables for Oh My Posh
$env:CUSTOM_USERNAME = "jamie"
$env:CUSTOM_HOSTNAME = "shell"

# Safely import posh-git
$poshGitLoaded = Import-ModuleSafely -ModuleName "posh-git"
if (Get-Command oh-my-posh -ErrorAction SilentlyContinue) {
    oh-my-posh init pwsh --config "C:\dev\catppuccin_frappe.omp.json" | Invoke-Expression
} else {
    Write-Host "ohmyposh not installed: https://ohmyposh.dev/docs/installation/windows" -ForegroundColor Yellow
}

# Alias
Set-Alias -Name ll -Value Get-ChildItem

if (-not $poshGitLoaded) {
    Write-Host "posh-git module is missing. Please install it for full functionality." -ForegroundColor Yellow
}

function vs-solution {
    param(
        [Parameter(Mandatory=$true)]
        [string]$SolutionPath
    )
    $vsPath = "C:\Program Files\Microsoft Visual Studio\2022\Community\Common7\IDE\devenv.exe"
   
    if (Test-Path $vsPath) {
        & $vsPath $SolutionPath
    } else {
        Write-Error "Visual Studio 2022 not found at the expected location. Please update the path in the function."
    }
}

function show_gitlab_repos {
    py c:/dev/gitlab_repos.py @args
}
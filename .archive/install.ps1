# TODO this script may encounter issues with non-administrator accounts
# enforce admin
if (!([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "script must be run as administrator"
    exit
}

# install chocolatey
Write-Host "installing chocolatey..."
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# verify chocolatey installation
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Error "chocoloatey install failed"
    exit
}
Write-Host "chocolatey installed successfully"

# list of packages to install
$packages = @(
    'git',
    'lazygit',
    '7zip',
    'make',
    'grep',
    'neovim'
)

# install packages
foreach ($package in $packages) {
    if (choco list | Select-String $package) {
        Write-Host "updating $package..."
        choco upgrade $package -y
    } else {
        Write-Host "installing $package..."
        choco install $package -y
    }
}
Write-Host "all packages installed successfully"

$miniforgeInstallerUrl = "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Windows-x86_64.exe"
$miniforgeInstallPath = "$env:USERPROFILE\miniforge3"
if (-not (Test-Path $miniforgeInstallPath)) {
    Write-Host "installing miniforge3..."
    $miniforgeInstallerPath = "$env:TEMP\Miniforge3-Windows-x86_64.exe"
    Invoke-WebRequest -Uri $miniforgeInstallerUrl -OutFile $miniforgeInstallerPath
    Start-Process -FilePath $miniforgeInstallerPath -ArgumentList "/InstallationType=JustMe", "/RegisterPython=0", "/AddToPath=1", "/S", "/D=$miniforgeInstallPath" -NoNewWindow -Wait
    Remove-Item $miniforgeInstallerPath
    Write-Host "miniforge3 installed successfully"
} else {
    Write-Host "miniforge3 is already installed"
}

# configure miniforge
Write-Host "initializing mamba..."
& "$miniforgeInstallPath\Scripts\mamba.exe" init powershell

Write-Host "please restart shell for installation to complete"

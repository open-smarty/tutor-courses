# Tutor Setup — Windows
# Double-click setup.bat to run this, or:
# powershell -ExecutionPolicy Bypass -File setup.ps1

$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "Tutor — Setup"
Write-Host ""

function Refresh-Path {
    $env:PATH = [System.Environment]::GetEnvironmentVariable("PATH", "Machine") + ";" +
                [System.Environment]::GetEnvironmentVariable("PATH", "User")
}

# ── VS Code ───────────────────────────────────────────────────────────────────

function Install-VSCode {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "  Using winget to install VS Code..."
        winget install Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements --silent
    } else {
        Write-Host "  Downloading VS Code installer..."
        $url = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
        $installer = "$env:TEMP\vscode-setup.exe"
        Invoke-WebRequest -Uri $url -OutFile $installer -UseBasicParsing
        Write-Host "  Installing VS Code..."
        # /MERGETASKS includes addtopath so 'code' works in new terminals
        Start-Process -FilePath $installer -ArgumentList "/VERYSILENT /NORESTART /MERGETASKS=!runcode,addtopath" -Wait
        Remove-Item $installer -Force -ErrorAction SilentlyContinue
    }
    Refresh-Path
}

if (Get-Command code -ErrorAction SilentlyContinue) {
    $v = (code --version)[0]
    Write-Host "  VS Code: $v ✓"
} else {
    Write-Host "  VS Code not found. Installing..."
    Install-VSCode
    Refresh-Path

    if (Get-Command code -ErrorAction SilentlyContinue) {
        $v = (code --version)[0]
        Write-Host "  VS Code: $v ✓"
    } else {
        Write-Host ""
        Write-Host "  VS Code installed but 'code' command needs a terminal restart."
        Write-Host "  Close this window, open a new terminal, and run setup.bat again."
        Read-Host "Press Enter to exit"
        exit 1
    }
}

# ── Node.js ───────────────────────────────────────────────────────────────────

function Install-Node {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        Write-Host "  Using winget to install Node.js..."
        winget install OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements --silent
    } elseif (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Host "  Using Chocolatey to install Node.js..."
        choco install nodejs-lts -y
    } else {
        Write-Host "  Downloading Node.js installer..."
        $url = "https://nodejs.org/dist/v20.14.0/node-v20.14.0-x64.msi"
        $installer = "$env:TEMP\node-setup.msi"
        Invoke-WebRequest -Uri $url -OutFile $installer -UseBasicParsing
        Write-Host "  Installing Node.js..."
        Start-Process msiexec.exe -Wait -ArgumentList "/I `"$installer`" /quiet /norestart"
        Remove-Item $installer -Force -ErrorAction SilentlyContinue
    }
    Refresh-Path
}

if (Get-Command node -ErrorAction SilentlyContinue) {
    $v = node --version
    Write-Host "  Node.js: $v ✓"
} else {
    Write-Host "  Node.js not found. Installing..."
    Install-Node

    if (Get-Command node -ErrorAction SilentlyContinue) {
        $v = node --version
        Write-Host "  Node.js: $v ✓"
    } else {
        Write-Host ""
        Write-Host "  Node.js installed but needs a terminal restart."
        Write-Host "  Close this window, open a new terminal, and run setup.bat again."
        Read-Host "Press Enter to exit"
        exit 1
    }
}

# ── npm setup ─────────────────────────────────────────────────────────────────
Write-Host ""
Set-Location $RepoDir
npm run setup

# ── Open VS Code ──────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  Opening VS Code..."
code $RepoDir

Write-Host ""
Write-Host "Done. VS Code is opening the course folder."
Write-Host ""
Read-Host "Press Enter to close"

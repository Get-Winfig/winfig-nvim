# ====================================================================== #
# UTF-8 with BOM Encoding for output
# ====================================================================== #

if ($PSVersionTable.PSVersion.Major -eq 5) {
    $OutputEncoding = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    [Console]::InputEncoding = [System.Text.Encoding]::UTF8
} else {
    $utf8WithBom = New-Object System.Text.UTF8Encoding $true
    $OutputEncoding = $utf8WithBom
    [Console]::OutputEncoding = $utf8WithBom
}

# ====================================================================== #
#  Script Metadata
# ====================================================================== #

$Script:WinfigMeta = @{
    Author       = "Armoghan-ul-Mohmin"
    CompanyName  = "Get-Winfig"
    Description  = "Windows configuration and automation framework"
    Version     = "1.0.0"
    License     = "MIT"
    Platform    = "Windows"
    PowerShell  = $PSVersionTable.PSVersion.ToString()
}

# ====================================================================== #
#  Color Palette
# ====================================================================== #

$Script:WinfigColors = @{
    Primary   = "Blue"
    Success   = "Green"
    Info      = "Cyan"
    Warning   = "Yellow"
    Error     = "Red"
    Accent    = "Magenta"
    Light     = "White"
    Dark      = "DarkGray"
}

# ====================================================================== #
# User Prompts
# ====================================================================== #

$Script:WinfigPrompts = @{
    Confirm    = "[?] Do you want to proceed? (Y/N): "
    Retry      = "[?] Do you want to retry? (Y/N): "
    Abort      = "[!] Operation aborted by user."
    Continue   = "[*] Press any key to continue..."
}

# ====================================================================== #
#  Paths
# ====================================================================== #

$Global:WinfigPaths = @{
    Desktop         = [Environment]::GetFolderPath("Desktop")
    Documents       = [Environment]::GetFolderPath("MyDocuments")
    UserProfile     = [Environment]::GetFolderPath("UserProfile")
    Temp            = [Environment]::GetEnvironmentVariable("TEMP")
    AppDataRoaming  = [Environment]::GetFolderPath("ApplicationData")
    AppDataLocal    = [Environment]::GetFolderPath("LocalApplicationData")
    Downloads       = [System.IO.Path]::Combine([Environment]::GetFolderPath("UserProfile"), "Downloads")
    Logs            = [System.IO.Path]::Combine([Environment]::GetEnvironmentVariable("TEMP"), "Winfig-Logs")
}
$Global:WinfigPaths.DotFiles = [System.IO.Path]::Combine($Global:WinfigPaths.UserProfile, ".Dotfiles")
$Global:WinfigPaths.Templates = [System.IO.Path]::Combine($Global:WinfigPaths.DotFiles, "winfig-nvim")

# ====================================================================== #
#  Packages List
# ====================================================================== #

$Script:Packages = @(
    # --- winget packages first ---
    @{ ID = "perl"; Name = "Strawberry Perl"; Description = "Perl for Windows"; Homepage = "https://strawberryperl.com/"; Source = "winget" }
    @{ ID = "ruby"; Name = "Ruby"; Description = "Ruby language";    Homepage = "https://rubyinstaller.org/"; Source = "winget" }
    @{ ID = "tar"; Name = "tar"; Description = "Archiver";         Homepage = "https://www.gnu.org/software/tar/"; Source = "winget" }
    @{ ID = "MartinStorsjo.LLVM-MinGW.MSVCRT"; Name = "C++ Programming Language"; Description = "C++ build tools including MSVC compiler; libraries; and CMake support."; Homepage = "https://visualstudio.microsoft.com/visual-cpp-build-tools/"; Source = "winget"}
    @{ ID = "7zip.7zip"; Name = "7-Zip - File Archiver"; Description = "High-compression file archiver supporting multiple formats including ZIP; RAR; and TAR."; Homepage = "https://www.7-zip.org/"; Source = "winget"}
    @{ ID = "astral-sh.uv"; Name = "uv - Python Package Manager"; Description = "Ultra-fast Python package installer and resolver; replacing pip and virtualenv."; Homepage = "https://github.com/astral-sh/uv/"; Source = "winget"}
    @{ ID = "make"; Name = "make"; Description = "Build automation tool"; Homepage = "https://www.gnu.org/software/make/"; Source = "winget" }
    @{ ID = "unzip"; Name = "unzip"; Description = "Unzip utility"; Homepage = "https://infozip.sourceforge.net/"; Source = "winget" }

    # --- choco packages after ---
    @{ ID = "fzf"; Name = "fzf - Fuzzy Finder"; Description = "Blazing-fast command-line fuzzy finder for files; commands; history; and more."; Homepage = "https://github.com/junegunn/fzf/"; Source = "choco"}
    @{ ID = "ripgrep"; Name = "ripgrep - Search Tool"; Description = "Ultra-fast text search tool that respects your .gitignore and recursively searches code."; Homepage = "https://github.com/BurntSushi/ripgrep/"; Source = "choco"}
    @{ ID = "lazygit"; Name = "lazygit"; Description = "Terminal Git UI";  Homepage = "https://github.com/jesseduffield/lazygit"; Source = "choco" }
    @{ ID = "fd"; Name = "fd"; Description = "Simple; fast and user-friendly alternative to 'find'"; Homepage = "https://github.com/sharkdp/fd"; Source = "choco" }
    @{ ID = "curl"; Name = "curl"; Description = "Command-line HTTP client"; Homepage = "https://curl.se/"; Source = "choco" }
    @{ ID = "nvm"; Name = "nvm-windows - Node Version Manager"; Description = "Easily switch between Node.js versions and manage multiple development environments."; Homepage = "https://github.com/coreybutler/nvm-windows/"; Source = "choco"}
)

# ====================================================================== #
# Start Time, Resets, Counters
# ====================================================================== #
$Global:WinfigLogStart = Get-Date
$Global:WinfigLogFilePath = $null
Remove-Variable -Name WinfigLogFilePath -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name LogCount -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name ErrorCount -Scope Global -ErrorAction SilentlyContinue
Remove-Variable -Name WarnCount -Scope Global -ErrorAction SilentlyContinue
$Script:RemovedCount = 0
$Script:NotFoundCount = 0
$Script:ErrorCount = 0

# ====================================================================== #
# Utility Functions
# ====================================================================== #

# ---------------------------------------------------------------------------- #
# Function to display a Success message
function Show-SuccessMessage {
    param (
        [string]$Message
    )
    Write-Host "[OK] $Message" -ForegroundColor $Script:WinfigColors.Success
}

# ---------------------------------------------------------------------------- #
# Function to display an Error message
function Show-ErrorMessage {
    param (
        [string]$Message
    )
    Write-Host "[ERROR] $Message" -ForegroundColor $Script:WinfigColors.Error
}

# ---------------------------------------------------------------------------- #
# Function to display an Info message
function Show-InfoMessage {
    param (
        [string]$Message
    )
    Write-Host "[INFO] $Message" -ForegroundColor $Script:WinfigColors.Info
}

# ---------------------------------------------------------------------------- #
# Function to display a Warning message
function Show-WarningMessage {
    param (
        [string]$Message
    )
    Write-Host "[WARN] $Message" -ForegroundColor $Script:WinfigColors.Warning
}

# ---------------------------------------------------------------------------- #
# Function to prompt user for input with a specific color
function Prompt-UserInput {
    param (
        [string]$PromptMessage = $Script:WinfigPrompts.Confirm,
        [string]$PromptColor   = $Script:WinfigColors.Primary
    )
    # Write prompt in the requested color, keep cursor on same line, then read input
    Write-Host -NoNewline $PromptMessage -ForegroundColor $PromptColor
    $response = Read-Host

    return $response
}

# ---------------------------------------------------------------------------- #
# Function to Prompt user for confirmation (Y/N)
function Prompt-UserConfirmation {
    while ($true) {
        $response = Prompt-UserInput -PromptMessage $Script:WinfigPrompts.Confirm -PromptColor $Script:WinfigColors.Primary
        switch ($response.ToUpper()) {
            "Y" { return $true }
            "N" { return $false }
            default {
                Show-WarningMessage "Invalid input. Please enter Y or N."
            }
        }
    }
}

# ---------------------------------------------------------------------------- #
# Function to Prompt user to Retry (Y/N)
function Prompt-UserRetry {
    while ($true) {
        $response = Prompt-UserInput -PromptMessage $Script:WinfigPrompts.Retry -PromptColor $Script:WinfigColors.Primary
        switch ($response.ToUpper()) {
            "Y" { return $true }
            "N" { return $false }
            default {
                Show-WarningMessage "Invalid input. Please enter Y or N."
            }
        }
    }
}

# ---------------------------------------------------------------------------- #
# Function to Prompt user to continue
function Prompt-UserContinue {
    Write-Host $Script:WinfigPrompts.Continue -ForegroundColor $Script:WinfigColors.Primary
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}

# ---------------------------------------------------------------------------- #
# Function to Abort operation
function Abort-Operation {
    Show-ErrorMessage $Script:WinfigPrompts.Abort
    # Write log footer before exiting
    if ($Global:WinfigLogFilePath) {
        Log-Message -Message "Script terminated." -EndRun
    }
    exit 1
}

# ---------------------------------------------------------------------------- #
# Function to Write a Section Header
function Write-SectionHeader {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title,

        [Parameter(Mandatory=$false)]
        [string]$Description = ""
    )
    $separator = "=" * 70
    Write-Host $separator -ForegroundColor $Script:WinfigColors.Accent
    Write-Host "$Title" -ForegroundColor $Script:WinfigColors.Primary
    if ($Description) {
        Write-Host "$Description" -ForegroundColor $Script:WinfigColors.Accent
    }
    Write-Host $separator -ForegroundColor $Script:WinfigColors.Accent
}

# ---------------------------------------------------------------------------- #
# Function to Write a Subsection Header
function Write-SubsectionHeader {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Title
    )
    $separator = "-" * 50
    Write-Host $separator -ForegroundColor $Script:WinfigColors.Accent
    Write-Host "$Title" -ForegroundColor $Script:WinfigColors.Primary
    Write-Host $separator -ForegroundColor $Script:WinfigColors.Accent
}

# ---------------------------------------------------------------------------- #
#  Function to Write a Log Message
function Log-Message {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,

        [Parameter(Mandatory=$false)]
        [ValidateSet("DEBUG", "INFO", "WARN", "ERROR", "SUCCESS")]
        [string]$Level = "INFO",

        [Parameter(Mandatory=$false)]
        [switch]$EndRun
    )

    if (-not $Global:LogCount) { $Global:LogCount = 0 }
    if (-not $Global:ErrorCount) { $Global:ErrorCount = 0 }
    if (-not $Global:WarnCount) { $Global:WarnCount = 0 }


    if (-not (Test-Path -Path $Global:WinfigPaths.Logs)) {
        New-Item -ItemType Directory -Path $Global:WinfigPaths.Logs -Force | Out-Null
    }

    $enc = New-Object System.Text.UTF8Encoding $true

    $identity = try { [System.Security.Principal.WindowsIdentity]::GetCurrent().Name } catch { $env:USERNAME }
    $isElevated = try {
        (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    } catch {
        $false
    }
    $scriptPath = if ($PSCommandPath) { $PSCommandPath } elseif ($MyInvocation.MyCommand.Path) { $MyInvocation.MyCommand.Path } else { $null }
    $psVersion = $PSVersionTable.PSVersion.ToString()
    $dotNetVersion = [System.Environment]::Version.ToString()
    $workingDir = (Get-Location).Path
    $osInfo = try {
        (Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop).Caption
    } catch {
        [Environment]::OSVersion.VersionString
    }
    # ---------------------------------------------------------------------------------------

    if (-not $Global:WinfigLogFilePath) {
        # $Global:WinfigLogStart is set in the main script execution block for each run
        $fileStamp = $Global:WinfigLogStart.ToString('yyyy-MM-dd_HH-mm-ss')
        $Global:WinfigLogFilePath = [System.IO.Path]::Combine($Global:WinfigPaths.Logs, "winfig-terminal-$fileStamp.log")

        $header = @()
        $header += "==================== Winfig Terminal Log ===================="
        $header += "Start Time  : $($Global:WinfigLogStart.ToString('yyyy-MM-dd HH:mm:ss'))"
        $header += "Host Name   : $env:COMPUTERNAME"
        $header += "User        : $identity"
        $header += "IsElevated  : $isElevated"
        if ($scriptPath) { $header += "Script Path : $scriptPath" }
        $header += "Working Dir : $workingDir"
        $header += "PowerShell  : $psVersion"
        $header += "NET Version : $dotNetVersion"
        $header += "OS          : $osInfo"
        $header += "=============================================================="
        $header += ""

        try {
            [System.IO.File]::WriteAllLines($Global:WinfigLogFilePath, $header, $enc)
        } catch {
            $header | Out-File -FilePath $Global:WinfigLogFilePath -Encoding UTF8 -Force
        }
    } else {
        if (-not $Global:WinfigLogStart) {
            $Global:WinfigLogStart = Get-Date
        }

        try {
            if (Test-Path -Path $Global:WinfigLogFilePath) {
                $firstLine = Get-Content -Path $Global:WinfigLogFilePath -TotalCount 1 -ErrorAction SilentlyContinue
                if ($firstLine -and ($firstLine -notmatch 'Winfig Terminal Log')) {

                    $header = @()
                    $header += "==================== Winfig Terminal Log  ===================="
                    $header += "Start Time  : $($Global:WinfigLogStart.ToString('yyyy-MM-dd HH:mm:ss'))"
                    $header += "Host Name   : $env:COMPUTERNAME"
                    $header += "User        : $identity"
                    $header += "IsElevated  : $isElevated"
                    if ($scriptPath) { $header += "Script Path : $scriptPath" }
                    $header += "Working Dir : $workingDir"
                    $header += "PowerShell  : $psVersion"
                    $header += "NET Version : $dotNetVersion"
                    $header += "OS          : $osInfo"
                    $header += "======================================================================="
                    $header += ""

                    # Prepend header safely: write header to temp file then append original content
                    $temp = [System.IO.Path]::GetTempFileName()
                    try {
                        [System.IO.File]::WriteAllLines($temp, $header, $enc)
                        [System.IO.File]::AppendAllLines($temp, (Get-Content -Path $Global:WinfigLogFilePath -Raw).Split([Environment]::NewLine), $enc)
                        Move-Item -Force -Path $temp -Destination $Global:WinfigLogFilePath
                    } finally {
                        if (Test-Path $temp) { Remove-Item $temp -ErrorAction SilentlyContinue }
                    }
                }
            }
        } catch {
            # ignore header-fix failures; continue logging
        }
    }

    if ($EndRun) {
        $endTime = Get-Date
        # $Global:WinfigLogStart is guaranteed to be set now
        $duration = $endTime - $Global:WinfigLogStart
        $footer = @()
        $footer += ""
        $footer += "--------------------------------------------------------------"
        $footer += "End Time    : $($endTime.ToString('yyyy-MM-dd HH:mm:ss'))"
        $footer += "Duration    : $($duration.ToString('dd\.hh\:mm\:ss') -replace '^00\.', '')"
        $footer += "Log Count   : $Global:LogCount"
        $footer += "Errors/Warn : $Global:ErrorCount / $Global:WarnCount"
        $footer += "===================== End of Winfig Log ======================"
        try {
            [System.IO.File]::AppendAllLines($Global:WinfigLogFilePath, $footer, $enc)
        } catch {
            $footer | Out-File -FilePath $Global:WinfigLogFilePath -Append -Encoding UTF8
        }
        return
    }

    $now = Get-Date
    $timestamp = $now.ToString("yyyy-MM-dd HH:mm:ss.fff")
    $logEntry = "[$timestamp] [$Level] $Message"

    $Global:LogCount++
    if ($Level -eq 'ERROR') { $Global:ErrorCount++ }
    if ($Level -eq 'WARN') { $Global:WarnCount++ }

    try {
        [System.IO.File]::AppendAllText($Global:WinfigLogFilePath, $logEntry + [Environment]::NewLine, $enc)
    } catch {
        Write-Host "Failed to write log to file: $($_.Exception.Message)" -ForegroundColor Yellow
        Write-Host $logEntry
    }
}

# ====================================================================== #
#  Main Functions
# ====================================================================== #

# ---------------------------------------------------------------------------- #
# Function to check if running as Administrator
function IsAdmin{
    $currentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $principal = New-Object System.Security.Principal.WindowsPrincipal($currentUser)
    if ($principal.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Log-Message -Message "Script is running with Administrator privileges." -Level "SUCCESS"
    } else {
        Show-ErrorMessage "Script is NOT running with Administrator privileges."
        Log-Message -Message "Script is NOT running with Administrator privileges." -Level "ERROR"
        Log-Message "Forced exit." -EndRun
        $LogPathMessage = "Check the Log file for details: $($Global:WinfigLogFilePath)"
        Show-InfoMessage -Message $LogPathMessage
        exit 1
    }
}

# ---------------------------------------------------------------------------- #
# Function to check Working Internet Connection
function Test-InternetConnection {
    try {
        $request = [System.Net.WebRequest]::Create("http://www.google.com")
        $request.Timeout = 5000
        $response = $request.GetResponse()
        $response.Close()
        Log-Message -Message "Internet connection is available." -Level "SUCCESS"
        return $true
    } catch {
        Show-ErrorMessage "No internet connection available: $($_.Exception.Message)"
        Log-Message -Message "No internet connection available: $($_.Exception.Message)" -Level "ERROR"
        Log-Message "Forced exit." -EndRun
        $LogPathMessage = "Check the Log file for details: $($Global:WinfigLogFilePath)"
        Show-InfoMessage -Message $LogPathMessage
        exit 1

    }
}

# ---------------------------------------------------------------------------- #
# Function to check if PowerShell version is 7 or higher
function Test-PSVersion {
    $psVersion = $PSVersionTable.PSVersion
    if ($psVersion.Major -ge 5) {
        Log-Message -Message "PowerShell version is sufficient: $($psVersion.ToString())." -Level "SUCCESS"
    } else {
        Show-ErrorMessage "PowerShell version is insufficient: $($psVersion.ToString()). Version 5 or higher is required."
        Log-Message -Message "PowerShell version is insufficient: $($psVersion.ToString()). Version 5 or higher is required." -Level "ERROR"
        Log-Message "Forced exit." -EndRun
        $LogPathMessage = "Check the Log file for details: $($Global:WinfigLogFilePath)"
        Show-InfoMessage -Message $LogPathMessage
        exit 1
    }
}

# ---------------------------------------------------------------------------- #
# Function to Display Banner
function Winfig-Banner {
    Clear-Host
    Write-Host ""
    Write-Host ("  ██╗    ██╗██╗███╗   ██╗███████╗██╗ ██████╗  ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Light
    Write-Host ("  ██║    ██║██║████╗  ██║██╔════╝██║██╔════╝  ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Light
    Write-Host ("  ██║ █╗ ██║██║██╔██╗ ██║█████╗  ██║██║  ███╗ ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Accent
    Write-Host ("  ██║███╗██║██║██║╚██╗██║██╔══╝  ██║██║   ██║ ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Accent
    Write-Host ("  ╚███╔███╔╝██║██║ ╚████║██║     ██║╚██████╔╝ ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Success
    Write-Host ("   ╚══╝╚══╝ ╚═╝╚═╝  ╚═══╝╚═╝     ╚═╝ ╚═════╝  ".PadRight(70)) -ForegroundColor $Script:WinfigColors.Success
    Write-Host ((" " * 70)) -ForegroundColor $Script:WinfigColors.Primary
    Write-Host ("" + $Script:WinfigMeta.CompanyName).PadLeft(40).PadRight(70) -ForegroundColor $Script:WinfigColors.Primary
    Write-Host ((" " * 70)) -ForegroundColor $Script:WinfigColors.Primary
    Write-Host ("  " + $Script:WinfigMeta.Description).PadRight(70) -ForegroundColor $Script:WinfigColors.Accent
    Write-Host ((" " * 70)) -ForegroundColor $Script:WinfigColors.Primary
    Write-Host (("  Version: " + $Script:WinfigMeta.Version + "    PowerShell: " + $Script:WinfigMeta.PowerShell).PadRight(70)) -ForegroundColor $Script:WinfigColors.Warning
    Write-Host (("  Author:  " + $Script:WinfigMeta.Author + "    Platform: " + $Script:WinfigMeta.Platform).PadRight(70)) -ForegroundColor $Script:WinfigColors.Warning
    Write-Host ""
}

# ---------------------------------------------------------------------------- #
# CTRL+C Signal Handler
trap {
    # Check if the error is due to a user interrupt (CTRL+C)
    if ($_.Exception.GetType().Name -eq "HostException" -and $_.Exception.Message -match "stopped by user") {

        # 1. Print the desired message
        Write-Host ""
        Write-Host ">>> [!] User interruption (CTRL+C) detected. Exiting gracefully..." -ForegroundColor $Script:WinfigColors.Accent

        # 2. Log the event before exit
        Log-Message -Message "Script interrupted by user (CTRL+C)." -Level "WARN"

        # 3. Write log footer before exiting
        if ($Global:WinfigLogFilePath) {
            Log-Message -Message "Script terminated by user (CTRL+C)." -EndRun
        }

        # 4. Terminate the script cleanly (exit code 1 is standard for non-zero exit)
        exit 1
    }
    # If it's a different kind of error, let the default behavior (or next trap) handle it
    continue
}

# ---------------------------------------------------------------------------- #
#  Check if windows terminal is installed or not
function Test-WindowsTerminalInstalled {
    $wtPath = "$($Global:WinfigPaths.AppDataLocal)\Microsoft\WindowsApps\wt.exe"
    if (Test-Path -Path $wtPath) {
        Log-Message -Message "Windows Terminal is installed." -Level "SUCCESS"
        return $true
    } else {
        Show-WarningMessage "Windows Terminal is not installed."
        Log-Message -Message "Windows Terminal is not installed." -Level "WARN"
        exit 1
    }
}

# ---------------------------------------------------------------------------- #
#  Create Dotfiles Directory if not exists
function Create-DotfilesDirectory {
    if (-not (Test-Path -Path $Global:WinfigPaths.DotFiles)) {
        try {
            New-Item -ItemType Directory -Path $Global:WinfigPaths.DotFiles -Force | Out-Null
            Show-SuccessMessage "Created Dotfiles directory at $($Global:WinfigPaths.DotFiles)."
            Log-Message -Message "Created Dotfiles directory at $($Global:WinfigPaths.DotFiles)." -Level "SUCCESS"
        } catch {
            Show-ErrorMessage "Failed to create Dotfiles directory: $($_.Exception.Message)"
            Log-Message -Message "Failed to create Dotfiles directory: $($_.Exception.Message)" -Level "ERROR"
            Abort-Operation
        }
    } else {
        Log-Message -Message "Dotfiles directory already exists at $($Global:WinfigPaths.DotFiles)." -Level "INFO"
    }
}

# ---------------------------------------------------------------------------- #
#  Check if git is installed
function Test-GitInstalled {
    try {
        git --version *> $null
        Log-Message -Message "Git is installed." -Level "SUCCESS"
        return $true
    } catch {
        Show-ErrorMessage "Git is not installed or not found in PATH."
        Log-Message -Message "Git is not installed or not found in PATH." -Level "ERROR"
        exit 1
    }
}

# ---------------------------------------------------------------------------- #
#  Check if Neovim is installed
function Test-NeovimInstalled {
    try {
        nvim --version *> $null
        Log-Message -Message "Neovim is installed." -Level "SUCCESS"
        return $true
    } catch {
        Show-ErrorMessage "Neovim is not installed or not found in PATH."
        Log-Message -Message "Neovim is not installed or not found in PATH." -Level "ERROR"
        exit 1
    }
}

# ---------------------------------------------------------------------------- #
#  Install Packages via winget/chocolatey
function Install-Packages {
    param(
        [Parameter(Mandatory=$true)]
        [array]$PackageList
    )

    $wingetCommand = "winget install --id {0} --exact --silent --accept-source-agreements --accept-package-agreements --force"
    $chocoCommand = "choco install {0} -y --no-progress --ignore-checksums --limit-output --no-color"

    # Install Packages via winget
    foreach ($package in $PackageList | Where-Object { $_.Source -eq "winget" }) {
        $pkgName = $package.Name
        $pkgDescription = $package.Description
        $pkgHomepage = $package.Homepage

        Write-SubsectionHeader -Title "Processing: $pkgName"
        Show-InfoMessage "$pkgDescription"
        Show-InfoMessage "$pkgHomepage"
        Write-Host ""

        $installCmd = $wingetCommand -f $package.ID
        try {
            Show-InfoMessage "Installing $pkgName via winget..."
            Log-Message -Message "Installing $pkgName via winget..." -Level "INFO"
            iex $installCmd *> $null
            Show-SuccessMessage "$pkgName installed successfully via winget."
            Write-Host ""
            Log-Message -Message "$pkgName installed successfully via winget." -Level "SUCCESS"
        } catch {
            Show-ErrorMessage "Failed to install $pkgName via winget: $($_.Exception.Message)"
            Log-Message -Message "Failed to install $pkgName via winget: $($_.Exception.Message)" -Level "ERROR"
        }
    }

    # Install Packages via chocolatey
    foreach ($package in $PackageList | Where-Object { $_.Source -eq "choco" }) {
        $pkgName = $package.Name
        $pkgDescription = $package.Description
        $pkgHomepage = $package.Homepage

        Write-SubsectionHeader -Title "Processing: $pkgName"
        Show-InfoMessage "$pkgDescription"
        Show-InfoMessage "$pkgHomepage"
        Write-Host ""

        $installCmd = $chocoCommand -f $package.ID
        try {
            Show-InfoMessage "Installing $pkgName via chocolatey..."
            Log-Message -Message "Installing $pkgName via chocolatey..." -Level "INFO"
            iex $installCmd *> $null
            Show-SuccessMessage "$pkgName installed successfully via chocolatey."
            Log-Message -Message "$pkgName installed successfully via chocolatey." -Level "SUCCESS"
        } catch {
            Show-ErrorMessage "Failed to install $pkgName via chocolatey: $($_.Exception.Message)"
            Log-Message -Message "Failed to install $pkgName via chocolatey: $($_.Exception.Message)" -Level "ERROR"
        }
    }
}

# ---------------------------------------------------------------------------- #
#  Configure UV for Python package management and setup default Python version
function Configure-UV {
    try {
        Show-InfoMessage "Configuring UV for Python package management..."
        Log-Message -Message "Configuring UV for Python package management..." -Level "INFO"
        uv install latest *> $null
        uv use latest *> $null
        Log-Message -Message "UV configured successfully with the latest Python version." -Level "SUCCESS"
    } catch {
        Show-ErrorMessage "Failed to configure UV: $($_.Exception.Message)"
        Log-Message -Message "Failed to configure UV: $($_.Exception.Message)" -Level "ERROR"
        exit 1
    }
}

# ---------------------------------------------------------------------------- #
#  Configure NVM for Node.js version management and setup default Node.js version and add in system path
function Configure-NVM {
    try {
        Show-InfoMessage "Configuring NVM for Node.js version management..."
        Log-Message -Message "Configuring NVM for Node.js version management..." -Level "INFO"
        nvm install latest *> $null
        nvm use latest *> $null
        # Add Node.js to system PATH
        $nodePath = [System.IO.Path]::Combine($env:APPDATA, "nvm", "v$(nvm current)")
        if (-not ($env:PATH -split ';' | Where-Object { $_ -eq $nodePath })) {
            [Environment]::SetEnvironmentVariable("PATH", $env:PATH + ";" + $nodePath, [EnvironmentVariableTarget]::Machine)
            Show-InfoMessage "Added Node.js to system PATH."
            Log-Message -Message "Added Node.js to system PATH." -Level "INFO"
        }
        Log-Message -Message "NVM configured successfully with the latest Node.js version." -Level "SUCCESS"
    } catch {
        Show-ErrorMessage "Failed to configure NVM: $($_.Exception.Message)"
        Log-Message -Message "Failed to configure NVM: $($_.Exception.Message)" -Level "ERROR"
        exit 1
    }
}

# ====================================================================== #
#  Main Script Execution
# ====================================================================== #

Winfig-Banner
Write-SectionHeader -Title "Checking Requirements"
Write-Host ""

IsAdmin | Out-Null
Show-SuccessMessage "Administrator privileges confirmed."

Test-InternetConnection | Out-Null
Show-SuccessMessage "Internet connection is available."

Test-PSVersion | Out-Null
Show-SuccessMessage "PowerShell version is sufficient."

Test-WindowsTerminalInstalled | Out-Null
Show-SuccessMessage "Windows Terminal installation check completed."

Test-GitInstalled | Out-Null
Show-SuccessMessage "Git installation check completed."

Test-NeovimInstalled | Out-Null
Show-SuccessMessage "Neovim installation check completed."

Create-DotfilesDirectory | Out-Null
Show-SuccessMessage "Dotfiles directory setup completed."

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Installing Neovim Requirements"
Write-Host ""
Install-Packages -PackageList $Script:Packages
Show-SuccessMessage "Neovim requirements installation completed."

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Configure Python and Node.js Version Managers"
Write-Host ""

Configure-UV  | Out-Null
Show-SuccessMessage "UV configured successfully with the latest Python version."

Configure-NVM | Out-Null
Show-SuccessMessage "NVM configured successfully with the latest Node.js version."

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Cloning Winfig Neovim Repository"
Write-Host ""
$repoPath = Join-Path $Global:WinfigPaths.DotFiles "winfig-nvim"
if (-not (Test-Path -Path $repoPath)) {
    try {
        Show-InfoMessage "Cloning Winfig Neovim repository..."
        Log-Message -Message "Cloning Winfig Neovim repository..." -Level "INFO"
        git clone https://github.com/Get-Winfig/winfig-nvim.git $repoPath *> $null
    } catch {
        Show-ErrorMessage "Failed to clone Winfig Neovim repository: $($_.Exception.Message)"
        Log-Message -Message "Failed to clone Winfig Neovim repository: $($_.Exception.Message)" -Level "ERROR"
        exit 1
    }
    if (Test-Path -Path $repoPath) {
        Show-SuccessMessage "Cloned Winfig Neovim repository to $repoPath."
        Log-Message -Message "Cloned Winfig Neovim repository to $repoPath." -Level "SUCCESS"
    } else {
        Show-ErrorMessage "Winfig Neovim repository was not cloned. Please check your internet connection or repository URL."
        Log-Message -Message "Winfig Neovim repository was not cloned. Please check your internet connection or repository URL." -Level "ERROR"
        exit 1
    }
} else {
    try {
        Show-InfoMessage "Updating Winfig Neovim repository..."
        Log-Message -Message "Updating Winfig Neovim repository..." -Level "INFO"
        Push-Location $repoPath
        git pull *> $null
        Pop-Location
        Show-SuccessMessage "Updated Winfig Neovim repository at $repoPath."
        Log-Message -Message "Updated Winfig Neovim repository at $repoPath." -Level "SUCCESS"
    } catch {
        Show-ErrorMessage "Failed to update Winfig Neovim repository: $($_.Exception.Message)"
        Log-Message -Message "Failed to update Winfig Neovim repository: $($_.Exception.Message)" -Level "ERROR"
        exit 1
    }
}

Write-Host ""
Prompt-UserContinue

Winfig-Banner
Write-SectionHeader -Title "Symbolic Linking Neovim Configuration"
Write-Host ""
try {
    $source =  $Global:WinfigPaths.Templates
    $target = [System.IO.Path]::Combine($env:USERPROFILE, "AppData\Local\nvim")

    if (Test-Path $target) { Remove-Item $target -Force }
    New-Item -ItemType SymbolicLink -Path $target -Target $source -Force

    Show-SuccessMessage "Symlink created: $target -> $source"
    Log-Message -Message "Symlink created: $target -> $source" -Level "SUCCESS"

} catch {
    Show-ErrorMessage "Failed to create symlink: $($_.Exception.Message)"
    Log-Message -Message "Failed to create symlink: $($_.Exception.Message)" -Level "ERROR"
}

Write-Host ""
Write-SectionHeader -Title "Thank You For Using Winfig Terminal" -Description "https://github.com/Get-Winfig/"
Show-WarningMessage -Message "Restart Windows to apply changes"
Write-Host ""
Log-Message -Message "Logging Completed." -EndRun

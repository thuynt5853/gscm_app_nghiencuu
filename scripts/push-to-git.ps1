param(
    [string]$ProjectPath = "C:\ThuyNT_Viec\3. gscm_app_git_khoadulieu\3. gscm_app_git_khoadulieu",
    [string]$RemoteUrl = "https://github.com/thuynt5853/gscm_app_nghiencuu.git",
    [string]$Branch = "main",
    [string]$CommitMessage = "Initial commit",
    [switch]$AllowEmptyCommit
)

$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host ""
    Write-Host "==> $Message" -ForegroundColor Cyan
}

function Assert-Command {
    param([string]$CommandName)

    if (-not (Get-Command $CommandName -ErrorAction SilentlyContinue)) {
        throw "Khong tim thay lenh '$CommandName'. Hay cai dat va mo lai terminal."
    }
}

Assert-Command "git"

if (-not (Test-Path -LiteralPath $ProjectPath -PathType Container)) {
    throw "Khong tim thay thu muc project: $ProjectPath"
}

Write-Step "Di chuyen vao thu muc project"
Set-Location -LiteralPath $ProjectPath
Write-Host "ProjectPath: $(Get-Location)"

if (-not (Test-Path -LiteralPath ".git" -PathType Container)) {
    Write-Step "Khoi tao Git repository"
    git init
}

Write-Step "Kiem tra cau hinh remote origin"
$originUrl = ""
try {
    $originUrl = git remote get-url origin 2>$null
} catch {
    $originUrl = ""
}

if ([string]::IsNullOrWhiteSpace($originUrl)) {
    if ([string]::IsNullOrWhiteSpace($RemoteUrl)) {
        throw "Repo chua co remote origin. Hay chay lai voi -RemoteUrl 'https://github.com/thuynt5853/gscm_app_nghiencuu.git'"
    }

    git remote add origin $RemoteUrl
    Write-Host "Da them origin: $RemoteUrl"
} elseif (-not [string]::IsNullOrWhiteSpace($RemoteUrl) -and $originUrl -ne $RemoteUrl) {
    git remote set-url origin $RemoteUrl
    Write-Host "Da cap nhat origin: $RemoteUrl"
} else {
    Write-Host "origin: $originUrl"
}

Write-Step "Chuyen sang branch $Branch"
$existingBranch = git branch --list $Branch
if ([string]::IsNullOrWhiteSpace($existingBranch)) {
    git checkout -b $Branch
} else {
    git checkout $Branch
}

Write-Step "Them tat ca thay doi vao staging"
git add -A

$status = git status --porcelain
if ([string]::IsNullOrWhiteSpace($status)) {
    if ($AllowEmptyCommit) {
        Write-Step "Khong co thay doi, tao empty commit theo yeu cau"
        git commit --allow-empty -m $CommitMessage
    } else {
        Write-Host "Khong co thay doi nao de commit. Bo qua commit." -ForegroundColor Yellow
    }
} else {
    Write-Step "Tao commit"
    git commit -m $CommitMessage
}

Write-Step "Day code len Git remote"
git push -u origin $Branch

Write-Host ""
Write-Host "Hoan tat day code len Git." -ForegroundColor Green

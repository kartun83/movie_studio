# Movie Studio MTA Deployment Script (PowerShell)
# Automatically finds and deploys the latest MTA archive

param(
    [switch]$Force,
    [string]$ProjectName = "movie_studio"
)

# Configuration
$MtaArchivesDir = ".\mta_archives"

Write-Host "🎬 Movie Studio Deployment Script" -ForegroundColor Cyan
Write-Host "==================================" -ForegroundColor Cyan

# Check if mta_archives directory exists
if (-not (Test-Path $MtaArchivesDir)) {
    Write-Host "❌ Error: $MtaArchivesDir directory not found!" -ForegroundColor Red
    Write-Host "Please run 'mbt build' first to generate the MTA archive." -ForegroundColor Yellow
    exit 1
}

# Find the latest MTA archive
Write-Host "🔍 Looking for MTA archives in $MtaArchivesDir..." -ForegroundColor Yellow

# Get all .mtar files matching the project name pattern
$Archives = Get-ChildItem -Path $MtaArchivesDir -Filter "${ProjectName}_*.mtar" | Sort-Object Name

if ($Archives.Count -eq 0) {
    Write-Host "❌ Error: No MTA archives found in $MtaArchivesDir!" -ForegroundColor Red
    Write-Host "Please run 'mbt build' first to generate the MTA archive." -ForegroundColor Yellow
    exit 1
}

# Get the latest archive (last in sorted list)
$LatestArchive = $Archives | Select-Object -Last 1
Write-Host "📦 Found latest archive: $($LatestArchive.Name)" -ForegroundColor Green

# Check if cf CLI is available
try {
    $null = Get-Command cf -ErrorAction Stop
} catch {
    Write-Host "❌ Error: Cloud Foundry CLI (cf) is not installed or not in PATH!" -ForegroundColor Red
    Write-Host "Please install the cf CLI first." -ForegroundColor Yellow
    exit 1
}

# Check if user is logged in to CF
try {
    $null = cf target 2>$null
    if ($LASTEXITCODE -ne 0) {
        throw "Not logged in"
    }
} catch {
    Write-Host "❌ Error: Not logged in to Cloud Foundry!" -ForegroundColor Red
    Write-Host "Please run 'cf login' first." -ForegroundColor Yellow
    exit 1
}

# Show current target
Write-Host "🎯 Current CF target:" -ForegroundColor Yellow
cf target

Write-Host ""
Write-Host "🚀 Deploying to Cloud Foundry..." -ForegroundColor Green
Write-Host "Command: cf deploy `"$($LatestArchive.FullName)`" --delete-services" -ForegroundColor Gray
Write-Host ""

# Deploy the MTA archive
cf deploy $LatestArchive.FullName --delete-services

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Deployment completed successfully!" -ForegroundColor Green
    Write-Host "🌐 Your application should be available at the URL shown above." -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "❌ Deployment failed!" -ForegroundColor Red
    exit 1
} 
# SwarmGuard Firebase Hosting Deployment Script
param(
    [string]$ProjectId = ""
)

$ErrorActionPreference = "Stop"
$FirebaseBin = "$env:TEMP\firebase.exe"

if (-not (Test-Path $FirebaseBin)) {
    Write-Host "Firebase CLI binary not found at $FirebaseBin. Please wait for download or place firebase.exe there." -ForegroundColor Red
    exit 1
}

Write-Host "=== Step 1: Firebase Authentication ===" -ForegroundColor Cyan
& $FirebaseBin login

Write-Host "`n=== Step 2: Checking Firebase Projects ===" -ForegroundColor Cyan
if (-not $ProjectId) {
    & $FirebaseBin projects:list
    $ProjectId = Read-Host "`nEnter your Firebase Project ID from the list above (or create one at https://console.firebase.google.com)"
}

if (-not $ProjectId) {
    Write-Host "No Project ID provided. Deployment aborted." -ForegroundColor Red
    exit 1
}

# Update .firebaserc
$rcContent = @{
    projects = @{
        default = $ProjectId
    }
} | ConvertTo-Json

Set-Content -Path ".\.firebaserc" -Value $rcContent
Write-Host "Configured .firebaserc for project: $ProjectId" -ForegroundColor Green

Write-Host "`n=== Step 3: Deploying to Firebase Hosting ===" -ForegroundColor Cyan
& $FirebaseBin deploy --only hosting

Write-Host "`n=== Deployment Complete! ===" -ForegroundColor Green
Write-Host "Your website is live at: https://$ProjectId.web.app" -ForegroundColor Yellow
Write-Host "Alternate URL: https://$ProjectId.firebaseapp.com" -ForegroundColor Yellow

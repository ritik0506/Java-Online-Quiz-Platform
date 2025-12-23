# Java Online Quiz Platform - Quick Start Script
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  Java Online Quiz Platform" -ForegroundColor Green
Write-Host "  Starting Server..." -ForegroundColor Green
Write-Host "========================================`n" -ForegroundColor Cyan

# Navigate to project directory
Set-Location -Path $PSScriptRoot

# Check for running server on port 8080
Write-Host "Checking for running server on port 8080..." -ForegroundColor Yellow
$existingProcess = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue
if ($existingProcess) {
    $pid = $existingProcess.OwningProcess | Select-Object -First 1
    Write-Host "Found process $pid using port 8080. Killing it..." -ForegroundColor Yellow
    Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
    Write-Host "✅ Process stopped" -ForegroundColor Green
}

# Clean old build
Write-Host "`nCleaning old build..." -ForegroundColor Yellow
& mvn clean | Out-Null

# Build application
Write-Host "`nBuilding application..." -ForegroundColor Yellow
$buildOutput = & mvn package 2>&1

if ($LASTEXITCODE -ne 0) {
    Write-Host "`n❌ ERROR: Build failed!" -ForegroundColor Red
    Write-Host "Please check the error messages above." -ForegroundColor Red
    Write-Host $buildOutput
    Read-Host "`nPress Enter to exit"
    exit 1
}

Write-Host "✅ Build successful!" -ForegroundColor Green

# Start server
Write-Host "`nStarting server...`n" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Application will be available at:" -ForegroundColor Green
Write-Host "  http://localhost:8080/quiz-platform/" -ForegroundColor White -BackgroundColor DarkBlue
Write-Host "========================================`n" -ForegroundColor Cyan
Write-Host "Press Ctrl+C to stop the server`n" -ForegroundColor Yellow

& mvn cargo:run

# Quick Database Connection Test
Write-Host "`n=== Testing Database Connection ===" -ForegroundColor Cyan

# Test if we can reach MySQL
Write-Host "`n1. Testing MySQL port 3306..." -ForegroundColor Yellow
$mysqlPort = Test-NetConnection -ComputerName localhost -Port 3306 -WarningAction SilentlyContinue
if ($mysqlPort.TcpTestSucceeded) {
    Write-Host "✅ MySQL port 3306 is open and accessible" -ForegroundColor Green
} else {
    Write-Host "❌ Cannot connect to MySQL on port 3306" -ForegroundColor Red
    Write-Host "   → Check if MySQL is running in XAMPP Control Panel" -ForegroundColor Yellow
}

Write-Host "`n2. Checking if phpMyAdmin is accessible..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost/phpmyadmin/" -TimeoutSec 3 -UseBasicParsing -ErrorAction Stop
    Write-Host "✅ phpMyAdmin is accessible" -ForegroundColor Green
} catch {
    Write-Host "⚠️  phpMyAdmin not accessible - Apache may not be running" -ForegroundColor Yellow
}

Write-Host "`n3. Checking if application server is running..." -ForegroundColor Yellow
try {
    $appResponse = Invoke-WebRequest -Uri "http://localhost:8080/quiz-platform/" -TimeoutSec 3 -UseBasicParsing -ErrorAction Stop
    Write-Host "✅ Application server is responding (Status: $($appResponse.StatusCode))" -ForegroundColor Green
} catch {
    if ($_.Exception.Response.StatusCode -eq 500) {
        Write-Host "⚠️  Server running but returning 500 error" -ForegroundColor Red
        Write-Host "   → This is the issue we need to fix!" -ForegroundColor Yellow
    } else {
        Write-Host "❌ Cannot connect to application (Status: $($_.Exception.Message))" -ForegroundColor Red
    }
}

Write-Host "`n=== Test Complete ===" -ForegroundColor Cyan
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. If MySQL port is closed → Start MySQL in XAMPP" -ForegroundColor White
Write-Host "2. If database connection fails → Check DBConnection.java settings" -ForegroundColor White
Write-Host "3. If getting 500 errors → Check terminal logs for stack traces" -ForegroundColor White
Write-Host "`nRun this to restart server:" -ForegroundColor Cyan
Write-Host "mvn clean tomcat7:run" -ForegroundColor Green

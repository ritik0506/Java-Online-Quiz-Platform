@echo off
echo ========================================
echo   Java Online Quiz Platform
echo   Starting Server...
echo ========================================
echo.

cd /d "%~dp0"

echo Checking for running server on port 8080...
for /f "tokens=5" %%a in ('netstat -ano ^| findstr :8080 ^| findstr LISTENING') do (
    echo Found process %%a using port 8080. Killing it...
    taskkill /PID %%a /F >nul 2>&1
)

echo.
echo Cleaning old build...
call mvn clean

echo.
echo Building application...
call mvn package

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo ERROR: Build failed!
    echo Please check the error messages above.
    pause
    exit /b 1
)

echo.
echo Starting server...
echo.
echo ========================================
echo   Application will be available at:
echo   http://localhost:8080/quiz-platform/
echo ========================================
echo.
echo Press Ctrl+C to stop the server
echo.

call mvn cargo:run

pause

@echo off
title SwarmGuard - Firebase Hosting Deployment
color 0B
echo ===================================================
echo     SWARMGUARD GCU - FIREBASE DEPLOYMENT WIZARD
echo ===================================================
echo.
cd /d "%~dp0"

set "FIREBASE_BIN=%TEMP%\firebase.exe"

if not exist "%FIREBASE_BIN%" (
    echo [!] Downloading Firebase CLI...
    curl.exe -L -o "%FIREBASE_BIN%" https://firebase.tools/bin/win/latest
)

echo [1/3] Authenticating with Google / Firebase...
"%FIREBASE_BIN%" login

echo.
echo [2/3] Listing your Firebase Projects...
"%FIREBASE_BIN%" projects:list
echo.

set /p PROJECT_ID="Enter your Firebase Project ID (e.g. swarmguard-sar): "

if "%PROJECT_ID%"=="" (
    echo [!] No Project ID entered. Exiting.
    pause
    exit /b 1
)

echo { "projects": { "default": "%PROJECT_ID%" } } > .firebaserc

echo.
echo [3/3] Deploying to Firebase Hosting...
"%FIREBASE_BIN%" deploy --only hosting

echo.
echo ===================================================
echo [SUCCESS] Your app is live!
echo Public URL: https://%PROJECT_ID%.web.app
echo ===================================================
echo.
pause

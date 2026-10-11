@echo off
title BagGuard AI - Central Host Server
echo =======================================================
echo    BAGGUARD AI - CENTRAL HOST SERVER LAUNCHER
echo =======================================================
echo.
echo Detecting your Local IP Address...
for /f "tokens=4" %%a in ('route print ^| find " 0.0.0.0"') do (
    set LOCAL_IP=%%a
    goto :found_ip
)
:found_ip
echo Host Local IP Address: %LOCAL_IP%
echo.
if not exist .runtime\python311-x64\python.exe (
    echo ERROR: BagGuard's project-local Python runtime is missing.
    echo Run setup_windows.bat first, then run this launcher again.
    exit /b 1
)
.runtime\python311-x64\python.exe -c "import sys, platform, fastapi, uvicorn, cv2, mediapipe; raise SystemExit(0 if sys.version_info[:2] == (3, 11) and platform.machine() == 'AMD64' else 1)" >nul 2>nul
if errorlevel 1 (
    echo ERROR: The backend environment is not healthy or is not Python 3.11.
    echo Run setup_windows.bat and fix any dependency installation errors before starting BagGuard.
    exit /b 1
)
echo Starting FastAPI Backend on 0.0.0.0:8000...
start "BagGuard Backend" cmd /k ".runtime\python311-x64\python.exe -m uvicorn backend.app.main:app --host 0.0.0.0 --port 8000"
set /a BACKEND_WAIT=0
:wait_for_backend
curl --silent --fail http://127.0.0.1:8000/api/health >nul 2>nul
if not errorlevel 1 goto backend_ready
set /a BACKEND_WAIT+=1
if %BACKEND_WAIT% GEQ 20 goto backend_failed
timeout /t 1 /nobreak >nul
goto wait_for_backend
:backend_failed
echo ERROR: Backend did not become healthy on http://127.0.0.1:8000/api/health.
echo Check the BagGuard Backend window for the startup error. The frontend was not started.
exit /b 1
:backend_ready
echo Backend is healthy.
echo.

echo Starting Vite Frontend on 0.0.0.0:5173...
start "BagGuard Frontend" cmd /k "cd frontend && npm run dev -- --host 0.0.0.0 --port 5173"
timeout /t 3 /nobreak >nul

echo =======================================================
echo  CENTRAL SERVER IS NOW RUNNING!
echo =======================================================
echo.
echo  1. On THIS Host Laptop:
echo     Open Dashboard: http://localhost:5173/
echo.
echo  2. On LAPTOP 1 (Stage A - Check-In):
echo     Browser Link:   http://%LOCAL_IP%:5173/agent?stage=stage_a^&laptop=laptop-1
echo     Or Python Agent: python camera_agent\agent.py --server http://%LOCAL_IP%:8000 --stage stage_a --laptop-id laptop-1
echo.
echo  3. On LAPTOP 2 (Stage C - Handling Incidents):
echo     Browser Link:   http://%LOCAL_IP%:5173/agent?stage=stage_c^&laptop=laptop-2
echo.
echo  4. On LAPTOP 3 (Stage D - Final Inspection):
echo     Browser Link:   http://%LOCAL_IP%:5173/agent?stage=stage_d^&laptop=laptop-3
echo     Or Python Agent: python camera_agent\agent.py --server http://%LOCAL_IP%:8000 --stage stage_d --laptop-id laptop-3
echo.
echo =======================================================
pause

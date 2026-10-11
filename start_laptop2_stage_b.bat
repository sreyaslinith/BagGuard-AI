@echo off
title BagGuard AI - Laptop 2 (Stage C Handling Camera)
echo =======================================================
echo    BAGGUARD AI - LAPTOP 2 CAMERA AGENT (STAGE C)
echo =======================================================
echo.
set /p SERVER_IP="Enter Host Server IP [Default: 192.168.0.227]: "
if "%SERVER_IP%"=="" set SERVER_IP=192.168.0.227

echo.
echo Connecting to http://%SERVER_IP%:8000 as Laptop 2 (Stage C)...
echo Press Ctrl+C in this window to stop streaming.
echo.
python camera_agent\agent.py --server http://%SERVER_IP%:8000 --stage stage_c --laptop-id laptop-2 --fps 15
pause

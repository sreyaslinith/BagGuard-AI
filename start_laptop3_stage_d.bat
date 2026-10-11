@echo off
title BagGuard AI - Laptop 3 (Stage D Destination Camera)
echo =======================================================
echo    BAGGUARD AI - LAPTOP 3 CAMERA AGENT (STAGE D)
echo =======================================================
echo.
set /p SERVER_IP="Enter Host Server IP [Default: 192.168.0.227]: "
if "%SERVER_IP%"=="" set SERVER_IP=192.168.0.227

echo.
echo Connecting to http://%SERVER_IP%:8000 as Laptop 3 (Stage D)...
echo Press Ctrl+C in this window to stop streaming.
echo.
python camera_agent\agent.py --server http://%SERVER_IP%:8000 --stage stage_d --laptop-id laptop-3 --fps 15
pause

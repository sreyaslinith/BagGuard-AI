@echo off
setlocal
cd /d "%~dp0"

where npm >nul 2>nul
if errorlevel 1 (
  echo npm was not found. Install Node.js 20 or newer from nodejs.org.
  exit /b 1
)

if not exist .runtime\python311-x64\python.exe (
  if not exist .runtime mkdir .runtime
  echo Downloading the project-local Python 3.11 x64 runtime for computer vision...
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.9/python-3.11.9-embed-amd64.zip' -OutFile '.runtime\python311-embed-amd64.zip'"
  if errorlevel 1 exit /b 1
  mkdir .runtime\python311-x64
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -LiteralPath '.runtime\python311-embed-amd64.zip' -DestinationPath '.runtime\python311-x64' -Force"
  if errorlevel 1 exit /b 1
)
.runtime\python311-x64\python.exe -c "import sys, platform; raise SystemExit(0 if sys.version_info[:2] == (3, 11) and platform.machine() == 'AMD64' else 1)"
if errorlevel 1 (
  echo ERROR: The project-local Python runtime is not the required x64 Python 3.11 runtime.
  exit /b 1
)
(
  echo python311.zip
  echo .
  echo Lib\site-packages
  echo ..\..
  echo import site
) > .runtime\python311-x64\python311._pth
if not exist .runtime\python311-x64\Lib\site-packages mkdir .runtime\python311-x64\Lib\site-packages
.runtime\python311-x64\python.exe -m pip --version >nul 2>nul
if errorlevel 1 (
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Invoke-WebRequest -Uri 'https://bootstrap.pypa.io/get-pip.py' -OutFile '.runtime\get-pip.py'"
  if errorlevel 1 exit /b 1
  .runtime\python311-x64\python.exe .runtime\get-pip.py --no-warn-script-location
  if errorlevel 1 exit /b 1
)
.runtime\python311-x64\python.exe -m pip install --upgrade pip
if errorlevel 1 exit /b 1
.runtime\python311-x64\python.exe -m pip install -r backend\requirements.txt
if errorlevel 1 exit /b 1

if not exist .env copy .env.example .env >nul
pushd frontend
npm install
if errorlevel 1 (popd & exit /b 1)
popd

echo.
echo Setup complete. Start BagGuard AI with start_server_lan.bat
endlocal

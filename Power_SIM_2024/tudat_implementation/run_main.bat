@echo off
REM Windows batch file to run main.py with MKL threading fix
REM This sets environment variables BEFORE Python starts

echo Setting MKL environment variables for Windows...
set MKL_THREADING_LAYER=SEQUENTIAL
set MKL_NUM_THREADS=1
set NUMEXPR_NUM_THREADS=1
set OMP_NUM_THREADS=1

echo Environment variables set:
echo MKL_THREADING_LAYER=%MKL_THREADING_LAYER%
echo MKL_NUM_THREADS=%MKL_NUM_THREADS%
echo NUMEXPR_NUM_THREADS=%NUMEXPR_NUM_THREADS%
echo OMP_NUM_THREADS=%OMP_NUM_THREADS%
echo.

echo Running main.py...
C:\Users\vpn\miniconda3\envs\tudat-space\python.exe %~dp0main.py %*

pause

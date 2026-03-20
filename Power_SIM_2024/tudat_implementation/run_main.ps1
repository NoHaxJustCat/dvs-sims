# PowerShell script to run main.py with MKL threading fix

Write-Host "Setting MKL environment variables for Windows..." -ForegroundColor Green

# Set environment variables
$env:MKL_THREADING_LAYER = "SEQUENTIAL"
$env:MKL_NUM_THREADS = "1"
$env:NUMEXPR_NUM_THREADS = "1"
$env:OMP_NUM_THREADS = "1"

Write-Host "Environment variables set:" -ForegroundColor Green
Write-Host "  MKL_THREADING_LAYER = $($env:MKL_THREADING_LAYER)"
Write-Host "  MKL_NUM_THREADS = $($env:MKL_NUM_THREADS)"
Write-Host "  NUMEXPR_NUM_THREADS = $($env:NUMEXPR_NUM_THREADS)"
Write-Host "  OMP_NUM_THREADS = $($env:OMP_NUM_THREADS)"
Write-Host ""

Write-Host "Running main.py..." -ForegroundColor Green
& C:\Users\vpn\miniconda3\envs\tudat-space\python.exe "$PSScriptRoot\main.py" @args

# Keep window open if script fails
if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "Script exited with code: $LASTEXITCODE" -ForegroundColor Red
    Read-Host "Press Enter to exit"
}

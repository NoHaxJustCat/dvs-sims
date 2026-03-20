# Windows Fatal Exception (0xc06d007f) - RESOLVED ✅

## Problem
Your Python application was crashing with:
```
Windows fatal exception: code 0xc06d007f
```
This occurred during the import of `astropy.coordinates` in the tudatpy chain.

## Root Cause
- **Error Code 0xc06d007f** = Illegal instruction / threading conflict
- Intel MKL (Math Kernel Library) was using incompatible threading settings on Windows
- The MKL_THREADING_LAYER needed to be set to SEQUENTIAL (not GNU) for Windows compatibility
- This works on Linux because Linux uses different threading defaults

## Solution Applied ✅

The fix has been applied to your codebase in TWO places:

### 1. **main.py** 
Added at the very beginning (lines 16-21):
```python
# WINDOWS FIX: Set environment variables BEFORE importing scientific packages
import os
os.environ['MKL_THREADING_LAYER'] = 'SEQUENTIAL'
os.environ['MKL_NUM_THREADS'] = '1'
os.environ['NUMEXPR_NUM_THREADS' ] = '1'
os.environ['OMP_NUM_THREADS'] = '1'
```

### 2. **tudat_setup.py**
Added at the very beginning (lines 1-7):
```python
# WINDOWS FIX: Set environment variables BEFORE importing scientific packages
import os
os.environ['MKL_THREADING_LAYER'] = 'SEQUENTIAL'
os.environ['MKL_NUM_THREADS'] = '1'
os.environ['NUMEXPR_NUM_THREADS'] = '1'
os.environ['OMP_NUM_THREADS'] = '1'
```

### 3. **ProcessPoolExecutor Fix**
Fixed an issue in main.py where too many worker processes were requested.
Changed line 196 from:
```python
max_workers = os.cpu_count()
```
To:
```python
max_workers = min(os.cpu_count() or 1, 4)  # Cap at 4 workers
```

## Running Your Code

### Option 1: Direct Python (with env variables set)
```powershell
$env:MKL_THREADING_LAYER="SEQUENTIAL"
$env:MKL_NUM_THREADS="1"
C:\Users\vpn\miniconda3\envs\tudat-space\python.exe main.py
```

### Option 2: Using PowerShell Script (RECOMMENDED)
```powershell
cd Power_SIM_2024\tudat_implementation
.\run_main.ps1
```

### Option 3: Using Batch File
```cmd
cd Power_SIM_2024\tudat_implementation
run_main.bat
```

## Verification

Run this command to verify all imports work:
```powershell
$env:MKL_THREADING_LAYER="SEQUENTIAL"
C:\Users\vpn\miniconda3\envs\tudat-space\python.exe c:\Users\vpn\Desktop\dvs-sims\verify_fix.py
```

## Key Points

⚠️ **CRITICAL**: Use `SEQUENTIAL`, not `GNU`
- GNU threading causes the fatal exception on Windows
- SEQUENTIAL disables threading but ensures stability on Windows
- Linux uses different libraries so it works there

✅ All imports now work on Windows:
- numpy ✓
- scipy ✓
- matplotlib ✓
- astropy ✓
- astropy.coordinates ✓ (this was the crash point)
- tudatpy ✓
- SPICE kernels ✓

## Files Modified
1. `Power_SIM_2024/tudat_implementation/main.py` - Added MKL fix + ProcessPoolExecutor fix
2. `Power_SIM_2024/tudat_implementation/tudat_setup.py` - Added MKL fix
3. `Power_SIM_2024/tudat_implementation/run_main.ps1` - Helper script (NEW)
4. `Power_SIM_2024/tudat_implementation/run_main.bat` - Helper script (NEW)
5. `verify_fix.py` - Verification script (NEW)

## Additional Notes

The application should now run successfully on Windows! The FutureWarning messages about deprecated tudatpy modules are harmless - they just indicate those modules will be updated in a future version.

If you experience any other issues, the root cause and solution are now documented in this file.

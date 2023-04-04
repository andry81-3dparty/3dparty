@echo off

setlocal

rem Directory prefix for repo output local path.
set "PREFIX_OUTPUT_DIR=%~1"
rem Directory prefix for repo input local path.
set "PREFIX_INPUT_DIR=%~2"

if not defined PREFIX_OUTPUT_DIR (
  set "PREFIX_OUTPUT_DIR=src"
  goto PREFIX_OUTPUT_DIR_END
) else set "PREFIX_OUTPUT_DIR=%PREFIX_OUTPUT_DIR:\=/%"

if defined PREFIX_OUTPUT_DIR if "%PREFIX_OUTPUT_DIR:~-1%" == "/" set "PREFIX_OUTPUT_DIR=%PREFIX_OUTPUT_DIR:~0,-1%"

:PREFIX_OUTPUT_DIR_END

if not defined PREFIX_INPUT_DIR (
  set "PREFIX_INPUT_DIR=_externals"
  goto PREFIX_INPUT_DIR_END
) else set "PREFIX_INPUT_DIR=%PREFIX_INPUT_DIR:\=/%"

if defined PREFIX_INPUT_DIR if "%PREFIX_INPUT_DIR:~-1%" == "/" set "PREFIX_INPUT_DIR=%PREFIX_INPUT_DIR:~0,-1%"

:PREFIX_INPUT_DIR_END

pushd "%~dp0..\%PREFIX_OUTPUT_DIR:/=\%" >nul && (
  call :MAIN %%*
  popd
)

exit /b

:MAIN
echo.repositories:
echo.

set IS_REPOSITORIES=0

for /F "usebackq eol=# tokens=* delims=" %%i in ("%~dp0..\.categories.lst") do (
  set "CATEGORY=%%i"
  call :PROCESS_CATEGORY
)

exit /b 0

:PROCESS_CATEGORY

if %IS_REPOSITORIES% NEQ 0 echo.
rem safe echo
setlocal ENABLEDELAYEDEXPANSION & for /F "eol= tokens=* delims=" %%i in ("!CATEGORY!") do endlocal & echo.  # %%i/
echo.

set IS_REPOSITORIES=0

set "CATEGORY=%CATEGORY:/=\%"
for /F "usebackq eol=# tokens=* delims=" %%i in (`dir /A:D /B /O:N "%CATEGORY%"`) do (
  set "LIBDIR=%%i"
  call :PROCESS_LIBDIR
)

exit /b 0

:PROCESS_LIBDIR
for /F "usebackq eol=# tokens=* delims=" %%i in (`dir /A:D /B /O:N "%CATEGORY%\%LIBDIR%"`) do (
  set "BRANCHDIR=%%i"
  call :PROCESS_BRANCHDIR
)

exit /b 0

:PROCESS_BRANCHDIR
if not exist "%CATEGORY%\%LIBDIR%\%BRANCHDIR%\.externals" exit /b 0

if %IS_REPOSITORIES% NEQ 0 echo.
rem safe echo
setlocal ENABLEDELAYEDEXPANSION & for /F "eol= tokens=* delims=" %%i in ("!LIBDIR!") do endlocal & echo.  ## %%i/
echo.

rem echo "%CATEGORY%\%LIBDIR%\%BRANCHDIR%\.externals"

set IS_REPOSITORIES=0
set IS_NEXT_EXTERNAL=0

for /F "usebackq eol=# tokens=* delims=" %%i in ("%CATEGORY%\%LIBDIR%\%BRANCHDIR%\.externals") do (
  set "EXTERNALS_FILE_LINE=%%i"
  call :PROCESS_EXTERNALS_FILE_LINE || exit /b
)

exit /b 0

:PROCESS_EXTERNALS_FILE_LINE
if not defined EXTERNALS_FILE_LINE exit /b 0

set "PARSED_FILE_LINE="
for /F "eol=# tokens=* delims=	 " %%i in ("%EXTERNALS_FILE_LINE%") do set "PARSED_FILE_LINE=%%i"

if not defined PARSED_FILE_LINE exit /b 0

if %IS_REPOSITORIES% EQU 0 (
  if "%EXTERNALS_FILE_LINE:~0,1%" == "%PARSED_FILE_LINE:~0,1%" if "%PARSED_FILE_LINE%" == "repositories:" (
    set IS_REPOSITORIES=1
    exit /b 0
  )
) else if "%EXTERNALS_FILE_LINE:~0,1%" == "%PARSED_FILE_LINE:~0,1%" if not "%PARSED_FILE_LINE%" == "repositories:" exit /b 1

rem filter context specific fields
if "%PARSED_FILE_LINE:~0,16%" == "fetch-to-branch:" exit /b 0

if %IS_REPOSITORIES% EQU 0 exit /b 0

if not "%PARSED_FILE_LINE:~0,11%" == "%PREFIX_INPUT_DIR%/" goto SKIP_REPO_LOCAL_PATH

call set "REPO_LOCAL_PATH_LINE=%%EXTERNALS_FILE_LINE:%PREFIX_INPUT_DIR%/=%PREFIX_OUTPUT_DIR%/%CATEGORY:\=/%/%LIBDIR:\=/%/%%"

if %IS_NEXT_EXTERNAL% NEQ 0 echo.
rem safe echo
setlocal ENABLEDELAYEDEXPANSION & for /F "eol= tokens=* delims=" %%i in ("!REPO_LOCAL_PATH_LINE!") do endlocal & echo.%%i

set IS_NEXT_EXTERNAL=1

exit /b 0

:SKIP_REPO_LOCAL_PATH

setlocal ENABLEDELAYEDEXPANSION & for /F "eol= tokens=* delims=" %%i in ("!EXTERNALS_FILE_LINE!") do endlocal & echo.%%i
exit /b

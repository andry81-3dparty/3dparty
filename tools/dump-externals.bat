@echo off

rem Description:
rem   Script to collect the `vcstool` externals lists into a single list using
rem   a categories list file as search directories.

rem Usage:
rem   dump-externals.bat <Flags> <Category-List-File> [<Prefix-Output-Dir> [<Suffix-Output-Dir>]]
rem
rem <Flags>:
rem   -D
rem     Script working directory.
rem   -no-branches
rem     Don't use and extract a `<branch>` subdirectory.
rem
rem <Category-List-File>:
rem   Path to category list file to start search from as directories list.
rem
rem <Prefix-Output-Dir>:
rem   Directory prefix for repo output local path.
rem   The `src` by default.
rem
rem <Prefix-Input-Dir>:
rem   Directory prefix for repo input local path.
rem   The `_externals` by default.

rem Examples:
rem   >
rem   dump-externals.bat -no-branches -D ../.. 3dparty\.categories.lst > .src.new

setlocal

rem script flags
set "FLAG_WORKING_DIR="
set FLAG_NO_BRANCHES=0

:FLAGS_LOOP

rem flags always at first
set "FLAG=%~1"

if defined FLAG ^
if not "%FLAG:~0,1%" == "-" set "FLAG="

if defined FLAG (
  if "%FLAG%" == "-D" (
    set "FLAG_WORKING_DIR=%~2"
    shift
  ) else if "%FLAG%" == "-no-branches" (
    set FLAG_NO_BRANCHES=1
  ) else (
    echo.%?~nx0%: error: invalid flag: %FLAG%
    exit /b -255
  ) >&2

  shift

  rem read until no flags
  goto FLAGS_LOOP
)

set "CATEGORIES_LIST_FILE=%~1"
set "PREFIX_OUTPUT_DIR=%~2"
set "PREFIX_INPUT_DIR=%~3"

if not defined CATEGORIES_LIST_FILE (
  echo.%~nx0: error: CATEGORIES_LIST_FILE is not defined.
  exit /b 1
) >&2

if defined FLAG_WORKING_DIR for /F "eol= tokens=* delims=" %%i in ("%FLAG_WORKING_DIR%") do set "FLAG_WORKING_DIR=%%~fi"

if "%CATEGORIES_LIST_FILE:~1,1%" == ":" (
  for /F "eol= tokens=* delims=" %%i in ("%CATEGORIES_LIST_FILE%") do set "CATEGORIES_LIST_FILE=%%~fi"
) else if defined FLAG_WORKING_DIR (
  for /F "eol= tokens=* delims=" %%i in ("%FLAG_WORKING_DIR%\%CATEGORIES_LIST_FILE%") do set "CATEGORIES_LIST_FILE=%%~fi"
) else for /F "eol= tokens=* delims=" %%i in ("%CATEGORIES_LIST_FILE%") do set "CATEGORIES_LIST_FILE=%%~fi"

if not exist "%CATEGORIES_LIST_FILE%" (
  echo.%~nx0: error: CATEGORIES_LIST_FILE does not exist: "%CATEGORIES_LIST_FILE%".
  exit /b 255
) >&2

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

if defined FLAG_WORKING_DIR (
  pushd "%FLAG_WORKING_DIR%" >nul && (
    call :MAIN %%*
    popd
  )
) else call :MAIN %%*

exit /b

:MAIN
echo.repositories:
echo.

set IS_REPOSITORIES=0

for /F "usebackq eol=# tokens=* delims=" %%i in ("%CATEGORIES_LIST_FILE%") do (
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
if %FLAG_NO_BRANCHES% NEQ 0 goto SKIP_PROCESS_BRANCHDIR

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

:SKIP_PROCESS_BRANCHDIR
if not exist "%CATEGORY%\%LIBDIR%\.externals" exit /b 0

if %IS_REPOSITORIES% NEQ 0 echo.
rem safe echo
setlocal ENABLEDELAYEDEXPANSION & for /F "eol= tokens=* delims=" %%i in ("!LIBDIR!") do endlocal & echo.  ## %%i/
echo.

rem echo "%CATEGORY%\%LIBDIR%\.externals"

set IS_REPOSITORIES=0
set IS_NEXT_EXTERNAL=0

for /F "usebackq eol=# tokens=* delims=" %%i in ("%CATEGORY%\%LIBDIR%\.externals") do (
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

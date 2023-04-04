@echo off

setlocal

call "%%~dp0__init__\__init__.bat" || exit /b

rem collect mingw/cygwin/msys paths from PATH variable

set "PREFIX_PATHS="
for /F "usebackq eol= tokens=* delims=" %%i in (`@"%COMSPEC%" /c "%CONTOOLS_ROOT%\std\echo_path_var.bat" PATH`) do (
  set "PATH_VALUE=%%i"
  call :CLEANUP_PATH_VAR
)

goto CLEANUP_PATH_VAR_END

:CLEANUP_PATH_VAR
if not defined PATH_VALUE exit /b 0

if ^%PATH_VALUE:~0,1%/ == ^"/ ^
if ^%PATH_VALUE:~-1%/ == ^"/ set "PATH_VALUE=%PATH_VALUE:~1,-1%"

set "PATH_VALUE=%PATH_VALUE:/=\%"

if "%PATH_VALUE%" == "%PATH_VALUE:\mingw=%" ^
if "%PATH_VALUE%" == "%PATH_VALUE:\cygwin=%" ^
if "%PATH_VALUE%" == "%PATH_VALUE:\msys=%" exit /b 0

rem safe set
setlocal ENABLEDELAYEDEXPANSION & for /F "eol= tokens=* delims=" %%i in ("!PATH_VALUE!") do (
  if defined PREFIX_PATHS (
    for /F "eol= tokens=* delims=" %%j in ("!PREFIX_PATHS!") do (
      endlocal
      set "PREFIX_PATHS=%%j;%%i"
    )
  ) else (
    endlocal
    set "PREFIX_PATHS=%%i"
  )
)

exit /b 0

:CLEANUP_PATH_VAR_END

rem reset PATH variable to defaults

if defined PREFIX_PATHS (
  rem safe set
  setlocal ENABLEDELAYEDEXPANSION & for /F "eol= tokens=* delims=" %%i in ("!PREFIX_PATHS!") do (
    endlocal
    set "PATH=%%i;%SYSTEMROOT%\system32;%SYSTEMROOT%;%SYSTEMROOT%\system32\Wbem"
  )
) else (
  set "PATH=%SYSTEMROOT%\system32;%SYSTEMROOT%;%SYSTEMROOT%\system32\Wbem"
)

if defined USER_PATH (
  rem safe set
  setlocal ENABLEDELAYEDEXPANSION & for /F "eol= tokens=* delims=" %%i in ("!PATH!") do (
    for /F "eol= tokens=* delims=" %%j in ("!USER_PATH!") do (
      endlocal
      set "PATH=%%i;%%j"
    )
  )
)

rem return variables
(
  rem safe set
  setlocal ENABLEDELAYEDEXPANSION & for /F "eol= tokens=* delims=" %%i in ("!PATH!") do (
    endlocal
    endlocal
    set "PATH=%%i"
  )
)

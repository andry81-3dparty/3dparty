@echo off

setlocal

call "%%~dp0..\__init__\__init__.bat" || exit /b

set "PATH=%SYSTEMROOT%\system32;%SYSTEMROOT%;%SYSTEMROOT%\system32\Wbem"

if not "%TOOLSET%" == "%TOOLSET:mingw_=%" ^
if defined MINGW_ROOT ^
if exist "%MINGW_ROOT%\" (
  rem safe update path variable
  setlocal ENABLEDELAYEDEXPANSION & for /F "eol= tokens=* delims=" %%i in ("!PATH!") do (
    endlocal
    set "PATH=%MINGW_ROOT%\bin;%%i"
  )
)

if not "%TOOLSET%" == "%TOOLSET:cygwin_=%" ^
if defined CYGWIN_ROOT ^
if exist "%CYGWIN_ROOT%\" (
  rem safe update path variable
  setlocal ENABLEDELAYEDEXPANSION & for /F "eol= tokens=* delims=" %%i in ("!PATH!") do (
    endlocal
    set "PATH=%CYGWIN_ROOT%\bin;%%i"
  )
)

if not "%TOOLSET%" == "%TOOLSET:msys_=%" ^
if defined MSYS_ROOT ^
if exist "%MSYS_ROOT%\" (
  rem safe update path variable
  setlocal ENABLEDELAYEDEXPANSION & for /F "eol= tokens=* delims=" %%i in ("!PATH!") do (
    endlocal
    set "PATH=%MSYS_ROOT%\bin;%%i"
  )
)

if "%TOOLSET%" == "%TOOLSET:msvc-=%" ^
if "%TOOLSET%" == "%TOOLSET:mingw_=%" ^
if "%TOOLSET%" == "%TOOLSET:cygwin_=%" goto IGNORE_PATH_UPDATE

if defined WINDOWS_SDK_ROOT ^
if exist "%WINDOWS_SDK_ROOT%\" (
  rem safe update path variable
  setlocal ENABLEDELAYEDEXPANSION & for /F "eol= tokens=* delims=" %%i in ("!PATH!") do (
    endlocal
    set "PATH=%WINDOWS_SDK_ROOT%\bin;%%i"
  )
)

if defined WINDOWS_KIT_BIN_ROOT ^
if exist "%WINDOWS_KIT_BIN_ROOT%\" (
  rem safe update path variable
  setlocal ENABLEDELAYEDEXPANSION & for /F "eol= tokens=* delims=" %%i in ("!PATH!") do (
    endlocal
    set "PATH=%WINDOWS_KIT_BIN_ROOT%\%MSVC_ARCHITECTURE%;%%i"
  )
)

:IGNORE_PATH_UPDATE

call "%%CONTOOLS_ROOT%%\std\echo_path_var.bat" PATH "PATH: `" `
echo.

rem return variables
(
  rem safe set
  setlocal ENABLEDELAYEDEXPANSION & for /F "eol= tokens=* delims=" %%i in ("!PATH!") do (
    endlocal
    endlocal
    set "PATH=%%i"
  )
)

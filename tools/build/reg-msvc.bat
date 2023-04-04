@echo off

setlocal

call "%%~dp0..\__init__\__init__.bat" || exit /b

if "%ADDRESS_MODEL%" == "64" (
  rem for vcvarsall.bat call
  set MSVC_ARCHITECTURE=amd64
  rem for devenv call
  set DEVENV_SOLUTION_PLATFORM=x64
) else (
  rem for vcvarsall.bat call
  set MSVC_ARCHITECTURE=x86
  rem for devenv call
  set DEVENV_SOLUTION_PLATFORM=Win32
)

rem return variables
(
  endlocal
  set "MSVC_ARCHITECTURE=%MSVC_ARCHITECTURE%"
  set "DEVENV_SOLUTION_PLATFORM=%DEVENV_SOLUTION_PLATFORM%"
)

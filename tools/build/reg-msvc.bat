@echo off

setlocal

call "%%~dp0..\__init__\__init__.bat" || exit /b

if "%ADDRESS_MODEL%" == "64" (
  rem for vcvarsall.bat call
  if not defined MSVC_ARCHITECTURE set MSVC_ARCHITECTURE=amd64
  rem for devenv call
  set DEVENV_SOLUTION_PLATFORM=x64
) else (
  rem for vcvarsall.bat call
  if not defined MSVC_ARCHITECTURE set MSVC_ARCHITECTURE=x86
  rem for devenv call
  set DEVENV_SOLUTION_PLATFORM=Win32
)

rem check msvc required variables
if "%TOOLSET%" == "msvc-14.0" (
  if not defined VS140COMNTOOLS (
    echo.%~nx0: error: VS140COMNTOOLS is not defined.
    exit /b 255
  ) >&2
) else if "%TOOLSET:~0,8%" == "msvc-14." (
  if not defined VS150COMNTOOLS (
    echo.%~nx0: error: VS150COMNTOOLS is not defined.
    exit /b 255
  ) >&2
) else (
  echo.%~nx0: error: Visual Studio version is not supported.
  exit /b 255
)

rem return variables
(
  endlocal
  set "MSVC_ARCHITECTURE=%MSVC_ARCHITECTURE%"
  set "DEVENV_SOLUTION_PLATFORM=%DEVENV_SOLUTION_PLATFORM%"
)

rem run vsvarsall.bat on exit
if "%TOOLSET%" == "msvc-14.0" (
  if not defined MSVC_VCVARSALL_CMDLINE (
    call "%%VS140COMNTOOLS%%\..\..\VC\vcvarsall.bat" %%MSVC_ARCHITECTURE%% -vcvars_ver=%%TOOLSET:msvc-=%% || exit /b
  ) else call "%%VS140COMNTOOLS%%\..\..\VC\vcvarsall.bat" %%MSVC_VCVARSALL_CMDLINE%% || exit /b
) else if "%TOOLSET:~0,8%" == "msvc-14." (
  if not defined MSVC_VCVARSALL_CMDLINE (
    call "%%VS150COMNTOOLS%%\..\..\VC\Auxiliary\Build\vcvarsall.bat" %%MSVC_ARCHITECTURE%% -vcvars_ver=%%TOOLSET:msvc-=%% || exit /b
  ) else call "%%VS150COMNTOOLS%%\..\..\VC\Auxiliary\Build\vcvarsall.bat" %%MSVC_VCVARSALL_CMDLINE%% || exit /b
)

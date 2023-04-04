@echo off

if /i "%_3DPARTY_PROJECT_ROOT_INIT0_DIR%" == "%~dp0" exit /b 0

call "%%~dp0__init__\__init__.bat" || exit /b

set "_3DPARTY_PROJECT_ROOT_INIT0_DIR=%~dp0"

for %%i in (_3DPARTY_BUILD_SOURCES_ROOT _3DPARTY_BUILD_OUTPUT_ROOT) do (
  if not defined %%i (
    echo.%~nx0: error: `%%i` variable is not defined.
    exit /b 255
  ) >&2
)

set "_3DPARTY_PROJECT_ROOT=%_3DPARTY_PROJECT_ROOT:\=/%"

rem if "%PATH:~-1%" == ";" set "PATH=%PATH:~0,-1%"

set DEV_COMPILER_DIR=unknown
set DEV_COMPILER=unknown

if not "%TOOLSET%" == "%TOOLSET:mingw_=%" (
  if not "%TOOLSET%" == "%TOOLSET:_gcc=%" (
    set DEV_COMPILER=mingw_gcc
    set DEV_COMPILER_DIR=mingw/gcc
  )
) else if not "%TOOLSET%" == "%TOOLSET:cygwin_=%" (
  if not "%TOOLSET%" == "%TOOLSET:_gcc=%" (
    set DEV_COMPILER=cygwin_gcc
    set DEV_COMPILER_DIR=cygwin/gcc
  )
) else if not "%TOOLSET%" == "%TOOLSET:msys_=%" (
  if not "%TOOLSET%" == "%TOOLSET:_gcc=%" (
    set DEV_COMPILER=msys_gcc
    set DEV_COMPILER_DIR=msys/gcc
  )
) else if "%TOOLSET%" == "msvc-14.2" (
  set DEV_COMPILER=vc2019
  set DEV_COMPILER_DIR=msvc/vc2019
) else if "%TOOLSET%" == "msvc-14.1" (
  set DEV_COMPILER=vc2017
  set DEV_COMPILER_DIR=msvc/vc2017
) else if "%TOOLSET%" == "msvc-14.0" (
  set DEV_COMPILER=vc14
  set DEV_COMPILER_DIR=msvc/vc14
) else if "%TOOLSET%" == "msvc-12.0" (
  set DEV_COMPILER=vc12
  set DEV_COMPILER_DIR=msvc/vc12
) else if "%TOOLSET%" == "msvc-10.0" (
  set DEV_COMPILER=vc10
  set DEV_COMPILER_DIR=msvc/vc10
) else (
  echo.%~nx0: error: TOOLSET registration is not supported: "%TOOLSET%".
  exit /b 255
) >&2

if %ADDRESS_MODEL% == 32 (
  set DEV_COMPILER_DIR=%DEV_COMPILER_DIR%/x86
) else (
  set DEV_COMPILER_DIR=%DEV_COMPILER_DIR%/x%ADDRESS_MODEL%
)

set "BUILD_SOURCES_ROOT=%_3DPARTY_BUILD_SOURCES_ROOT%/%BUILD_SOURCES_CATEGORY%/%BUILD_BASE_DIR%/%BUILD_SOURCES_DIR%"
set "BUILD_SOURCES_ROOT=%BUILD_SOURCES_ROOT:\=/%"

set "BUILD_OUTPUT_ROOT=%_3DPARTY_BUILD_OUTPUT_ROOT%/%DEV_COMPILER_DIR%/%BUILD_SOURCES_CATEGORY%/%BUILD_BASE_DIR%/%BUILD_OUTPUT_DIR%"
set "BUILD_OUTPUT_ROOT=%BUILD_OUTPUT_ROOT:\=/%"

echo.BUILD_SOURCES_ROOT:  "%BUILD_SOURCES_ROOT%"
echo.BUILD_OUTPUT_ROOT:   "%BUILD_OUTPUT_ROOT%"
echo.

call "%%_3DPARTY_TOOLS%%\build\reg-msvc.bat" || exit /b
call "%%_3DPARTY_TOOLS%%\build\reg-jam.bat" || exit /b
call "%%_3DPARTY_TOOLS%%\build\reg-cmake.bat" || exit /b
call "%%_3DPARTY_TOOLS%%\build\reg-qmake.bat" || exit /b
call "%%_3DPARTY_TOOLS%%\build\gen-path-var.bat" || exit /b

if not exist "%BUILD_SOURCES_ROOT%\" (
  echo.%~nx0: error: BUILD_SOURCES_ROOT does not exist: "%BUILD_SOURCES_ROOT%".
  exit /b 255
) >&2

if not exist "%BUILD_OUTPUT_ROOT%\" mkdir "%BUILD_OUTPUT_ROOT%" || exit /b

exit /b 0

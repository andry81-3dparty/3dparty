@echo off

setlocal

call "%%~dp0..\__init__\__init__.bat" || exit /b

rem ### QT/QMAKE ###

rem Qt beginning from version 5.9.0 has changed the generator toolset naming, so we have to test the QT version to select platform correctly

if not defined QMAKE_BIN_PATH goto IGNORE_QMAKE_GENERATOR_VERSION_SELECT

set "QMAKE_EXECUTABLE_PATH=%QMAKE_BIN_PATH%/qmake.exe"

if not exist "%QMAKE_EXECUTABLE_PATH%" goto IGNORE_QMAKE_GENERATOR_VERSION_SELECT

:PARSE_QMAKE_VERSION
echo.Found qmake.exe: "%QMAKE_EXECUTABLE_PATH%"
echo.

for /F "usebackq tokens=* delims=" %%i in (`%QMAKE_EXECUTABLE_PATH% --version`) do (
  set "QMAKE_VERSION_LINE=%%i"
  call :PARSE_QMAKE_VERSION_LINE
)

goto SELECT_MAKE_GENERATORS

:PARSE_QMAKE_VERSION_LINE
if not "%QMAKE_VERSION_LINE:~0,16%" == "Using Qt version" exit /b 0

for /F "tokens=1,* delims= " %%i in ("%QMAKE_VERSION_LINE:~17%") do (
  set "QT_VERSION=%%i"
)

exit /b 0

:SELECT_MAKE_GENERATORS

if not defined QT_VERSION goto IGNORE_QMAKE_GENERATOR_VERSION_SELECT

for /F "tokens=1,2,* delims=." %%i in ("%QT_VERSION%") do (
  set "QT_VERSION_MAJOR=%%i"
  set "QT_VERSION_MINOR=%%j"
  set "QT_VERSION_PATCH=%%k"
)

if not defined QT_VERSION_MAJOR goto IGNORE_QMAKE_GENERATOR_VERSION_SELECT
if not defined QT_VERSION_MINOR goto IGNORE_QMAKE_GENERATOR_VERSION_SELECT

if %QT_VERSION_MAJOR% GTR 5 goto IGNORE_QMAKE_GENERATOR_VERSION_SELECT
if %QT_VERSION_MAJOR% GEQ 5 if %QT_VERSION_MINOR% GEQ 9 goto IGNORE_QMAKE_GENERATOR_VERSION_SELECT

set "QMAKE_GENERATOR_TOOLSET=unknown"
if not "%TOOLSET%" == "%TOOLSET:mingw_=%" (
  if not "%TOOLSET%" == "%TOOLSET:_gcc=%" (
    set "QMAKE_GENERATOR_TOOLSET=g++"
  )
) else if not "%TOOLSET%" == "%TOOLSET:cygwin_=%" (
  if not "%TOOLSET%" == "%TOOLSET:_gcc=%" (
    set "QMAKE_GENERATOR_TOOLSET=g++"
  )
) else if "%TOOLSET%" == "msvc-14.1" (
  set "QMAKE_GENERATOR_TOOLSET=msvc2017"
) else if "%TOOLSET%" == "msvc-14.0" (
  set "QMAKE_GENERATOR_TOOLSET=msvc2015"
) else if "%TOOLSET%" == "msvc-12.0" (
  set "QMAKE_GENERATOR_TOOLSET=msvc2012"
) else if "%TOOLSET%" == "msvc-10.0" (
  set "QMAKE_GENERATOR_TOOLSET=msvc2010"
)

goto QMAKE_GENERATOR_VERSION_SELECT_END

:IGNORE_QMAKE_GENERATOR_VERSION_SELECT

set "QMAKE_GENERATOR_TOOLSET=unknown"
if not "%TOOLSET%" == "%TOOLSET:mingw_=%" (
  if not "%TOOLSET%" == "%TOOLSET:_gcc=%" (
    set "QMAKE_GENERATOR_TOOLSET=g++"
  )
) else if not "%TOOLSET%" == "%TOOLSET:cygwin_=%" (
  if not "%TOOLSET%" == "%TOOLSET:_gcc=%" (
    set "QMAKE_GENERATOR_TOOLSET=g++"
  )
) else if not "%TOOLSET%" == "%TOOLSET:msvc-=%" (
  set "QMAKE_GENERATOR_TOOLSET=msvc"
)

:QMAKE_GENERATOR_VERSION_SELECT_END

if not "%TOOLSET%" == "%TOOLSET:mingw_=%" (
  if "%ADDRESS_MODEL%" == "64" set "QMAKE_GENERATOR_TOOLSET=win64-g++"
  if "%ADDRESS_MODEL%" == "32" set "QMAKE_GENERATOR_TOOLSET=win32-g++"
) else if not "%TOOLSET%" == "%TOOLSET:cygwin_=%" (
  if "%ADDRESS_MODEL%" == "64" set "QMAKE_GENERATOR_TOOLSET=win64-g++"
  if "%ADDRESS_MODEL%" == "32" set "QMAKE_GENERATOR_TOOLSET=win32-g++"
) else if not "%TOOLSET%" == "%TOOLSET:msvc-=%" (
  if "%ADDRESS_MODEL%" == "64" set "QMAKE_GENERATOR_TOOLSET=win64-%QMAKE_GENERATOR_TOOLSET%"
  if "%ADDRESS_MODEL%" == "32" set "QMAKE_GENERATOR_TOOLSET=win32-%QMAKE_GENERATOR_TOOLSET%"
)

rem return variables
(
  endlocal
  set "QMAKE_GENERATOR_TOOLSET=%QMAKE_GENERATOR_TOOLSET%"
)

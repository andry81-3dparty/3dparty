@echo off

setlocal

call "%%~dp0..\__init__\__init__.bat" || exit /b

if "%TOOLSET%" == "msvc-14.1" (
  set "CMAKE_GENERATOR=Visual Studio 15 2017"
) else if "%TOOLSET%" == "msvc-14.0" (
  set "CMAKE_GENERATOR=Visual Studio 14 2015"
) else if "%TOOLSET%" == "msvc-12.0" (
  set "CMAKE_GENERATOR=Visual Studio 12 2013"
) else if "%TOOLSET%" == "msvc-10.0" (
  set "CMAKE_GENERATOR=Visual Studio 10 2010"
) else (
  set "CMAKE_GENERATOR=unknown"
)

if not "%CMAKE_GENERATOR%" == "unknown" (
  if "%ADDRESS_MODEL%" == "64" set "CMAKE_GENERATOR=%CMAKE_GENERATOR% Win64"
)

rem return variables
(
  endlocal
  set "CMAKE_GENERATOR=%CMAKE_GENERATOR%"
)

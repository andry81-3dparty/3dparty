@echo off

setlocal

call "%%~dp0..\__init__\__init__.bat" || exit /b

set JAM_TOOLSET=%TOOLSET%

if not "%TOOLSET%" == "%TOOLSET:mingw_=%" (
  if not "%TOOLSET%" == "%TOOLSET:_gcc=%" (
    set JAM_TOOLSET=gcc
  )
) else if not "%TOOLSET%" == "%TOOLSET:cygwin_=%" (
  if not "%TOOLSET%" == "%TOOLSET:_gcc=%" (
    set JAM_TOOLSET=gcc
  )
) else if not "%TOOLSET%" == "%TOOLSET:msys_=%" (
  if not "%TOOLSET%" == "%TOOLSET:_gcc=%" (
    set JAM_TOOLSET=gcc
  )
)

rem return variables
(
  endlocal
  set "JAM_TOOLSET=%JAM_TOOLSET%"
)

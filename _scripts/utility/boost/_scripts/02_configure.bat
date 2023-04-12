@echo off

setlocal

call "%%~dp0..\__init__\__init__.bat" || exit /b

call "%%_3DPARTY_PROJECT_ROOT%%/__init__/declare_builtins.bat" %%0 %%*

call "%%_3DPARTY_PROJECT_ROOT%%/_scripts/.common/exec_user_prefix.bat" || exit /b
if %IMPL_MODE%0 EQU 0 exit /b

call "%%_3DPARTY_TOOLS%%/reg-env.bat" || exit /b

rem register all environment variables
set 2>nul > "%INIT_VARS_FILE1%"

call :CMD pushd "%%BUILD_OUTPUT_ROOT%%" && (
  if not exist "%%BUILD_OUTPUT_ROOT%%/b2.exe" (
    call :CMD "%%BUILD_OUTPUT_ROOT%%/bootstrap.bat" || exit /b
  )
  call :CMD popd
)

exit /b

:CMD
echo.^>%*
(
  %*
)
exit /b

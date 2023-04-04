@echo off

setlocal

for %%i in (CONTOOLS_ROOT CONTOOLS_UTILITIES_BIN_ROOT) do (
  if not defined %%i (
    echo.%~nx0: error: `%%i` variable is not defined.
    exit /b 255
  ) >&2
)

if %IMPL_MODE%0 NEQ 0 goto IMPL

call "%%CONTOOLS_ROOT%%/build/init_project_log.bat" "%%?~n0%%" || exit /b

set "INIT_VARS_FILE=%PROJECT_LOG_DIR%\init.vars"

rem register all environment variables
set 2>nul > "%INIT_VARS_FILE%"

"%CONTOOLS_UTILITIES_BIN_ROOT%/contools/callf.exe" ^
  /promote{ /ret-child-exit } /promote-parent{ /pause-on-exit /tee-stdout "%PROJECT_LOG_FILE%" /tee-stderr-dup 1 } ^
  /elevate{ /no-window /create-inbound-server-pipe-to-stdout 3dparty_stdout_{pid} /create-inbound-server-pipe-to-stderr 3dparty_stderr_{pid} ^
  }{ /attach-parent-console /reopen-stdout-as-client-pipe 3dparty_stdout_{ppid} /reopen-stderr-as-client-pipe 3dparty_stderr_{ppid} } ^
  /no-expand-env /no-subst-pos-vars /pipe-out-child ^
  /v IMPL_MODE 1 /v INIT_VARS_FILE "%INIT_VARS_FILE%" ^
  /ra "%%" "%%?01%%" /v "?01" "%%" ^
  "%COMSPEC%" "/c \"@\"%?~f0%\" {*}\"" %* || exit /b
exit /b 0

:IMPL
call "%%CONTOOLS_ROOT%%/std/get_cmdline.bat" %%?0%% %%*
call "%%CONTOOLS_ROOT%%/std/echo_var.bat" RETURN_VALUE ">"
echo.

rem check for true elevated environment (required in case of Windows XP)
"%SystemRoot%\System32\net.exe" session >nul 2>nul || (
  echo.%?~nx0%: error: the script process is not properly elevated up to Administrator privileges.
  exit /b 255
) >&2

rem load initialization environment variables
rem if defined INIT_VARS_FILE for /F "usebackq eol=# tokens=1,* delims==" %%i in ("%INIT_VARS_FILE%") do set "%%i=%%j"

exit /b 0

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

set "INIT_VARS_FILE0=%PROJECT_LOG_DIR%\init.0.vars"
set "INIT_VARS_FILE1=%PROJECT_LOG_DIR%\init.1.vars"

rem register all environment variables
set 2>nul > "%INIT_VARS_FILE0%"

"%CONTOOLS_UTILITIES_BIN_ROOT%/contools/callf.exe" ^
  /attach-parent-console /ret-child-exit /pause-on-exit /no-expand-env /no-subst-pos-vars ^
  /tee-stdout "%PROJECT_LOG_FILE%" /tee-stderr-dup 1 ^
  /v IMPL_MODE 1 /v INIT_VARS_FILE0 "%INIT_VARS_FILE0%" /v INIT_VARS_FILE1 "%INIT_VARS_FILE1%" ^
  /ra "%%" "%%?01%%" /v "?01" "%%" ^
  "%COMSPEC%" "/c \"@\"%?~f0%\" {*}\"" %* || exit /b
exit /b 0

:IMPL
rem set /A NEST_LVL+=1
rem 
rem if %NEST_LVL% EQU 1 (
rem   rem load initialization environment variables
rem   if defined INIT_VARS_FILE0 for /F "usebackq eol=# tokens=1,* delims==" %%i in ("%INIT_VARS_FILE0%") do if /i not "%%i" == "NEST_LVL" set "%%i=%%j"
rem )

call "%%CONTOOLS_ROOT%%/std/get_cmdline.bat" %%?0%% %%*
call "%%CONTOOLS_ROOT%%/std/echo_var.bat" RETURN_VALUE ">"
echo.

exit /b 0

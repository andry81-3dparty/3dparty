@echo off

setlocal

call "%%~dp0..\__init__\__init__.bat" || exit /b

call "%%_3DPARTY_PROJECT_ROOT%%/__init__/declare_builtins.bat" %%0 %%*

call "%%_3DPARTY_PROJECT_ROOT%%/_scripts/.common/exec_admin_prefix.bat" || exit /b
if %IMPL_MODE%0 EQU 0 exit /b

call "%%CONTOOLS_ROOT%%/std/allocate_temp_dir.bat" . "%%?~n0%%" || (
  echo.%?~nx0%: error: could not allocate temporary directory: "%SCRIPT_TEMP_CURRENT_DIR%"
  set LASTERROR=255
  goto FREE_TEMP_DIR
) >&2

call :MAIN %%*
set LASTERROR=%ERRORLEVEL%

:FREE_TEMP_DIR
rem cleanup temporary files
call "%%CONTOOLS_ROOT%%/std/free_temp_dir.bat"

exit /b %LASTERROR%

:MAIN
set "EMPTY_DIR_TMP=%SCRIPT_TEMP_CURRENT_DIR%\emptydir"

call "%%_3DPARTY_TOOLS%%/reg-env.bat" || exit /b

rem register all environment variables
set 2>nul > "%INIT_VARS_FILE1%"

call :CREATE_DIR_LINK "%%BUILD_OUTPUT_ROOT%%\boost"                 "%%BUILD_SOURCES_ROOT%%\boost" || exit /b
call :CREATE_DIR_LINK "%%BUILD_OUTPUT_ROOT%%\libs"                  "%%BUILD_SOURCES_ROOT%%\libs" || exit /b
call :CREATE_DIR_LINK "%%BUILD_OUTPUT_ROOT%%\tools"                 "%%BUILD_SOURCES_ROOT%%\tools" || exit /b

call :CREATE_FILE_LINK "%%BUILD_OUTPUT_ROOT%%\bootstrap.bat"        "%%BUILD_SOURCES_ROOT%%\bootstrap.bat" || exit /b
call :CREATE_FILE_LINK "%%BUILD_OUTPUT_ROOT%%\boost-build.jam"      "%%BUILD_SOURCES_ROOT%%\boost-build.jam" || exit /b
call :CREATE_FILE_LINK "%%BUILD_OUTPUT_ROOT%%\boostcpp.jam"         "%%BUILD_SOURCES_ROOT%%\boostcpp.jam" || exit /b

call :CREATE_FILE_LINK "%%BUILD_OUTPUT_ROOT%%\Jamroot"              "%%BUILD_SOURCES_ROOT%%\Jamroot" || exit /b
call :CREATE_FILE_LINK "%%BUILD_OUTPUT_ROOT%%\project-config.jam"   "%%BUILD_SOURCES_ROOT%%\project-config.jam" || exit /b

rem call :XCOPY_DIR "%%BUILD_SOURCES_ROOT%%/msvc14" "%%BUILD_OUTPUT_ROOT%%/msvc14" /S /Y /D || exit /b

rem call :XCOPY_FILE "<from>" "<file>" "<to>" /Y /D /H || exit /b
rem call :XCOPY_DIR "<from>" "<to>" /S /Y /D || exit /b

exit /b

:CREATE_DIR_LINK
set "MKLINK_CMD=mklink /D"
call :MKLINK %%*
exit /b

:CREATE_FILE_LINK
set "MKLINK_CMD=mklink"
call :MKLINK %%*
exit /b

:XCOPY_FILE
if not exist "\\?\%~f3" (
  echo.^>mkdir "%~3"
  call :MAKE_DIR "%%~3" || (
    echo.%?~nx0%: error: could not create a target file directory: "%~3".
    exit /b 255
  ) >&2
  echo.
)
call "%%CONTOOLS_ROOT%%/std/xcopy_file.bat" %%*
exit /b

:XCOPY_DIR
if not exist "\\?\%~f2" (
  echo.^>mkdir "%~2"
  call :MAKE_DIR "%%~2" || (
    echo.%?~nx0%: error: could not create a target directory: "%~2".
    exit /b 255
  ) >&2
  echo.
)
call "%%CONTOOLS_ROOT%%/std/xcopy_dir.bat" %%*
exit /b

:MAKE_DIR
for /F "eol= tokens=* delims=" %%i in ("%~1\.") do set "FILE_PATH=%%~fi"

mkdir "%FILE_PATH%" 2>nul || if exist "%SystemRoot%\System32\robocopy.exe" ( "%SystemRoot%\System32\robocopy.exe" /CREATE "%EMPTY_DIR_TMP%" "%FILE_PATH%" >nul ) else type 2>nul || (
  echo.%?~nx0%: error: could not create a target file directory: "%FILE_PATH%".
  exit /b 255
) >&2
exit /b

:MKLINK
set "LINK_FROM=%~f1"
set "LINK_TO=%~f2"

if exist "%LINK_FROM%" exit /b 0

call :CMD %%MKLINK_CMD%% "%%LINK_FROM%%" "%%LINK_TO%%"
if exist "%LINK_FROM%" (
  echo."%LINK_FROM%" -^> "%LINK_TO%"
) else (
  echo.%~nx0%: error: could not create link: "%LINK_FROM%" -^> "%LINK_TO%"
  exit /b 255
) >&2

exit /b 0

:CMD
echo.^>%*
(
  %*
)
exit /b

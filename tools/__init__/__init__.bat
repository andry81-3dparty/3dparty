@echo off

if defined _3DPARTY_PROJECT_ROOT_INIT0_DIR if exist "%_3DPARTY_PROJECT_ROOT_INIT0_DIR%\" exit /b 0

call "%%~dp0..\..\__init__\__init__.bat" || exit /b

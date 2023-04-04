@echo off

if defined _3DPARTY_PROJECT_BOOST_INIT0_DIR if exist "%_3DPARTY_PROJECT_BOOST_INIT0_DIR%\" exit /b 0

call "%%~dp0..\..\..\__init__\__init__.bat" || exit /b

set "_3DPARTY_PROJECT_BOOST_INIT0_DIR=%~dp0"

rem basic set of system variables
if not defined _3DPARTY_PROJECT_BOOST_INPUT_CONFIG_ROOT                 call "%%CONTOOLS_ROOT%%/std/canonical_path.bat" _3DPARTY_PROJECT_BOOST_INPUT_CONFIG_ROOT   "%%_3DPARTY_PROJECT_ROOT%%/_config/src/utility/boost"
if not defined _3DPARTY_PROJECT_BOOST_OUTPUT_CONFIG_ROOT                call "%%CONTOOLS_ROOT%%/std/canonical_path.bat" _3DPARTY_PROJECT_BOOST_OUTPUT_CONFIG_ROOT  "%%_3DPARTY_PROJECT_OUTPUT_CONFIG_ROOT%%/src/utility/boost"

if not exist "%_3DPARTY_PROJECT_BOOST_OUTPUT_CONFIG_ROOT%\" ( mkdir "%_3DPARTY_PROJECT_BOOST_OUTPUT_CONFIG_ROOT%" || exit /b 10 )

call "%%CONTOOLS_ROOT%%/build/load_config_dir.bat" %%* -lite_parse -gen_user_config "%%_3DPARTY_PROJECT_BOOST_INPUT_CONFIG_ROOT%%" "%%_3DPARTY_PROJECT_BOOST_OUTPUT_CONFIG_ROOT%%" || exit /b

exit /b 0

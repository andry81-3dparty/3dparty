* README_EN.txt
* boost

1. DESCRIPTION
2. CONFIGURE
3. BUILD
4. CLEANUP

-------------------------------------------------------------------------------
1. DESCRIPTION
-------------------------------------------------------------------------------
Build scripts for the `boost` libraries.

-------------------------------------------------------------------------------
2. CONFIGURE
-------------------------------------------------------------------------------

NOTE:
  Read at first the `USAGE` section from the root `README_EN.txt` before run
  the steps from here.

1. run `_scripts/01_preconfigure.bat`

  NOTE:
    To begin edit the following configuration files you can just run
    `__init__/__init__.bat` script.

2. edit configuration files:

  * `<root>/_out/config/3dparty/config.*.vars`
  * `<root>/_out/config/3dparty/src/utility/boost/config.*.vars`

  NOTE:
    If previous `_scripts/01_preconfigure.bat` has exited with error, then run
    again.

3. run `_scripts/02_configure.bat`

  NOTE:
    You can directly run `bootstrap.bat` from directory in the
    `BUILD_OUTPUT_ROOT` variable.

  NOTE:
    To reconfigure remove `%BUILD_SOURCES_ROOT%\b2.exe` file.

-------------------------------------------------------------------------------
3. BUILD
-------------------------------------------------------------------------------

1. run `_scripts/03_build.bat`

-------------------------------------------------------------------------------
4. CLEANUP
-------------------------------------------------------------------------------

1. Remove respective subdirectory from the `BUILD_OUTPUT_ROOT`
   variable or remove entire `_out` directory.

2. Reset directory from the `BUILD_SOURCES_ROOT` variable.

NOTE:
  Search variables in the `.log` directory in `init.*.vars` files.

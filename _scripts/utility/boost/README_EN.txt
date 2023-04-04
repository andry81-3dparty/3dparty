* README_EN.txt
* boost

1. DESCRIPTION
3. CONFIGURE
4. BUILD
5. CLEANUP

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

2. edit `<root>/_out/config/3dparty/config.*.vars`:

3. edit `<root>/_out/config/3dparty/src/utility/boost/config.*.vars`

4. If previous `_scripts/01_preconfigure.bat` has exited with error, then run
   again.

5. run `bootstrap.bat` from the BUILD_OUTPUT_ROOT directory

-------------------------------------------------------------------------------
3. BUILD
-------------------------------------------------------------------------------

1. run `_scripts/02_build.bat`

-------------------------------------------------------------------------------
4. CLEANUP
-------------------------------------------------------------------------------
Remove respective subdirectory from the `_3DPARTY_BUILD_OUTPUT_ROOT` variable.

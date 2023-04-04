* README_EN.txt
* 2023.04.04
* 3dparty

1. DESCRIPTION
2. REPOSITORIES
3. CATALOG CONTENT DESCRIPTION
4. PREREQUISITES
5. DEPENDENCIES
6. EXTERNALS
7. USAGE
8. AUTHOR

-------------------------------------------------------------------------------
1. DESCRIPTION
-------------------------------------------------------------------------------
3dparty libraries with build scripts.

-------------------------------------------------------------------------------
2. REPOSITORIES
-------------------------------------------------------------------------------
Primary:
  * https://github.com/andry81-3dparty/3dparty/branches
  * https://github.com/andry81-3dparty/3dparty.git
First mirror:
  * https://sf.net/p/andry81-3dparty/3dparty/HEAD/tree
  * https://git.code.sf.net/p/andry81-3dparty/3dparty
Second mirror:
  * https://bitbucket.org/andry81/3dparty/branches
  * https://bitbucket.org/andry81/3dparty.git

-------------------------------------------------------------------------------
3. CATALOG CONTENT DESCRIPTION
-------------------------------------------------------------------------------

The `_3DPARTY_BUILD_SOURCES_ROOT` and `_3DPARTY_BUILD_OUTPUT_ROOT` variables
from the `config.0.vars` configuration file must point to the build sources
directory and to the build output directory respectively.

<root>
 |
 +- /`_config`
 |  | #
 |  | # Directory with build input configuration files.
 |  |
 |  +- /`cmake`
 |  |  | #
 |  |  | # Directory with cmake build input configuration files.
 |  |  |
 |  |  +- `config.0.vars.in`
 |  |      #
 |  |      # Configuration file for all libraries as an EXAMPLE (does not load
 |  |      # actually).
 |  |      #
 |  |      # Is used to accumulate all library variables and should be used to
 |  |      # build your own target project cmake configuration file which has
 |  |      # particular dependent libraries.
 |  |      #
 |  |      # NOTE:
 |  |      #   The configuration file loads by cmake script from the
 |  |      #   `tacklelib` library.
 |  |
 |  +- /`src`
 |       #
 |       # Directory with build input configuration files specific for each
 |       # library.
 |
 +- /`_externals`
 |    #
 |    # Directory with external dependencies.
 |
 +- /`_out`
 |  | #
 |  | # Temporary directory with build output.
 |  |
 |  +- /`config`
 |  |    #
 |  |    # Directory with build output configuration files.
 |  |
 +  +- /`build`
 |     | #
 |     | # Directory with build output
 |     | # Pointed by `_3DPARTY_BUILD_OUTPUT_ROOT` variable.
 |     |
 |     +- /`<platform>`
 |        | #
 |        | # Platform generic name.
 |        |
 |        +- /`<compiler>`
 |           | #
 |           | # Compiler generic name.
 |           |
 |           +- /`<arch>`
 |              | #
 |              | # Architecture generic name.
 |              |
 |              +- /`<category>`
 |                 | #
 |                 | # Sources category variant.
 |                 |
 |                 +- /`<library>`
 |                    | #
 |                    | # Library generic name.
 |                    |
 |                    +- /`<branch>`
 |                         #
 |                         # Particular library branch name.
 |
 +- /`_scripts`
 |    #
 |    # Projects with build scripts.
 |
 +- /`src`
 |  | #
 |  | # Directory with build sources.
 |  | # Pointed by `_3DPARTY_BUILD_SOURCES_ROOT` variable.
 |  |
 |  +- /`<category>`
 |     | #
 |     | # Sources category variant.
 |     |
 |     +- /`<library>`
 |        | #
 |        | # Library generic name.
 |        |
 |        +- /`<branch>`
 |             #
 |             # Particular library branch name.
 |
 +- /`tools`
 |  | #
 |  | # Directory with tool scripts.
 |  |
 |  +- `dump-externals.bat`
 |      #
 |      # Reads the `/src` directory using the predefined hierarchy to
 |      # print all found `.externals` files as a single file.
 |      # Additionally the script by default replaces all local relative paths
 |      # from `_externals/` to `src/<category>/<library>/`.
 |      # It is used to update the `.src` file from the `.externals` file in
 |      # each library repository.
 |      #
 |
 +- `.src`
     #
     # All library urls and branches to checkout altogether into the `/src`
     # directory.

, where:

  * <category>:

    * `app`     - application bundles
    * `arc`     - archiving libraries
    * `gui`     - UI libraries
    * `log`     - logging libraries
    * `math`    - mathematical libraries
    * `net`     - network libraries
    * `sat`     - satellite libraries
    * `test`    - testing libraries
    * `utility` - utility libraries
    * `xml`     - xml libraries
    * `yaml`    - yaml libraries

  * <platform>:

    * `msvc`    - Microsoft Visual Studio platform
    * `cygwin`  - Cygwin
    * `msys`    - Msys
    * `mingw`   - Mingw

  * <compiler>:

    * `vc10`    - Microsoft Visual Studio 2010
    * `vc11`    - Microsoft Visual Studio 2011
    * `vc12`    - Microsoft Visual Studio 2012
    * `vc14`    - Microsoft Visual Studio 2015
    * `vc2017`  - Microsoft Visual Studio 2017
    * `vc2019`  - Microsoft Visual Studio 2019

  * <arch>:

    * `x86`
    * `x64`

Example:

<root>
  /src
    /arc
      /libarchive
        /3_4_1_release
      /xzutils
        /5_2_4_release
      /zlib
        /1_2_11_release
    /utility
      /boost
        /1_72_0_release
  /_out
    /build
      /msvc
        /vc2017
          /x86
            /arc
              /libarchive
                /3_4_1_release
              /xzutils
                /5_2_4_release
              /zlib
                /1_2_11_release
            /utility
              /boost
                /1_72_0_release

-------------------------------------------------------------------------------
4. PREREQUISITES
-------------------------------------------------------------------------------

Currently used these set of OS platforms, externals, compilers, IDE's and
patches to run with or from:

1. OS platforms:

  * Windows 7+ (MSVC/GCC targets, minimal version for the cmake 3.14)

  * Cygwin 1.5+ or 3.0+ (GCC target):
    https://cygwin.com
    - to run scripts under cygwin

  * Msys2 20190524+ (GCC target):
    https://www.msys2.org
    - to run scripts under msys2

  * Linux Mint 18.3 x64 (GCC target)

2. Externals:

  * `contools`

3. C++11 compilers:

  * (primary) Microsoft Visual C++ 2015 Update 3 or Microsoft Visual C++ 2017
  * (secondary) GCC 5.4+

4. IDE's:

  * Microsoft Visual Studio 2015 Update 3
  * Microsoft Visual Studio 2017

5. Patches:

  Target repository with a 3dparty component sources must already contain all
  patches and description with it.

-------------------------------------------------------------------------------
5. DEPENDENCIES
-------------------------------------------------------------------------------

Any project which is dependent on this project have has to contain the
`README_EN.deps.txt` description file for the common dependencies in the
Windows and in the Linux like platforms.

-------------------------------------------------------------------------------
6. EXTERNALS
-------------------------------------------------------------------------------
To checkout externals you must use the
[vcstool](https://github.com/dirk-thomas/vcstool) python module.

NOTE:
  To install the module from the git repository:

  >
  python -m pip install git+https://github.com/dirk-thomas/vcstool

-------------------------------------------------------------------------------
7. USAGE
-------------------------------------------------------------------------------

1. Put `<root>` directory closer to the drive root to avoid a long paths issue
   (260+ characters).

2. Install `vcstool` described in the `EXTERNALS` section.

3. Checkout externals into the `/_externals` directory.

   >
   cd <root>
   vcs import < .externals

3. Checkout all/respective source libraries into the `/src` directory in
   predefined form described in the `CATALOG CONTENT DESCRIPTION` section.

   To checkout all sources:

   >
   cd <root>
   vcs import < .src

   CAUTION:
      Beware of start downloading of all libraries!

   NOTE:
      To checkout specific sources you must create or use your own version of
      the `.src` file.

5. Read `README_EN.txt` file from the `_scripts` directory to build specific
   library.

-------------------------------------------------------------------------------
8. AUTHOR
-------------------------------------------------------------------------------
Andrey Dibrov (andry at inbox dot ru)

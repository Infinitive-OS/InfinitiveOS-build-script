# InfinitiveOS-build-script

SCRIPT
  |
  |-- io.sh
  |      Main script that handles, build enviornment setup, repo init, repo sync, io.config export etc.
  |
  `-- rom-build.sh
         The build script that actually builds InfinitiveOS.
         It depends on io.config file for configuration of extras. You can make a io.config from the io.sh or use the below given file as an example to make one.
         
```
MAKE_CLEAN=0
MAKE_CLOBBER=0
REPO_SYNC_BEFORE_BUILD=0
BUILD_ENV_SETUP=1
CHERRYPICK=0
EXPORT_PACKAGE=1
RESET_HARD=0
```

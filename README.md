heads Builder scripts
==========

Bash scripts and config files to simplify building of heads using the official Debian docker image.



## BEFORE YOU BEGIN !!!!!

If your device has the stock BIOS installed, you must flash the BIOS chip externally first. I suggest starting with [Skulls](https://github.com/merge/skulls) which makes that first install as painless as possible.  

## Usage

```bash
./build.sh [-t <TAG>] [-c <COMMIT>] [--config] [--clean-slate] <model>

  --clean-slate                Purge previous build directory and config
  -c, --commit <commit>        Git commit hash
  -h, --help                   Show this help
  -t, --tag <tag>              Git tag/version
If a tag or commit not given, heads build the latest master branch commit.
```

Once the build is complete, you will be asked to backup the existing and flash the new rom.

NOTE: Internal flashing can only be complete if heads has already been flashed externally and ifd has been unlocked.

## Examples
* Build the latest commit on master branch:  
  `./build.sh X230`

## Devices
* QEMU image
* Lenovo Thinkpad X230

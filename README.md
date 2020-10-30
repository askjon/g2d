# The Urban Tool

u2l is a gentoo "distribution" aimed at providing a sysadmin tool thats

- [ ] already setup the way @askdonjohn and/or you wants
- [x] easy to deploy
- [ ] selfupdating
- [x] customizeable

## Usage

1. Get a gentoo iso running on the target system
2. Get internet working on the live system
3. Create the disklayout and mount them as you would want them in the system under /mnt/gentoo while /mnt/gentoo is the root of the new system
4. Run "git clone https://www.github.com/askdonjohn/u2l.git"
5. Run "cd u2l"
6. Run "./install.sh"
7. Follow instuctions given by the installer

## The Start

u2l is [atm] a script that installs gentoo with custom pkgs and 
basic configuration files.

## TODO

- [x] Autodownload latest stage3 if none present
- [x] Config Patching
- [ ] Binary Package Distribution
- [ ] More sets
- [ ] Switching to ck kernel patches and/or custom [?]


## The Goal

A fully fledged gentoo distribution


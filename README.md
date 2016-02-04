# libpth build

This repository allows you to build and package libpth

## Dependencies

```
apt-get install build-essential libgmp-dev libunbound-dev m4
```

# Building and Packaging
```
git clone https://github.com/charlesportwoodii/libpth-build
cd libpth-build

sudo make VERSION=<version>
# deb packages can be built with
# sudo make package VERSION=<version>
```

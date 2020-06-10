# Generating a ROOT Debian package with CPack

This directory contains configuration for generating a ROOT
debian package for Ubuntu 20.04. The files and their purpose
are listed below:

- **packages**: This file contains the list of build dependencies
- **build.cmake**: This is a CTest script for building ROOT with the
  configurations needed to generate the Debian package

## How to generate the package

Generating the Debian package can be done by running

```bash
$ # first install dependencies
$ sudo apt install -y $(< packages)
$ ctest -VV -S build.cmake
$ cpack -G DEB
```

The generated package can then be installed by running

```bash
$ sudo apt install ./root_<version>_<arch>.deb
```

# wpkg-init
Script written in go, which runs wpkg before running init

## Dependencies
Runtime dependencies:
- curl (to download wpkg)
- go compiler
- make (for installation)

Init system is also required. Any init is supported.

## Installation
Run:
```sh
make
make install # as root
make clean
```

## Uninstallation
If you didn't enjoy using wpkg-init, you can uninstall it by running as root:
```sh
make uninstall
```

## Some information
Project is licensed under MIT license. Author is not legally responsible for any damages made by this software, for the way which this software is used with and how it was spread.
# Aml Flash Tool for Nix

Nix package and NixOS modules of [Aml Flash Tool for Linux](https://github.com/antoxa78/Amlogic-Tool-for-Linux/tree/main)

## Usage

It exposes `packages.<system>.aml-flash-tool` package, also aliased as `packages.<system>.default`, which can be used on any linux system by `<result>/bin/aml-flash-tool`. The udev rules are under `<result>/lib/udev/rules.d/99-amlogic-flash.rules`, which should be copied to `/etc/udev/rules.d/`.

It also exposes a `overlays.aml-flash-tool`, aliased as `overlays.default`, integrating above package into `pkgs` as `pkgs.aml-flash-tool`.

For NixOS, it has a `nixosModules.aml-flash-tool`, aliased as `nixosModules.default`, doing all above things for you. All you need is set import this module and ser `programs.aml-flash-tool.enable = true;`.

## License

MIT
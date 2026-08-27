{
  inputs = {
    systems.url = "github:nix-systems/default-linux";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      flake@{ config, withSystem, ... }:
      {
        systems = import inputs.systems;

        flake = {
          nixosModules = {
            default = config.flake.nixosModules.aml-flash-tool;
            aml-flash-tool =
              {
                config,
                lib,
                pkgs,
                ...
              }:
              {
                options.programs.aml-flash-tool = {
                  enable = lib.mkEnableOption "Amlogic Flash Tool";
                  package = lib.mkPackageOption "aml-flash-tool";
                };

                config = lib.mkIf config.programs.aml-flash-tool.enable {
                  environment.systemPackages = with pkgs; [ aml-flash-tool ];

                  services.udev.packages = with pkgs; [ aml-flash-tool ];

                  nixpkgs.overlays = [ flake.config.overlays.aml-flash-tool ];
                };
              };
          };

          overlays = {
            default = config.flake.overlays.aml-flash-tool;
            aml-flash-tool = (
              _: prev:
              withSystem prev.hostPlatform.system (
                { config, ... }: {
                  aml-flash-tool = config.packages.aml-flash-tool;
                }
              )
            );
          };
        };

        perSystem = { config, pkgs, ... }: {
          packages = {
            default = config.packages.aml-flash-tool;
            aml-flash-tool = pkgs.callPackage ./package.nix { };
          };
        };
      }
    );
}

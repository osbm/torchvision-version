{
  description = "Development Shell For this repository";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        config.cudaSupport = true;
      };
    in
    {
      devShells."${system}".default = pkgs.mkShell {
        packages = with pkgs; [
          (python312.withPackages (ppkgs: with python312Packages; [
            torchvision
            pip
          ]))
        ];
        shellHook = ''
          echo 'Welcome to the ai development.'
          pip freeze | grep torchvision
        '';
      };
    };
}

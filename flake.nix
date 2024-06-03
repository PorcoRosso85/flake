{
  description = "nix dev env";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { self
    , nixpkgs
    , flake-utils
      # , parent
    }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      # nix develop
      devShell = pkgs.mkShell {
        buildInputs = [
          pkgs.neovim
          pkgs.nil
          pkgs.nixpkgs-fmt

          pkgs.zsh
          pkgs.zsh-powerlevel10k
          pkgs.gh
          pkgs.curl
          pkgs.wget
          pkgs.eza
          pkgs.fd
          pkgs.bat
          pkgs.lazygit

          # pkgs.docker
          pkgs.lazydocker
          # pkgs.containerd?
          # pkgs.act

        ];
        shellHook = ''
        '';
      };

      # nix run
      packages = {
        cowsay = pkgs.cowsay;
      };

      apps = {
        # .#hello
        hello = flake-utils.lib.mkApp {
          drv = pkgs.hello;
        };
        # .#cowsay
        # cowsay = flake-utils.lib.mkApp {
        #   drv = self.packages.${system}.cowsay;
        # };
        hello2 = flake-utils.lib.mkApp {
          drv = pkgs.writeShellScriptBin "hello_from_shell" ''
            echo "Hello from shell!"
          '';
        };
        test = flake-utils.lib.mkApp {
          drv = pkgs.writeShellScriptBin "test" ''
            # cd ./persistence
            # sqlc generate
            # cd ..
            # bunx vitest ./persistence
          '';
        };
      };

    }
    );
}

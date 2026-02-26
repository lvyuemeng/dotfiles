{
  description = "Nostalgia Packages Management";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux"; # Change to "aarch64-darwin" for Mac
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.${system}.default = pkgs.buildEnv {
        name = "my-packages";
        paths = with pkgs; [
          # List your packages here
          git
          starship
          neovim
          aria2
          ripgrep
          bat
          fzf
          fd
          ripgrep
          eget
          just
        ];
      };
    };
}

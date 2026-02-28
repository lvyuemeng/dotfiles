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
          # coreutils
          git
          starship
          neovim
          aria2
          ripgrep
          bat
          fzf
          fd
          ripgrep
          just
          eget
          # fonts
          maple-mono.truetype
          maple-mono.NF-unhinted
          maple-mono.NF-CN-unhinted
        ];
      };
    };
}

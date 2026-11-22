{
  description = "Starflake workspace development shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.linkml-csharp.url = "github:M4jor-Tom/linkml-csharp";
  inputs.linkml-csharp.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    { nixpkgs, linkml-csharp, ... }:
    {
      devShells =
        nixpkgs.lib.genAttrs
          [
            "x86_64-linux"
            "aarch64-linux"
          ]
          (
            system:
            let
              pkgs = nixpkgs.legacyPackages.${system};
            in
            {
              default = pkgs.mkShell {
                packages = [
                  linkml-csharp.packages.${system}.default
                  pkgs.just
                  pkgs.gh
                  pkgs.yq-go
                  pkgs.check-jsonschema
                  pkgs.yamllint
                  pkgs.actionlint
                  pkgs.shellcheck
                  pkgs.markdownlint-cli2
                  pkgs.nixfmt
                ];
                shellHook = ''
                  # Run the checks before every push (.githooks/pre-push).
                  git rev-parse --git-dir >/dev/null 2>&1 && git config core.hooksPath .githooks
                '';
              };
            }
          );
    };
}

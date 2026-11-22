# Run every check.
test: lint

# Lint every tracked file with its linter's defaults.
lint:
    just --unstable --fmt --check
    nixfmt --check flake.nix
    shellcheck .githooks/pre-push
    yamllint .github
    actionlint

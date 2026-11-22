# Run every check.
test: lint snapshot-test snapshot-check

# Lint every tracked file with its linter's defaults.
lint:
    just --unstable --fmt --check
    nixfmt --check flake.nix
    shellcheck .githooks/pre-push tools/*.sh tests/*.sh
    yamllint .github
    actionlint

# Test tools/snapshot.sh against fixture repositories.
snapshot-test:
    bash tests/snapshot.test.sh

# Check that every recorded submodule commit is on master or a tag of its declared repository.
snapshot-check:
    tools/snapshot.sh check

# Record the checked-out commits of game, design and ontology as one workspace commit.
snapshot message="chore: snapshot":
    tools/snapshot.sh record "{{ message }}"

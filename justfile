# Run every check.
test: lint snapshot-test snapshot-check

# Lint every tracked file with its linter's defaults.
lint:
    just --unstable --fmt --check
    nixfmt --check flake.nix
    shellcheck .githooks/pre-push tools/*.sh tests/*.sh
    yamllint .github labels.yaml
    actionlint
    check-jsonschema --check-metaschema labels.schema.json
    check-jsonschema --schemafile labels.schema.json labels.yaml
    check-jsonschema --schemafile https://json.schemastore.org/github-issue-forms.json .github/ISSUE_TEMPLATE/bug.yaml .github/ISSUE_TEMPLATE/suggestion.yaml
    check-jsonschema --schemafile https://json.schemastore.org/github-issue-config.json .github/ISSUE_TEMPLATE/config.yml
    markdownlint-cli2 README.md

# Test tools/snapshot.sh against fixture repositories.
snapshot-test:
    bash tests/snapshot.test.sh

# Check that every recorded submodule commit is on master or a tag of its declared repository.
snapshot-check:
    tools/snapshot.sh check

# Record the checked-out commits of game, design and ontology as one workspace commit.
snapshot message="chore: snapshot":
    tools/snapshot.sh record "{{ message }}"

# Create or update the shared labels in the workspace repository and every component repository.
labels:
    #!/usr/bin/env bash
    set -euo pipefail
    repos=$(gh repo view --json nameWithOwner -q .nameWithOwner)
    repos+=" $(git config -f .gitmodules --get-regexp 'submodule\..*\.url' | sed -E 's#.*github\.com/(.*)\.git#\1#' | tr '\n' ' ')"
    for repo in $repos; do
      yq -r '.labels[] | [.name, .color, .description] | @tsv' labels.yaml |
        while IFS=$'\t' read -r name color description; do
          gh label create "$name" --repo "$repo" --color "$color" --description "$description" --force
        done
    done

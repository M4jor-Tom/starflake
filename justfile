# Run every check.
test: lint snapshot-test snapshot-check

# Lint every tracked file with its linter's defaults.
lint:
    just --unstable --fmt --check
    nixfmt --check flake.nix
    shellcheck $(git ls-files '*.sh' .githooks)
    yamllint .github labels.yaml
    actionlint
    check-jsonschema --check-metaschema labels.schema.json
    check-jsonschema --schemafile labels.schema.json labels.yaml
    check-jsonschema --schemafile https://json.schemastore.org/github-issue-forms.json $(git ls-files '.github/ISSUE_TEMPLATE/*.yaml')
    check-jsonschema --schemafile https://json.schemastore.org/github-issue-config.json .github/ISSUE_TEMPLATE/config.yml
    markdownlint-cli2 $(git ls-files '*.md')

# Test tools/snapshot.sh against fixture repositories.
snapshot-test:
    bash tests/snapshot.test.sh

# Check that every recorded submodule commit is on master or a tag of its declared repository.
snapshot-check:
    {{ justfile_directory() }}/tools/snapshot.sh check

# Record the checked-out commits of game, design and ontology as one workspace commit.
snapshot message="chore: snapshot":
    {{ justfile_directory() }}/tools/snapshot.sh record {{ quote(message) }}

# Create or update the shared labels in the workspace repository and every component repository.
labels:
    #!/usr/bin/env bash
    set -euo pipefail
    repos=("$(gh repo view --json nameWithOwner -q .nameWithOwner)")
    while read -r _ url; do
      repos+=("$(gh repo view "$url" --json nameWithOwner -q .nameWithOwner)")
    done < <(git config -f .gitmodules --get-regexp '^submodule\..*\.url$')
    for repo in "${repos[@]}"; do
      yq -r '.labels[] | [.name, .color, .description] | @tsv' labels.yaml |
        while IFS=$'\t' read -r name color description; do
          gh label create "$name" --repo "$repo" --color "$color" --description "$description" --force
        done
    done

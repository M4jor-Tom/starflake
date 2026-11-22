#!/usr/bin/env bash
# Record or check a workspace snapshot: one commit of each submodule, each on
# master or a tag of the repository declared for it in .gitmodules.
#   tools/snapshot.sh check             judge the pointers committed in HEAD
#   tools/snapshot.sh record <message>  judge the checked-out commits, commit them
set -euo pipefail

usage() {
  echo "usage: tools/snapshot.sh check | record <message>" >&2
  exit 2
}

mode=${1:-}
case $mode in
  check) [[ $# -eq 1 ]] || usage ;;
  record) [[ $# -eq 2 ]] || usage ;;
  *) usage ;;
esac

cd "$(git rev-parse --show-toplevel)"

# reachable <path> <url> <sha>: fails with a message unless <sha> is on master
# or a tag of <url>. Fetches into refs/snapshot-check/ so no user ref moves.
reachable() {
  local path=$1 url=$2 sha=$3
  if ! git -C "$path" fetch --quiet --prune --no-tags "$url" \
    '+refs/heads/master:refs/snapshot-check/master' \
    '+refs/tags/*:refs/snapshot-check/tags/*' 2>/dev/null </dev/null; then
    echo "snapshot: cannot fetch $url" >&2
    return 1
  fi
  if [[ -n $(git -C "$path" for-each-ref --contains "$sha" refs/snapshot-check/ 2>/dev/null) ]]; then
    return 0
  fi
  echo "snapshot: $path $sha is not on master or a tag of $url" >&2
  return 1
}

mapfile -t entries < <(git config -f .gitmodules --get-regexp '^submodule\..*\.path$' 2>/dev/null || true)
((${#entries[@]})) || exit 0

failed=0
paths=()
for entry in "${entries[@]}"; do
  key=${entry%% *}
  path=${entry#* }
  url=$(git config -f .gitmodules "${key%.path}.url")
  paths+=("$path")
  if [[ ! -e $path/.git ]]; then
    echo "snapshot: $path is not checked out; run: git submodule update --init" >&2
    failed=1
    continue
  fi
  if [[ $mode == check ]]; then
    sha=$(git rev-parse "HEAD:$path")
  elif [[ -n $(git -C "$path" status --porcelain) ]]; then
    echo "snapshot: $path has uncommitted changes" >&2
    failed=1
    continue
  else
    sha=$(git -C "$path" rev-parse HEAD)
  fi
  reachable "$path" "$url" "$sha" || failed=1
done
((failed == 0)) || exit 1
[[ $mode == record ]] || exit 0

if git diff HEAD --quiet -- "${paths[@]}"; then
  echo "snapshot: no pointer moved"
  exit 0
fi
# --only (implied by the paths) leaves anything else staged out of the commit.
git commit --quiet -m "$2" -- "${paths[@]}"

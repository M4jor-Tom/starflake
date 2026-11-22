#!/usr/bin/env bash
# Tests tools/snapshot.sh against fixture repositories in a temporary directory.
set -euo pipefail

S="$(cd "$(dirname "$0")/.." && pwd)/tools/snapshot.sh"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# Isolate git from the user's configuration and allow file:// submodules.
export GIT_CONFIG_GLOBAL="$tmp/gitconfig" GIT_CONFIG_NOSYSTEM=1
git config --global user.name test
git config --global user.email test@example.invalid
git config --global init.defaultBranch master
git config --global protocol.file.allow always
git config --global advice.detachedHead false

# commit <repo> <message>: makes an empty commit and prints its hash.
commit() {
  git -C "$1" commit --quiet --allow-empty -m "$2"
  git -C "$1" rev-parse HEAD
}

# remote.git: A on master, T only reachable from tag v1, F on branch feat.
# fork.git: master is K, a child of A that remote.git does not have.
git init --quiet "$tmp/seed"
A=$(commit "$tmp/seed" A)
git -C "$tmp/seed" switch --quiet -c released
T=$(commit "$tmp/seed" T)
git -C "$tmp/seed" tag v1
git -C "$tmp/seed" switch --quiet -c feat master
F=$(commit "$tmp/seed" F)
git -C "$tmp/seed" switch --quiet -c forked master
K=$(commit "$tmp/seed" K)
git init --quiet --bare "$tmp/remote.git"
git -C "$tmp/seed" push --quiet "$tmp/remote.git" master feat v1
git init --quiet --bare "$tmp/fork.git"
git -C "$tmp/seed" push --quiet "$tmp/fork.git" forked:master

# ws: a workspace whose submodule sub points at A.
ws="$tmp/ws"
git init --quiet "$ws"
git -C "$ws" submodule --quiet add "file://$tmp/remote.git" sub
git -C "$ws" commit --quiet -m baseline
BASE=$(git -C "$ws" rev-parse HEAD)
git -C "$ws/sub" fetch --quiet --tags origin
git -C "$ws/sub" remote add fork "file://$tmp/fork.git"
git -C "$ws/sub" fetch --quiet fork

reset() {
  git -C "$ws" reset --quiet --hard "$BASE"
  git -C "$ws/sub" checkout --quiet --detach "$A"
  git -C "$ws/sub" clean --quiet -fd
}
checkout() { git -C "$ws/sub" checkout --quiet --detach "$1"; }

failures=0
fail() {
  echo "FAIL: $*"
  failures=$((failures + 1))
}

# expect <exit-status> <output-substring-or-empty> <command...>
# A failing command must also leave the workspace HEAD where it was.
expect() {
  local want=$1 msg=$2 before status=0
  shift 2
  before=$(git -C "$ws" rev-parse HEAD)
  (cd "$ws" && "$@") >"$tmp/out" 2>&1 || status=$?
  if [[ $status != "$want" ]] || { [[ -n $msg ]] && ! grep -qF -- "$msg" "$tmp/out"; }; then
    fail "$* exited $status, want $want with '$msg'; output:"
    sed 's/^/  /' "$tmp/out"
  fi
  if [[ $want != 0 && $(git -C "$ws" rev-parse HEAD) != "$before" ]]; then
    fail "$* committed although it failed"
  fi
}

# master
expect 0 '' "$S" check

# tag-only
reset
checkout "$T"
expect 0 '' "$S" record 'chore: snapshot'
[[ $(git -C "$ws" rev-parse HEAD:sub) == "$T" ]] || fail "tag-only: T was not recorded"
[[ $(git -C "$ws" log -1 --format=%s) == 'chore: snapshot' ]] || fail "tag-only: wrong message"
expect 0 '' "$S" check

# feat branch
reset
checkout "$F"
expect 1 'is not on master or a tag of' "$S" record m

# unpushed
reset
git -C "$ws/sub" commit --quiet --allow-empty -m local
expect 1 'is not on master or a tag of' "$S" record m

# fork: K is on the master of a remote the clone knows, but not of the declared URL.
reset
checkout "$K"
expect 1 'is not on master or a tag of' "$S" record m

# dirty
reset
touch "$ws/sub/new"
expect 1 'sub has uncommitted changes' "$S" record m

# nothing-moved
reset
expect 0 'no pointer moved' "$S" record m
[[ $(git -C "$ws" rev-parse HEAD) == "$BASE" ]] || fail "nothing-moved: committed"

# staged-bystander
reset
echo other >"$ws/other.txt"
git -C "$ws" add other.txt
checkout "$T"
expect 0 '' "$S" record m
[[ $(git -C "$ws" show --name-only --format= HEAD) == sub ]] || fail "staged-bystander: commit holds more than sub"
[[ $(git -C "$ws" diff --cached --name-only) == other.txt ]] || fail "staged-bystander: other.txt is no longer staged"

# message-quoting: `just snapshot` passes the message through untouched.
reset
ln -s "$(dirname "$S")" "$ws/tools"
checkout "$T"
# shellcheck disable=SC2016 # $HOME and `id` must reach git unexpanded.
msg='fix: say "hi" to $HOME `id`'
expect 0 '' just --justfile "$(dirname "$S")/../justfile" --working-directory "$ws" snapshot "$msg"
[[ $(git -C "$ws" log -1 --format=%B) == "$msg" ]] || fail "message-quoting: recorded '$(git -C "$ws" log -1 --format=%B)'"
rm "$ws/tools"

# unreachable-url
reset
git -C "$ws" config -f .gitmodules submodule.sub.url file:///nonexistent.git
expect 1 'cannot fetch file:///nonexistent.git' "$S" check

# uninitialised
reset
git -C "$ws" submodule --quiet deinit -f sub
expect 1 'sub is not checked out; run: git submodule update --init' "$S" check

if ((failures)); then
  echo "snapshot tests: $failures failed"
  exit 1
fi
echo "snapshot tests: ok"

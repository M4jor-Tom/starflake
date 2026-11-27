# Starflake workspace

One commit of this repository records one commit of each Starflake component:

- [`game`](https://github.com/M4jor-Tom/starflake.game.cs): the game, in C#
  and Godot.
- [`design`](https://github.com/M4jor-Tom/starflake.design): the gameplay
  specification the game is tested against.
- [`ontology`](https://github.com/M4jor-Tom/starflake.ontology.linkml): the
  domain model the game's types are generated from.

## Restore a snapshot

```sh
git clone --recurse-submodules https://github.com/M4jor-Tom/starflake.git
cd starflake
git checkout <commit> && git submodule update --init
```

Record a new one with `just snapshot`, inside `nix develop`. It refuses any
component commit that is not on `master` or a tag of its repository.

A snapshot records what was checked out together. The game builds against the
versions in `game/ontology.lock` and `game/design.lock`, which may differ from
the `design` and `ontology` commits of the same snapshot.

## Generate C# from a LinkML schema

The workspace shell includes `gen-csharp`; no separate checkout or Python setup
is needed. For example, to generate the ontology classes into a fresh directory:

```sh
out=$(mktemp -d)
schema=$(git -C ontology ls-files 'src/*starflake_ontology.yaml')
nix develop -c gen-csharp "ontology/$schema" -d "$out"
```

## Report a problem

Report problems and ideas for any part of Starflake in one place:
<https://github.com/M4jor-Tom/starflake/issues/new/choose>.

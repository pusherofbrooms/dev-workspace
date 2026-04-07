# dev-workspace

Shared Nix + direnv workspace for `~/ai`.

## Usage

From `~/ai`:

```bash
direnv allow
```

To dogfood the latest `pi` or `codesieve` inputs:

```bash
cd dev-workspace
nix flake lock --update-input pi
nix flake lock --update-input codesieve
```

Or update everything:

```bash
cd dev-workspace
nix flake update
```

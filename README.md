# dev-workspace

Shared Nix + direnv workspace intended to be sourced from a parent directory. Includes `pi`, `codesieve`, and `node` by default.

The workspace file is named `envrc`, not `.envrc`, so direnv loads once from the parent directory and does not reload again when you enter `dev-workspace/`.

## Usage

If this repo lives at `~/ai/dev-workspace`, put this in `~/ai/.envrc`:

```bash
source_env ./dev-workspace/envrc
```

Then allow it once from the parent directory:

```bash
direnv allow
```

## Updating inputs

From this repo:

```bash
nix flake update pi
nix flake update codesieve
nix flake update
```

## Notes

- `flake.lock` pins input revisions.
- On first use, Nix may create `flake.lock` and trigger one extra direnv reload.
- Add more tools in `flake.nix` as needed.

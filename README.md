# dev-workspace

Shared Nix + direnv workspace for `~/ai`.

This setup uses two `.envrc` files:

- `~/ai/.envrc` — trivial wrapper that sources `./dev-workspace/.envrc`
- `~/ai/dev-workspace/.envrc` — the real direnv file that loads the flake

That keeps the top-level `.envrc` simple while storing the actual workspace config in `dev-workspace/`.

## Files

- `flake.nix` — defines the dev shell
- `flake.lock` — pins input revisions
- `.envrc` — loads the flake via direnv
- `.gitignore` — ignores everything except tracked workspace files
- `LICENSE` — MIT license

## Normal usage

Top-level `~/ai/.envrc`:

```bash
source_env ./dev-workspace/.envrc
```

Then from `~/ai`:

```bash
direnv allow
```

After that, entering `~/ai` should load the workspace automatically.

## Updating inputs

To dogfood the latest `pi`:

```bash
cd ~/ai/dev-workspace
nix flake lock --update-input pi
```

To dogfood the latest `codesieve`:

```bash
cd ~/ai/dev-workspace
nix flake lock --update-input codesieve
```

To update everything:

```bash
cd ~/ai/dev-workspace
nix flake update
```

After changing the lockfile, direnv should reload automatically when you return to `~/ai` or press enter there.

## Notes

- On first use, evaluating the flake may create `flake.lock` and trigger one extra direnv reload.
- Add more tools to `flake.nix` as your default workflow grows, for example `nixpkgs#playwright` later.

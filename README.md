# FlatRoot Docs

Versioned documentation publisher for [FlatRoot](https://github.com/flatroot/flatroot). This repository holds no documentation content: the publish workflow clones the production repository, builds the MkDocs site of every release tag plus the HEAD of master, and force-pushes the assembled versioned site to the `gh-pages` branch, served by GitHub Pages at <https://flatroot.github.io/docs>.

## Version model

- `master` — HEAD of the master branch.
- `vX.Y.Z` — one version per release tag, named verbatim after the tag; the newest tag is the default landing version.

The `gh-pages` branch is generated output: every run rebuilds the full set from scratch and replaces the branch, so it never needs manual edits.

## Publishing

Trigger the **Publish docs** workflow manually (`workflow_dispatch`).

## Building locally

The built versions land directly on the local `gh-pages` branch of this repository:

```sh
git clone https://github.com/flatroot/docs
cd docs
git clone https://github.com/flatroot/flatroot
docker build -f flatroot/docker/Dockerfile.mkdocs -t flatroot-mkdocs flatroot
docker run --rm -v "$PWD/flatroot:/flatroot-src" -v "$PWD:/docs" flatroot-mkdocs sh /docs/publish.sh
```

The container runs as root, so the objects it writes under `.git/` come out root-owned; pushing still works, reclaim them with `chown` if needed.

## Previewing locally

`mike serve` serves the local `gh-pages` branch with the version dropdown and the root redirect to the newest tag:

```sh
docker run --rm -p 8000:8000 -v "$PWD:/docs" flatroot-mkdocs sh -c '
  git config --global --add safe.directory /docs
  cd /docs
  /flatroot/docs/mkdocs/env/bin/mike serve --remote origin --branch gh-pages --dev-addr 0.0.0.0:8000'
```

Then open <http://localhost:8000>. To publish a locally built set: `git push --force origin gh-pages`.

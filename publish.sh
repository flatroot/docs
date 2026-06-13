#!/bin/sh
# Builds the docs of every release tag plus master HEAD from the clone at
# /flatroot-src onto the gh-pages branch of /docs.
set -eu

export PATH="/flatroot/docs/mkdocs/env/bin:$PATH"
config=/flatroot-src/docs/mkdocs/mkdocs.yml

# The mounted repositories belong to the host user, not the container's.
git config --global --add safe.directory /flatroot-src
git config --global --add safe.directory /docs

# mike commits to gh-pages
git config --global user.name mkdocs-publish
git config --global user.email mkdocs-publish@localhost

cd /docs

git -C /flatroot-src checkout --quiet master
mike deploy --config-file "$config" master

for tag in $(git -C /flatroot-src tag --list 'v*' --sort=v:refname); do
  git -C /flatroot-src checkout --quiet "$tag"
  mike deploy --config-file "$config" "$tag"
done

mike set-default --config-file "$config" "$tag"

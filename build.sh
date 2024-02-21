#!/usr/bin/env bash
# exit on error
set -o errexit

# Initial setup
mix deps.get --only prod
MIX_ENV=prod mix compile

# Compile assets
MIX_ENV=prod mix assets.deploy

# Build the release and overwrite the existing release directory
mix phx.gen.release

MIX_ENV=prod mix release --overwrite


# Run migrations
_build/prod/rel/hindsight/bin/hindsight eval "Hindsight.Release.migrate"
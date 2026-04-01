#!/bin/bash

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
COMMIT=$(git rev-parse HEAD)
BRANCH=$(git rev-parse --abbrev-ref HEAD)
REPO=$(basename "$(git rev-parse --show-toplevel)")

echo "timestamp=$TIMESTAMP"
echo "current_commit=$COMMIT"
echo "current_branch=$BRANCH"
echo "repo_name=$REPO"

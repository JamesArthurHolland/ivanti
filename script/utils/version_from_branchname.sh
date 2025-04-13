#!/bin/bash

utils_dir="$( dirname -- "$BASH_SOURCE"; )"

branch=$(git log -1 --pretty=%B | grep -o -m 1 "[r|R]elease\\/.*")
if [ -z "$branch" ]
then
  echo "Merged branch is not release branch."
  echo "Branch name should be in the title: "
  git log -1 --pretty=%B
  exit 3
fi

version=$("${utils_dir}/get_release_version_from_commit_message.py" "$branch")

echo $version
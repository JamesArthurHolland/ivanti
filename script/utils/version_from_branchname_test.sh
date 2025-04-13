ozone -d -c pull-request run deploy-pr#!/bin/bash

utils_dir="$( dirname -- "$BASH_SOURCE"; )"

echo "$utils_dir"

echo "Branch is $branch±"
git log -1 --pretty=%B | grep -o "release\\/.*"

branch=$(git log -1 --pretty=%B | grep -o "release\\/.*")
echo "Branch is $branch"
if [ -z "$branch" ]
then
  echo "Merged branch is not release branch."
  exit 1
fi

version=$("${utils_dir}/get_release_version.py" "$branch")

echo $version
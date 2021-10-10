#!/bin/bash
if [ `git branch --list gh-pages` ]
then
   echo "Branch name gh-pages already exists."
   exit 0
fi


# fail on unset variables and command errors
set -eu -o pipefail # -x: is for debugging

DEFAULT_BRANCH="main"

CURRENT_BRANCH="$(git branch --show-current)"
if [ "${CURRENT_BRANCH}" != "${DEFAULT_BRANCH}" ]; then
  echo "$0: Current branch ${CURRENT_BRANCH} is not ${DEFAULT_BRANCH}, continue? (y/n)"
  read -r res
  if [ "${res}" = "n" ]; then
    echo "$0: Stop script"
    exit 0
  fi
fi

username=$(git --no-pager log --format=format:'%an' -n 1)
email=$(git --no-pager log --format=format:'%ae' -n 1)
repo_uri="https://x-access-token:${{ secrets.GITHUB_TOKEN }}@github.com/${GITHUB_REPOSITORY}.git"

echo "Username: $username"
echo "email: $username"
echo "repo_uri: $repo_uri"

GIT_REPO_URL=$(git config --get remote.origin.url)

mkdir .deploy
cp -R .github/actions/converter-docker-action/public/* .deploy
cd .deploy
git init .
echo "setup credentials"
git config user.name "$username"
git config user.email "$email"
git remote add pages $repo_uri
echo "pushing"

git add .
git commit -am "Create gh-pages"
git branch -M gh-pages
git push -u pages gh-pages
cd ..
rm -rf .deploy

echo "gh-pages deployed."

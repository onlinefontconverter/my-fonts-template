#!/bin/bash
if [ `git branch --list gh-pages` ]
then
   echo "Branch name gh-pages already exists."
   exit 0
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
git config --global user.name "$username"
git config --global user.email "$email"
git remote add pages $repo_uri
echo "pushing"

git add .
git commit -am "Create gh-pages"
git branch -M gh-pages
git push -u pages gh-pages
cd ..
rm -rf .deploy

echo "gh-pages deployed."

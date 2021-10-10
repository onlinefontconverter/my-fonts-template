#!/bin/bash
if [ `git branch --list gh-pages` ]
then
   echo "Branch name gh-pages already exists."
   exit 0
fi

GIT_REPO_URL=$(git config --get remote.origin.url)

mkdir .deploy
cp -R .github/actions/converter-docker-action/public/* .deploy
cd .deploy
git init .
git remote add github $GIT_REPO_URL
git checkout -b gh-pages
git add .
git commit -am "Create gh-pages"
git push github gh-pages
cd ..
rm -rf .deploy

echo "gh-pages deployed."

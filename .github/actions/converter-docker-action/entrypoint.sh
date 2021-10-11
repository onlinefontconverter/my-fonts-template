#!/bin/bash

set -eu -o pipefail # -x: is for debugging

echo "Push to branch $INPUT_BRANCH";
[ -z "${INPUT_GITHUB_TOKEN}" ] && {
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};

while [[ "$PWD" != "/" ]] ; do
  mkdir work && cd work # only when testing local
done

workingDir=$(pwd)
fontDir=$1
github_token=$2
if [ -z "${VAR}" ]; then
  fontDir="fonts"
fi

if [ -z "$(ls -A ./$fontDir)" ]; then
  mv /samplefonts ./$fontDir # only when local
fi

mv /public ./

username=$(git --no-pager log --format=format:'%an' -n 1)
email=$(git --no-pager log --format=format:'%ae' -n 1)
repo_uri="https://x-access-token:${github_token}@github.com/${GITHUB_REPOSITORY}.git"

remote_repo="https://${GITHUB_ACTOR}:${INPUT_GITHUB_TOKEN}@github.com/${REPOSITORY}.git"
if [ `git branch --list gh-pages` ]
then
   echo "Branch name gh-pages already exists."
else

   echo "Creating branch gh-pages"


  echo "Username: $username"
  echo "email: $username"
  echo "repo_uri: $repo_uri"

  GIT_REPO_URL=$(git config --get remote.origin.url)

  mkdir .deploy
  cp -R .github/actions/converter-docker-action/public/* .deploy
  cd .deploy
  git init .
  echo "setup credentials"
  git config --local user.name "GitHub Action"
  git config --local user.email "action@github.com"
  git remote add pages $repo_uri
  echo "pushing"

  git add .
  git commit -am "Create gh-pages"
  git branch -M gh-pages
  git push -u pages gh-pages
  cd ..
  rm -rf .deploy

  echo "gh-pages deployed."
fi

echo "Files in $workingDir 1:"
ls -al
# ttfautohint $fontDir/verdana.ttf $fontDir/verdana_auto_hint.ttf # fontforge do this?
fontforge -script /all2all.pe --format ".svg" $fontDir/*
for i in $fontDir/*.ttf;
do
  mkeot $i > $fontDir/verdana.eot
done

echo "Files in $workingDir 2:"
ls -al
echo "Files in $fontDir:"
ls -al $fontDir
mv $fontDir/* ./public
echo "Files in public:"
ls -al public
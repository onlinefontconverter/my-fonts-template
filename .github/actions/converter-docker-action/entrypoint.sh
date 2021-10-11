#!/bin/bash

set -eu -o pipefail # -x: is for debugging


[ -z "${1}" ] && {
    echo 'Missing input "github_token: ${{ secrets.GITHUB_TOKEN }}".';
    exit 1;
};
github_token=$1

[ -z "${2}" ] && {
    echo 'Missing input "font_dir: fonts".';
    exit 1;
};
fontDir=$2

#while [[ "$PWD" != "/" ]] ; do
#  mkdir work && cd work # only when testing local
#done

workingDir=$(pwd)
echo "Workdir: $workingDir"

if [ -z "$(ls -A ./$fontDir)" ]; then
  mv /samplefonts ./$fontDir # only when local
fi

username=onlinefontconverter
email="bot@onlinefontconverter.com"
repo_uri="https://x-access-token:${github_token}@github.com/${GITHUB_REPOSITORY}.git"
echo "Username: $username"
echo "email: $username"
echo "repo_uri: $repo_uri"

if [ `git branch --list gh-pages` ]
then
   echo "Branch name gh-pages already exists."
else
  echo "Creating branch gh-pages"

  mkdir .deploy
  cp -R /public/* .deploy
  cd .deploy

  echo "setup git local"
  git init .
  git config --local user.name $username
  git config --local user.email $email
  git remote add pages $repo_uri

  echo "Adding files"
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



mkdir .deploy
cd .deploy

echo "setup git local"
git init .
git config --local user.name $username
git config --local user.email $email
git remote add pages $repo_uri
git fetch pages
git switch gh-pages

cp -R ../.github/actions/converter-docker-action/public/* ./

echo "Adding files"
git add .
git commit -am "Update gh-pages"
git push -u pages gh-pages
cd ..
rm -rf .deploy

echo "gh-pages deployed."
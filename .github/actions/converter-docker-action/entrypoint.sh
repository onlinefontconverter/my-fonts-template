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

#username=onlinefontconverter
#email="bot@onlinefontconverter.com"
username=$(git --no-pager log --format=format:'%an' -n 1)
email=$(git --no-pager log --format=format:'%ae' -n 1)
repo_uri="https://x-access-token:${github_token}@github.com/${GITHUB_REPOSITORY}.git"
echo "Username: $username"
echo "email: $username"
echo "repo_uri: $repo_uri"


echo "setup deployment folder"
mkdir .deploy
cp -R /public/* .deploy
cd .deploy
echo "setup git local"
git config --global init.defaultBranch main
git init .
git config --local user.name $username
git config --local user.email $email


git remote add pages $repo_uri
git fetch pages
existed_in_remote=$(git ls-remote --heads pages "gh-pages" | wc -l)
echo "exists: $existed_in_remote"
if [[ $existed_in_remote == 1 ]];
then
   echo "Branch name gh-pages already exists."
   git checkout gh-pages
else
    touch index.md
    git add index.md
    git commit -am "Create gh-pages"
    git branch -M gh-pages
    git push -u pages gh-pages
    echo "gh-pages deployed."
    sleep 1m #letting github work for a while

fi
cd ..

echo "Files in $workingDir 1:"
ls -al
# ttfautohint $fontDir/verdana.ttf $fontDir/verdana_auto_hint.ttf # fontforge do this?
fontforge -script /all2all.pe --format ".svg" $fontDir/*
for i in $fontDir/*.ttf;
do
  mkeot $i > $fontDir/verdana.eot
done

cd .deploy

git rm -r --cached . # remove old files

cp -R ../.github/actions/converter-docker-action/public/* ./ #copy static files
cp -R ../$fontDir/* ./fonts/ # copy generated files

echo "Adding files"
git add .
git commit -am "Update gh-pages"
git push -u pages gh-pages
cd ..
rm -rf .deploy

echo "gh-pages deployed."
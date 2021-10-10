#!/bin/bash
if [ `git branch --list gh-pages` ]
then
   echo "Branch name gh-pages already exists."
   exit 0
fi

git branch gh-pages
git checkout gh-pages

mv ./build/* .

echo "din not."
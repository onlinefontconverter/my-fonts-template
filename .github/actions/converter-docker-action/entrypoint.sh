#!/bin/sh -l


while [[ "$PWD" != "/" ]] ; do
  mkdir work && cd work # only when testing local
done

workingDir=$(pwd)
fontDir=$1
if [ -z "${VAR}" ]; then
  fontDir="fonts"
fi

if [ -z "$(ls -A ./$fontDir)" ]; then
  mv /samplefonts ./$fontDir # only when local
fi


time=$(date)
echo "::set-output name=time::$time"
ls -al
pwd
mv /public ./

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
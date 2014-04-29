#!/bin/sh

git init
git add README.txt
git commit -m "Commit initial"
git config --global user.email "pimpampoum002@gmail.com"
git config --global user.name "shkel"
git remote add origin https://github.com/shkel/debian.git
git push -u origin master



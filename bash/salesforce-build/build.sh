#!/bin/bash
branch="master"

echo $(date '+%Y-%m-%d %H:%M:%S:%s')": clean folder: unpackged";
rm -rf unpackged/;
mkdir unpackged;

echo $(date '+%Y-%m-%d %H:%M:%S:%s')": update branch $branch";
git reset --hard;
git checkout $branch;
git pull --force;

echo $(date '+%Y-%m-%d %H:%M:%S:%s')": get commit list from baseline, see commit.txt and commitlist.txt";
hashbaseline=$(head -n 1 commit.txt);
rm commitlist.txt;
git rev-list $hashbaseline..HEAD --oneline > commitlist.txt;

echo $(date '+%Y-%m-%d %H:%M:%S:%s')": get files from the list of commits, see in commitedfiles.txt";
while read commit message
do
    git diff-tree --name-status --no-commit-id -r $commit >> commitedfiles.txt;
done < commitlist.txt;

echo $(date '+%Y-%m-%d %H:%M:%S:%s')": create dummy sfdx project";
sfdx force:project:create -n unpackged --template standard

echo $(date '+%Y-%m-%d %H:%M:%S:%s')": copy files to unpackged folder";
while read status path
do
    if [ $status != "D" ]; then
        mkdir -p "$(dirname "../build/unpackged/$path")";
        cp -r "../$path" "../build/unpackged/$path";
    fi
done < commitedfiles.txt;

#!/bin/bash
branch="master"

echo $(date '+%Y-%m-%d %H:%M:%S:%s')": clean folder: build";
rm -rf build/;
mkdir build;

echo $(date '+%Y-%m-%d %H:%M:%S:%s')": update branch $branch";
git reset --hard;
git checkout $branch;
git pull --force;

echo $(date '+%Y-%m-%d %H:%M:%S:%s')": get commit list from baseline, see baseline.txt and commitlist.txt";
hashbaseline=$(head -n 1 baseline.txt);
rm commitlist.txt;
git rev-list $hashbaseline..HEAD --oneline > commitlist.txt;

echo $(date '+%Y-%m-%d %H:%M:%S:%s')": get files from the list of commits, see in commitedfiles.txt";
while read commit message
do
    git diff-tree --name-status --no-commit-id -r $commit >> commitedfiles.txt;
done < commitlist.txt;

echo $(date '+%Y-%m-%d %H:%M:%S:%s')": create dummy sfdx project";
sfdx force:project:create -n build --template standard

echo $(date '+%Y-%m-%d %H:%M:%S:%s')": copy files to build folder";
while read status path
do
    if [ $status != "D" ]; then
        mkdir -p "$(dirname "build/$path")";
        cp -r "../$path" "build/$path";
    fi
done < commitedfiles.txt;

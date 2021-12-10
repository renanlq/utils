#!/bin/bash
branch="master"
buildpath="build"

echo $(date '+%Y-%m-%d %H:%M:%S:%s')": clean folder: build";
rm -rf $buildpath;
mkdir $buildpath;

# echo $(date '+%Y-%m-%d %H:%M:%S:%s')": update branch $branch";
# git reset --hard;
# git checkout $branch;
# git pull --force;

# echo $(date '+%Y-%m-%d %H:%M:%S:%s')": get commit list from baseline, see baseline.txt and commitlist.txt";
# hashbaseline=$(head -n 1 baseline.txt);
# rm commitlist.txt;
# #git rev-list HEAD -n 1 --oneline > commitlist.txt;
# git rev-list $hashbaseline..HEAD --oneline > commitlist.txt;

# echo $(date '+%Y-%m-%d %H:%M:%S:%s')": get files from the list of commits, see in commitedfiles.txt";
# while read commit message
# do
#     git diff-tree --name-status --no-commit-id -r $commit >> commitedfiles.txt;
# done < commitlist.txt;

# echo $(date '+%Y-%m-%d %H:%M:%S:%s')": create dummy sfdx project";
# sfdx force:project:create -n build --template standard

echo $(date '+%Y-%m-%d %H:%M:%S:%s')": copy files to build folder";
while read status filepath
do

    if [ $status != "D" ]; then   
        if [[ "$filepath" == *\/* ]]; then
            mkdir -p "$(dirname "$buildpath/${filepath%\/*}")"
        fi
        cp -r "../../$filepath" "$buildpath/$filepath"
    else
        #//TODO Add package-destructive.xml
        echo "destructive: $filepath"
    fi
done < commitedfiles.txt;

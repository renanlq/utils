# Salesforce build package from git log

## Sumary
* [Purpose](#purpose)
* [Usage](#usage)
* [Files](#files)
* [Contribution](#Contribution)

## Purpose
Generate build "package" from a list of commits in git log.

## Usage   
1. Add full hash in 'commit.txt' (just 1st line);  
2. Run `bash build.sh`;  
3. Build script will create "unpackaged" folder with a new SFDX project structure with commited files inside it.  
```
!IMPORTANT Remember to run this script in your SFDX repo, due to correct structure to be managed
```

## Results
At the end you will recieve a path with all files that were inside each commit since you baseline configured: 
![image](https://user-images.githubusercontent.com/15347353/137984457-d3f31da5-8adb-4f0d-9c90-5f3275177a83.png)

Files managed: 
1. baseline.txt: Hash that could be your baseline;
2. commitedfiles.txt: List of updated files inside each hash listed in 'commitlist.txt';
3. commitlist.txt: list of commit existed in log repo since hash baseline.

## Contribution
If you want to contribute, please read more about markdown tags to edit README file, [Markdown guide](https://docs.microsoft.com/en-us/vsts/project/wiki/markdown-guidance?view=vsts)

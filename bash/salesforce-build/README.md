# PowerShell Utils

## Sumary
* [Purpose](#purpose)
* [Scripts](#scripts)
* [Contribution](#Contribution)

## Purpose
Generate build "package" from a list of commits in git log.

## Usage 
1. Add full hash in 'commit.txt' (just 1st line);
2. Run `bash build.sh`;
3. Build script will create "unpackaged" folder with a new SFDX project structure with commited files inside it.

Usage of files: 
1. commit.txt: Hash that could be your baseline;
2. commitedfiles.txt: List of updated files inside each hash listed in 'commitlist.txt';
3. commitlist.txt: list of commit existed in log repo since hash baseline.

## Contribution
If you want to contribute, please read more about markdown tags to edit README file, [Markdown guide](https://docs.microsoft.com/en-us/vsts/project/wiki/markdown-guidance?view=vsts)

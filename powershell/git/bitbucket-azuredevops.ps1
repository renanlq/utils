# More info about how to Import a Git repo in Azure Devops, at: 
# - https://docs.microsoft.com/en-us/azure/devops/repos/git/import-git-repository?view=azdevops&tabs=new-nav
# Add public ssh key to Azure DevOps:
# - https://docs.microsoft.com/en-us/azure/devops/repos/git/use-ssh-keys-to-authenticate
# - https://docs.microsoft.com/en-us/azure/devops/repos/git/auth-overview?view=azure-devops

# This repositories need to be previously created on Azure DevOps
$repositories = @("repo1","repo2", "repo3")

# Bitbucket parameters
$bitbucketUsername = "bitbucketUsername"
$bitbucketPassword = "bitbucketPassword" 
$bitbucketProject = "bitbucketProject"

# Azure DevOps parameters
$azureUsername = "azureUsername"
$azureCompany = "azureCompany"
$azureDevOpsProject = "azureDevOpsProject"

$count = 0

Try {

    Foreach ($r in $repositories)
    {
        If(Test-Path -Path "${r}.git") {
            # Remove existing git folder
            Remove-Item .\${r}.git -Force -Recurse
        }

        # Get source from actual repository
        Write-Host "$(Get-Date) - Cloning repo from: https://${bitbucketUsername}@bitbucket.org/${bitbucketProject}/${r}.git"
        git clone --bare https://${bitbucketUsername}:${bitbucketPassword}@bitbucket.org/${bitbucketProject}/${r}.git

        If(-Not (Test-Path -Path "${r}.git")) { 
            Write-Host -Foreground Red "$(Get-Date) - Git folder ${r}.git was not cloned"
            Continue
        }
        Set-Location .\${r}.git

        # Push source to destination repositpry
        Write-Host "$(Get-Date) - Pushing source to: git@ssh.dev.azure.com:v3/${azureCompany}/${azureDevOpsProject}/${r}"
        git push --mirror git@ssh.dev.azure.com:v3/${azureCompany}/${azureDevOpsProject}/${r}      
        $count += 1

        # Remove temp folder
        Write-Host "$(Get-Date) - Removing temporary git folder $r.git"
        Set-Location .\..
        Remove-Item .\${r}.git -Force -Recurse
    }
}
Catch {
    $formatstring = "{0} : {1}`n{2}`n" +
                    "    + CategoryInfo          : {3}`n" +
                    "    + FullyQualifiedErrorId : {4}`n"
    $fields = $_.InvocationInfo.MyCommand.Name, $_.ErrorDetails.Message,
            $_.InvocationInfo.PositionMessage, $_.CategoryInfo.ToString(),
            $_.FullyQualifiedErrorId

    Write-Host -Foreground Red ($formatstring -f $fields)
    Break
}
Finally {
    Write-Host -Foreground Green -Background Black "$(Get-Date) - End of the script. $count processed repositories"
}
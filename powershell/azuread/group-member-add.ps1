# Install the Azure PowerShell module
# httPS:>//docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-1.2.0
# References:
# - https://docs.microsoft.com/en-us/powershell/module/azuread/?view=azureadps-2.0#groups
# - https://docs.microsoft.com/en-us/powershell/module/azuread/?view=azureadps-2.0#users

# Dependencies:
#   Modules: AzureAD
#   Set user environment variable:and see them:
#     PS:> [Environment]::SetEnvironmentVariable("name", "value", "User")
#     PS:> Get-ChildItem env:

# Previous insert user credentials in systen environment variables
$user = "$($env:script_user)"
$pass =  "$($env:script_pass)"

$azgroup = "group-name"
$azusers = @("user01", "user02")
$azemaildomain = "@domain.com"

Try {
    $securepass = $pass | ConvertTo-SecureString -AsPlainText -Force
    $UserCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $user, $securepass
    Connect-AzureAD -Credential $UserCredential

    $adgroup = Get-AzureADGroup -Filter "DisplayName eq '$azgroup'"
    If(-Not $adgroup) { 
        Write-Host -Foreground Yellow "$(Get-Date) - No existing group with name: '$azgroup'"
        Continue
    }

    Write-Host "$(Get-Date) - Get group $azgroup($(($adgroup).ObjectId))"

    Foreach ($u in $azusers)
    {
        $aduser = Get-AzureADUser -ObjectId "$u$azemaildomain"
        If(-Not $aduser) { 
            Write-Host -Foreground Yellow "$(Get-Date) - No existing user for value: '$u$azemaildomain'"
            Continue
        }
        Add-AzureADGroupMember -ObjectId ($adgroup).ObjectId -RefObjectId ($aduser).ObjectId
        Write-Host "$(Get-Date) - Adding $u$azemaildomain($(($aduser).ObjectId))"
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
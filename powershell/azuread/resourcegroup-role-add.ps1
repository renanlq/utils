
# Install the Azure PowerShell module
# httPS:>//docs.microsoft.com/en-us/powershell/azure/install-az-ps?view=azps-1.2.0
# References:
# - https://docs.microsoft.com/en-us/powershell/module/azuread/?view=azureadps-2.0#groups
# - https://docs.microsoft.com/en-us/powershell/module/azuread/?view=azureadps-2.0#users

# Dependencies:
#   Modules: AzureAD, AzureRM and Az.Resources
#   Set user environment variable:and see them:
#     PS:> [Environment]::SetEnvironmentVariable("name", "value", "User")
#     PS:> Get-ChildItem env:

# Previous insert user credentials in systen environment variables
$user = "$($env:script_user)"
$pass =  "$($env:script_pass)"

$azplroles = @("Application Insights Component Contributor", "Monitoring Reader", "Reader", "Reader and Data Access")
$azsrroles = @("API Management Service Contributor", "Cognitive Services Contributor", "Redis Cache Contributor", `
                "Search Service Contributor", "Storage Account Contributor", "Storage Blob Data Contributor", "Website Contributor")
# $azmgroles = @("Application Insights Component Contributor", "Monitoring Reader", "Reader", "Reader and Data Access", "Website Contributor")
# $azadmroles = @("Contributor", "User Access Administrator")
# azadmdataroles = @("SQL Security Manager", "SQL Server Contributor")

# Edit - Subscriptions and resource group childs
$azsubscription = @("subscription-hml","subscription-prd")
$azresourcegroup = @("resourcegroup-rg","resourcegroup-rg")

# Edit - Developers resource group roles and security groups
$azdevplgroup = "azuread-group-pl"
$azdevsrgroup = "azuread-group-sr"

Try {
    $securepass = $pass | ConvertTo-SecureString -AsPlainText -Force
    $UserCredential = New-Object System.Management.Automation.PSCredential -ArgumentList $user, $securepass
    Connect-AzureAD -Credential $UserCredential
    Login-AzureRmAccount -Credential $UserCredential

    $azdevplgroup = Get-AzureADGroup -Filter "DisplayName eq '$azdevplgroup'"
    If(-Not $azdevplgroup) { 
        Write-Host -Foreground Yellow "$(Get-Date) - No existing group for value: '$azdevplgroup'"
        Exit
    }
    $azdevplgroupId = $azdevplgroup."ObjectId"
    $azdevplgroupName = $azdevplgroup."DisplayName"

    $azdevsrgroup = Get-AzureADGroup -Filter "DisplayName eq '$azdevsrgroup'"
    If(-Not $azdevsrgroup) { 
        Write-Host -Foreground Yellow "$(Get-Date) - No existing group for value: '$azdevsrgroup'"
        Exit
    }
    $azdevsrgroupId = $azdevsrgroup."ObjectId"
    $azdevsrgroupName = $azdevsrgroup."DisplayName"

    For ($i = 0; $i -lt $azresourcegroup.Length; $i++) 
    {        
        Set-AzureRmContext -SubscriptionName "$($azsubscription[$i])"
        $resourcegroup = Get-AzureRmResourceGroup -Name "$($azresourcegroup[$i])"

        If(-Not $resourcegroup) { 
            Write-Host -Foreground Yellow "$(Get-Date) - No existing resource group for value: '$($azresourcegroup[$i])'"
            Continue
        }

        Foreach ($pl in $azplroles)
        {
            Write-Host "$(Get-Date) Adding Role '$pl' to '$azdevplgroupName' in '$($azresourcegroup[$i])'"
            New-AzureRmRoleAssignment -ObjectId "$azdevplgroupId" -ResourceGroupName "$($azresourcegroup[$i])" -RoleDefinitionName "$pl"

            Write-Host "$(Get-Date) Adding Role '$pl' to '$azdevsrgroupName' in '$($azresourcegroup[$i])'"
            New-AzureRmRoleAssignment -ObjectId "$azdevsrgroupId" -ResourceGroupName "$($azresourcegroup[$i])" -RoleDefinitionName "$pl"
        }
        Foreach ($sr in $azsrroles)
        {
            Write-Host "$(Get-Date) Adding Role '$sr' to '$azdevsrgroupName' in '$($azresourcegroup[$i])'"
            New-AzureRmRoleAssignment -ObjectId "$azdevsrgroupId" -ResourceGroupName "$($azresourcegroup[$i])" -RoleDefinitionName "$sr"
        }
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

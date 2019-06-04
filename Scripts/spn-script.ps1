##############################################################
# Script is for Service Principal creation
##############################################################

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: spn-script.ps1 - Script Begin *****"

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: spn-script.ps1 - Getting Azure account details *****"
$account_name = 'STORAGE_ACCOUNT_NAME'
$rgName = 'RESOURCE_GROUP_NAME'
$share_name = 'FILE_SHARE_FOLDER_NAME'
$subscriptionId = 'SUBSCRIPTION_ID'
#be sure the azure file share location matches the location of the host
$location = 'LOCATION_OR_REGION'
$spn = 'SERVICE_PRINCIPAL_NAME'
#az cli to create group and share
#az group create -n $rgName -l $location
#az storage account create --resource-group $rgName --name $account_name --location $location
$res = az storage account keys list -g $rgName -n $account_name | ConvertFrom-Json
$account_key = $res[0].value

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: spn-script.ps1 - Creating an Azure Storage file share *****"
###create a file share
az storage share create --name $share_name --account-key $account_key --account-name $account_name

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: spn-script.ps1 - Adding Service Principal*****"
#add a service principal
#https://docs.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli?view=azure-cli-latest
$result = az ad sp create-for-rbac --name $spn --role owner --scopes "/subscriptions/$subscriptionId/resourceGroups/$rgName"
az ad sp list --spn "http://$spn"

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: spn-script.ps1 - Script Ended Successfully *****"
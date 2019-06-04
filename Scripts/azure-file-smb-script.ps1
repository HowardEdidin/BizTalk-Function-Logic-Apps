##############################################################
# Script is for the ISE-VM to create link with Azure Files
##############################################################

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: azure-file-smb-script.ps1 - Script Begin *****"
#make sure to use az cli on the host
#https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-windows?view=azure-cli-latest
#Start-BitsTransfer https://aka.ms/installazurecliwindows .\azure-cli.msi
#.\azure-cli.msi /quiet /norestart
#(we may need a restart)
#shutdown -r

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: azure-file-smb-script.ps1 - Getting Azure account details *****"
#be sure to login with az cli
#az login
#az account set --subscription 'sub id'
#az account show

###run this section on the host
$ErrorActionPreference = "Stop"
$account_name = 'STORAGE_ACCOUNT_NAME'
$rgName = 'RESOURCE_GROUP_NAME'
$share_name = 'FILE_SHARE_FOLDER_NAME'
#https://blogs.technet.microsoft.com/heyscriptingguy/2015/10/08/playing-with-json-and-powershell/
$res = az storage account keys list -g $rgName -n $account_name | ConvertFrom-Json
$account_key = $res[0].value

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: azure-file-smb-script.ps1 - Creating mapping variables *****"
$mapping_remote_target = "\\$account_name.file.core.windows.net\$share_name"
$mapping_local_root = '\LOCAL\FILE-SHARE-WITH-AZURE-FILE\FOLDER\PATH'
$mapping_local_folder = $account_name + '-' + $share_name

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: azure-file-smb-script.ps1 - Making directory for mapping folder *****"
# Ensure root folder exists
mkdir $mapping_local_root -Force

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: azure-file-smb-script.ps1 - Get-SmbMapping *****"
# Only create the SMB global mapping if it doesn't already exist
#open port 445 if host isn't on Azure
# netsh advfirewall firewall add rule name="Open Port 445" dir=out action=allow protocol=TCP localport=445
$mapping = Get-SmbMapping -RemotePath $mapping_remote_target -ErrorAction SilentlyContinue

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: azure-file-smb-script.ps1 - Checking if mapping exists... *****"
if (!$mapping) {
    
    $retryCount = 0

    while ($true)
    {
        Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: azure-file-smb-script.ps1 - Mapping doens't exist *****"

        $acctKey = ConvertTo-SecureString -String $account_key -AsPlainText -Force
        $credential = New-Object System.Management.Automation.PSCredential -ArgumentList "Azure\$account_name", $acctKey
        New-SmbMapping -RemotePath $mapping_remote_target -password $account_key -username "Azure\$account_name"
        Start-Sleep -s 5
        $mapping = Get-SmbMapping -RemotePath $mapping_remote_target -ErrorAction SilentlyContinue

        if ($mapping)
        {
            Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: azure-file-smb-script.ps1 - Created new smb-mapping *****"
            Break
        }
        
        $retryCount++;
        if ($retryCount -eq 10)
        {
            Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: azure-file-smb-script.ps1 - ERROR creating new smb-mapping after 10 retries *****"
            Break
        }
    }
}

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: azure-file-smb-script.ps1 - Pushd mapping_local_root *****"
# Creating a directory symlink from PowerShell doesn't work with absolute paths, so we'll hop into the root folder
pushd $mapping_local_root

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: azure-file-smb-script.ps1 - Linking file share folder to local folder *****"
# Link remote file share to local folder under D:\smbmappings
New-Item -ItemType SymbolicLink -Name $mapping_local_folder -Target $mapping_remote_target -Force

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: azure-file-smb-script.ps1 - popd *****"
popd

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: azure-file-smb-script.ps1 - ACL *****"
$sharepath = "$mapping_local_root\$mapping_local_folder"
$Acl = Get-ACL $SharePath
$AccessRule= New-Object System.Security.AccessControl.FileSystemAccessRule("everyone","full","ContainerInherit,Objectinherit","none","Allow")
$Acl.AddAccessRule($AccessRule)
Set-Acl $SharePath $Acl
$acl

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: azure-file-smb-script.ps1- Script Ended Successfully *****"

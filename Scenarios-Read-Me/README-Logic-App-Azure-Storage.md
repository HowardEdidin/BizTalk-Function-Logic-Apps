# Logic App with Azure File Storage from On-Prem VM

## Requirements
1. VM (Windows Server 2016) on the ISE VNet  
   - Make sure it's discoverable by other networks
1. VM (Windows Server 2016) on the on-prem VNet  
   - Make sure it's discoverable by other networks
1. [Azure Storage Account on the ISE VNet](https://docs.microsoft.com/en-us/azure/storage/common/storage-network-security)  
   - Make sure that the four ISE subnets are added to the list of virtual networks that are allowed to access Azure Storage
1. [Azure Storage Explorer](https://azure.microsoft.com/en-us/features/storage-explorer/)
1. Powershell Scripts  
   -  spn-script.ps1
   - on-prem-smb-script.ps1
   - azure-file-smb-script.ps1
   - copy-script.ps1

## Set-up

### Creating Event Logs  
  All logs from the scripts will be logged in Event Logs
1. Connect to the ISE VM
1. In Powershell run `New-EventLog -LogName LOG_NAME -Source "SOURCE_NAME"`
1. To verify the Event Log was created successfully, run `Get-EventLog *` and the newly created Event Log should appear on the list
1. To write an Event Log, run  
```Write-EventLog -LogName LOG_NAME -Source "SOURCE_NAME" -EntryType Information -EventId 1 -Message "EVENT_MESSAGE_HERE    "```
1. To see your logs, open Event Viewer and look for your log name in `Applications and Services Logs`

### Running Scripts
1. Connect to the ISE VM
1. In Powershell, log on to Azure with `az login --use-device-code`
1. Set your Azure Subscription with `az account set --subscription SUBSCRIPTION_ID` and verify with `az account show`
1. Once you've successfully set-up your Azure credentials on Powershell, run the following scripts:
   - `spn-script.ps1`  
   This script is for creating Azure Storage File Share and Service Principal  
   **\*Note**: Before running the script, make sure you replace the temporary values in the script with your desired values  
   To verify that the script ran successfully:  
      1. Open Azure Storage Explorer and look for your storage account and go to the File Share section.  
      1. Verify that the folder you created from script exists.  
   - `on-prem-smb-script.ps1`   
   This script is for the ISE VM to access the folder on on-prem-VM  
   **\*Note**: Before running the script, make sure you create a file-share folder on the on-prem VM and replace the temporary values in the script with your desired values
   To verify that the script ran successfully:  
      1. Make sure that the file-share folder has been created on the ISE VM.
      1. Connect to the on-prem VM and open the file-share folder. Create a folder/file inside the file-share folder.
      1. Verify that you can see the same file/folder on the ISE VM's file-share folder.
   - `azure-file-smb-script.ps1`   
   This script is for the ISE VM to create link with Azure Files.  
   **\*Note**: Before running the script, make sure you replace the temporary values in the script with your desired values  
   To verify that the script ran successfully:  
      1.  Open the local file-share folder with Azure File Share and create a folder/file inside the folder.
      1. Verify that you can see the same file/folder on Azure Storage Explorer.

### Task Scheduler

#### Verifying copyscript.ps1
1. Before creating a task on Task Scheduler, run the `copyscript.ps1` first to ensure that the script works
1. If the script works as expected, it should copy over folders and files from the file-share folder with the on-prem VM to the file-share folder with Azure File Share

#### Creating Task on Task Scheduler
1. On the ISE VM, open Task Scheduler
1. On the right side, click on "Task Scheduler Library" and you'll see "Actions" for Task Scheduler Library on the right side
1. Click on "Create Task..."
1. In the "General" tab,  
   - Name your task  
   - Check the box "Run whether user is logged in or not"
   - Check the box "Run with highest privileges"
1. In the "Triggers" tab, click on "New..." to create a trigger 
1. In the "Actions" tab, click on "New..." and fill in the values:  
   - Action: "Start a program"
   - Program/script: Look for powershell.exe (usually it's in C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe)
   - Add arguments (optional): `-Command "& 'PATH\TO\SCRIPT\copyscript.ps1'"` (take note of the single and double quotes)  
   - Start in (optional): `PATH\TO\SCRIPT`
1. Click on "Ok" to create the task
1. To run the task, click on the tast created and hit "Run" on the right side
1. To verify that the task runs the script as expected, create a folder/file in the file-share folder with the on-prem VM and run the task
1. If the task ran successfully, you should see a copy of the folder/file created on the file-share folder with Azure File Share

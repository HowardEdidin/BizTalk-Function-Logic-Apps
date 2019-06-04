Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: copy-script.ps1 - Script Begin *****"

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: copy-script.ps1 - Calling on-prem-smb-script.ps1 *****"
powershell C:\Users\sqlserveradmin\Desktop\scripts\on-prem-smb-script.ps1

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: copy-script.ps1 - Calling azure-file-smb-script.ps1 *****"
powershell C:\Users\sqlserveradmin\Desktop\scripts\smblink.ps1

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: copy-script.ps1 - Start-sleep for 10 seconds for azure-file-smb-script.ps1 to finish running *****"
Start-Sleep -s 10

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: copy-script.ps1 - Copying files from on-prem-smb folder to azure-file-folder *****"
cp -r \LOCAL\FILE-SHARE-WITH-ON-PREM\FOLDER\PATH\* \LOCAL\FILE-SHARE-WITH-AZURE-FILE\FOLDER\PATH -force

Write-EventLog -LogName LogApp -Source "Log Script" -EntryType Information -EventId 1 -Message "***** Running Script: copy-script.ps1 - Script Ended Successfully *****"
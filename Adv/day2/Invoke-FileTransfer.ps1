<#
Invoke-FileTransfer takes *all* the files in a source folder and copies them to a destination folder on a remote server
- $Source must be an existing folder, not a file or it won't pass validation
- $Destination must be a valid path and contain a ":"
- $RemoteServers is an optional list of servers to copy the data to. If this is unused it uses the local machine.
- $Force will overwrite existing data in the destination

Output is an arrayList including destinations and paths for transferred files
#>
Function Invoke-FileTransfer {
    Param(
        [String][parameter(Mandatory)][ValidateScript({Test-Path -path $_ -PathType container})]$Source,
        [String][parameter(Mandatory)][ValidateScript({$_ -match ":"})]$Destination,
        [String[]][ValidateNotNullOrEmpty()]$RemoteServers,
        [Switch]$Force
        )

    #This list will contain all the destination paths and files transferred
    [System.Collections.ArrayList]$FilesTransferred  = @()

    if ($RemoteServers) {
        foreach ($RemoteServer In $RemoteServers) {
            #Check connection to the remote server
            if(!(Test-Connection -ComputerName $RemoteServer -Quiet)){
                Write-Warning "Could not connect to $RemoteServer"
                continue
            }

            $session = New-PSSession -ComputerName $RemoteServer
            $Transferred  = Copy-Item -Path $Source -Destination $Destination -ToSession $session -Force:$Force -PassThru -Recurse -ErrorAction Stop
            $FilesTransferred.add("Destination Server: $RemoteServer `nFrom: $Source `nTo: $Destination") | out-null
            $FilesTransferred.add($Transferred.fullname) | out-null
            $session | Remove-PSSession
        }
    }
    else { #use the local machine
        $Transferred = Copy-Item -Path $Source -Destination $Destination -Force:$Force -PassThru
        $FilesTransferred.add($Transferred) | out-null
    }

    $FilesTransferred
}

Set-StrictMode -Version Latest
Invoke-FileTransfer -Source 'C:\PShell\Labs\Test' -Destination 'C:\Temp' -RemoteServers MS,DC -force

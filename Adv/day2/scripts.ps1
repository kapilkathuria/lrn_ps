# Import the ServerInfo class from server.ps1
. "C:\path\to\server.ps1"

# List of server names
$servers = @("Server1", "Server2", "Server3")

# Loop through each server and gather information
foreach ($server in $servers) {
    try {
        # Create a new instance of ServerInfo for the remote server
        $serverInfo = [ServerInfo]::new()
        
        # Display the information
        Write-Host "Gathering information for $server..."
        $serverInfo.DisplayInfo()
    } catch {
        Write-Host "Failed to gather information for $server : $_"
    }
}
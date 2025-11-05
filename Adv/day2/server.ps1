# Create class to gather information about the server
class ServerInfo {
    [string]$Hostname
    [string]$OS
    [string]$Architecture

    ServerInfo() {
        $this.Hostname = $env:COMPUTERNAME
        $this.OS = (Get-WmiObject -Class Win32_OperatingSystem).Caption
        $this.Architecture = (Get-WmiObject -Class Win32_OperatingSystem).OSArchitecture
    }

    [void] DisplayInfo() {
        Write-Host "Hostname: $($this.Hostname)"
        Write-Host "Operating System: $($this.OS)"
        Write-Host "Architecture: $($this.Architecture)"
    }
}
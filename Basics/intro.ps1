# Check version
$PSVersionTable

# get all the verbs
Get-Verb | more
Get-Verb -verb set

# common parameters
Get-Service -Name app*
Get-Service -Name AppMgmt | Select-Object *

# help
Get-Help get-acl
Get-Help about*

# alias
gsv app*

# 3 commands
Get-Command -Name *service*
Get-Member
Get-Help get-verb
# examples
get-help get-service -examples
Get-Service | Get-Member
Get-Command -verb get -noun *service*
# get all command in module
Get-Command -Module Microsoft.PowerShell.Utility

# Alias
ip
New-Alias -Name ip -Value Get-NetIPAddress
ip

# get-member examples
Get-Service -Name App* | Where-Object Status -EQ "Stopped" | Format-Table
Get-Service -Name App* | Where-Object Status -EQ "Stopped" | Start-Service

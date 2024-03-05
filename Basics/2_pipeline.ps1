Get-Service | Get-Member
Get-Service | Select-Object Name, Status | Get-Member
Get-Service | Where-Object Status -EQ "stopped" | gm
(Get-Service | Where-Object Status -EQ "stopped").count

# formatting
Get-Service | Format-Table -AutoSize
Get-Service | Format-List

# variables
Get-Variable
Get-ChildItem env:
Get-ChildItem Env:\ALLUSERSPROFILE
$service = Get-Service
$service
$service | Where-Object -Property Status -EQ stopped

# write-host vs write-output
# write-output has output as object
# double vs single quote - in double quote - variable value is used
Write-Host "$ENV:ALLUSERSPROFILE"
Write-Host '$ENV:ALLUSERSPROFILE'
Write-Output ""

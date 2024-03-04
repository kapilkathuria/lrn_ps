# my computer name- WW4

# Lab 1 - 
# Review PowerShell remoting requirements.
# Test for PowerShell remoting.
# Enable PowerShell Remoting.
# Working with PowerShell Remoting.

# Get-Command -ParameterName ComputerName

Get-Service WinRM | Select-Object *

# to enable 
Enable-PSRemoting
# you can also try this in case above is not working
Set-WSManQuickConfig -Force

# runnin on remot machine
Invoke-Command -ComputerName DC, MS -ScriptBlock {Get-ChildItem -Path C:\}

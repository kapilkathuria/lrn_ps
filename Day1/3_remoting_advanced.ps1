# cmdlets using computername or session as paramert
Get-Command -ParameterName "*ComputerName*"
Get-Command -ParameterName "*Session*"

# non persistant session
Invoke-Command -ComputerName MS -ScriptBlock {$var = 123}
Invoke-Command -ComputerName MS -ScriptBlock {$var}

# persistent session
$s = New-PSSession -ComputerName MS
Invoke-Command $s -ScriptBlock {$var=123}
Invoke-Command $s -ScriptBlock {$var}

# To remove persistant session
Remove-PSSession $s
# Disconnect
Disconnect-PSSession

# Session lifecycle


# Disconnected sessions
Get-PSSession
Connect-PSSession -Session $s
$ses = Get-PSSession -Id 11
Receive-PSSession -Session $ses


# implicit remoting
$dcsess = New-PSSession -ComputerName DC
Invoke-Command -Session $dcsess -ScriptBlock {Import-Module ActiveDirectory -Prefix 2016DC}


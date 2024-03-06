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

# get connected session
Get-PSSession 

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


# trusted hosts
Get-ChildItem WSMan:\localhost\Client\TrustedHosts
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value "DC"
Set-Item -Path WSMan:\localhost\Client\TrustedHosts -Value "Client01, Client02" -Concatenate


## Workng with credential
$pass = Read-Host -Prompt Password -AsSecureString

$cred = Get-Credential

$cred = New-Object pscredential -ArgumentList $userName, $SecurePassword
# $SecurePassword is in secure string format.

# convert from securestring to encrypted
ConvertFrom-SecureString -SecureString $pass
# to use convert from encrypted to securestring 
$SecureString = $EncryptedPlainPassword | ConvertTo-SecureString 
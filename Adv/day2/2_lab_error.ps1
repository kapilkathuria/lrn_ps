# Exercise 1: Non-Terminating Errors
'C:\windows','C:\fakefolder','C:\users' | Get-Item

Get-Help About_redirection -ShowWindow

'C:\windows','C:\fakefolder','C:\users' | Get-Item 2>> Save-Errors.txt 1>> Save-Output.txt

$Error[0]

Get-Item C:\FakeFile

$Error[0].Exception | get-member
$Error[0].Exception.Message

$Error.Clear()

Test-Connection fakeserver -Count 1 -ErrorVariable myError
$myError[0].Exception.Message

# Append error in variable
Test-Connection fakeserver -Count 1 -ErrorVariable +myError
$myError.Count


# Task 1.4: $ErrorActionPreference and $WarningPreference
Get-Help about_Preference_Variables -showWindow

# Exercise 2: Terminating Errors
Function ProcessUserFile
{
    Param($UserFile=$(throw "ERROR:`n`tPlease specify a Comma Separated Value file that contains the user data to process`n"))
    
    $users = Import-Csv $UserFile

    foreach ($user in $users){
        
        Write-Host "Adding User: $($User.Name)..."

        $user | New-ADUser -Enabled $true

    }
    
    Write-Host "Processing Complete"
}
ProcessUserFile 
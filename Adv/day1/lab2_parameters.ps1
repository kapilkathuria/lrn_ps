Function New-AccountName {
    param([parameter(Mandatory)]$AccountName)
    $UniqueName = $AccountName
    $count = 1
    While ([bool](Get-Aduser -filter { SamAccountName -eq $UniqueName })) {
        $UniqueName = $AccountName + $count
        $Count++
    }
    if ($UniqueName -ne $AccountName) {
        Write-Warning "$AccountName already exists, using $UniqueName instead"
    }
    $UniqueName
}

Function New-ContosoUser {
    [cmdletbinding(SupportsShouldProcess)]
    [alias("New-CUser","NCU")]
    param(
        [parameter(
            ParameterSetName = "CSV",
            Mandatory,
            HelpMessage = "Provide the path to a CSV file that contains at least NAME as a header",
            ValueFromPipeline = $true)]
            [alias("FileName","InputFile")]
            [ValidateScript( { Test-Path $_ })]$csv,
        [parameter(ParameterSetName = "User",
            Mandatory,
            HelpMessage = "An account name is required for a new user",
            ValueFromPipeline = $true,
            position = 0)]
            [alias("Name")]
            [ValidateLength(3, 12)]$AccountName,
        [parameter(ParameterSetName = "User")]$FirstName,
        [parameter(ParameterSetName = "User")]$LastName,
        [parameter(ParameterSetName = "User")]$Title,
        [parameter(ParameterSetName = "User")]$City,
        [parameter(ParameterSetName = "User")]$EmployeeNumber
    )

    process{
        if ($PSCmdlet.ParameterSetName -eq "CSV") {
            $Users = Import-Csv $csv
        }
        elseif ($PSCmdlet.ParameterSetName -eq "User") {
            $users = [pscustomobject]@{
                Name           = $AccountName
                FirstName      = $FirstName
                LastName       = $LastName
                Title          = $Title
                City           = $City
                EmployeeNumber = $EmployeeNumber
            }
        }
        foreach ($user in $users) {
            $User.Name = New-AccountName -AccountName $User.Name
            if ($PSCmdlet.ShouldProcess($User.Name, "Adding user")) {
                $user | New-ADUser
                Write-Verbose "Adding User: $($User.Name)..."
            }
        }
    }
}

function Get-LabUsers {
    param([int]$Hours = 6)
    $Created = (Get-Date).AddHours(-$Hours)
    Get-Aduser -filter { WhenCreated -gt $Created } | select Name
}

function Remove-LabUsers {
    param([int]$Hours = 6)
    $Created = (Get-Date).AddHours(-$Hours)
    Get-Aduser -filter { WhenCreated -gt $Created } | Remove-ADUser -Confirm:$false -Verbose
}

# New-AccountName -AccountName Kapil
# New-ContosoUser -csv C:\PShell\Labs\NewEmployees.csv
Get-LabUsers
Remove-LabUsers
# "C:\PShell\Labs\NewEmployees.csv" | New-ContosoUser

# "C:\PShell\Labs\NewEmployees.csv", "C:\PShell\Labs\NewEmployees2.csv", "C:\PShell\Labs\NewEmployees3.csv" | New-ContosoUser

# New-ContosoUser -AccountName "MyNewUser"
# New-ContosoUser -csv "C:\PShell\Labs\NewEmployees.csv" -Verbose

New-CUser -FileName "C:\PShell\Labs\NewEmployees.csv" -Verbose
NCU -Name "AnotherUser" -FirstName "Another" -LastName "User" -Title "Intern" -City "Redmond" -EmployeeNumber "1004" -Verbose

# Task 1.5: Fixing Positional Binding
# Added position = 0 in New-ContosoUser
New-ContosoUser "PositionalUser" -FirstName "Positional" -LastName "User" -Title "Intern" -City "Redmond" -EmployeeNumber "1005" -Verbose


# Exercise 2: Validating Parameter Input

# This shouldn't work
New-ContosoUser -csv "C:\PShell\Labs\WrongEmployees.csv"
New-ContosoUser -AccountName NewLongAccountName

# This should work
New-ContosoUser -csv "C:\PShell\Labs\NewEmployees.csv"
New-ContosoUser -AccountName John
Get-LabUsers
Remove-LabUsers


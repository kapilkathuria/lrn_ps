Function New-AccountName {
    param($AccountName)

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
    param($csv)
    $Users = Import-Csv $csv
    foreach ($user in $users) {
        $User.Name = New-AccountName -AccountName $User.Name
        if ($PSCmdlet.ShouldProcess($User.Name, "Adding user")) {
            $user | New-ADUser -Confirm:$False
            Write-Verbose "Adding User: $($User.Name)..."
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
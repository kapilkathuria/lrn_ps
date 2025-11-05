Function Get-ServiceReport {
    $services = Get-Service x*
    $report = New-Object -TypeName System.Collections.ArrayList
    for ($i = 0; $i -le $services.count; $i++) {
        $obj = [pscustomobject]@{
            ReportID      = $i
            Name          = $Services[$i].DisplayName
            CurrentStatus = $Services[$i].Status
            Mode          = $Services[$i].StartType
        }
        $report.add($obj) | Out-Null
    }

    $report | Out-GridView
}

Get-ServiceReport
Function Round-Number {
    Param ($Number, $Digits = 2)
    [math]::Round($Number, $Digits)
}

Function Convert-KbToGb {
    param($Kb)
    $Bytes = $kb*1kb
    Round-Number ($Bytes / 1gb)
}

Function Get-DiskReport {
    param()
    $Disks = Get-CimInstance -ClassName Cim_logicaldisk
    foreach ($Disk in $Disks) {
        $FreeSpace = Round-Number ($Disk.Freespace / 1gb)
        [PSCustomObject]@{
            DiskName     = "$($Disk.DeviceID) ($($Disk.VolumeName))"
            Freespace    = $FreeSpace
        }
    }
}

Function Get-RamReport {
    param()
    $OSInfo = Get-CimInstance -ClassName Cim_Operatingsystem
    $TotalMemoryGB = Convert-KbToGb $OSInfo.TotalVisibleMemorySize
    $FreeMemoryGB = Convert-KbToGb $OSInfo.FreePhysicalMemory
    $PercentMemoryFree = "{0:P}" -f ($FreeMemoryGB / $TotalMemoryGB)

    [PSCustomObject]@{
        "Memory" = $TotalMemoryGB
        "Available Memory" = "$FreeMemoryGB gb ($PercentMemoryFree)"
    }
}

Function Get-ComputerReport {
    param()

    $OSInfo = Get-CimInstance -ClassName win32_Operatingsystem

    $RamReport = Get-RamReport

    $Finalreport = [ordered]@{
        "Machine Name" = $env:COMPUTERNAME.ToUpper()
        "Operating System" = $($OSInfo.Caption)
        "Processor" = $Env:PROCESSOR_IDENTIFIER
        "Memory" = $RamReport.Memory
        "Available Memory" = $RamReport."Available Memory"
        "PowerShell Version" = $PSVersionTable.PSVersion
    }

    foreach($Disk in Get-DiskReport){
        #SIMPLER $Finalreport.Add($Disk.DiskName, "$($Disk.FreeSpace) gb Free")
        $Space = "{0,-7} gb Free" -f $Disk.FreeSpace
        $Finalreport.Add($Disk.DiskName, $Space)
    }

    [PSCustomObject]$Finalreport
}

Get-ComputerReport

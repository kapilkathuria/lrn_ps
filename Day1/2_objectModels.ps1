get-help about_objects

# get type
$datetime = Get-Date
$datetime.GetType()

$datetime | Get-Member
Get-Member -InputObject $datetime
$datetime.DayOfYear
$datetime.AddDays(5)

# get static properties
# static properties are the one for which you are not required to created object
$datetime | Get-Member -Static
[datetime]::IsLeapYear(2024)

# New PS Object
$obj = New-Object -TypeName psobject
$obj | Get-Member
$obj.GetType()

# calculated properties - 


# Adding properties via hashtables
$hashTable = @{
  Name = $env:USERNAME
  Language = "powershell"
  Version = $PSVersionTable.PSVersion.Major
}
$hashTable
$obj = New-Object -TypeName psobject -Property $hashTable
$obj | Get-Member
$obj.Version

$os = Get-WmiObject win32_operatingSystem
$bios = Get-WmiObject win32_bios
$prop = @{
  Buildnumber = $os.Buildnumber
  Version = $os.Version
  # Org = $os.Organization
  Manufactor = $bios.Manufactor
  SerialNumber = $bios.SerialNumber
}

$obj = New-Object -TypeName psobject -Property $prop
$obj.SerialNumber
$obj.Buildnumber

# COM Object
$wordapp = New-Object -ComObject word.Application
$wordapp | Get-Member
$doc = $wordapp.Documents.Add()
$doc | Get-Member
$doc.Content.Text = "Hello, written with PS"
$doc.SaveAs("C:\temp\docWithPS.docx")

## anoter example
$wshshell = New-Object -ComObject wscript.shell

# How to search COM classes
$Allcom =  Get-ChildItem -path HKLM:\Software\Classes | Where-Object -FilterScript `
 {
     $_.PSChildName -match '^\w+\.\w+$' -and (Test-Path –Path `
     "$($_.PSPath)\CLSID")
 }
 $Allcom.Count


 # GET CIM Class
Get-CimClass -ClassName Win32_Process

Get-CimInstance -ClassName Win32_LogicalDisk
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "drivetype=3" -Property Name, FreeSpace, Size

$systeminfo = Get-CimInstance -ClassName CIM_ComputerSystem
$systeminfo

# Remote CIM
Get-CimInstance -ClassName Win32_BIOS -ComputerName RemoteMachine

# WMI - almost similar to  CIM
Get-WmiObject -List
Get-WmiObject -Class win32_computersystem
Get-WmiObject -Class win32_Processor

# WMI vs CIM
Get-WmiObject -Query "select * from Win32_share"
Get-CimInstance -Query "select * from Win32_share"
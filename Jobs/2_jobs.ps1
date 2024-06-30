Get-Command -noun 'Job'

# start the job
Start-Job -ScriptBlock {Get-Process}

Get-WmiObject -Class win32_service -Filter "Name = Spooler" -AsJob

$session = New-PSSession -ComputerName MS
Invoke-Command -ScriptBlock {Get-Service -Name Spooler} -AsJob -Session $session

# to see the result
$result = Receive-Job -Id 1
$result

# 
Get-Job

# backgroun job
# Start-Job
# Stop-Job
# Wait-Job
# Remove-Job

Start-Job -ScriptBlock {Get-ChildItem "C:\" -Recurse}
Start-Job -FilePath 'C:\temp\installed software.TXT'

# working with job objects
Get-Job -IncludeChildJob

# errors
Start-Job -ScriptBlock {Get-Service -Name Test}
$job = Get-Job -Id 5
$job
$job.ChildJobs[0]
$job.ChildJobs[0].Error
$job.Error


# managing job
Stop-Job
Remove-Job
Suspend-Job
Resume-Job
Wait-Job

# get-job is not object
Get-Job | Receive-Job | Get-Member

# remote job
Invoke-Command -AsJob -ScriptBlock {}
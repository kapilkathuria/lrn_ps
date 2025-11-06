# Powershell runspace
# PowerShell runspaces can be leveraged to create additional process threads and run work in parallel.
# This allows for long running code to run concurrently, which uses more system resources, but completes
# in less overall time.

$PSInstance = [powershell]::Create()
$PSInstance.AddScript({"Hello World"})
$result = $PSInstance.Invoke()
$result

# above runs synchronously, below runs asynchronously
$asyncResult = $PSInstance.BeginInvoke()
# Wait for the runspace to complete
$PSInstance.EndInvoke($asyncResult)
# Output the result
$result = $PSInstance.Invoke()
$result

# Clean up
$PSInstance.Dispose()

# Get runspace
Get-Runspace

# Add script example
$PSInstance = [powershell]::Create()
$PSInstance = [powershell]::Create().AddScript({
    param($name)
    # Output a greeting message
    "Hello, $name! The current date and time is: $(Get-Date)"
}).AddParameter("name", "PowerShell User")

# Add command example
$PSInstance = [powershell]::Create()
$PSInstance.Commands.AddCommand("Get-Date").AddParameter("Format", "F")
$PSInstance.Invoke()

# Clean up
$PSInstance.Dispose()

# Async example
$PSInstance = [powershell]::Create()
$PSInstance.AddScript({Start-Sleep -Seconds 10; "Task Completed"})
$asyncResult = $PSInstance.BeginInvoke()
# Do other work here if needed
# Check if completed
$asyncResult.IsCompleted

# retrieve result
$PSInstance.EndInvoke($asyncResult)

# Clean up
$PSInstance.Dispose()

# Mutual excludion / Mutexes
# only one thread can access a resource at a time
$mutex = New-Object System.Threading.Mutex($false, "Global\MyUniqueMutexName")
if ($mutex.WaitOne(0)) {
    try {
        # Critical section
        Write-Output "Accessing shared resource..."
        Start-Sleep -Seconds 5
        Write-Output "Done."
    } finally {
        $mutex.ReleaseMutex()
    }
} else {
    Write-Output "Another instance is already running."
}

# Clean up
$mutex.Dispose()

# 
$InitalState = [initialsessionstate]::CreateDefault()

$var = [System.Management.Automation.Runspaces.SessionStateVariableEntry]::new("MyVar", "Hello from Runspace", "A variable in the runspace")
$InitalState.Variables.Add($var)
$powershellInstance = [powershell]::Create($InitalState)
$powershellInstance.AddScript({ $MyVar })
$powershellInstance.Invoke()
$powershellInstance.Dispose()

# PowerShell Session Configuration Sample File
New-PSSessionConfigurationFile -Full -Path ".\MySessionConfig.pssc"

# create runspace with session config
$iss = [initialsessionstate]::CreateFromSessionConfigurationFile(".\MySessionConfig.pssc")
$iss
$psInstance = [powershell]::Create($iss)


# Runspace pools
# Create a runspace pool with a minimum of 1 and a maximum of 5 runspaces
# This helps keeps resource usage under control
# See slide 27 in deck 
$runspacePool = [runspacefactory]::CreateRunspacePool(1, 5)
$runspacePool 
$runspacePool.Open()
[System.Collections.ArrayList]$runSpaceList = @()

foreach ($instance in 1..10) {
    $ps = [powershell]::Create()
    $ps.RunspacePool = $runspacePool
    $ps.AddScript({
        param($num)
        Start-Sleep -Seconds (Get-Random -Minimum 1 -Maximum 5)
        "Runspace $num completed."
    }).AddParameter("num", $instance)
    $runSpaceList.Add([PSCustomObject]@{
        InstanceNumber = $instance
        PowerShell    = $ps
        AsyncResult   = $ps.BeginInvoke()
    })
}

# Wait for all runspaces to complete
foreach ($runspace in $runSpaceList) {
    $runspace.PowerShell.EndInvoke($runspace.AsyncResult)
    $result = $runspace.PowerShell.Invoke()
    $result
    $runspace.PowerShell.Dispose()
}


# Multithreading on Powershell 7
# Using ForEach-Object -Parallel
$items = 1..10
$items | ForEach-Object -Parallel {
    Start-Sleep -Seconds (Get-Random -Minimum 1 -Maximum 5)
    "Item $_ processed."
} -ThrottleLimit 5
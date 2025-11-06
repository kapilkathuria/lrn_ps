# Powershell runspaces
# PowerShell runspaces can be leveraged to create additional process threads and run work in parallel. 
# This allows for long running code to run concurrently, which uses more system resources, but completes 
# in less overall time.

# Module Objective
# After completing this module, you will be able to:
# Explore runspace classes, methods, and properties
# Create and initialize runspaces
# Invoke scripts in runspaces asynchronously
# Use runspace pools


# Exercise 1: Working With Runspaces
# Objectives
# After completing this exercise, you will be able to:

# Create and initialize a runspace
# Add commands to a runspace
# Input parameters to a runspace
# Invoke a runspace Synchronously
# Invoke a runspace Asynchronously

# # Create and initialize a runspace
# $runspace = [powershell]::Create().AddScript({
#     param($name)
#     # Output a greeting message
#     "Hello, $name! The current date and time is: $(Get-Date)"
# }).AddParameter("name", "PowerShell User")

# # Invoke the runspace synchronously
# $result = $runspace.Invoke()
# # Output the result
# $result
# # Clean up
# # $runspace.Dispose()

# # Invoke the runspace asynchronously
# $asyncResult = $runspace.BeginInvoke()
# # Wait for the runspace to complete
# $runspace.EndInvoke($asyncResult)
# # Output the result
# $result = $runspace.Invoke()
# $result

# # Clean up
# $runspace.Dispose()

# Another way
$runspace2 = [powershell]::Create()
$scriptBlock = {
    param($name)
    Get-Service -Name $name
    Write-Verbose "Service $name retrieved." -Verbose
    Start-Sleep -Seconds 2
}
$runspace2.AddScript($scriptBlock).AddParameter("name", "wuauserv")
$runspace2.Commands | Get-Member
$runspace2.Commands.Commands
$runspace2.Commands.Commands.parameters

$result = $runspace2.Invoke()
$result

# Task 1.2: Invoke PowerShell command synchronously and asynchronously
# Get all runspaces
Get-Runspace
$asyncResult = $runspace2.BeginInvoke()
$asyncResult
$runspace2.Streams
$runspace2.EndInvoke
$runspace2.EndInvoke($asyncResult)
$asyncResult

# Clean up
$runspace2.Dispose()

# Exercise 2: Using the runspace factory class to orchestrate runspaces
# Objectives
# After completing this exercise, you will be able to:

# Utilize the runspace factory class to orchestrate multiple runspaces
# Retrieve output from runspaces that are part of a runspace factory
# Create runspaces for different use case scenarios.
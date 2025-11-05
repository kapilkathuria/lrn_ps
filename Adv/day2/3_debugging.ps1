# Debugging introduction - Breakpoints, writing to console or logs, debugger, call stack

# Example PowerShell script with intentional errors for debugging practice
function Get-ServiceInfo {
    param (
        [string]$servicename
    )

    # Intentional error: Using a non-existent cmdlet
    $service = Get-Service -Name $servicename

    if ($null -eq $service) {
        Write-Host "service not found: $servicename"
        return
    }

    # Intentional error: Accessing a non-existent property
    Write-Host "Service Display Name: $($service.DisplayName)"
}
# Call the function with a test username
Get-ServiceInfo -servicename Wcmsvc

# Call stack
function OuterFunction {
    InnerFunction
}
function InnerFunction {
    throw "An error occurred in InnerFunction"
}
OuterFunction
# To debug, you can set breakpoints using Set-PSBreakpoint or use the PowerShell ISE or VSCode debugger.

# $PSDebugContext

# Useful cmdlets for debugging:
# Set-StrictMode
# Trace-Command
# Set-PSDebug

trace-command -Name ParameterBinding -Expression { Get-ServiceInfo -servicename "Wcmsvc" } -PSHost
trace-command -Name TypeConversion -Expression { Get-ServiceInfo -servicename "Wcmsvc" } -PSHost


# Set-psdebug 
# turns script debugging on. Sets the tracel level and toggles strict mode.. Enable step mode
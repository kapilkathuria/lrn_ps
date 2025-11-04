# Parameter attribute
# create function with manatory parameter, positional parameter, parameterSetName
function Test-Parameters {
    [CmdletBinding(DefaultParameterSetName = 'Set1')]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$MandatoryParam,

        [Parameter(Position = 1, ParameterSetName = 'Set1')]
        [int]$PositionalParam1,

        [Parameter(Position = 1, ParameterSetName = 'Set2')]
        [string]$PositionalParam2
    )

    switch ($PSCmdlet.ParameterSetName) {
        'Set1' { "Mandatory: $MandatoryParam, Positional1: $PositionalParam1" }
        'Set2' { "Mandatory: $MandatoryParam, Positional2: $PositionalParam2" }
    }

    Write-Host "Parameter Set: $($PSCmdlet.ParameterSetName)" -ForegroundColor Green
}

Test-Parameters -MandatoryParam "Test" -PositionalParam1 10

Get-Command Test-Parameters -Syntax
Get-Command Test-Parameters | Select-Object -ExpandProperty Parameters

# Value from pipeline and value from property
function Test-PipelineParameter {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string]$Name
    )

    process {
        Write-Host "Name: $Name" -ForegroundColor Cyan
    }
}

"Hello", "World" | Test-PipelineParameter

# Value from pipeline by property name
function Test-PipelineParameter {
    param (
        [Parameter(ValueFromPipelineByPropertyName = $true)]
        [string]$Name
    )

    process {
        Write-Host "Name: $Name" -ForegroundColor Cyan
    }
}

Get-Service | Test-PipelineParameter

# Value from remaining arguments
# This is helpful when we want flexibility in number of arguments passed to function
function Test-RemainingParameters {
    param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )

    Write-Host "Arguments: $($Args -join ', ')" -ForegroundColor Yellow
}

Test-RemainingParameters -Args "One", "Two", "Three"

# Aliases for parameters
function Test-ParameterAliases {
    param (
        [Parameter()]
        [Alias("fn", "first")]
        [string]$FirstName,

        [Parameter()]
        [Alias("ln", "last")]
        [string]$LastName
    )

    Write-Host "First Name: $FirstName, Last Name: $LastName" -ForegroundColor Magenta
}

Test-ParameterAliases -fn "John" -ln "Doe"

# Excess positional parameters
function Test-ExcessPositionalParameters {
    param (
        [Parameter(Position = 0)]
        [string]$Name,

        [Parameter(Position = 1)]
        [int]$Age
    )

    Write-Host "Name: $Name, Age: $Age" -ForegroundColor DarkCyan
}

# This throws an error due to excess positional parameters
Test-ExcessPositionalParameters "Alice" 30 "Extra1" "Extra2"

# Parameter validation attributes
function Test-ParameterValidation {
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]$Name,

        [Parameter()]
        [ValidateRange(1, 120)]
        [int]$Age
    )

    Write-Host "Name: $Name, Age: $Age" -ForegroundColor DarkYellow
}

Test-ParameterValidation -Name "Bob" -Age 25
# The following line will throw a validation error
Test-ParameterValidation -Name "" -Age 150

# Regex validation
function Test-RegexValidation {
    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")]
        [string]$Email
    )

    Write-Host "Valid Email: $Email" -ForegroundColor DarkGreen
}

Test-RegexValidation -Email "kapil.kathuria@gmail.com"
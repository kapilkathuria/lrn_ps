# Classes
# Classes allows you to create custom data types that encapsulate data and behavior.
# With classes, you can create objects that have properties and methods.
# This allows for better organization and structure in your code.

# With PSCustomObject, you can create objects with properties, but you cannot define methods.
# And you cannot enforce data types for properties.
# And you run into multiple other limitations.
# This is where classes come in.

# Class basics and syntax
# Class keyword
# Class name - must start with a letter and can contain letters, numbers, and underscores. Example: Person below
# Curly braces {} to define the class body
# Properties - defined using [data type]$propertyName syntax. Ex. FirstName and LastName below
# Consuctor - special method that is called when an object is created. Used to initialize properties. Ex. Person() below
# Methods - defined using [return type] MethodName() { } syntax. Ex. GetFullName() below
# Methods must have a return type defined.
# Methods should have strongly typed parameters.

class Person {
    [string]$FirstName
    [string]$LastName

    Person([string]$firstName, [string]$lastName) {
        $this.FirstName = $firstName
        $this.LastName = $lastName
    }

    [string] GetFullName() {
        return "$($this.FirstName) $($this.LastName)"
    }
}

# Creating an instance of the Person class
$person = [Person]::new("John", "Doe")
Write-Output $person.GetFullName()

# Get members of the Person class
$person | Get-Member

# Serveral way to create objects from classes

# Instantiating a class using a constructor
$person1 = [Person]::new("Jane", "Smith")

# 
$person2 = New-Object Person("Alice", "Johnson")

# Creating instances using hash table
$person3 = [Person]::new(@{ FirstName = "Bob"; LastName = "Brown" } )

# Creating instances using splatting
$person4Params = @{
    firstName = "Charlie"
    lastName  = "Davis"
}
$person4 = [Person]::new($person4Params)

# Creating instances by setting properties directly
$person5 = [Person]::new()
$person5.FirstName = "Eve"
$person5.LastName = "Wilson"

# example of overloads

class ProcessManager {
    ProcessManager() { }

    # Overloaded method to get process by name
    [System.Diagnostics.Process] GetProcess([string]$processName) {
        return Get-Process -Name $processName
    }

    # Overloaded method to get process by ID
    [System.Diagnostics.Process] GetProcess([int]$processId) {
        return Get-Process -Id $processId
    }
}

# Create an instance of the ProcessManager class
$processManager = [ProcessManager]::new()

# Get process by name
$processByName = $processManager.GetProcess("notepad")
Write-Output "Process retrieved by name: $($processByName.Name)"

# Get process by ID
$processById = $processManager.GetProcess(1234)  # Replace 1234 with an actual process ID
Write-Output "Process retrieved by ID: $($processById.Name)"


# Classes - advanced features
# Constructors can be overloaded
# Properties and methods can have access modifiers (public, private, protected)
# Enums can be used for friendly names on predefined values
# Classes can inherit from other classes


# Enum for Operating System Types
# Enum is like a drop down of values shown in excel cell for predefined values
enum OSArchitecture {
    x86
    x64
    ARM
}

class ServerInfo {
    [string]$Hostname
    [string]$OS
    [OSArchitecture]$Architecture

    # Default constructor
    ServerInfo() {
        $this.Hostname = $env:COMPUTERNAME
        $this.OS = (Get-WmiObject -Class Win32_OperatingSystem).Caption
        $this.Architecture = [OSArchitecture]::x64  # Default value
    }

    # Overloaded constructor
    ServerInfo([string]$hostname, [string]$os, [OSArchitecture]$architecture) {
        $this.Hostname = $hostname
        $this.OS = $os
        $this.Architecture = $architecture
    }

    [void] DisplayInfo() {
        Write-Host "Hostname: $($this.Hostname)"
        Write-Host "Operating System: $($this.OS)"
        Write-Host "Architecture: $($this.Architecture)"
    }
}

class AdvancedServerInfo : ServerInfo {
    [string]$AdditionalInfo

    AdvancedServerInfo([string]$hostname, [string]$os, [OSArchitecture]$architecture, [string]$additionalInfo) : base($hostname, $os, $architecture) {
        $this.AdditionalInfo = $additionalInfo
    }

    [void] DisplayAdvancedInfo() {
        $this.DisplayInfo()
        Write-Host "Additional Info: $($this.AdditionalInfo)"
    }
}

# Example usage
$server = [ServerInfo]::new()
$server.DisplayInfo()

$advancedServer = [AdvancedServerInfo]::new("MyServer", "Windows Server 2022", [OSArchitecture]::x64, "This is a test server.")
$advancedServer.DisplayAdvancedInfo()

# Object Models
CIM vs WMI

WMI is on path of deprecation. CIM would replace WMI

Objects - foundation block of PS. Everything
Object is structured data - combines similar information and capabilities into one entity
get-help about_objects
properties = are information
methods = actions

Powershell is known as object based shell. Powershell is based on .NEt framework. data type are coming from .NET

OBJECTS have data field (Properties) and procedure (METHODS)

properties and methods are collectively known as members

An object is an instance of a Type

## where do types come from
* .NET framework: int, boolean, string etc.
* Common information model (CIM)
* Component object model (COM)
* Windows management instrumentation (WMI)
* Classes: custome classes which are created

default data type comes from .NET. using CIM, COM and WMI we can define our own set of classes, properties and methods

# Custom objects
<!-- $obj = New-Object -TypeName psobject
$obj | Get-Member
$obj.GetType() -->

# COM -  Component object models
- Not a langugae but binary programing interface
- a description of classes that exposes interfaces
- com fixed the issues of having multiple version of same DLL

for ex. - to write doc file , a com object can be used.

## Benefits
1. Reuse com object
2. we can integrate with other windows apps

## Common use cases
- Windows exploer
- IE

# How to search COM classes


# NNEXT SECTON

# Common informaton model - CIM
open standard maintained by DMTF since 199
includes cim infra specification 
A common definiationof management information
provides means to actively control and manage these elements

## powershell & CIM
-  manage OS settings
- some modules are just a wrapper around CIM
- can manage CIM cross platforms OS's

## CIM Namespace
- Namespace is hierarchial odered contaier
- CIM classes reside in Namespace
- Defailt namespace is "/root/cimv2"
- other examples
root\rsop
root\ccm - config manger classes
root\microsoft
root\microsoft\windows - Windows related
root\micorosft\windows\DesiredStateConfiguration = DSC Classes

## CIM Remoting
- CIM remoting can be executed remotely and uses WSMAN
- 


# WMI 
Deprecated. 
- it used DCOM over RPC. Not a very secure method. Doesn't use WSMAN
- Only for Windows
- Namespace is same as CIM
- Defailt namespace is /root/CIM2

# WMI vs CIM
- Not all OS Settings can be changed using native PS
- cmdlets are same

Note: type accelrators. [WMI] - these are the aliases to .NEt classes

# best practices for performance
- CIM is performant
- using persistent session is faster
- CIM is http based
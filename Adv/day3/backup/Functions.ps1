
function Get-Ldapobject
{
    <#
    .SYNOPSIS
        Search LDAP directorys using .NET LDAP searcher
    .DESCRIPTION
        Search AD configuration or naming partition or using .NET AD searcher 
    .EXAMPLE
        Get-Ldapobject -LDAPfilter "(&(name=henk*)(diplayname=*))"

        Search the current domain with the LDAP filter "(&(name=Henk*)(diplayname=*))". Return all properties.
        Return only 1 result
    .EXAMPLE
        Get-Ldapobject -LDAPfilter "(&(name=henk*)(diplayname=*))" -properties Displayname,samaccountname -Findall $true

        Search the current domain with the LDAP filter "(&(name=henk*)(diplayname=*))". Return Displayname and samaccountname.
        Return all result 
    .EXAMPLE
        Get-Ldapobject -OU "OU=users,DC=contoso,DC=com" -DC "DC01" -LDAPfilter "(&(name=henk*)(diplayname=*))" -properties samaccountname

        Search the OU "users" in the domain "contoso.com" using DC01 and the LDAP filter "(&(name=henk*)(diplayname=*))". Return the
        samaccountname. Return only 1 result
    .EXAMPLE
        Get-Ldapobject -OU "CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=tailspin,DC=com" -LDAPfilter 
        "(&(objectclass=msExchExchangeServer)(serialnumber=*15*))" -Findall $true -$configurationNamingContext

        Search the current AD domain for all exchange 2013 and 2016 servers in the configuration partition of AD.
        Return all result 
    .EXAMPLE
        Get-Ldapobject -OU "CN=Microsoft Exchange,CN=Services,CN=Configuration,DC=tailspin,DC=com" -LDAPfilter 
        "(objectclass=msExchExchangeServer)" -Findall $true -ConfigurationNamingContext -ConfigurationNamingContextdomain "tailspin.com"

        Search the Remote AD domain "tailspin.com" for all exchange servers in the configuration partition of AD.
        Return all result
    .NOTES
        -----------------------------------------------------------------------------------------------------------------------------------
        Function name : Get-Ldapobject
        Authors       : Martijn van Geffen
        Version       : 1.2
        dependancies  : None
        -----------------------------------------------------------------------------------------------------------------------------------
        -----------------------------------------------------------------------------------------------------------------------------------
        Version Changes:
        Date: (dd-MM-YYYY)    Version:     Changed By:           Info:
        12-12-2016            V1.0         Martijn van Geffen    Initial Script.
        06-01-2017            V1.1         Martijn van Geffen    Released on Technet
        13-10-2017            V1.2         Martijn van Geffen    Set the default OU to the forest root to better support multi domain
        -----------------------------------------------------------------------------------------------------------------------------------
    .COMPONENT
        None
    .ROLE
        None
    .FUNCTIONALITY
        Search LDAP directorys using .NET LDAP searcher
    #>

    [CmdletBinding(HelpUri='https://gallery.technet.microsoft.com/scriptcenter/Search-AD-LDAP-from-domain-c0131588')]

    param(

    [Parameter(Mandatory=$false)]
    [ValidateNotNullOrEmpty()]
    [string]$OU,
    
    [Parameter(Mandatory=$false)]
    [string]$DC,
    
    [Parameter(Mandatory=$true)]
    [ValidateNotNullOrEmpty()]
    [string]$LDAPfilter,

    [Parameter(Mandatory=$false)]
    [array]$Properties = "*",

    [Parameter(Mandatory=$false)]
    [boolean]$Findall = $false,
        
    [Parameter(Mandatory=$false)]
    [string]$Searchscope = "Subtree",

    [Parameter(Mandatory=$false)]
    [int32]$PageSize = "900",

    [Parameter(Mandatory=$false)]
    [switch]$ConfigurationNamingContext,

    [Parameter(Mandatory=$false)]
    [string]$ConfigurationNamingContextdomain,

    [Parameter(Mandatory=$false)]
    [System.Management.Automation.PsCredential]$Cred
    

    )
    
    If ( $cred )
    {
        $username = $Cred.username
        $password = $Cred.GetNetworkCredential().password
    }

    if ( !$DC )
    {
        try 
        {
            $DC = ([system.directoryservices.activedirectory.domain]::GetCurrentDomain()).name
        }
        catch
        {
            Write-error "Variable DC can not be empty if you run this from a non domain joined computer. Use a DC or Use Get-dc function here from https://gallery.technet.microsoft.com/scriptcenter/Find-a-working-domain-fe731b4f"
        }
    }

    if ( !$OU )
    {
        try 
        {
            $OU = "DC=" + ([string]([system.directoryservices.activedirectory.domain]::GetCurrentDomain()).forest).Replace(".",",DC=")
        }
        catch
        {
            Write-error "Variable OU can not be empty if you run this from a non domain joined computer. Use a DC or Use Get-dc function here from https://gallery.technet.microsoft.com/scriptcenter/Find-a-working-domain-fe731b4f"
        }
    }

    Try
    {
        if ( $cred )
        {
            $root = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$DC/$OU",$username,$password)
        }else
        {
            $root = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$DC/$OU")
        } 
        
        if ( $configurationNamingContext.IsPresent )
        {
        
            try
            {
                if (!$ConfigurationNamingContextdomain)
                {
                    $ConfigurationNamingContextdomain = [system.directoryservices.activedirectory.domain]::GetCurrentDomain()
                }
                $tempconfigurationNamingContextdomain = $configurationNamingContextdomain
            }
            catch
            {
                Write-error "Variable ConfigurationNamingContextdomain can not be empty if you run this from a not domain joined computer"
            }

            try
            {
                do
                {
                    if ( $cred )
                    {
                        $tempdomain = new-object System.DirectoryServices.ActiveDirectory.DirectoryContext("domain",$tempconfigurationNamingContextdomain,$username,$password)
                    }else
                    {
                        $tempdomain = new-object System.DirectoryServices.ActiveDirectory.DirectoryContext("domain",$tempconfigurationNamingContextdomain)
                    }
                    $domain = [system.directoryservices.activedirectory.domain]::GetDomain($tempdomain)
                    $configurationNamingContextdomain = $domain.forest.name
                    $tempconfigurationNamingContextdomain = $domain.parent
                }while ( $domain.parent )

                $configurationdn = "CN=configuration,DC=" + $configurationNamingContextdomain.Replace(".",",DC=")
                if ( $cred )
                {
                    $root = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$DC/$configurationdn",$username,$password)
                }else
                {
                    $root = New-Object System.DirectoryServices.DirectoryEntry("LDAP://$DC/$configurationdn")
                }
                      
            }
            Finally
            {
                if (  $domain -is [System.IDisposable])
                { 
                     $domain.Dispose()
                }
                if ( $configurationNamingContextdomain -is [System.IDisposable])
                { 
                     $configurationNamingContextdomain.Dispose()
                }
            }
        
        }
                   
        $searcher = new-object DirectoryServices.DirectorySearcher($root)
        $searcher.filter = $LDAPfilter
        $searcher.PageSize = $PageSize
        $searcher.searchscope = $searchscope
        $searcher.PropertiesToLoad.addrange($properties)

        if ($findall)
        {
            $object = $searcher.Findall()
        }
    
        if (!$findall)
        {
            $object = $searcher.Findone()
        }

    }
    Finally
    {        
        if ( $searcher -is [System.IDisposable])
        { 
            $searcher.Dispose()
        }
        if ( $OU -is [System.IDisposable])
        { 
            $OU.Dispose()
        }
        if ( $DC -is [System.IDisposable])
        { 
            $DC.Dispose()
        }
    }
    return $object
}

function test ($rootfolder)
{
    $folder = Get-Item -Path $rootfolder
    [array]$subfolders = $null
    [array]$subfolders = Get-ChildItem -Path $rootfolder -Directory
    $temp = New-Object PSCustomObject
    $temp | add-member -type NoteProperty -Name name -Value $folder.name
    if ($subfolders.count -ne 0)
    {
        [array]$nestedtemp = $null
        [array]$nestedtemp = foreach ( $sub in $subfolders){test $sub.fullname}
        $temp | add-member -type NoteProperty -Name nest -Value $nestedtemp
    }else
    {
        $temp | add-member -type NoteProperty -Name nest -Value $null
    }

    $temp
}

function ResolveOu ([string]$rootOU)
{

     $ouname = "bad"
    if($rootOU)
    {
        $OU = Get-Ldapobject -LDAPfilter ("(|(objectclass=container)(objectclass=organizationalUnit))") -Findall $true -Searchscope base -ou $rootOU
        $oudn = $ou.properties.distinguishedname[0]
        if ($ou.properties.cn)
        {
            $ouname = $ou.properties.cn[0]
        }else
        {
            $ouname = $ou.properties.ou[0]
        }
    }else
    {
        $oudn = "DC=" + ([string]([system.directoryservices.activedirectory.domain]::GetCurrentDomain()).forest).Replace(".",",DC=")
        $ouname = "Root"
    }
   
    [array]$subou  = $null
    [array]$subou = Get-Ldapobject -LDAPfilter ( "(|(objectclass=container)(objectclass=organizationalUnit))") -Findall $true -Searchscope onelevel -ou $oudn
    $temp = New-Object PSCustomObject
    $temp | add-member -type NoteProperty -Name name -Value $ouname
    $temp | add-member -type NoteProperty -Name fullname -Value $oudn
    if ($subou.count -ne 0)
    {
        [array]$nestedtemp = $null
        [array]$nestedtemp = foreach ( $sub in $subou){ResolveOu $sub.properties.distinguishedname[0]}
        $temp | add-member -type NoteProperty -Name nest -Value $nestedtemp
    }else
    {
        $temp | add-member -type NoteProperty -Name nest -Value $null
    }

    $temp
}

Function Select-LoadFileLocation($initialDirectory)
{   
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | out-null

    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog 
    if ( test-path $initialDirectory) 
    {
        $OpenFileDialog.initialDirectory = $initialDirectory
    }else 
    {
        $OpenFileDialog.initialDirectory = "c:\"
    }

    $OpenFileDialog.filter = "CSV files (CSV)|*.csv| All files (*.*)|*.*"
    $OpenFileDialog.ShowDialog() | out-null
    $OpenFileDialog.filename

}

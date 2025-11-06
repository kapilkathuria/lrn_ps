Class ADUser
{
    #region Properties
    [string] $Ou
    [string] $Cn
    [string] $Samaccountname
    [string] $UserPrincipalName
    [string] $DisplayName
    [string] $Department
    [string] $Title
    [string] $GivenName
    [string] $sn
    [string] $company
    [string] $description
    [string] $imageurl

    #endregion Properties

    #region constructors
    
    ADUser(){}
    ADUser($Ou, $Cn, $Samaccountname)
    {
        $this.Ou = $Ou
        $this.Cn = $Cn
        $this.Samaccountname = $Samaccountname
    }

    #endregion constructors

    #region Methodes 
    [void] create()
    {
        $password = 1..16 | ForEach-Object -Begin {[string]$result} -Process { $result +=[char](Get-Random -Minimum 63 -Maximum 90)  }
        
        [ADSI]$ADou = "LDAP://" + $this.Ou
        $ADnewuser = $ADou.Create("user","CN=$($this.Cn)")
        $ADnewuser.put("samaccountname", $this.Samaccountname)
        $ADnewuser.InvokeSet("samaccountname",$this.Samaccountname)
        $ADnewuser.setinfo()

        #set properties
        $ADnewuser.put("userAccountControl",544)
        $ADnewuser.setpassword($password)
        $ADnewuser.setinfo()
    }

}
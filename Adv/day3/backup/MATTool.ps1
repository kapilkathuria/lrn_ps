#region load dependancies

#region Load includes

. "$PSScriptRoot\functions.ps1"
. "$PSScriptRoot\Classes.ps1"

#endregion Load includes

#region load assembly dlls

Add-Type -AssemblyName PresentationCore,PresentationFramework

#endregion load assembly dlls

#endregion load dependancies

#region Initiate GUI

#region Cleanup XAML

$XAML= [XML](Get-Content -Path "$PSScriptRoot\MainWindow.xaml" -Raw)
$XAML.Window.RemoveAttribute('x:Class')
$XAML.Window.RemoveAttribute('xmlns:local')
$XAML.Window.RemoveAttribute('xmlns:d')
$XAML.Window.RemoveAttribute('xmlns:mc')
$XAML.Window.RemoveAttribute('mc:Ignorable')

#endregion Cleanup XAML options

#region load XML as XAML and Add namespace manager for X

$XAMLreader = New-Object System.Xml.XmlNodeReader $XAML
$Rawform = [Windows.Markup.XamlReader]::Load($XAMLreader)

$XmlNamespaceManager = [System.Xml.XmlNamespaceManager]::New($XAML.NameTable)
$XmlNamespaceManager.AddNamespace('x','http://schemas.microsoft.com/winfx/2006/xaml')

#endregion load XML as XAML and Add namespace manager for X

#region Create PS objects for controls

$GUI = @{}
$namedNodes = $XAML.SelectNodes("//*[@x:Name]",$XmlNamespaceManager)
$namedNodes | ForEach-Object -Process {$GUI.Add($_.Name, $Rawform.FindName($_.Name))}

#endregion Create PS objects for controls

#endregion Initiate GUI

#region WPF codebehind

#region From Initiationcode

#populate AD tree

$OUdata = @()
$OUdata += ResolveOu
$gui.ActiveDirectory_Treeview.ItemsSource = $OUdata

#endregion From Initiationcode

#region menu

$GUI.Menu_File_Exit.add_click({

    $Rawform.close()

})

$GUI.Menu_File_New.add_click({

    $GUI.Fileexplorer_Textbox_Folderinput.Clear()

})

#endregion menu

#region buttons

$GUI.Fileexplorer_Button_Inspectfolder.add_click({

    $GUI.Fileexplorer_listbox_Resultpath.clear()
    $pathcontent = Get-ChildItem -Path $GUI.Fileexplorer_Textbox_Folderinput.text

    foreach ($path in $pathcontent )
    {
        $GUI.Fileexplorer_listbox_Resultpath.Items.add($path.fullname)
    }

})

$GUI.ActiveDirectory_Button_NewUser.add_click({

    $NewAdUser = [aduser]::new($GUI.ActiveDirectory_Textbox_OU.Text,$GUI.ActiveDirectory_Textbox_Cn.Text,$GUI.ActiveDirectory_Textbox_Samaccountname.Text)
    $NewAdUser.create()

})

$GUI.ActiveDirectory_Button_NewUserCsv.add_click({

    $csvdata = Import-Csv -Path $gui.ActiveDirectory_Textbox_CSVpath.text

    $counter = 0
    Foreach ($newuser in $csvdata)
    {
        $Newaduser = [aduser]::new($newuser.ou,$newuser.cn,$newuser.samaccountname)
        $Newaduser.create()
        $counter++
        $completed = 100/$csvdata.count*$counter
        $GUI.Statusbar_Progressbar.value = $completed
        Start-Sleep -s 2
    }

})

#endregion buttons

#region Listboxitems

$GUI.Fileexplorer_listbox_Resultpath.Add_MouseDoubleClick({
    
    $GUI.Fileexplorer_Textbox_Folderinput.text = $GUI.Fileexplorer_listbox_Resultpath.selecteditem
    
    $Resultpathselecteditem = Get-ItemProperty -Path $GUI.Fileexplorer_listbox_Resultpath.selecteditem
    
    $Resultpathselecteditemproperties =($Resultpathselecteditem | Get-Member -MemberType Property).Name
    foreach ($item in $Resultpathselecteditemproperties)
    {
        $GUI.Fileexplorer_listView_Resultextension.Items.Add($item + ": " + $Resultpathselecteditem.$item)
    } 
    
    #create datasource for Fileexplorer_listView_Resultsize

    $datasource = @()

    #note the line below should only catch files with -file 
    $RecurseResultselecteditem = Get-childitem -Path $GUI.Fileexplorer_listbox_Resultpath.selecteditem -Recurse 
    $extension = $RecurseResultselecteditem | Group-Object -Property Extension
    foreach ($itemextension in $extension)
    {
        
        #clean itterative variabels
        $totalsize = $null

        $totalsize = $itemextension.Group | Measure-Object -Sum -Property length
        $temp = New-Object pscustomobject
        
        #Add datasource property used in XAML binding 
        $temp | Add-Member -Type noteproperty -Name property -Value $itemextension.name
        #Add datasource count used in XAML binding 
        $temp | Add-Member -Type noteproperty -Name count -Value $totalsize.count
        #Add datasource size used in XAML binding 
        $temp | Add-Member -Type noteproperty -Name size -Value ($totalsize.sum /1mb)
        
        $datasource += $temp
    }
 
    $GUI.Fileexplorer_listView_Resultsize.ItemsSource = $datasource

})

#endregion Listboxitems

#region Treeview

$gui.ActiveDirectory_Treeview.add_SelectedItemChanged({

    $gui.ActiveDirectory_Textbox_OU.Text = $gui.ActiveDirectory_Treeview.SelectedItem.fullname

})

$gui.ActiveDirectory_Treeview.add_MouseDoubleClick({
    
    $properties = @("description","company","sn","givenname","title","department","userprincipalname","samaccountname","cn","displayname","objectclass")

    $users = Get-Ldapobject -LDAPfilter ('(objectclass=user)') -Findall $true -OU $gui.ActiveDirectory_Treeview.SelectedItem.fullname -properties $properties
    
    $result = @()
    
    foreach ($user in $users)
    {
        $temp = New-Object ADUser
        $temp.Ou = $user.path.split("/")[-1]
        $temp.Cn = $user.properties.cn
        $temp.Samaccountname = $user.properties.samaccountname
        $temp.UserPrincipalName = $user.properties.userprincipalname
        $temp.DisplayName = $user.properties.displayname
        $temp.Department = $user.properties.department
        $temp.Title = $user.properties.title
        $temp.GivenName = $user.properties.givenname
        $temp.sn = $user.properties.sn
        $temp.company = $user.properties.company
        $temp.description = $user.properties.description
        $result += $temp

    }

    $gui.ActiveDirectory_DataGrid.ItemsSource = $result

})

#endregion Treeview

#region textbox

$gui.ActiveDirectory_Textbox_CSVpath.Add_MouseDoubleClick({

    $gui.ActiveDirectory_Textbox_CSVpath.text = Select-LoadFileLocation -initialDirectory "c:\"

})

#endregion Textbox

#region Show the form

$Rawform.ShowDialog()

#endregion Show the form

#endregion WPF codebehind
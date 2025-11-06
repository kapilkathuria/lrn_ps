#region load assembly dlls

Add-Type -AssemblyName PresentationCore,PresentationFramework

#endregion load assembly dlls

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

#region WPF controls

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


    $pathcontent = Get-ChildItem -Path $GUI.Fileexplorer_Textbox_Folderinput.text

    foreach ($path in $pathcontent )
    {
        $GUI.Fileexplorer_listbox_Resultpath.Items.add($path.fullname)
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

#endregion WPF controls

#region Show the form

$Rawform.ShowDialog()

#endregion Show the form
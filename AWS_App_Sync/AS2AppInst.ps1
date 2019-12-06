<#Filename:AS2AppInst.ps1

.Synopsis
Download and Install:
    Create c:\temp folder
    Create c:\AS2files folder
    Download and Install Latest Chrome Enterprise x64 browser
    Download and Install Latest Microsft Visual Studio code
    Install Notepad++ 
    Download 3 Workshop files

.Description
Performs configuration of Image Builder instance once provisioned prior to IMage Builder being run.

.Example command line
AS2AppInst.ps1

.Notes/References
See various links emnbedded within sections to give credit and thanks for who it is due!!

.Future Enhancement Opps
Make Downloand Labfiles a function
Further validation (Try,Catch) on dowload and installation processes
C:\Program Files\Notepad++\notepad++.exe
C:\Program Files\Microsoft VS Code\code.exe
C:\Program Files (x86)\Google\Chrome\Application\chrome.exe
C:\AS2Files\aws.png 
 
Review Notepad++ donwloading automation options....their new URL was having DNS resolution/consistency issues
Standardize on download folder and logging locations 

    Author: Greg LaVigne  
   Initial: 11/26/2019 (GPL)  Created for AppStream 2.0 WorkShop hosted during 2019 reInvent
   ModHist: 12/03/2019 (GPL)  Fixed a spelling error and re-pointed aws.gif to aws.png
			12/05/2019 (GPL)  Added checks for each process to check for existing install and if found skipping.

#>
############################################################################################
#					         	Set Script Variables 	  			                       #
############################################################################################
$Date = Get-Date -Format yyyyMMdd-HHmmss  # Date: Get the date and time in a filename friendly format
$logdir = "C:\AS2Files"
$logfile = "\AS2Lab_appinst.log"
$LogTrans = "C:\AS2Files\AS2Lab_trans-"+"$Date"+".log"
$strIam = $env:username
$strHomeDrive = $env:HOMEDRIVE
$strHomepath = $env:HOMEPATH
$strUser = [Security.Principal.WindowsIdentity]::GetCurrent()
$strUserDownloads = "$strHomeDrive"+"$strHomepath" + "\Downloads\"
$mainlog = "$logdir" + "$logfile"
$StartDTM = (Get-Date)
$path = Get-Location
$scriptName = $MyInvocation.MyCommand.Name

############################################################################################
#	     	        				Functions 	  			                               #
############################################################################################

Function GenerateFolder($path) {
    $global:foldPath = $null
    foreach($foldername in $path.split("\")) {
        $global:foldPath += ($foldername+"\")
        if (!(Test-Path $global:foldPath)){
            New-Item -ItemType Directory -Path $global:foldPath
            Write-Host "$global:foldPath Folder Created Successfully"
        }
    }
}

Function log($string, $color)
{
   if ($Color -eq $null) {$color = "white"}
   write-host $string -foregroundcolor $color
   $string | out-file -Filepath $mainlog -append
}

Function Get-ChromeVersion {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $False)]
        [string] $Uri = "https://omahaproxy.appspot.com/all.json",
 
        [Parameter(Mandatory = $False)]
        [ValidateSet('win', 'win64', 'mac', 'linux', 'ios', 'cros', 'android', 'webview')]
        [string] $Platform = "win",
 
        [Parameter(Mandatory = $False)]
        [ValidateSet('stable', 'beta', 'dev', 'canary', 'canary_asan')]
        [string] $Channel = "stable"
        )
 
    # Read the JSON and convert to a PowerShell object. Return the current release version of Chrome
    $chromeVersions = (Invoke-WebRequest -uri $Uri).Content | ConvertFrom-Json
    $output = (($chromeVersions | Where-Object { $_.os -eq $Platform }).versions | `
            Where-Object { $_.channel -eq $Channel }).current_version
    Write-Output $output
}

############################################################################################
#	     	        				Main Script	  			                               #
############################################################################################
GenerateFolder "C:\Temp"
GenerateFolder "C:\AS2Files"
Start-Transcript $LogTrans | Out-Null

##### Add Windows Presentation Framework #####
Add-Type -AssemblyName PresentationFramework

Log ("The execution started: " + $Date) yellow
Log ("This script name is: " + $scriptName) yellow
Log ("The full script path is: " + $path) yellow

##### Install Notepad++ #####
Log ("#############################################") Cyan

Log ("Installing Notepad++") magenta
$Path = $strUserDownloads
$UnattendedArgs = '/S'
$exeLoc = "C:\Program Files\Notepad++\notepad++.exe"

Log ("The Installed app location var is: $exeLoc") gray

Log ("Checking if Notepad++ is already installed")
If (!(Test-Path -Path $exeloc)) {
Log ("Notepad++ app .exe file not found so proceeding with installation.") green


Log ("The Notepad++ install path is: " + $Path) gray 
$InstallerFile = "npp.7.8.1.Installer.x64.exe"
$InstallerPath = $strUserDownloads + $InstallerFile
Log ("Looking for the Notepad++ installer file here: " + $InstallerPath)
If (Test-Path $InstallerPath) {
    Log ("Starting Installation of $InstallerPath") green
    (Start-Process "$InstallerPath" $UnattendedArgs -Wait -Passthru).ExitCode
    }Else{
    Log ("$InstallerPath NOT FOUND") RED
    [System.Windows.MessageBox]::Show($InstallerPath +' NOT FOUND!! You will need to manually install it after this concludes.')
    }

Start-Sleep -s 3
}
Else {
    Log ("Notepad++ app .exe file already exists. Skipping Notepad++ install process.") red
     }

Log ("####### COMPLETED NOTEPAD++ PROCESSING #########") Blue

##### Install Chrome Enterprise X64 #####
Log ("#############################################") Cyan
#https://xenappblog.com/2018/download-and-install-latest-google-chrome-enterprise/
#https://github.com/haavarstein/Applications/blob/master/Misc/NotePadPlusPlus/Install.ps1

Log ("Installing Chrome x64 Enterprise") magenta
Log ("Setting Chrome Varialbes")
$StartDTM = (Get-Date)
$Vendor = "Google"
$Product = "Chrome Enterprise"
$Version = $(Get-ChromeVersion)
$PackageName = "googlechromestandaloneenterprise64"
$InstallerType = "msi"
$Source = "$PackageName" + "." + "$InstallerType"
$Source = "c:\temp\"+ $source
$LogApp = "C:\Temp\$PackageName.log"
$Destination = "C:\Temp" + "\$Vendor\$Product\$Version\$packageName.$installerType"
$UnattendedArgs = "/i $Source ALLUSERS=1 NOGOOGLEUPDATEPING=1 /qn /liewa $LogApp"
$url = "https://dl.google.com/tag/s/dl/chrome/install/googlechromestandaloneenterprise64.msi"
$exeLoc = "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe"

Log ("Checking if Chrome is already installed")
If (!(Test-Path -Path $exeloc)) {
Log ("Chrome app .exe file not found so proceeding with installation.") green

Log ("The StartDMT var is: $StartDTM") gray
Log ("The Vendor var is: $Vendor") gray
Log ("The Product var is: $Product") gray
Log ("The Version var is: $Version") gray
Log ("The PackageName var is: $PackageName") gray
Log ("The InstallerType var is: $InstallerType") gray
Log ("The LogApp var is: $LogApp") gray
Log ("The Source var is: $Source") gray
Log ("The Destination var is: $Destination") gray
Log ("The URL var is: $url") gray
Log ("The UnattendedArgs var is: $UnattendedArgs") gray
Log ("The Installed app location var is: $exeLoc") gray

$ProgressPreference = 'SilentlyContinue'

Log ("Downloading $Vendor $Product $Version")
If (!(Test-Path -Path $Source)) {
    Log ("Chrome install file note found. Downloading.") green
    Invoke-WebRequest -Uri $url -OutFile $Source
         }
        Else {
            Log ("Chrome install file already exists. Skipping Download.") red
         }
 
Log ("Starting Installation of $Vendor $Product $Version") green
(Start-Process msiexec.exe -ArgumentList $UnattendedArgs -Wait -Passthru).ExitCode
Start-Sleep -s 5

Log ("Chrome Customization")
sc.exe config gupdate start= disabled
sc.exe config gupdatem start= disabled
Unregister-ScheduledTask -TaskName GoogleUpdateTaskMachineCore -Confirm:$false
Unregister-ScheduledTask -TaskName GoogleUpdateTaskMachineUA -Confirm:$false

Start-Sleep -s 3
}
Else {
    Log ("Chrome app .exe file already exists. Skipping Chrome install process.") red
     }

Log ("####### COMPLETED Chrome PROCESSING #########") Blue

##### Install Visual Studio Code #####
Log ("#############################################") Cyan

Log ("InstallingVisual Studio Code") magenta
Log ("Setting Visual Studio Code Varialbes")
$downloadURL     = 'https://go.microsoft.com/fwlink/?Linkid=852157'
$DownloadFolder = "c:\temp\VSCodeX64\"
$VSCodeinstallfile = "$DownloadFolder"+"VSCodex64.exe"
$exeLoc = "C:\Program Files\Microsoft VS Code\code.exe"

Log ("Checking if VS Code is already installed")
If (!(Test-Path -Path $exeloc)) {
Log ("VS Code app .exe file not found so proceeding with installation.") green

Log ("The DownloadURL var is: $downloadURL") gray
Log ("The DownloadFolder var is: $DownloadFolder") gray
Log ("The VSCodeinstallfile var is: $VSCodeinstallfile") gray
Log ("The Installed app location var is: $exeLoc") gray

# Check if the local download folder exists if not create it
Log ("Valiating $DownloadFolder")
If (Test-Path -Path $DownloadFolder -PathType Container)
{Log ("$DownloadFolder already exists") yellow}
ELSE
{Log ("Creating $DownloadFolder now") green
 New-Item -Path $DownloadFolder -ItemType directory}
  
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
#Download the file
Log ("Downloading Visual Studio Code")
Log ("The installer file is: $VSCodeinstallfile") gray
Invoke-WebRequest -Uri $downloadURL -OutFile $VSCodeinstallfile

#Install the downloaded file
Log ("Installing Visual Studio Code")
(Start-Process -FilePath "$VSCodeinstallfile" -ArgumentList "/SILENT /NORESTART /mergetasks=!runcode /LOG=C:\temp\VSCode-64bit-installer.log" -Wait -Passthru).ExitCode

# Wait for the installation to finish.
Start-Sleep -s 3
}
Else {
    Log ("VS Code app .exe file already exists. Skipping Visual Studio Code install process.") red
     }

Log ("####### COMPLETED VS Code PROCESSING #########") Blue

##### Downloading Lab Files #####
Log ("#############################################") Cyan

Log ("Downloading Lab Files") magenta
Log ("Setting LabFiles Varialbes")
$Labfileurl1 = "https://s3-us-west-2.amazonaws.com/labguide.appstreamlabs.com/2019labconfig.txt"
$Labfileurl2 = "https://s3-us-west-2.amazonaws.com/labguide.appstreamlabs.com/aws.png"

$LabFolder = "C:\AS2Files\"
$Labfile1 = "$LabFolder"+"2019labconfig.txt"
$Labfile2 =  "$LabFolder"+"aws.png"

Log ("Checking if aws.png is already downloaded")
If (!(Test-Path -Path $Labfile2)) {
Log ("aws.png icon file not found so proceeding with processing.") green

Log ("The Labfileurl1 var is: $Labfileurl1") gray
Log ("The Labfileurl2 var is: $Labfileurl2") gray
log ("The LabFolder var is: $LabFolder") gray
Log ("The Labfile1 var is: $Labfile1") gray
Log ("The Labfile2 var is: $Labfile2") gray

#Download the file
Log ("Downloading the Lab Files")
Invoke-WebRequest -Uri $Labfileurl1 -OutFile $Labfile1
Start-Sleep -s 3
Invoke-WebRequest -Uri $Labfileurl2 -OutFile $Labfile2
Start-Sleep -s 3
}
Else {
    Log ("aws icon file already exists. Skipping file dowload process.") red
     }

Log ("####### COMPLETED Downloading Lab Files #########") Blue

############################################################################################
#	     	        			END	Main Script	  			                               #
############################################################################################
Log ("##################### COMPLETED SCRIPT #############################") Yellow
$EndDTM = (Get-Date)
$ENDDate = Get-Date -Format yyyyMMdd-HHmmss  # Date: Get the date and time in a filename friendly format
Log ("The execution completed: " + $ENDDate) Yellow
Log ("Elapsed Time: $(($EndDTM-$StartDTM).TotalSeconds) Seconds") Yellow
Log ("Elapsed Time: $(($EndDTM-$StartDTM).TotalMinutes) Minutes") Yellow
Log ("Stop logging") gray
Stop-Transcript
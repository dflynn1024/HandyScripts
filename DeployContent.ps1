############################################################
# Script: Deploy Intouch Content v0.1 
# Author: David Flynn
# Date:   5th Aug 2016
############################################################
# Script Parameters


param([ValidateSet("appdev","sit")][string]$environment="local",      
      [Parameter(Mandatory=$True)][string]$archive)

############################################################
# Script Functions

function BackupCustomerLetters()
{
    param([string]$from, [string]$to)
    write-host "Backing Up Customer Letters from $from to $to" -foregroundcolor "yellow"
    Remove-Item $to -Force -Recurse -ErrorAction Ignore
    New-Item $to -type directory -Force 
    Copy-Item -path $from -destination $to -Recurse -Force	
}

function DeployCustomerLetters()
{
    param([string]$from, [string]$to)
    write-host "Copying Customer Letters from $from to $to" -foregroundcolor "yellow"
    Copy-Item -path $from -destination $to -Recurse -Force   
}

############################################################
# Script Main()

$destPaths = @{appdev = "C:\Temp\Assets\AppDev"; sit = "C:\Temp\Assets\SIT"; }
$bakPaths =  @{appdev = "C:\Temp\Assets\AppDev\Bak"; sit = "C:\Temp\Assets\SIT\Bak"; }
$from	 = "Assets"
$to = $destPaths.Get_Item($environment)
$bak = $bakPaths.Get_Item($environment)

write-host "Deploying InTouch Content`n" -foregroundcolor "yellow"

try
{                
   BackupCustomerLetters -from $from -to $bak
   DeployCustomerLetters -from $from -to $to
}
catch
{
    throw $error[0]
}

write-host "Me Godzilla, you Japan!!!" -foregroundcolor "yellow"
write-host "We're done here.. " -foregroundcolor "yellow"
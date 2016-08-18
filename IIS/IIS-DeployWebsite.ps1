############################################################
# Script: Deploy Web Site
# Author: David Flynn
# Date:   16th Aug 2016
#
# Deploys an IIS Website. The site is created if it doesnt
# exist already. Otherwise just the source files are copied.
# Use the -force to create the site regardless if it exists
# already. Note: The IIS Site Id will be different.
############################################################
# Script Parameters

param([Parameter(Mandatory=$True)][string]$siteName, 
      [Parameter(Mandatory=$True)][string]$sitePath, 
      [int]$port=80,
      [Parameter(Mandatory=$True)][string]$source,
      [Parameter(Mandatory=$True)][string]$identity, 
      [Parameter(Mandatory=$True)][string]$pwd,
      [switch]$force)

############################################################
# Script Functions

function CreateWebsiteIfNotExists()
{
    param([string]$name, [string]$path, [int]$port, [string]$identity, [string]$pwd)
      
    if (!(Test-Path "IIS:\AppPools\$name"))  { 
        write-host "Creating Application Pool: $name" -foregroundcolor "yellow"
        New-WebAppPool -Name $name
        ConfigureApplicationPoolIdentity -Name $name -identity $identity -pwd $pwd
    }

    if (!(Test-Path "IIS:\Sites\$name"))  { 
        write-host "Creating Site: $name" -foregroundcolor "yellow"       
        New-Website -Name $name -PhysicalPath $path -Port $port -ApplicationPool $name
        ConfigureWebsiteAuthenticationWindowsOnly -Name $name
    }
}

function ConfigureApplicationPoolIdentity()
{
    param([string]$name, [string]$identity, [string]$pwd)

    write-host "Configuring Application Pool Identity: $identity" -foregroundcolor "yellow"

    Set-ItemProperty IIS:\AppPools\$name -name processModel -value @{userName=$identity;password=$pwd;identitytype=3} 
}

function ConfigureWebsiteAuthenticationWindowsOnly()
{
    param([string]$name)

    write-host "Configure Website Authentication: WindowsOnly" -foregroundcolor "yellow"

    Set-WebConfigurationProperty -filter '/system.WebServer/security/authentication/windowsAuthentication' -name Enabled -value $true -location "$name"
    Set-WebConfigurationProperty -filter '/system.WebServer/security/authentication/AnonymousAuthentication' -name Enabled -value $false -location "$name"
    Set-WebConfigurationProperty -filter '/system.WebServer/security/authentication/basicAuthentication' -name Enabled -value $false -location "$name"
}

function RemoveWebsiteIfExists()
{
    param([string]$name)
    
    if ((Test-Path "IIS:\Sites\$name"))  { 
        write-host "Removing Site: $name" -foregroundcolor "yellow"       
        Remove-Website -Name $name
    }

    if ((Test-Path "IIS:\AppPools\$name"))  { 
        write-host "Removing Application Pool: $name" -foregroundcolor "yellow"
        Remove-WebAppPool -Name $name
    }    
}

function CopyBits()
{
    param([string]$from, [string]$to)

    write-host "Copying bits $from to $to" -foregroundcolor "yellow"

    Remove-Item $to -Force -Recurse -ErrorAction Ignore   
    New-Item $to -type directory -Force | Out-Null     
    Copy-Item -path $from\* -destination $to -Recurse -Force	
}

############################################################
# Script Main()

write-host "Deploying IIS Web Site: $siteName`nRunning as: $env:username on $(Get-Date)" -foregroundcolor "green"

try
{      
    CopyBits -from $source -to $sitePath
    
    if($force) {RemoveWebsiteIfExists -name $siteName}       
        
    CreateWebsiteIfNotExists -name $siteName -path $sitePath -port $port -identity $identity -pwd $pwd    
}
catch
{
    throw $error[0]
}

write-host "Me Godzilla, you Japan!!!" -foregroundcolor "green"
write-host "We're done here.. " -foregroundcolor "green"
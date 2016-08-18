############################################################
# Script: Nuke v0.1 (Sep 2015)
# Author: David Flynn
# 
# References:
#
#  - https://sachabarbs.wordpress.com/2014/10/24/powershell-to-clean-visual-studio-binobj-folders/

############################################################
# Script Parameters

param([Parameter(Mandatory=$True)][string]$path)

############################################################
# Script Functions

function RemoveAllBinAndObjFolders()
{
    param([string]$path)
    write-host "Nuking all [bin],[obj] & [testresults] folders under $path" -foregroundcolor "yellow"
    gci -path $path -inc bin,obj,testresults -rec | rm -rec -force
}

############################################################
# Script Main()

#   _   _       _                _____  __  
#  | \ | |     | |              |  _  |/  | 
#  |  \| |_   _| | _____  __   _| |/' |`| | 
#  | . ` | | | | |/ / _ \ \ \ / /  /| | | | 
#  | |\  | |_| |   <  __/  \ V /\ |_/ /_| |_
#  \_| \_/\__,_|_|\_\___|   \_/  \___(_)___/
#                                           
#   

write-host "  _   _       _                _____  __  
 | \ | |     | |              |  _  |/  | 
 |  \| |_   _| | _____  __   _| |/' | | | 
 | .   | | | | |/ / _ \ \ \ / /  /| | | | 
 | |\  | |_| |   <  __/  \ V /\ |_/ /_| |_
 \_| \_/\__,_|_|\_\___|   \_/  \___(_)___/`n" -foregroundcolor "yellow"

try
{                
   RemoveAllBinAndObjFolders -path $path
}
catch
{
    throw $error[0]
}

write-host "Me Godzilla, you Japan!!!" -foregroundcolor "yellow"
write-host "We're done here.. " -foregroundcolor "yellow"
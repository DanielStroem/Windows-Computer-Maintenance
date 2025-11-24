#YOU NEED ADMIN PRIVILEGES TO RUN THIS SCRIPT

#Sets var values
$domain = (Get-CimInstance Win32_ComputerSystem).PartOfDomain
$check = Repair-WindowsImage -Online -CheckHealth
$health = ($check).ImageHealthState
$restart = ($check).RestartNeeded

#Updates GPOs if computer is in a domain
if ($domain -eq $true) {
    gpupdate /force
}

#Repairs image if corrupt, then updates $restart
if ($health -ne "Healthy") {
    $restore = Repair-WindowsImage -Online -RestoreHealth -NoRestart
    $restart = ($restore).RestartNeeded
}

#Scans and repairs system files, then saves it to $sfc
$sfc = sfc /scannow

#Restarts computer if required and confirmation is given
if ($restart -eq $true) {
    Restart-Computer -Force -Confirm
}

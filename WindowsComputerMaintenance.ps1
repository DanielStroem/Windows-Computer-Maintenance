#YOU NEED ADMIN PRIVILEGES TO RUN THIS SCRIPT

#Checks if computer is domain joined and updates GPOs
$domainJoined = (Get-CimInstance Win32_ComputerSystem).PartOfDomain
if ($domainJoined -eq $true) {
    gpupdate /force
}

#Checks image health and repairs image if corrupt
$health = (Repair-WindowsImage -Online -CheckHealth).ImageHealthState
if ($health -ne "Healthy") {
    $restart = (Repair-WindowsImage -Online -RestoreHealth -NoRestart).RestartNeeded
}

#Scans and repairs system files
sfc /scannow

#Checks if restart is needed, and restarts if confirmation is given
if ($restart -eq $true) {
    Restart-Computer -Force -Confirm
}

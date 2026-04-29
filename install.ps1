# Request Administrator privileges
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Start-Process PowerShell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# Define the names and grab the current folder path
$TaskName = "Change Wallpaper on Lock"
$XmlFileName = "Change Wallpaper on Lock.xml"
$ExeFileName = "wallpaperChanger.exe"

$XmlPath = Join-Path -Path $PSScriptRoot -ChildPath $XmlFileName
$ExePath = Join-Path -Path $PSScriptRoot -ChildPath $ExeFileName

# Verify the required files exist in the directory
if (-not (Test-Path $XmlPath)) {
    Write-Host "Error: Could not find '$XmlFileName'."
    Read-Host "Press Enter to exit"
    exit
}
if (-not (Test-Path $ExePath)) {
    Write-Host "Error: Could not find '$ExeFileName'."
    Read-Host "Press Enter to exit"
    exit
}

# Read the XML -> update XML data -> and register the task
try {
    # Cast the file content to an XML object so we can edit it
    [xml]$TaskXmlObject = Get-Content -Path $XmlPath
    
    # Overwrite the hardcoded <Command> path with the actual current location of the .exe
    $TaskXmlObject.Task.Actions.Exec.Command = $ExePath

    # Overwrite the hardcoded <UserId> with the current user so it doesn't break on other machines
    $CurrentUser = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name
    $TaskXmlObject.Task.Principals.Principal.UserId = $CurrentUser
    
    # Import the modified XML into Task Scheduler
    Register-ScheduledTask -TaskName $TaskName -Xml $TaskXmlObject.OuterXml -Force | Out-Null
    
    Write-Host "Success! The scheduled task '$TaskName' was imported successfully."
    Write-Host "It is now pointing directly to: $ExePath"
}
catch {
    Write-Host "An error occurred while importing the task:"
    Write-Host $_.Exception.Message
}

Read-Host "Press Enter to close"
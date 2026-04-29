$WALLPAPER_FOLDER = $env:WALLPAPER_FOLDER
$StateFile = "$PSScriptRoot\wallpaper_state.txt"

# Grab all the files using .NET
$Files = [System.IO.Directory]::GetFiles($WALLPAPER_FOLDER)

if ($Files.Count -eq 0) { exit }

$Index = 0

# Check our state text file to see which picture we showed last time
if ([System.IO.File]::Exists($StateFile)) {
    $Index = [int][System.IO.File]::ReadAllText($StateFile)
    $Index++
    
    # Loop back
    if ($Index -ge $Files.Count) {
        $Index = 0
    }
}

[System.IO.File]::WriteAllText($StateFile, $Index.ToString())

$PicPath = $Files[$Index]

# Change Wallpaper
Add-Type -TypeDefinition @"
using System.Runtime.InteropServices;
public class WP {
    [DllImport("user32.dll", CharSet=CharSet.Auto)]
    public static extern int SystemParametersInfo(int uAction, int uParam, string lpvParam, int fuWinIni);
}
"@
[void][WP]::SystemParametersInfo(20, 0, $PicPath, 3)
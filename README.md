# Wallpaper Changer

A simple script to change the desktop wallpaper.
There are 2 solutions for this in this repository, a PowerShell script and a go script. Both do the same thing, but the go script should be faster.
This script is designed to work on Windows in combination with Task Scheduler.

For Multiple Monitors: If you have multiple monitors, the script will set the same wallpaper on all monitors.

## Usage

> [!NOTE]
> This script will create a `wallpaper_state.txt` in the same directory as the script.

### PowerShell Script

1. Set the `WALLPAPER_FOLDER` environment variable to the directory containing your wallpapers. For example, you can set it to `C:\Users\YourName\Pictures\Wallpapers`.
2. Save the `WallpaperChanger.ps1` script to a location of your choice.
3. Run the script using PowerShell. You can also set it up to run at startup or on a schedule using Task Scheduler.

### Go Script

1. Set the `WALLPAPER_FOLDER` environment variable to the directory containing your wallpapers. For example, you can set it to `C:\Users\YourName\Pictures\Wallpapers`.
1. Build the Go script or download the pre-built executable.
1. Run the executable. You can also set it up to run at startup or on a schedule using Task Scheduler.

## Building the Go Script

1. Make sure you have Go installed on your system.
1. Navigate to the directory containing the script.
1. Run the following command to build the executable:

```bash
go build -ldflags="-s -w -H=windowsgui" wallpaperChanger.go
```

## Installation with Go & Task Scheduler

1. Clone this repository to a location of your choice, for example `C:\tools\Wallpaper-Changer`.
1. Download or build the Go script and place the executable in the same directory as the `install.ps1` script.
1. Run the `install.ps1` script with administrator privileges.

The `install.ps1` script will automatically create a scheduled task that runs the wallpaper changer executable every time you lock your computer. You can verify the task was created successfully by opening Task Scheduler and looking for a task named "Change Wallpaper on Lock".
Additionally, you can easily modify the Task after creation in Task Scheduler to change the trigger or other settings as needed.

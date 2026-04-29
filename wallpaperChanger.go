package main

import (
	"os"
	"path/filepath"
	"strconv"
	"syscall"
	"unsafe"
)

// Load the Windows API
var (
	user32               = syscall.NewLazyDLL("user32.dll")
	systemParametersInfo = user32.NewProc("SystemParametersInfoW")
)

const (
	spiSetDeskWallpaper  = 0x0014
	spifUpdateIniFile    = 0x01
	spifSendWinIniChange = 0x02
)

func main() {
	// 1. Get the folder from your environment variable
	folder := os.Getenv("WALLPAPER_FOLDER")
	if folder == "" {
		return // Exit instantly if the variable isn't set
	}

	// 2. Set up the state file right next to wherever this .exe is running
	exePath, _ := os.Executable()
	stateFile := filepath.Join(filepath.Dir(exePath), "wallpaper_state.txt")

	// 3. Read the folder and grab all the files
	entries, err := os.ReadDir(folder)
	if err != nil {
		return
	}

	var files []string
	for _, e := range entries {
		if !e.IsDir() {
			files = append(files, filepath.Join(folder, e.Name()))
		}
	}

	if len(files) == 0 {
		return // Exit if folder is empty
	}

	// 4. Check the state file to see what number we used last
	index := 0
	if stateData, err := os.ReadFile(stateFile); err == nil {
		if parsedIndex, err := strconv.Atoi(string(stateData)); err == nil {
			index = parsedIndex + 1
			if index >= len(files) {
				index = 0
			}
		}
	}

	// 5. Write the new number back to the state file
	os.WriteFile(stateFile, []byte(strconv.Itoa(index)), 0644)

	// 6. Lock in the wallpaper path and convert it to a Windows-friendly string
	picPath := files[index]
	picPtr, _ := syscall.UTF16PtrFromString(picPath)

	// 7. Call the Windows API to change the background instantly
	systemParametersInfo.Call(
		uintptr(spiSetDeskWallpaper),
		uintptr(0),
		uintptr(unsafe.Pointer(picPtr)),
		uintptr(spifUpdateIniFile|spifSendWinIniChange),
	)
}
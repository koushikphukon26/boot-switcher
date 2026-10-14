

# Boot Switcher

Boot Switcher lets you switch between available operating systems directly from the terminal without manually opening the BIOS/UEFI boot menu. Select a boot entry, and Boot Switcher requests that the computer start from the selected entry on the next reboot.

## Windows Installation

### Step 1: Download

1. Open this repository on GitHub.
2. Click **Code → Download ZIP**.
3. Extract the ZIP file.
4. Open the extracted `boot-switcher` folder.

### Step 2: Run the installer

Open PowerShell in the extracted project folder and copy and run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Then run:

```powershell
.\install.ps1
```

Approve the administrator prompt if requested. The execution-policy bypass applies only to the current PowerShell process.

### Step 3: Open a new terminal

After installation, close the terminal and open a new PowerShell or Command Prompt window.

### Step 4: List boot entries

Copy and run:

```powershell
boot
```

Read the displayed entry names and numbers carefully.

### Step 5: Select a boot entry

To request the next boot using entry number 0:

```powershell
boot 0
```

To request the next boot using entry number 1:

```powershell
boot 1
```

Replace the number with the entry you actually want. Selecting an entry may restart your computer immediately. Save your work first.

## Windows Troubleshooting

### Problem: PowerShell says running scripts is disabled

Try running the installed CMD launcher directly:

```powershell
& "$env:ProgramData\BootSwitcher\boot.cmd"
```

### Problem: The launcher still cannot run the script

If the installed PowerShell file is named `boot.ps1`, run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:ProgramData\BootSwitcher\boot.ps1"
```

If your installed file is named `boot-script.ps1`, run:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:ProgramData\BootSwitcher\boot-script.ps1"
```

Use the command that matches the filename actually installed on your computer. The installer and launcher must use consistent filenames.

### Problem: The `boot` command is not recognized

1. Close PowerShell or Command Prompt.
2. Open a new terminal.
3. Try:

```powershell
where.exe boot
```

If the launcher is missing, check that `C:\ProgramData\BootSwitcher` contains the expected launcher files and that this directory is included in your PATH.

## Linux Installation

This installer is intended for APT-based Linux distributions that use GRUB.

### Step 1: Download and extract

Download the ZIP from GitHub and extract the project folder.

### Step 2: Install

Open a terminal in the extracted folder and run:

```bash
chmod +x install.sh
./install.sh
```

Follow the installer prompts.

### Step 3: List boot entries

```bash
boot
```

### Step 4: Select a boot entry

```bash
boot 0
```

Or:

```bash
boot 1
```

Use the number displayed by your own system. Selecting an entry may schedule the next boot and restart the computer.

## Important Notes

- Windows support uses UEFI firmware entries.
- Linux support depends on APT and GRUB.
- Firmware entries may include tools and recovery options, not just operating systems.
- Save all work before selecting an entry that may restart the computer.
- Test the listing command before requesting a boot change.
- Review scripts before running them with administrator privileges.
- This project has not been tested on every Windows or Linux configuration.

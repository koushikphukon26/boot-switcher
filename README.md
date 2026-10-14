# Boot Switcher

Boot Switcher lets you list boot entries and request the next boot from a terminal.

## Windows

### Installation

1. Download the project using **Code → Download ZIP**.
2. Extract the ZIP file.
3. Open the extracted `boot-switcher` folder.
4. Open PowerShell in that folder.
5. Run the following commands:

   powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   .\install.ps1
   

6. Approve the administrator prompt if requested.
7. When installation finishes, close PowerShell and open a new PowerShell or Command Prompt window.

The execution-policy setting above applies only to the current PowerShell process. It does not permanently change your system policy.

### Usage

List the available firmware boot entries:

powershell
boot


Select an entry by its displayed number:

powershell
boot 0


Or:

powershell
boot 1


Use the number shown by your own `boot` output. Do not assume that entry `0` is Windows or entry `1` is Linux.

**Important:** Selecting an entry may schedule the next boot and immediately restart the PC. Save your work before using a selection command.

Windows support uses UEFI firmware entries. The list may include firmware tools or other entries, not only operating systems.

If PowerShell blocks the `boot` command after installation, the launcher may be conflicting with a PowerShell script of the same name. Follow the troubleshooting instructions below.

### Windows troubleshooting

If PowerShell reports that running scripts is disabled, first try the installed launcher directly:

powershell
& "$env:ProgramData\BootSwitcher\boot.cmd"


If necessary, run the PowerShell script through a temporary execution-policy bypass:

powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:ProgramData\BootSwitcher\boot.ps1"


If your installation uses `boot-script.ps1` instead of `boot.ps1`, use this command:

powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$env:ProgramData\BootSwitcher\boot-script.ps1"


These commands assume that the named files exist at the specified locations. Do not rename installed files unless the launcher and installer are updated to match.

## Linux

This installer is for APT-based Linux distributions that use GRUB.

### Installation

1. Download the project using **Code → Download ZIP**.
2. Extract the ZIP file.
3. Open a terminal in the extracted `boot-switcher` folder.
4. Run:

bash
chmod +x install.sh
./install.sh


Follow any prompts displayed by the installer. It may ask before installing `os-prober` and may update the GRUB configuration.

### Usage

List the available top-level GRUB menu entries:

bash
boot


Select an entry by its displayed number:

bash
boot 0


Or:

bash
boot 1

Use the number displayed on your own computer. Selecting an entry may schedule the next boot and restart the computer. Save your work first.

## Notes

- Windows support uses UEFI firmware entries.
- Linux support depends on APT and GRUB; this is not a universal installer for every Linux distribution.
- OS detection depends on entries exposed by the system's firmware or GRUB configuration.
- Firmware entries do not necessarily correspond one-to-one with installed operating systems.
- Review the entry names carefully before selecting an entry.
- Test the listing command before attempting to change the next boot.

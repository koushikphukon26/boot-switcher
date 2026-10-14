# Boot Switcher

Boot Switcher lets you list boot entries and request the next boot from a terminal.

## Windows

1. Extract the ZIP.
2. Open the extracted `boot-switcher` folder.
3. Right-click `install.ps1` and choose **Run with PowerShell**, or open PowerShell in that folder and run:

   `.\install.ps1`

4. Approve the administrator prompt.
5. When the installer finishes, close the terminal and open a new PowerShell or Command Prompt.
6. Run:

   `boot`

7. To select an entry, run `boot 0` or `boot 1`, using the number shown by `boot`.

Selecting an entry schedules it for the next boot and immediately restarts the PC. Save your work first.

Windows support uses UEFI firmware entries. The list may contain firmware tools or other boot entries, not only operating systems. Test `boot` first and read the names carefully before selecting a number.

## Linux

This installer is for APT-based Linux distributions that use GRUB. Extract the ZIP, open a terminal in the extracted folder, and run:

`chmod +x install.sh && ./install.sh`

The installer may ask before installing `os-prober`. It updates GRUB configuration and installs `/usr/local/bin/boot`.

After installation, run `boot` to list the top-level GRUB menu entries. Run `boot 0` or `boot 1` to schedule the corresponding entry and reboot.

## Notes

- The Linux script depends on APT and GRUB; it is not a universal installer for every Linux distribution.
- OS detection depends on the entries made available by Windows firmware or GRUB.
- Review the listed entry names before selecting an entry because the command restarts the computer.

#!/bin/bash

set -e
clear

if [ "$(uname -s)" != "Linux" ]; then
    echo "This installer supports Linux only."
    exit 1
fi

if [ "$EUID" -eq 0 ]; then
    echo "Run this as a normal user, not with sudo."
    exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
    echo "sudo is required."
    exit 1
fi

if ! command -v apt >/dev/null 2>&1; then
    echo "This installer requires an APT-based Linux system."
    exit 1
fi

if ! command -v os-prober >/dev/null 2>&1; then
    read -r -p "os-prober is required. Install it? [y/N]: " answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
        sudo apt update
        sudo apt install -y os-prober
    else
        echo "Installation cancelled."
        exit 1
    fi
fi

if [ ! -f /etc/default/grub ]; then
    echo "GRUB was not found."
    exit 1
fi

if grep -q "^GRUB_DISABLE_OS_PROBER=" /etc/default/grub; then
    sudo sed -i 's/^GRUB_DISABLE_OS_PROBER=.*/GRUB_DISABLE_OS_PROBER=false/' /etc/default/grub
else
    echo 'GRUB_DISABLE_OS_PROBER=false' | sudo tee -a /etc/default/grub >/dev/null
fi

sudo os-prober
sudo update-grub

sudo tee /usr/local/bin/boot >/dev/null <<'BOOT'
#!/bin/bash

mapfile -t OS_LIST < <(grep -E "^[[:space:]]*menuentry " /boot/grub/grub.cfg | sed -n "s/^[[:space:]]*menuentry ['\"]\\([^'\"]*\\)['\"].*/\\1/p")

if [ ${#OS_LIST[@]} -eq 0 ]; then
    echo "No top-level GRUB menu entries detected."
    exit 1
fi

if [ -z "$1" ]; then
    echo
    echo "Available GRUB menu entries:"
    echo
    for i in "${!OS_LIST[@]}"; do
        echo "[$i] ${OS_LIST[$i]}"
    done
    echo
    echo "Usage: boot [number]"
    exit 0
fi

if [[ "$1" =~ ^[0-9]+$ ]] && [ "$1" -lt "${#OS_LIST[@]}" ]; then
    echo "Selected: ${OS_LIST[$1]}"
    sudo grub-reboot "${OS_LIST[$1]}"
    sudo systemctl reboot
else
    echo "Invalid selection. Run 'boot' to see the list."
    exit 1
fi
BOOT

sudo chmod +x /usr/local/bin/boot

echo
echo "Boot Switcher installed successfully."
echo "Detected GRUB entries:"
boot

#!/bin/bash
# Gaming setup script for Arch Linux and Arch-based distributions (Nyarch, Manjaro, EndeavourOS, Garuda...)

set -e

echo "[*] Installing basic dependencies (git, base-devel, flatpak, corectrl, steam, lutris)..."
sudo pacman -S --needed --noconfirm git base-devel flatpak corectrl steam lutris

echo "[*] Adding Flathub repository..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "[?] Do you want to install AMD drivers? (y/n)"
read -rp "Choice: " amd_choice
if [[ "$amd_choice" =~ ^[Yy]$ ]]; then
    echo "[*] Installing AMD drivers..."
    sudo pacman -S --needed --noconfirm mesa vulkan-radeon lib32-vulkan-radeon
fi

echo "[?] Do you want to install NVIDIA drivers? (y/n)"
read -rp "Choice: " nvidia_choice
if [[ "$nvidia_choice" =~ ^[Yy]$ ]]; then
    echo "[*] Installing NVIDIA drivers..."
    sudo pacman -S --needed --noconfirm nvidia nvidia-utils lib32-nvidia-utils
fi

echo "[*] Installing Heroic Games Launcher..."
flatpak install -y flathub com.heroicgameslauncher.hgl

echo "[?] Do you want to install Discord? (y/n)"
read -rp "Choice: " discord_choice
if [[ "$discord_choice" =~ ^[Yy]$ ]]; then
    echo "[*] Installing Discord..."
    flatpak install -y flathub com.discordapp.Discord
fi

echo "[?] Choose a music player to install:"
echo "1) Spotify"
echo "2) SoundCloud"
read -rp "Choice (1/2): " music_choice

case "$music_choice" in
    1)
        echo "[*] Installing Spotify..."
        flatpak install -y flathub com.spotify.Client
        ;;
    2)
        echo "[*] Installing SoundCloud..."
        flatpak install -y flathub com.soundcloud.SoundCloud
        ;;
    *)
        echo "[!] Invalid option selected – skipping music player installation."
        ;;
esac

echo "[?] Do you want to install Wine + Proton-GE for Windows games? (y/n)"
read -rp "Choice: " wine_choice
if [[ "$wine_choice" =~ ^[Yy]$ ]]; then
    echo "[*] Installing Wine + Winetricks..."
    sudo pacman -S --needed --noconfirm wine winetricks
    echo "[*] Installing yay (AUR helper) for Proton-GE..."
    if ! command -v yay &> /dev/null; then
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ..
        rm -rf yay
    fi
    echo "[*] Installing Proton-GE..."
    yay -S --noconfirm proton-ge-custom
else
    echo "[!] Skipping Wine and Proton-GE installation."
fi

echo "[?] Do you want to install ProtonVPN (free) client? (y/n)"
read -rp "Choice: " vpn_choice
if [[ "$vpn_choice" =~ ^[Yy]$ ]]; then
    echo "[*] Installing ProtonVPN CLI..."
    sudo pacman -S --needed --noconfirm protonvpn-cli
    echo "[*] To initialize ProtonVPN, run: 'protonvpn init'"
else
    echo "[!] Skipping VPN installation."
fi

echo "[✔] Setup complete! Please restart your system for all changes to take effect."

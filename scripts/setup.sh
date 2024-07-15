#!/bin/sudo bash

display=(feh picom rofi lxappearance arc-gtk-theme arc-icon-theme lightdm-webkit-theme-aether)
filemgr=(thunar tumbler gvfs)
fonts=(ttf-dejavu ttf-droid ttf-liberation noto-fonts-emoji noto-fonts-cjk)
media=(light sox alsa-utils pulseaudio-alsa pavucontrol playerctl)
tools=(unzip emacs numlockx ibus-bamboo flameshot acpi barrier reflector)
xorg=(xorg-font-util xorg-xmodmap xorg-server xorg-xinput xorg-xprop xorg-xrandr)

yay_dir="$HOME/.cache/yay/yay"

if ! which yay &> /dev/null; then
    if [ ! -d $yay_dir ]; then
        mkdir -p $yay_dir
        git clone https://aur.archlinux.org/yay.git $yay_dir
    else
        cd $yay_dir
        makepkg -si --noconfirm
    fi
fi

read -p "Do you want to install bluetooth packages (optional)? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    bluetooth=(pulseaudio-bluetooth bluez bluez-utils)
else
    echo "Skipped bluetooth packages"
fi

yay -S --needed --noconfirm ${fonts[@]} ${media[@]} ${display[@]} ${xorg[@]} ${filemgr[@]} ${tools[@]} ${bluetooth[@]}

echo "Done"
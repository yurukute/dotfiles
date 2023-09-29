#!/bin/sudo bash
bluetooth=(pulseaudio-bluetooth bluez bluez-utils)
display=(feh picom rofi lxappearance arc-gtk-theme arc-icon-theme lightdm-webkit-theme-aether)
filemgr=(thunar tumbler gvfs)
fonts=(ttf-dejavu ttf-droid ttf-liberation)
media=(light alsa-utils pulseaudio-alsa pavucontrol)
tools=(emacs numlockx ibus-bamboo flameshot acpi)
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

yay -S --needed --noconfirm ${fonts[@]} ${media[@]} ${display[@]} ${xorg[@]} ${filemgr[@]} ${tools[@]}

read -p "Do you want to install bluetooth packages? (y/n)" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    yay -S --needed --noconfirm ${bluetooth[@]}
    sudo systemctl enable bluetooth
fi

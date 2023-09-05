#!/bin/sudo bash
fonts=(ttf-dejavu ttf-droid ttf-liberation)
media=(light alsa-utils pulseaudio-alsa pavucontrol flameshot)
beautify=(feh picom rofi lxappearance arc-gtk-theme)
input=(xorg-font-util ibus-bamboo)
filemgr=(thunar tumbler gvfs)
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

yay -S --needed ${font[@]} ${media[@]} ${beautify[@]} ${input[@]} ${filemgr[@]}
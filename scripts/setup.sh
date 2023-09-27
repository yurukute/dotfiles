#!/bin/sudo bash
bluetooth=(pulseaudio-bluetooth bluez bluez-utils)
display=(feh picom rofi lxappearance arc-gtk-theme arc-icon-theme lightdm-ewbkit-theme-aether)
filemgr=(thunar tumbler gvfs)
fonts=(ttf-dejavu ttf-droid ttf-liberation)
media=(light alsa-utils pulseaudio-alsa pavucontrol flameshot)
tool=(emacs numlockx ibus-bamboo)
xorg=(xorg-server xogr-xinput xorg-xrandr xorg-font-util)

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

yay -S --needed ${font[@]} ${media[@]} ${display[@]} ${xorg[@]} ${filemgr[@]} ${tool[@]}

read -p "Do you want to install bluetooth packages? (y/n)" -n 1 -r
ehco
if [[ $REPLY =~ ^[Yy]$ ]]; then
    yay -S --needed --noconfirm ${bluetooth[@]}

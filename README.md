# Necessary settings for better use
This is the note to my forgetful a$$. Feel free to skip.
## Awesomewm
### Fonts
- `ttf-dejavu `
- `ttf-droid`
- `ttf-liberation `

### Screen brightness
Install `light` 

Change permission
```
sudo chmod +s /usr/bin/light
```
### Volume
Install `alsa-utils pulseaudio-alsa pavucontrol`

Start the PulseAudio daemon
```
pulseaudio --start
```
*Optional* Install `sox` to play sound when adjusting volume
## Bluetooth headset
Intstall `pulseaudio-bluetooth bluez bluez-utils`

Make sure bluetooth is running and automatically starts after booting:
```
systemctl enable bluetooth
systemctl start bluetooth
```
Add the following to the bottom of `/etc/bluetooth/main.cf`
```
AutoEnable=true
```
## Getting IBus working with Emacs
> According to FAQ and Fonts, it's likely that `xorg-fonts-misc-otb`<sup>AUR</sup> is the one that should be installed since `xorg-fonts-misc` no longer provides the required fontset.

*From [ArchWiki](https://wiki.archlinux.org/title/Fcitx#Emacs)*
## Lightdm
### Dual monitor
*To prevent mouse and login screen from displaying on separate screens*

Install `xorg-xrandr`

Add the following line to `/etc/lightdm/lightdm.conf`
```
display-setup-script=/path/to/.screenlayout/Noob.sh
```
### Enable numlock
Install `numlockx`

Add the following line to `/etc/lightdm/lightdm.conf`
```
greeter-setup-script=/usr/bin/numlockx on
```
## Picom
Install `picom-jonaburg-git` from AUR
## Thunar 
### Automount 
For removable devices: Install `gvfs`

For ntfs partition:
- Install `ntfs-3g`
- Add this line to `/etc/fstab`
```
/dev/NTFS-part		/mnt/windows	ntfs-3g		defaults	0 0
```
### File thumbnails
Install `tumbler`
### Touchpad
Install `xorg-xinput`

Add the following line to `.xprofile`
```
xinput set-prop 'Synaptics TM3096-001' 'libinput Tapping Enabled' 1
xinput set-prop 'Synaptics TM3096-001' 'libinput Natural Scrolling Enabled' 1
```

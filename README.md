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
Install `alsa-utils alsa-plugins pulseaudio-alsa pavucontrol`

Start the PulseAudio daemon
```
pulseaudio --start
```
*Optional* Install `sox` to play sound when adjusting volume
## Bluetooth headset
Install `pulseaudio-bluetooth bluez bluez-utils`

Make sure bluetooth is running and automatically starts after booting:
```
systemctl enable bluetooth
systemctl start bluetooth
```
In `/etc/bluetooth/main.conf` file, find `[Policy]` section and add/uncomment:
```
AutoEnable=true
```
## Getting IBus working with Emacs
Install `xorg-font-util`

## Lightdm
### Fail to Start Light Display Manager error
Install `xorg-server`
### Dual monitor
*To prevent mouse and login screen from displaying on separate screens*

Install `xorg-xrandr`

Edit the following line in `/etc/lightdm/lightdm.conf`
```
display-setup-script=xrandr --output eDP-1 --primary --output HDMI-1 --off
```
### Enable numlock
Install `numlockx`

Add the following line to `/etc/lightdm/lightdm.conf`
```
greeter-setup-script=/usr/bin/numlockx on
```
## Picom
Install `picom-jonaburg-git` from AUR
## File manager
### Automount 
For removable devices: Install `gvfs`

For ntfs partition:
- Install `ntfs-3g`
- Add this line to `/etc/fstab`
```
/dev/NTFS-part		/mnt/windows	ntfs-3g		defaults	0 0
```
### Thumbnailers
Install `tumbler`
Install `ffmpegthumbnailer` for video thumbnailing
## Touchpad
Install `xorg-xinput`

Add the following line to `.xprofile`
```
xinput set-prop 'Synaptics TM3096-001' 'libinput Tapping Enabled' 1
xinput set-prop 'Synaptics TM3096-001' 'libinput Natural Scrolling Enabled' 1
```
## Grub theme
- Edit the following line in `/etc/default/grub`
```
GRUB_THEME="/path/to/theme.txt"
```
- Install and run `update-grub`

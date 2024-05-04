# Necessary settings for better use
This is a note to my forgetful a$$. Feel free to skip.
## Window manager - Awesomewm
### Theme
Using `arc-gtk-theme`.

Install `lxappearance` to customize theme and icon.
### Fonts
- `ttf-dejavu `
- `ttf-droid`
- `ttf-liberation `

### Screen brightness
Install `light`.

Change permission:
```
sudo chmod +s /usr/bin/light
```
### Audio
Install `alsa-utils alsa-plugins pulseaudio-alsa pavucontrol`.

Start the PulseAudio daemon:
```
pulseaudio --start
```
*[Optional]:* Install `sox` to play sound when adjusting volume.
## Display manager - Lightdm
### Fail to Start Light Display Manager error
Install `xorg-server`.
### Dual monitor
*Avoid displaying mouse pointer and login screen on different screens.*

Install `xorg-xrandr`.

Edit the following line in `/etc/lightdm/lightdm.conf`:
```conf
display-setup-script=xrandr --output eDP-1 --primary --output HDMI-1 --off
```
### Enable numlock
Install `numlockx`.

Add the following line to `/etc/lightdm/lightdm.conf`:
```conf
greeter-setup-script=/usr/bin/numlockx on
```
## File manager - Thunar
### Automount removable devices
Install `gvfs`
### Thumbnailers
Install `tumbler`.

Install `ffmpegthumbnailer` for video thumbnailing.
## NTFS mounting
- Install `ntfs-3g`
- Add this line to `/etc/fstab`
```
/dev/NTFS-part		/path/to/mount	ntfs-3g		defaults	0 0
```
### Cannot change files permission on NTFS partition
Add `exec` in mounting options
```
/dev/NTFS-part		/path/to/mount	ntfs-3g		exec,...	0 0
```
## Bluetooth
Install `pulseaudio-bluetooth bluez bluez-utils`

Make sure bluetooth is running and automatically starts after booting:
```
systemctl enable bluetooth
systemctl start bluetooth
```
 `/etc/bluetooth/main.conf` file, find `[Policy]` section and add/uncomment:
```
AutoEnable=true
```
## IBus
Vietnamese: using `ibus-bamboo`.
### Not working with some apps
Add the following to `/etc/environment`:
```bash
GTK_IM_MODULE=ibus
QT_IM_MODULE=ibus
XMODIFIERS=@im=ibus

# QT4-based applications
QT4_IM_MODULE=ibus

# Applications using Clutter/OpenGL
CLUTTER_IM_MODULE=ibus
GLFW_IM_MODULE=ibus
```
*[Note]:* Relogin needed.
### Not working with Emacs
Install `xorg-fonts-misc-otb`. (According to [Archwiki](https://wiki.archlinux.org/title/Fcitx#Emacs))

*[Note]:* Relogin needed.
## Touchpad
Install `xorg-xinput`

Create `/etc/X11/xorg.conf.d/30-touchpad.conf` with following content:
```conf
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    Option "Tapping" "on"
    Option "NaturalScrolling" "true"
EndSection
```
Or simply add:
```bash
xinput set-prop '<DeviceName>' 'libinput Tapping Enabled' 1
xinput set-prop '<DeviceName>' 'libinput Natural Scrolling Enabled' 1
```
to `.xprofile`.

*[Tips]:*`<DeviceName>` can be get by running `xinput` command.
## Grub theme
- Edit the following line in `/etc/default/grub`:
```conf
GRUB_THEME="/path/to/theme.txt"
```
- Run `grub-mkconfig -o /boot/grub/grub.cfg`.

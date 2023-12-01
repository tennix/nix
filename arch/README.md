
For ARM, use [archboot](https://archboot.com)

Install basic package: git, sudo, vi

Set up user:

``` shell
useradd tennix -m -G wheel
visudo # comment out the lines contain wheel to enable wheel group use sudo
```

## Install useful packages

``` shell
pacman -S --needed - < pkglist.txt
```


## Sync dot files

``` shell
chezmoi init tennix --apply
```

## Enable System Services

``` shell
systemctl enable lightdm
systemctl enable systemd-timesyncd
systemctl enable docker
systemctl enable tailscaled
```

## Install AUR Helper

``` shell
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

Print system statistics
yay -Ps

carapace-bin
aws-session-manager-plugin

## ArchLinux in a VM

### Parallels Desktop VM

Install parallels tools

1. Mount parallels tools iso to a directory

2. Install it

3. Configure the parallels

``` shell
prlcc
prlcp
```

### UTM VM

Install spice-vdagent, xorg-xrandr

``` shell
spice-vdagent
xrandr --output Virtual-1 --auto
```
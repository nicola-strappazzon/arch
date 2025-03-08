# Cheat Sheet

Basic survival guide.

## Pacman

Install packages:

```bash
sudo pacman -Syu [PackageName]
```

Uninstall packages:

```bash
sudo pacman -Rns [PackageName]
```

Search for a package:

```bash
pacman -Ss [PackageName]
```

Query package info:

```bash
sudo pacman -Fy [PackageName]
```

Update installed packages:

```bash
sudo pacman -Syu
```
Check for updates:

```bash
sudo pacman -Syu 
```

Clean cache:

```bash
sudo pacman -Scc
```

## Maintenance

Generates a random mirrorlist for the users and sort them by their current access time.

```bash
sudo pacman-mirrors --fasttrack
```

Generate cache list:

```bash
du -sh ~/.cache/*
```

Purge files not accessed in 100 days:

```bash
find ~/.cache/ -type f -atime +100 -delete
```

Report journal current size:

```bash
journalctl --disk-usage
```

Remove but recent entries by size or time:

```bash
journalctl --vacuum-size=50M
journalctl --vacuum-time=2weeks
```

Check for orphaned packages:

```bash
pamac list -o
```

Remove all orphans:

```bash
pamac remove -o
```

Remove all packages except the latest 3 versions:

```bash
pamac clean --keep 3
```

## AUR

Search for package

```bash
pamac search -a [PackageName]
```

Build the package

```bash
pamac build [PackageName]
```

## Access rights

Execute command as root

```bash
sudo [command]
```

Empty password cache

```bash
sudo -k
```

Change user password

```bash
passwd username
```

Change owner and group of file

```bash
chown [owner]:[group] -c [file]
```

Change file permissions

```bash
chmod [permissions] -c [file]
```

Set permissions in octal mode: 4(read) 2(write) 1(execute)

Example: 755 read-write-execute for owner and read-execute for group and others

Display files and permissions [of directory]

```bash
ls -lh [dir]
```

## Files and Directories

Change the working directory


```bash
cd [dir]
```

Change to parent directory

```bash
cd ..
```

List directory contents

```bash
ls -l
```

List also hidden files

```bash
ls -la
```

Copy file
```bash
cp [file] [target]
```

Copy directory recursively

```bash
cp -r [directory] [target]
```

Move or rename file/directory

```bash
mv [source] [target]
```

Remove directory recursively

```bash
rm -r [dir]
```

Create symbolic link

```bash
ln -s [target] [link]
```

Mount filesystem

```bash
mount -t [type] [/dev/sdx9] [mountpoint]
```

Mount ISO image

```bash
mount -o loop [iso] [mountpoint]
```

Home directory of user

```bash
cd /home/$USER
cd ~
```

Directory with global configurations

```bash
cd /etc
```

## Network

Display network information

```bash
nmcli
```

List wireless access points

```bash
nmcli c
```

Enable firewall [package Community: ufw]

```bash
ufw enable
```

Allow/deny all incoming traffic

```bash
ufw default [allow/deny]
```

Displays firewall status and rules

```bash
ufw status
```

Allows/deny incoming traffic on the specified port

```bash
ufw [allow/deny] [port]
```

Allows/deny incoming traffic from specified IP address

```bash
ufw [allow/deny] from [ip]
```

## System and Screen

Display kernel version

```bash
uname -r
```

Display long kernel version

```bash
uname -a
```

Report file system disk space usage

```bash
df [/] [/home]
sudo btrfs filesystem usage -h [/]
```

Display system tasks

```bash
top
htop
```

Display system information

```bash
inxi --admin --verbosity=7 --filter --width
```

Display a tree of processes

```bash
pstree
```

Switch to tty

```console
    Ctrl+Alt+F1
    Ctrl+Alt+F2
    Ctrl+Alt+F3
    Ctrl+Alt+F4
    Ctrl+Alt+F5
    Ctrl+Alt+F6
```

Switch to the X session

    Ctrl+Alt+F7

Start a unit

```bash
systemctl start unit
```

Stop a unit

```bash
systemctl stop unit
```

Check status of a unit

```bash
systemctl status unit
```

Enable a unit

```bash
systemctl enable unit
```

Disable a unit

```bash
systemctl disable unit
```

Restart a unit

```bash
systemctl restart unit
```

Shut down the system

```bash
poweroff
```


Restart the system

```bash
reboot
```

## Configure accents

Go to: System Settings \ Keyboard \ Key Bindings

Enable checkbox on `Configure keyboard options`.

Select and expand on the list: Position of Compose key: `Right Alt`, and click to Apply button.

For example:

1. To type `canción`, `canci` and press `Right Alt` + `'` and then leter `o` and you have `ó`, continue `ón`
2. To type `compañero`, `compa` and press `Right Alt` + `Shift` + `~` and then letter `n` and you have `ñ`, continue `ñero`.

## Test

To test this repository, use VirtualBox.

Create and start VM:

```bash
VBoxManage createvm --name ArchLinux --ostype="ArchLinux_64" --register --basefolder=/home/nicola/VirtualBox\ VMs/
VBoxManage modifyvm ArchLinux --ioapic on
VBoxManage modifyvm ArchLinux --memory 1024 --vram 128
VBoxManage modifyvm ArchLinux --nic1 nat
VBoxManage modifyvm ArchLinux --chipset ich9
VBoxManage modifyvm ArchLinux --firmware efi
VBoxManage createhd --filename=/home/nicola/VirtualBox\ VMs/ArchLinux/ArchLinux.vdi --size 1000000 --format VDI
VBoxManage storagectl ArchLinux --name "NVMe Controller" --add pcie --controller NVMe --portcount 1 --bootable on
VBoxManage storageattach ArchLinux --storagectl "NVMe Controller" --device 0 --port 0 --type hdd --medium=/home/nicola/VirtualBox\ VMs/ArchLinux/ArchLinux.vdi
VBoxManage storagectl ArchLinux --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach ArchLinux --storagectl "IDE Controller" --port=1 --device=0 --type=dvddrive --medium=/home/nicola/Downloads/archlinux-2025.02.01-x86_64.iso
VBoxManage startvm ArchLinux --type gui
```

Delete VM:

```bash
VBoxManage storagectl ArchLinux --name "NVMe Controller" --remove
VBoxManage closemedium disk "/home/nicola/VirtualBox VMs/ArchLinux/ArchLinux.vdi" --delete
VBoxManage unregistervm ArchLinux --delete
```

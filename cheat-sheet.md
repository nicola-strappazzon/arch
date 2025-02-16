# CheatSheet

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
user $ uname -r

Display long kernel version
user $ uname -a

Report file system disk space usage
user $ df [/] [/home]

user $ sudo btrfs filesystem usage -h [/]

Display system tasks
user $ top

user $ htop

Display system information
user $ inxi --admin --verbosity=7 --filter --width

Display a tree of processes
user $ pstree

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
user $ systemctl start unit

Stop a unit
user $ systemctl stop unit

Check status of a unit
user $ systemctl status unit

Enable a unit
user $ systemctl enable unit

Disable a unit
user $ systemctl disable unit

Restart a unit
user $ systemctl restart unit

Shut down the system
user $ poweroff

Restart the system
user $ reboot

## Configure accents

Go to: System Settings \ Keyboard \ Key Bindings

Enable checkbox on `Configure keyboard options`.

Select and expand on the list: Position of Compose key: `Right Alt`, and click to Apply button.

For example, to type `canción`, `canci` and press `Right Alt` + `'` and then `ón`

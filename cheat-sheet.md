# CheatSheet

## Pacman

Install packages

```bash
sudo pacman -Syu [PackageName]
```

Uninstall packages

```bash
sudo pacman -Rns [PackageName]
```

Search for a package

```bash
pacman -Ss [PackageName]
```

Query package info

```bash
pacman -F [PackageName]
```

Update installed packages

```bash
sudo pacman -Syu
```
Check for updates

```bash
sudo pacman -Syu 
```

Clean cache

```bash
pacman -Scc
```

## Maintenance

Generates a random mirrorlist for the users and sort them by their current access time.
user $ sudo pacman-mirrors --fasttrack

Generate cache list
user $ du -sh ~/.cache/*

Purge files not accessed in 100 days
user $ find ~/.cache/ -type f -atime +100 -delete

Report journal current size
user $ journalctl --disk-usage

Remove but recent entries by size or time
user $ journalctl --vacuum-size=50M

user $ journalctl --vacuum-time=2weeks

Check for orphaned packages
user $ pamac list -o

Remove all orphans
user $ pamac remove -o

Remove all packages except the latest 3 versions
user $ pamac clean --keep 3

## AUR

Search for package
user $ pamac search -a [PackageName]

Build the package
user $ pamac build [PackageName]

## Access rights

Execute command as root
user $ sudo [command]

Empty password cache
user $ sudo -k

Change user password
user $ passwd username

Change owner and group of file
user $ chown [owner]:[group] -c [file]

Change file permissions
user $ chmod [permissions] -c [file]

Set permissions in octal mode: 4(read) 2(write) 1(execute)

Example: 755 read-write-execute for owner and read-execute for group and others

Display files and permissions [of directory]
user $ ls -lh [dir]

## Files and Directories

Change the working directory
user $ cd [dir]

Change to parent directory
user $ cd ..

List directory contents
user $ ls -l

List also hidden files
user $ ls -la

Copy file
user $ cp [file] [target]

Copy directory recursively
user $ cp -r [directory] [target]

Move or rename file/directory
user $ mv [source] [target]

Remove directory recursively
user $ rm -r [dir]

Create symbolic link
user $ ln -s [target] [link]

Mount filesystem
user $ mount -t [type] [/dev/sdx9] [mountpoint]

Mount ISO image
user $ mount -o loop [iso] [mountpoint]

Home directory of user
user $ cd /home/$USER
user $ cd ~

Directory with global configurations
user $ cd /etc

## Network

Display network information
user $ nmcli

List wireless access points
user $ nmcli c

Enable firewall [package Community: ufw]
user $ ufw enable

Allow/deny all incoming traffic
user $ ufw default [allow/deny]

Displays firewall status and rules
user $ ufw status

Allows/deny incoming traffic on the specified port
user $ ufw [allow/deny] [port]

Allows/deny incoming traffic from specified IP address
user $ ufw [allow/deny] from [ip]

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

    Ctrl+Alt+F1
    Ctrl+Alt+F2
    Ctrl+Alt+F3
    Ctrl+Alt+F4
    Ctrl+Alt+F5
    Ctrl+Alt+F6

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

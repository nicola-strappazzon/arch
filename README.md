# My Arch Linux setup

The repository contains a personal distribution based on Arch Linux.
> [!Warning]
> - The following steps will erase the entire disk to install the base operating system. Make sure to have a backup outside the computer and check that nothing is missing before proceeding.
> - The author of these scripts is not responsible for any inconveniences.
> - By default, the username and hostname are set to my first and last name, and is part of code.

```bash
curl -s strappazzon.me
```

## Flash OS images to USB drives

Download the [Arch Linux ISO](https://archlinux.org/download) and use [Etcher](https://etcher.balena.io) to flash it to a USB drive.

## Install

During the computer's boot process, select the USB as the boot device (F12). Once Arch Linux Live has started, enter the following commands:

```bash
curl -s strappazzon.me | sh -s base
```

Once the previous step is completed without errors and you have restarted the computer, run the following command to install KDE Plasma 6.x or GNOME with all applications:

```bash
curl -s strappazzon.me | sh -s gnome
```

Install aditional applications and tools independently of the desktop:

```bash
curl -s strappazzon.me | sh -s packages
```

Finally, the work environment needs to be configured:

```bash
curl -s strappazzon.me | sh -s profile
```

Enjoy!

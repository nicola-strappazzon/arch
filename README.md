# My Arch Linux setup

The repository contains a personal distribution based on Arch Linux with KDE Plasma and is adapted for a computer with the `Gigabyte B550I Aorus Pro AX` motherboard.

> [!Warning]
> - The following steps will erase the entire disk to install the base operating system. Make sure to have a backup outside the computer and check that nothing is missing before proceeding.
> - The author of these scripts is not responsible for any inconveniences.
> - By default, the username and hostname are set to my first and last name, and is part of code.

## Install

Prepare a USB flash drive with an [Arch Linux image](https://archlinux.org/download). During the computer's boot process, select the USB as the boot device (F12). Once Arch Linux Live has started, enter the following commands:

```bash
curl -sfL strappazzon.me/arch | sh -s -- base
```

Once the previous step is completed without errors and you have restarted the computer, run the following command to install KDE Plasma 6.x with all applications:

```bash
curl -sfL strappazzon.me/arch | sh -s -- kde
```

Install aditional applications and tools independently of the desktop:

```bash
curl -sfL strappazzon.me/arch | sh -s -- packages
```

Finally, the work environment needs to be configured:

```bash
curl -sfL strappazzon.me/arch | sh -s -- profile
```

Enjoy!

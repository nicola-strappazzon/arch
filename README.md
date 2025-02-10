# My personal Arch Linux setup

## Install

Ejecute los siguientes comandos desde Arch Linux USB:

> [!Warning]
> El siguiente paso borrara todo el disco.

```bash
pacman -Sy curl
curl -sfL strappazzon.me/arch | sh -s -- install
```

Cuando esta reiniciado el PC, ejecute el siguiente comando para instalar KDE Plasma:

```bash
curl -sfL strappazzon.me/arch | sh -s -- desktop
```

Una ves instalado todo, queda configurar el entorno de trabajo:

```bash
curl -sfL strappazzon.me/arch | sh -s -- profile
```

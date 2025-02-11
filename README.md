# My Arch Linux setup

## Install

Ejecute los siguientes comandos desde Arch Linux USB:

> [!Warning]
> El siguiente paso borrara todo el disco para instalar la base del sistema operativo, asegurece de tener un respaldo fuera del ordenador y revisar que no falte nada antes de continuar.

```bash
pacman -Sy curl
curl -sfL strappazzon.me/arch | sh -s -- install
```

Cuando este completado el paso anterior sin errores y haya reiniciado el ordenador, ejecute el siguiente comando para instalar KDE Plasma 6.x con todas las aplicaciones:

```bash
curl -sfL strappazzon.me/arch | sh -s -- desktop
```

Por último queda configurar el entorno de trabajo:

```bash
curl -sfL strappazzon.me/arch | sh -s -- profile
```

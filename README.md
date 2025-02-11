# My Arch Linux setup

Esta distribución personal basada en Arch Linux está adaptado para un ordenador que tiene la placa base `B550I Aorus Pro AX`.

> [!Warning]
> Los siguientes pasos borrará todo el disco para instalar la base del sistema operativo, asegúrese de tener un respaldo fuera del ordenador y revisar que no falte nada antes de continuar.
> El autor de estos scripts no se hace responsable de cualquier inconveniente.

## Install

Ejecute los siguientes comandos desde Arch Linux USB:

```bash
pacman -Sy curl
curl -sfL strappazzon.me/arch | sh -s -- install
```

Cuando esté completado el paso anterior sin errores y haya reiniciado el ordenador, ejecute el siguiente comando para instalar KDE Plasma 6.x con todas las aplicaciones:

```bash
curl -sfL strappazzon.me/arch | sh -s -- desktop
```

Por último, queda configurar el entorno de trabajo:

```bash
curl -sfL strappazzon.me/arch | sh -s -- profile
```

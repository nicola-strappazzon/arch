Base
- btrfs
- limine
- xdg-terminal-exec
- Reemplazar alacritty foot https://codeberg.org/dnkl/foot
- Instalar nautilus y nautilus-python, imv, evince, mpv, mpv-mpris
- Instalar Walker
- Instalar impala
- Quitar fuzzel
- https://github.com/emersion/mako
- Configurar Walker:
  - Buscador
  - Calc
  - Web Search
  - Clipboard history
  - Apps
  - Emojis
  - Cheat sheet
  - SSH
  - Passwords
  - Messages
  - menu que hace wlogout:
    - Screensaver: omarchy-launch-screensaver force
    - Lock: omarchy-system-lock
    - Suspend: systemctl suspend
    - Hibernate: systemctl hibernate
    - Logout: omarchy-system-logout
    - Restart: omarchy-system-reboot
    - Shutdown: omarchy-system-shutdown
- Configurar wlogout (quitar)
- Configurar xdg-open (pdf, img, video, music, txt, go, ...)
- Probar cambiar de red: wifi/eth
- Teclas multimedia: swayosd, brightnessctl y playerctl

Sistema y servicios base (yo los añadiría sí o sí)
- avahi + nss-mdns — resolución .local / Bonjour.
- power-profiles-daemon — perfiles de energía (Performance/Balanced/Saver) usado por waybar.
- polkit-gnome — agente PolKit gráfico (lo necesitarás para que apps GUI pidan contraseña).
- gnome-keyring + libsecret — keyring para apps (Chrome, GitHub CLI, etc).
- ufw-docker — importante: Docker se salta UFW por defecto, esto lo arregla.
- plocate — locate moderno.
- uwsm — wrapper systemd para sesiones Wayland (lanzar apps con scope/slice). Aunque sigas en sway te puede interesar.

Wayland (compositor-agnóstico)
- swayosd — OSD bonito para volumen/brillo/caps lock (funciona en sway perfectamente).
- satty — anotador de capturas (encaja con grim/slurp que ya tienes).
- wiremix — TUI mixer para PipeWire (alternativa a pavucontrol).
- wl-clipboard — ya lo tienes, ok.

Audio / Vídeo / Imagen
- pamixer — control volumen desde CLI/scripts (más sencillo que wpctl).
- gpu-screen-recorder — grabador por GPU (mejor que screen-record por CPU).
- ffmpegthumbnailer — thumbnails de vídeo en Nautilus.
- obs-studio, kdenlive — captura/edición.
- pinta, xournalpp — editor de imágenes ligero / anotar PDFs.
- tesseract + tesseract-data-eng — OCR (omarchy lo combina con grim+satty para "copiar texto de la pantalla").

Filesystem / Nautilus integrations
- exfatprogs — soporte exFAT.
- gnome-disk-utility — gnome-disks para particionar/montar.
- gvfs-mtp, gvfs-nfs, gvfs-smb — para que Nautilus monte móviles/NFS/Samba.
- sushi — "Quick Look" de macOS dentro de Nautilus (preview con espacio).

Impresión
- cups, cups-browsed, cups-filters, cups-pdf, system-config-printer.

Bluetooth / red / hardware
- bluetui — TUI bluetooth.
- inxi — info hardware.
- inetutils, whois.
- wireless-regdb — regulación wifi por país.

Dev / CLI / TUI
- fastfetch — reemplazo moderno de neofetch (que sigue en tu base).
- github-cli (gh).
- lazygit, lazydocker.
- eza — reemplazo de ls/lsd.
- dust — reemplazo de du.
- gum — para hacer scripts bash bonitos (omarchy lo usa en su menú).
- tldr — man pages cortas.
- mise — gestor de versiones (asdf-like).
- expac — query sobre la DB de pacman (útil para omarchy-update style scripts).
- tree-sitter-cli, luarocks, llvm, clang.

Fonts / Themes
- noto-fonts-emoji — emojis.
- woff2-font-awesome — iconos para waybar.
- ttf-ia-writer — la fuente del estilo omarchy.
- yaru-icon-theme — iconos Yaru.
- gnome-themes-extra, kvantum-qt5 — coherencia GTK/Qt.

Calculadora
- gnome-calculator + libqalculate (el motor lo usa walker para hacer cálculos inline).

# Execute Bash script remotely

## cURL

```bash
pacman -Sy curl
curl -s -f -L strappazzon.me/arch | sh
curl -sfL strappazzon.me/arch | sh -s -- arg1 arg2
bash < <(curl -sL strappazzon.me/arch)
bash < <(curl -sL strappazzon.me/arch) -s arg1 arg2
```

## Local

```bash
python3 -m http.server 8080 -b 0.0.0.0
```

```bash
pacman -Sy curl
curl -sfL 192.168.1.100:8080/main.sh | sh -s base
```

picom para mejorar aspectos visuales, redondear esquinas, fondo transparente.
https://ntk148v.github.io/posts/getting-started-tiling-wm-part-6-i3-rounded-corners/


lock screen

https://i3-for-unity-users.readthedocs.io/en/stable/07-SuspendLockShutdown/
https://gist.github.com/rometsch/6b35524bcc123deb7cd30b293f2088d8

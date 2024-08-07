# Execute Bash script remotely

## cURL

```bash
pacman -Sy curl
curl -s -f -L strappazzon.me/arch | sh
curl -sfL strappazzon.me/arch | sh -s -- arg1 arg2
bash < <(curl -sL strappazzon.me/arch)
bash < <(curl -sL strappazzon.me/arch) -s arg1 arg2
```

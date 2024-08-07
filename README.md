# Execute Bash script remotely

## cURL

```bash
curl -s -f -L https://strappazzon.me/arch | sh
curl -sfL https://strappazzon.me/arch | sh -s -- arg1 arg2
bash < <(curl -sL https://strappazzon.me/arch)
bash < <(curl -sL https://strappazzon.me/arch) -s arg1 arg2
```

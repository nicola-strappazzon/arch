# Execute Bash script remotely

## cURL

```bash
curl -s -f -L https://strappazzon.me/get | sh
curl -sfL https://strappazzon.me/get | sh -s -- arg1 arg2
bash < <(curl -sL https://strappazzon.me/get)
bash < <(curl -sL https://strappazzon.me/get) -s arg1 arg2
```

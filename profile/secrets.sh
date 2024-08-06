#!/usr/bin/env sh
set -eu

.gnupg/

pass env/cloudflare > ~/.bashrc.d/env/cloudflare.sh

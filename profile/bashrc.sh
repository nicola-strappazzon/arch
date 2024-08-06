#!/usr/bin/env sh
set -eu

mkdir -p ~/.bashrc.d/
mkdir -p ~/.bashrc.d/alias/
mkdir -p ~/.bashrc.d/env/
mkdir -p ~/.bashrc.d/functions/
chmod -R 0700 ~/.bashrc.d

sudo rm -f /etc/profile.d/bashrc.sh
sudo tee -a /etc/profile.d/bashrc.sh > /dev/null <<'EOF'
if [ -x ~/.bashrc.d ]; then
  for i in ~/.bashrc.d/*.sh; do
    if [ -f "$i" ]; then
      . "$i"
    fi
  done
fi
EOF

if [ -f ~/.bashrc ]; then
    grep -qxF '[[ -f /etc/profile.d/bashrc.sh ]] && . /etc/profile.d/bashrc.sh' ~/.bashrc || \
    echo '[[ -f /etc/profile.d/bashrc.sh ]] && . /etc/profile.d/bashrc.sh' >> ~/.bashrc
fi

tee -a ~/.bashrc.d/alias.sh > /dev/null <<'EOF'
if [ -x ~/.bashrc.d/alias/ ]; then
  for i in $(find ~/.bashrc.d/alias/ -type f ); do
    source "$i"
  done
fi
EOF

tee -a ~/.bashrc.d/env.sh > /dev/null <<'EOF'
if [ -x ~/.bashrc.d/env/ ]; then
  for i in $(find ~/.bashrc.d/env/ -type f ); do
    source "$i"
  done
fi
EOF

tee -a ~/.bashrc.d/functions.sh > /dev/null <<'EOF'
if [ -x ~/.bashrc.d/functions/ ]; then
  for i in $(find ~/.bashrc.d/functions/ -type f ); do
    source "$i"
  done
fi
EOF

tee -a ~/.bashrc.d/alias/general.sh > /dev/null <<'EOF'
alias l="ls -lah"
alias c="clear"
alias reload="source ~/.bashrc.d/*.sh"
alias s="fzf -i --print0 | xclip -selection clipboard"
EOF

tee -a ~/.bashrc.d/alias/golang.sh > /dev/null <<'EOF'
alias gf="gofmt -w ."
EOF

tee -a ~/.bashrc.d/alias/git.sh > /dev/null <<'EOF'
alias gh="cd $HOME/go/src/github.com"
alias gs="git status"
alias ga="git add ."
alias gcane="git commit --amend --no-edit"
alias gpf="git push -f"
alias gw="git whatchanged"
EOF

tee -a ~/.bashrc.d/alias/docker.sh > /dev/null <<'EOF'
alias dps="sudo docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}'"
EOF

tee -a ~/.bashrc.d/env/general.sh > /dev/null <<'EOF'
export GOPATH=$HOME/go
export PATH=$PATH:$(go env GOPATH)/bin
export EDITOR=vim
export TERM=xterm
export BROWSER=firefox
export CLICOLOR=1
export LS_COLORS="di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31"
export PS1="\[\033[32m\]\W\[\033[31m\]\[\033[32m\]$\[\e[0m\] "
EOF

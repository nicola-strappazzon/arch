#!/usr/bin/env bash
# set -eu

# shellcheck disable=SC2119,SC2120
function main() {
    sudo -v
    
    configure_alacritty
    configure_git
    configure_gpg
    configure_helix
    configure_profile
    configure_tmux
    configure_udev
    configure_vim
    configure_vscode
    finish
}

function configure_alacritty() {
    echo "--> Configure Alacritty."

    mkdir -p "$HOME"/.config/alacritty/
    cat > "$HOME"/.config/alacritty/alacritty.toml << 'EOF'
[terminal]
shell = { program = "/bin/bash", args = ["-l", "-c", "zellij"] }

[bell]
duration = 0

[cursor.style]
blinking = "Always"
shape = "Underline"

[selection]
save_to_clipboard = true

[mouse]
bindings = [{mouse = "Right", action = "Paste"}]

[window]
opacity = 1.0
startup_mode = "Maximized"
EOF
}

function configure_profile() {
    echo "--> Configure profile."

    mkdir -p "$HOME"/.bashrc.d/
    mkdir -p "$HOME"/.bashrc.d/alias/
    mkdir -p "$HOME"/.bashrc.d/env/
    mkdir -p "$HOME"/.bashrc.d/functions/
    chmod -R 0700 "$HOME"/.bashrc.d

    cat > "$HOME"/.bashrc.d/alias.sh << 'EOF'
if [ -x ~/.bashrc.d/alias/ ]; then
  for i in $(find ~/.bashrc.d/alias/ -type f ); do
    source "$i"
  done
fi
EOF

    cat > "$HOME"/.bashrc.d/env.sh << 'EOF'
if [ -x ~/.bashrc.d/env/ ]; then
  for i in $(find ~/.bashrc.d/env/ -type f ); do
    source "$i"
  done
fi
EOF

    cat > "$HOME"/.bashrc.d/functions.sh << 'EOF'
if [ -x ~/.bashrc.d/functions/ ]; then
  for i in $(find ~/.bashrc.d/functions/ -type f ); do
    source "$i"
  done
fi
EOF

    cat > "$HOME"/.bashrc.d/alias/docker.sh << 'EOF'
alias dps="sudo docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}'"
EOF

    cat > "$HOME"/.bashrc.d/alias/general.sh << 'EOF'
alias c="reset;clear"
alias d="diff --color=auto"
alias x="yazi"
alias f="fzf -i --print0 | xclip -selection clipboard"
alias g="grep --color"
alias h="history"
alias e="helix"
alias ll="lsd -laS --color=auto"
alias l="lsd -lahS --color=auto"
alias md="glow --line-numbers --pager"
alias o="dolphin . &> /dev/null &"
alias r="source ~/.bashrc"
alias p="btop"
alias copy='xclip -sel clip'
EOF

    cat > "$HOME"/.bashrc.d/alias/git.sh << 'EOF'
alias ga="git add ."
alias gcane="git commit --amend --no-edit"
alias gpf="git push -f"
alias gs="git status"
alias gw="git whatchanged"
alias gd="git diff"
EOF

    cat > "$HOME"/.bashrc.d/alias/golang.sh << 'EOF'
alias gf="gofmt -w ."
EOF

    cat > "$HOME"/.bashrc.d/env/general.sh << 'EOF'
export BROWSER=firefox
export CLICOLOR=1
export EDITOR=helix
export SUDO_EDITOR=$(which helix)
export GOPATH=$HOME/go
export LS_COLORS="di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31"
export PATH=$PATH:$(go env GOPATH)/bin
export PS1="\[\033[32m\]\W\[\033[31m\]\[\033[32m\]$\[\e[0m\] "
export TERM=xterm
export LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=00:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.7z=01;31:*.ace=01;31:*.alz=01;31:*.apk=01;31:*.arc=01;31:*.arj=01;31:*.bz=01;31:*.bz2=01;31:*.cab=01;31:*.cpio=01;31:*.crate=01;31:*.deb=01;31:*.drpm=01;31:*.dwm=01;31:*.dz=01;31:*.ear=01;31:*.egg=01;31:*.esd=01;31:*.gz=01;31:*.jar=01;31:*.lha=01;31:*.lrz=01;31:*.lz=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.lzo=01;31:*.pyz=01;31:*.rar=01;31:*.rpm=01;31:*.rz=01;31:*.sar=01;31:*.swm=01;31:*.t7z=01;31:*.tar=01;31:*.taz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tgz=01;31:*.tlz=01;31:*.txz=01;31:*.tz=01;31:*.tzo=01;31:*.tzst=01;31:*.udeb=01;31:*.war=01;31:*.whl=01;31:*.wim=01;31:*.xz=01;31:*.z=01;31:*.zip=01;31:*.zoo=01;31:*.zst=01;31:*.avif=01;35:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:*~=00;90:*#=00;90:*.bak=00;90:*.crdownload=00;90:*.dpkg-dist=00;90:*.dpkg-new=00;90:*.dpkg-old=00;90:*.dpkg-tmp=00;90:*.old=00;90:*.orig=00;90:*.part=00;90:*.rej=00;90:*.rpmnew=00;90:*.rpmorig=00;90:*.rpmsave=00;90:*.swp=00;90:*.tmp=00;90:*.ucf-dist=00;90:*.ucf-new=00;90:*.ucf-old=00;90:';
EOF

    cat > "$HOME"/.bashrc.d/functions/aws.sh << 'EOF'

aws-ssm-login() {
    if [ -z "$1" ]; then
        echo "No argument supplied."
        echo "Usage: aws-ssm-login profile-stg"
        return
    fi

    aws sso login --profile $1 --no-browser
    eval "$(aws configure export-credentials --profile $1 --format env)"
    export AWS_PROFILE="$1"
}

aws-ec2-list() {
    if [[ -z "${AWS_PROFILE}" ]]; then
        echo "Environment variable AWS_PROFILE undefined."
        return
    fi

    if [ -z "$1" ]; then
        echo "No argument supplied."
        echo "Usage: aws-ec2-list instance_name"
        return
    fi

    aws ec2 describe-instances --profile $AWS_PROFILE --filters "Name=tag:Name,Values=${1}" | jq -r '(["Instance ID", "State", "Type", "Private IP", "Public IP"] | (., map(length*"-"))), (.Reservations[].Instances[] | [.InstanceId,.State.Name,.InstanceType,.PrivateIpAddress,.PublicIp]) | @tsv' | column -t -s $'\t'
}

aws-ec2-ssm-connect() {
    if [[ -z "${AWS_PROFILE}" ]]; then
        echo "Environment variable AWS_PROFILE undefined."
        return
    fi

    if [ -z "$1" ]; then
        echo "No argument supplied."
        echo "Usage: aws-ec2-ssm-connect instance_id"
        return
    fi

    aws ssm start-session \
        --document-name AWS-StartInteractiveCommand \
        --profile=$AWS_PROFILE \
        --target=$1 \
        --parameters command="bash -l"
}

aws-ec2-ssm-port-forward() {
    if [[ -z "${AWS_PROFILE}" ]]; then
        echo "Environment variable AWS_PROFILE undefined."
        return
    fi

    if [ $# -lt 2 ]; then
        echo "No argument supplied."
        echo "Usage: aws-ec2-ssm-port-forward instance_id 3000"
        return
    fi

    aws ssm start-session \
        --profile=$AWS_PROFILE \
        --target=$1 \
        --document-name AWS-StartPortForwardingSession \
        --parameters "{\"portNumber\":[\"$2\"],\"localPortNumber\":[\"$2\"]}"

}

aws-databases-list () {
    if [[ -z "${AWS_PROFILE}" ]]; then
        echo "Environment variable AWS_PROFILE undefined."
        return
    fi

    aws rds describe-db-instances \
        --profile=$AWS_PROFILE \
        --query 'DBInstances[]' | jq -r '(["Instance Identifier","Class","Engine", "MultiAZ", "AZ", "StorageType", "Delete", "Status"] | (., map(length*"-"))), (.[] | [.DBInstanceIdentifier, .DBInstanceClass, .Engine, .MultiAZ, .AvailabilityZone, .StorageType, .DeletionProtection, .OptionGroupMemberships[].Status]) | @tsv' | column -t -s $'\t'
}

aws-database-describe () {
    if [[ -z "${AWS_PROFILE}" ]]; then
        echo "Environment variable AWS_PROFILE undefined."
        return
    fi

    if [ -z "$1" ]; then
        echo "No argument supplied."
        echo "Usage: aws-database-describe xxx-yyy-mysql-zzz-node01"
        return
    fi

    aws rds describe-db-instances \
        --profile=$AWS_PROFILE \
        --db-instance-identifier=$1 \
        --output table
}

aws-database-logs-list () {
    if [[ -z "${AWS_PROFILE}" ]]; then
        echo "Environment variable AWS_PROFILE undefined."
        return
    fi

    if [ -z "$1" ]; then
        echo "No argument supplied."
        echo "Usage: aws-database-logs-list xxx-yyy-mysql-zzz-node01"
        return
    fi

    aws rds describe-db-log-files \
        --profile=$AWS_PROFILE \
        --db-instance-identifier=$1 | \
    jq -r '.[][] | [.LastWritten,.Size,.LogFileName] | @tsv'
}

aws-database-logs-download-all() {
    aws rds describe-db-log-files \
        --db-instance-identifier=$1 | \
    jq -r '.[][] | [.LogFileName] | @tsv' | \
    xargs -I{} \
    aws rds download-db-log-file-portion \
        --db-instance-identifier=$1 \
        --starting-token 0 \
        --output text \
        --log-file-name {} > $1.log
}

aws-database-logs-download() {
    aws rds download-db-log-file-portion \
        --db-instance-identifier=$1 \
        --starting-token 0 \
        --output text \
        --log-file-name $2 > "${1}_${2/\//_}.log"
}

aws-database-parameter-group-list () {
    if [ -z "$1" ]; then
        echo "No argument supplied."
        echo "Usage: aws-database-parameter-group-list pg-xxx-yyy-mysql-zzz-nodes"
        return
    fi

    aws rds describe-db-parameters \
        --db-parameter-group-name=$1 | \
    jq 'del(.[][].Description)' | \
    jq -r '.[][] | [.ParameterName,.ParameterValue] | @tsv' | \
    awk -v FS="\t" '{if ($2) printf "%s=%s%s",$1,$2,ORS}'
}

aws-database-parameter-group-set () {
    if [ -z "$1" ] && [ -z "$2" ] && [ -z "$3" ]; then
        echo "No argument supplied."
        echo "Usage: aws-database-parameter-group-set pg-xxx-yyy-mysql-zzz-nodes parameter value"
        return
    fi

    aws rds modify-db-parameter-group \
        --db-parameter-group-name $1 \
        --parameters "ParameterName=$2,ParameterValue=$3,ApplyMethod=immediate"
}

aws-set-keys() {
    if [ -z "$1" ]; then
        echo "No argument supplied."
        echo "Usage: aws-set-keys profile-stg"
        return
    fi

    aws-uset

    export AWS_ACCESS_KEY_ID=$(aws --profile $1 configure get aws_access_key_id)
    export AWS_DEFAULT_REGION=$(aws --profile $1 configure get region)
    export AWS_REGION=$(aws --profile $1 configure get region)
    export AWS_SECRET_ACCESS_KEY=$(aws --profile $1 configure get aws_secret_access_key)
    export AWS_PROFILE="$1"
}

aws-uset() {
    unset AWS_ACCESS_KEY_ID
    unset AWS_DEFAULT_REGION
    unset AWS_REGION
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_PROFILE
}

aws-get-secrets() {
    aws secretsmanager list-secrets --profile=$AWS_PROFILE | jq -r '.SecretList[] | .Name'
}

aws-get-secrets-values() {
    SECRETS=$(
        aws secretsmanager list-secrets --profile=$AWS_PROFILE | jq -r '.SecretList[] | .Name'
    )

    for SECRET in $SECRETS; do
        KEYS=$(
            aws secretsmanager get-secret-value \
                --profile=$AWS_PROFILE \
                --secret-id "${SECRET}" \
                --query SecretString \
                --output text | \
            tr -d '\n\t\r ' | \
            jq \
                --compact-output \
                --raw-output \
                --monochrome-output \
                "to_entries|map(\"\(.key)=\(.value|tostring)\") | .[]" \
            2> /dev/null
        )

        for KEY in $KEYS; do
            echo "${SECRET} ${KEY}"
        done
    done
}

aws-get-secret() {
    if [ -z "$1" ]; then
        echo "No argument supplied."
        echo "Usage: aws-get-secret xxx-yyy-project"
        return
    fi

    KEYS=$(
        aws secretsmanager get-secret-value \
            --profile=$AWS_PROFILE \
            --secret-id $1 \
            --query SecretString \
            --output text | \
        tr -d '\n\t\r ' | \
        jq \
            --compact-output \
            --raw-output \
            --monochrome-output \
             "to_entries|map(\"\(.key)=\(.value|tostring)\") | .[]" \
        2> /dev/null
    )

    for KEY in $KEYS; do
        echo "${KEY}"
        eval "export ${KEY}"
    done
}
EOF

    cat > "$HOME"/.bashrc.d/functions/general.sh << 'EOF'
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2) tar xjf $1   ;;
            *.tar.gz)  tar xzf $1   ;;
            *.bz2)     bunzip2 $1   ;;
            *.rar)     unrar e $1   ;;
            *.gz)      gunzip $1    ;;
            *.tar)     tar xf $1    ;;
            *.tbz2)    tar xjf $1   ;;
            *.tgz)     tar xzf $1   ;;
            *.zip)     unzip $1     ;;
            *.Z)       uncompress $1;;
            *.7z)      7z x $1      ;;
            *)         echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

hex2dec () {
    echo "ibase=16; $1" | bc
}

dec2hex () {
    echo "obase=16; $1" | bc
}

dec2bin () {
    echo "obase=2; $1" | bc
}

curl_json_to_table() {
    RULES="[.[]| with_entries( .key |= ascii_downcase ) ] |
           (.[0] | keys_unsorted | @tsv),
           (.[]  | map(.) | @tsv)"

    curl \
        --silent \
        --compressed \
        --globoff \
        --request GET \
        "$1" | \
    jq '.data' | \
    jq -r "$RULES" | \
    column -ts $'\t' | \
    less -S
}

jq-help() {
    echo "To CSV: jq -r '(map(keys_unsorted) | add | unique) as \$cols | \$cols, map(. as \$row | \$cols | map(\$row[.]))[] | @csv'"
}

backup-music-usb() {
    rsync -CPavzt /home/nicola/Music/ /run/media/nicola/Music/
}

backup-music-synology() {
    /usr/bin/rsync -CPavzt --rsync-path=/bin/rsync -e ssh /home/nicola/Music/ nicola@192.168.1.100:/var/services/homes/nicola/Music/
}

backup-icloud-local() {
    icloudpd --username nicola@strappazzon.me --directory /home/nicola/Pictures/iCloud/
}

raspberri-pi-find() {
    sudo nmap -sP 192.168.1.0/24 | awk '/^Nmap/{ip=$NF}/B8:27:EB/{print ip}'
}
EOF

    cat > "$HOME"/.bashrc.d/env/gpg.sh << 'EOF'
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
EOF

    cat > "$HOME"/.bashrc.d/functions/k8.sh << 'EOF'
k8 () {
    if [ -z "$K8_NAMESPACE" ]; then
        echo "First, set environment executing: [loc|stg|prd]-<app>"
        return
    fi

    alias k8-context="kubectl config get-contexts"
    alias k8-resources="kubectl get all -n $K8_NAMESPACE"
    alias k8-pods="kubectl get pods --namespace $K8_NAMESPACE"
    alias k8-restart="kubectl rollout restart deployment $K8_DEPLOYMENT --namespace $K8_NAMESPACE"
    alias k8-describe="kubectl describe deployment/$K8_DEPLOYMENT --namespace $K8_NAMESPACE"
    alias k8-deployments="kubectl get deployments --namespace $K8_NAMESPACE"
    alias k8-deployments-logs="kubectl logs deployment/$K8_DEPLOYMENT --all-containers=true --since=10m --follow --namespace $K8_NAMESPACE"
    alias k8-cronjobs="kubectl get cronjobs --namespace $K8_NAMESPACE"
    alias k8-rollout-history="kubectl rollout history deployment/$K8_DEPLOYMENT --namespace $K8_NAMESPACE"
}

k8-pod-logs () {
    if [ -z "$K8_NAMESPACE" ]; then
        echo "First, set environment executing: [loc|stg|prd]-<app>"
        return
    fi

    kubectl logs pod/$1 --follow --namespace $K8_NAMESPACE
}

k8-pod-ssh () {
    if [ -z "$K8_NAMESPACE" ]; then
        echo "First, set environment executing: [loc|stg|prd]-<app>"
        return
    fi

    kubectl exec --stdin --tty $1 --namespace $K8_NAMESPACE -- /bin/sh
}

k8-rollout() {
    if [ -z "$K8_NAMESPACE" ]; then
        echo "First, set environment executing: [loc|stg|prd]-<app>"
        return
    fi

    kubectl rollout undo deployment/$K8_DEPLOYMENT --to-revision=$1 --namespace $K8_NAMESPACE
}

k8-rollback() {
    if [ -z "$K8_NAMESPACE" ]; then
        echo "First, set environment executing: [loc|stg|prd]-<app>"
        return
    fi

    helm rollback $K8_DEPLOYMENT-release
}

k8-help() {
    echo -e "\033[0;32mCommands for: kubectl\033[0m"
    echo "kubectl config view"
    echo "kubectl config get-contexts"
    echo "kubectl config use-context <namespace>"
    echo "kubectl cluster-info"
    echo "kubectl get all --all-namespaces"
    echo "kubectl get all -n <namespace>"
    echo "kubectl get namespace"
    echo "kubectl get deployments --namespace <namespace>"
    echo "kubectl get pods --namespace <namespace>"
    echo "kubectl get jobs --namespace <namespace>"
    echo "kubectl logs deployment/<name-deployment> --all-containers=true --since=10m --follow --namespace <namespace>"
    echo "kubectl logs <pod-name> --namespace <namespace>"
    echo "kubectl describe deployment/<name-deployment> --namespace <namespace>"
    echo "kubectl exec --stdin --tty <pod-name> --namespace <namespace> -- /bin/bash"
    echo "kubectl exec --stdin --tty <pod-name> --container <container> --namespace <namespace> -- /bin/bash"
    echo "kubectl scale deployment <name-deployment> --replicas=<number> --namespace <namespace>"
    echo "kubectl rollout history deployment/<name-deployment> --namespace <namespace>"
    echo "kubectl rollout undo deployment/<name-deployment> --to-revision=<id> --namespace <namespace>"
    echo -e "\033[0;32mCommands for: helm\033[0m"
    echo "helm rollback <namespace>-release"
}
EOF

    cat > "$HOME"/.bashrc.d/functions/mysql.sh << 'EOF'
m () {
    if [ -z "$1" ]; then
        echo "No argument supplied."
        echo "Usage: m xxx-yyy-mysql-zzz-node01"
        return
    fi

    echo "mysql -h ${1}\${AWS_RDS_CNAME} -u \$MYSQL_USER -p\${MYSQL_PASSWORD} -A"

    if [ -z "$2" ]; then
        mysql -h ${1}${AWS_RDS_CNAME} -u $MYSQL_USER -p${MYSQL_PASSWORD} -A
    else
        mysql -h ${1}${AWS_RDS_CNAME} -u $MYSQL_USER -p${MYSQL_PASSWORD} -A -e "$2"
    fi
}
EOF

    cat > "$HOME"/.bashrc.d/functions/redpanda.sh << 'EOF'
redpanda(){
    if [ -z "$REDPANDA_CONFIG" ]; then
        echo "First, set environment executing: [loc|stg|prd]-redpanda"
        return
    fi

    unset REDPANDA_TLS_CERT
    unset REDPANDA_TLS_KEY

    alias rp="rpk --config $REDPANDA_CONFIG --brokers $REDPANDA_BROKERS"
    alias rp-list="rp topic list"
    alias rp-describe="rp topic describe"
    alias rp-consume="rp topic consume"

    alias rp-produce="rp topic produce"
    alias rp-config="rp topic alter-config"
    alias rp-groups="rp group list"
    alias rp-group-describe="rp group describe"
    alias rp-topic-delete="rp topic delete $1"
}

redpanda-help() {
    echo "rp topic consume <topic_name> -v -o end -n 1 -g TEST_<user_name>"
}
EOF

    cat << EOF | sudo tee /etc/profile.d/common.sh &> /dev/null
function append_path() {
    case ":$PATH:" in
        *:"$1":*)
            ;;
        *)
        PATH="${PATH:+$PATH:}$1"
    esac
}
EOF
}

function configure_git() {
    echo "--> Configure git."

    git config --global commit.gpgsign true
    git config --global init.defaultBranch main
    git config --global pull.rebase true
    git config --global push.autoSetupRemote true
    git config --global tag.gpgSign true
    git config --global user.email nicola@strappazzon.me
    git config --global user.name "Nicola Strappazzon."
    git config --global user.signingkey 9186C4129FFD3D2500B35FA18E97CAEEEE861364
}

function configure_gpg() {
    echo "--> Configure GPG."

    echo "DA0D2EC084DA5974997B8F5D3BAB49A94D82E715" > ~/.gnupg/sshcontrol

    cat > "$HOME"/.gnupg/gpg-agent.conf << 'EOF'
enable-ssh-support
default-cache-ttl 43200
max-cache-ttl 43200
EOF

    gpgconf --kill gpg-agent
}

function configure_helix() {
    echo "--> Configure Helix"

    mkdir -p "$HOME"/.config/helix/
    cat > "$HOME"/.config/helix/config.toml << 'EOF'
theme = "adwaita-dark"

[keys.normal]
y = "yank_joined_to_clipboard"
p = "paste_clipboard_before"
C-up = [ # scroll selections up one line
    "ensure_selections_forward",
    "extend_to_line_bounds",
    "extend_char_right",
    "extend_char_left",
    "delete_selection",
    "move_line_up",
    "add_newline_above",
    "move_line_up",
    "replace_with_yanked"
]
C-down = [ # scroll selections down one line
    "ensure_selections_forward",
    "extend_to_line_bounds",
    "extend_char_right",
    "extend_char_left",
    "delete_selection",
    "add_newline_below",
    "move_line_down",
    "replace_with_yanked"
]

[editor.whitespace.render]
space = "all"
tab = "all"
newline = "none"

EOF
}

function configure_vim() {
    echo "--> Configure vim."

    cat > "$HOME"/.vimrc << 'EOF'
" Global settings
set hidden                                                  " Don't unload buffer when switching away.
set modeline                                                " Allow per-file settings via modeline.
set modelines=3                                             "
set exrc                                                    " Enable per-directory .vimrc files.
set secure                                                  " Disable unsafe commands in local .vimrc files.
set encoding=utf-8 fileencoding=utf-8 termencoding=utf-8    " Saving and encoding.
set nobackup nowritebackup noswapfile autoread              " No backup or swap.
set hlsearch incsearch ignorecase smartcase                 " Search.
set wildmenu                                                " Completion.
set backspace=indent,eol,start                              " Sane backspace.
set clipboard=unnamed                                       " Use the system clipboard for yank/put/delete.
set mouse=a                                                 " Enable mouse for all modes settings.
set nomousehide                                             " Don't hide the mouse cursor while typing.
set mousemodel=popup                                        " Right-click pops up context menu.
set ruler                                                   " Show cursor position in status bar.
"set relativenumber                                         " Show relative line numbers.
set number                                                  " Show absolute line number of the current line.
"set nofoldenable                                           " I fucking hate code folding.
"set scrolloff=10                                           " Scroll the window so we can always see 10 lines around the cursor.
set textwidth=80                                            " Show a vertical line at the 79th character.
"set cursorline                                             " Highlight the current line.
set printoptions=paper:letter                               " Use letter as the print output format.
set laststatus=2                                            " Always show status bar.
set nocompatible                                            " Stops vim from behaving in a strongly vi.
set nowrap                                                  " No wrap line.
"set visualbell                                             " Don't beep.
set noerrorbells                                            " Don't beep.
set nosmartindent                                           " Reacts to the syntax/style of the code you are editing.
set noautoindent                                            " Disable auto ident.
set filetype=on                                             " Detect the type of file that is edited.
EOF
}

function configure_tmux() {
    echo "--> Configure tmux."

    cat > "$HOME"/.tmux.conf << 'EOF'
unbind r
bind r source-file ~/.tmux.conf

set -g prefix M-s
set -g mouse on

set-option -g default-terminal screen-256color
EOF
}

function configure_vscode() {
    echo "--> Configure vscode."

    mkdir -p "$HOME"/.config/VSCodium/User/

    cat > "$HOME"/.config/VSCodium/User/settings.json << 'EOF'
{
  "editor.fontSize": 14,
  "editor.minimap.enabled": false,
  "editor.occurrencesHighlight": "off",
  "editor.selectionHighlight": false,
  "editor.suggestOnTriggerCharacters": false,
  "editor.tabCompletion": "on",
  "editor.tabSize": 2,
  "editor.quickSuggestions": {
    "other": false,
    "comments": false,
    "strings": false
  },
  "explorer.confirmDelete": false,
  "extensions.ignoreRecommendations": true,
  "files.trimTrailingWhitespace": true,
  "git.autofetch": true,
  "git.confirmSync": false,
  "git.ignoreMissingGitWarning": true,
  "git.openRepositoryInParentFolders": "always",
  "security.workspace.trust.untrustedFiles": "open",
  "window.menuBarVisibility": "compact",
  "window.titleBarStyle": "custom",
  "workbench.activityBar.location": "hidden",
  "workbench.colorTheme": "Tokyo Night",
  "workbench.iconTheme": "vs-minimal",
  "workbench.startupEditor": "none"
}
EOF
}

function configure_udev() {
    echo "--> Configure udev rules."

    cat << EOF | sudo tee /etc/udev/rules.d/50-embedded_devices.rules &> /dev/null
SUBSYSTEMS=="usb", ATTRS{product}== "Arduino Uno", GROUP="users", MODE="0666"
SUBSYSTEMS=="usb", ATTRS{product}== "FT232R USB UART", GROUP="users", MODE="0666"
SUBSYSTEMS=="usb", ATTRS{product}== "USBtiny", GROUP="users", MODE="0666"
SUBSYSTEMS=="usb", ATTRS{product}== "USBtinyISP", GROUP="users", MODE="0666"
SUBSYSTEMS=="usb", ATTRS{product}== "QinHeng Electronics CH340 serial converter", GROUP="users", MODE="0666"
EOF

    sudo udevadm control --reload
    sudo udevadm trigger
}

function finish() {
    echo "--> To apply the changes:"
    echo "    Close and reopen the terminal."
    sudo -k
}

main "$@"

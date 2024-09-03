#!/usr/bin/env bash
# set -eu

main() {
    update
    ntp
    drivers
    xorg
    fonts
    desktop
    display_manager
    theme
    launcher
    packages
    printing
    yay_install
    yay_packages
    docker_install

    configure_xorg
    configure_gtk
    configure_home_dirs
    configure_profile
    configure_wakeup
    configure_git
    configure_login
    configure_i3wm
    configure_polybar
    configure_notification
    configure_xterm
    configure_rofi
    configure_screenshot
    configure_feh
    configure_vim
    configure_applications_desktop
    configure_playerctl
    configure_mocp
}

update() {
    sudo pacman -Sy &> /dev/null
}

ntp() {
    echo "--> Configure time zone and NTP."
    sudo timedatectl set-timezone Europe/Madrid
    sudo timedatectl set-ntp true
    sudo hwclock --systohc
}

drivers() {
    echo "--> Install drivers."
    sudo pacman -S --noconfirm --needed \
        xf86-video-amdgpu \
        alsa-firmware \
        alsa-utils \
        amd-ucode \
        pulseaudio \
        pulseaudio-alsa \
        ddcutil \
    &> /dev/null
}

xorg() {
    echo "--> Install xorg."
    sudo pacman -S --noconfirm --needed \
        xorg \
        xorg-server \
        xorg-xinit \
        xorg-fonts-misc \
        xorg-mkfontscale \
    &> /dev/null
}

fonts() {
    echo "--> Install fonts."
    sudo pacman -S --noconfirm --needed \
        adobe-source-sans-fonts \
        noto-fonts \
        noto-fonts-cjk \
        noto-fonts-emoji \
        terminus-font \
        ttf-dejavu \
        ttf-droid \
        ttf-font-awesome \
        ttf-inconsolata \
        ttf-indic-otf \
        ttf-liberation \
        ttf-nerd-fonts-symbols \
    &> /dev/null

    fc-cache -f -v &> /dev/null
}

desktop() {
    echo "--> Install desktop."
    sudo pacman -S --noconfirm --needed \
        i3-wm   `#Desktop environment`  \
        polybar `#Desktop bar`          \
        dunst   `#Notification daemons` \
        feh     `#Wallpaper tool`       \
        xterm   `#Terminal emulator`    \
    &> /dev/null
}

theme() {
    echo "--> Install themes."
    sudo pacman -S --noconfirm --needed \
        lxappearance \
        materia-gtk-theme \
        papirus-icon-theme \
    &> /dev/null
}

display_manager() {
    echo "--> Install display manager."
    sudo pacman -S --noconfirm --needed \
        sddm \
        qt6-svg \
    &> /dev/null
    sudo systemctl enable sddm.service &> /dev/null
}

launcher() {
    echo "--> Install application launcher."
    sudo pacman -S --noconfirm --needed \
        rofi \
        rofi-calc \
        rofi-emoji \
        rofi-pass \
    &> /dev/null
}

packages() {
    echo "--> Install packages."
    sudo pacman -S --noconfirm --needed \
        cheese              `#Webcam GUI`                \
        evince              `#PDF viewer`                \
        firefox             `#WEB browser`               \
        flameshot           `#Screenshot`                \
        mpv                 `#Video player`              \
        nemo                `#File manager`              \
        nemo-fileroller     `#File archiver extension`   \
        nemo-preview        `#Previewer extension`       \
        pragha              `#Audio player`              \
        playerctl           `#Multimedia player control` \
        arduino-ide         `#Arduino IDE`               \
        nicotine+           `#Music sharing client`      \
        texmaker            `#LaTex editor`              \
        texlive-latexextra  `#LaTex`                     \
        texlive-fontsextra  `#LaTex`                     \
        texlive-bibtexextra `#LaTex`                     \
        texlive-humanities  `#LaTex`                     \
        texlive-langspanish `#LaTex`                     \
        texlive-latexextra  `#LaTex`                     \
        texlive-mathscience `#LaTex`                     \
        texlive-pictures    `#LaTex`                     \
        texlive-publishers  `#LaTex`                     \
        qemu-full           `#Virtual Machine emulator`  \
        kicad               `#Electronics Design`        \
        kicad-library       `#Electronics Design`        \
        kicad-library-3d    `#Electronics Design`        \
        qimgv               `#Image viewer`              \
        thunderbird         `#Email client`              \
        evince              `#Document viewer`           \
        testdisk            `#Recovery tool`             \
        dosfstools          `#DOS file system & tools`   \
    &> /dev/null
}

printing() {
    echo "--> Install printing system."
    sudo pacman -S --noconfirm --needed \
        cups                  `#Printing system`         \
        system-config-printer `#Print settings`          \
    &> /dev/null

    sudo systemctl start cups.service &> /dev/null
    sudo systemctl enable cups.service &> /dev/null
}

yay_install() {
    echo "--> Install yay tool."
    if ! type "git" > /dev/null; then
        echo "Could not find: git"
        exit 1
    fi

    if ! type "makepkg" > /dev/null; then
        echo "Could not find: makepkg"
        exit 1
    fi

    if ! type "go" > /dev/null; then
        echo "Could not find: go"
        exit 1
    fi

    if ! type "yay" &> /dev/null; then
        tmp="$(mktemp -d)"

        mkdir -p $tmp

        if [[ ! "${tmp}" || ! -d "${tmp}" ]]; then
            echo "Could not find ${tmp} dir"
            exit 1
        fi

        cd $tmp
        git clone https://aur.archlinux.org/yay.git &> /dev/null
        cd yay
        makepkg -sif --noconfirm &> /dev/null
    fi
}

yay_packages() {
    echo "--> Install yay packages."
    yay -Sy --noconfirm --needed \
        moc-pulse            `#Music on Console`             \
        sublime-text-4       `#Source code editor`           \
        ivpn                 `#VPN Client`                   \
        colorpicker          `#Terminal color picker`        \
        qt-heif-image-plugin `#Image format plugin for HEIF` \
        nulloy               `#Minimal music player`         \
    &> /dev/null
}

docker_install() {
    echo "--> Install docker."
    if ! type "docker" > /dev/null; then
        sudo pacman -S docker --noconfirm --needed &> /dev/null
        sudo systemctl start docker.service &> /dev/null
        sudo systemctl enable docker.service &> /dev/null
        sudo newgrp docker &> /dev/null
        sudo usermod -aG docker $USER &> /dev/null
    fi
}

configure_xorg() {
    echo "--> Configure XOrg."

    cat << EOF | sudo tee /etc/X11/xorg.conf.d/20-amdgpu.conf &> /dev/null
Section "OutputClass"
    Identifier "AMD"
    MatchDriver "amdgpu"
    Driver "amdgpu"
    Option "EnablePageFlip" "off"
    Option "TearFree" "true"
EndSection
EOF

    # Configure black screensaver.
    xset s on
    # Configure turn off screen.
    xset s 600 600
}

configure_gtk() {
    echo "--> Configure GTK."

    cat > /home/nicola/.gtkrc-2.0 << 'EOF'
gtk-theme-name="Materia-dark"
gtk-icon-theme-name="Adwaita"
gtk-font-name="Terminus 10"
gtk-cursor-theme-name="Adwaita"
gtk-cursor-theme-size=0
gtk-toolbar-style=GTK_TOOLBAR_BOTH
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=1
gtk-menu-images=1
gtk-enable-event-sounds=1
gtk-enable-input-feedback-sounds=1
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle="hintfull"
EOF
}

configure_home_dirs() {
    echo "--> Configure home directories."

    mkdir -p $HOME/Documents
    mkdir -p $HOME/Downloads
    mkdir -p $HOME/Music
    mkdir -p $HOME/Pictures
    mkdir -p $HOME/Pictures/Photos
    mkdir -p $HOME/Pictures/Screenshots
    mkdir -p $HOME/Sources
    mkdir -p $HOME/Videos
}

configure_profile() {
    echo "--> Configure profile."

    mkdir -p $HOME/.bashrc.d/
    mkdir -p $HOME/.bashrc.d/alias/
    mkdir -p $HOME/.bashrc.d/env/
    mkdir -p $HOME/.bashrc.d/functions/
    chmod -R 0700 $HOME/.bashrc.d

    cat > $HOME/.bashrc.d/alias.sh << 'EOF'
if [ -x ~/.bashrc.d/alias/ ]; then
  for i in $(find ~/.bashrc.d/alias/ -type f ); do
    source "$i"
  done
fi
EOF

    cat > $HOME/.bashrc.d/env.sh << 'EOF'
if [ -x ~/.bashrc.d/env/ ]; then
  for i in $(find ~/.bashrc.d/env/ -type f ); do
    source "$i"
  done
fi
EOF

    cat > $HOME/.bashrc.d/functions.sh << 'EOF'
if [ -x ~/.bashrc.d/functions/ ]; then
  for i in $(find ~/.bashrc.d/functions/ -type f ); do
    source "$i"
  done
fi
EOF

    cat > $HOME/.bashrc.d/alias/docker.sh << 'EOF'
alias dps="sudo docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}'"
EOF

    cat > $HOME/.bashrc.d/alias/general.sh << 'EOF'
alias c="reset;clear"
alias d="diff --color=auto"
alias g="grep -n --color"
alias l="ls -lahS"
alias r="source ~/.bashrc.d/*.sh"
alias f="fzf -i --print0 | xclip -selection clipboard"
alias p="mocp -T main Music/"
alias o="nemo"
alias s="subl"
alias h="history"
EOF

    cat > $HOME/.bashrc.d/alias/git.sh << 'EOF'
alias ga="git add ."
alias gcane="git commit --amend --no-edit"
alias gh="cd $HOME/go/src/github.com"
alias gpf="git push -f"
alias gs="git status"
alias gw="git whatchanged"
alias gd="git diff"
EOF

    cat > $HOME/.bashrc.d/alias/golang.sh << 'EOF'
alias gf="gofmt -w ."
EOF

    cat > $HOME/.bashrc.d/env/general.sh << 'EOF'
export BROWSER=firefox
export CLICOLOR=1
export EDITOR=vim
export GOPATH=$HOME/go
export LS_COLORS="di=1:fi=0:ln=31:pi=5:so=5:bd=5:cd=5:or=31"
export PATH=$PATH:$(go env GOPATH)/bin
export PS1="\[\033[32m\]\W\[\033[31m\]\[\033[32m\]$\[\e[0m\] "
export TERM=xterm
EOF

    cat > $HOME/.bashrc.d/functions/aws.sh << 'EOF'
aws-instances () {
    aws ec2 describe-instances | jq -c '.Reservations[].Instances[] | { instanceid:.InstanceId, name:(.Tags[]? | select(.Key=="Name") | .Value), type:.InstanceType, private_ip:.PrivateIpAddress, public_ip: .PublicIp}'
}

aws-databases-list () {
    aws rds describe-db-instances --query 'DBInstances[].DBInstanceIdentifier[]'
}

aws-database-describe () {
    if [ -z "$1" ]; then
        echo "No argument supplied."
        echo "Usage: aws-database-describe xxx-yyy-mysql-zzz-node01"
        return
    fi

    aws rds describe-db-instances \
        --db-instance-identifier=$1 \
        --output table
}

aws-database-logs-list () {
    aws rds describe-db-log-files \
        --db-instance-identifier=$1 | \
    jq -r '.[][] | [.LastWritten,.Size,.LogFileName] | @tsv'
}

aws-database-logs-download() {
    aws rds describe-db-log-files \
        --db-instance-identifier=$1 | \
    jq -r '.[][] | [.LogFileName] | @tsv' | \
    xargs -I{} \
    aws rds download-db-log-file-portion \
        --db-instance-identifier=$1 \
        --starting-token 0 \
        --output text \
        --log-file-name {} >> /tmp/$1.log
}

aws-database-parameter-group-list () {
    if [ -z "$1" ]; then
        echo "No argument supplied."
        echo "Usage: aws-database-parameter-group-list xxx-yyy-mysql-zzz-nodes"
        return
    fi

    aws rds describe-db-parameters \
        --db-parameter-group-name=$1 | \
    jq 'del(.[][].Description)' | \
    jq -r '.[][] | [.ParameterName,.ParameterValue] | @tsv' | \
    awk -v FS="\t" '{printf "%s=%s%s",$1,$2,ORS}'
}

aws-database-parameter-group-set () {
    if [ -z "$1" ] && [ -z "$2" ] && [ -z "$3" ]; then
        echo "No argument supplied."
        echo "Usage: aws-database-parameter-group-set xxx-yyy-mysql-zzz-nodes parameter value"
        return
    fi

    aws rds modify-db-parameter-group \
        --db-parameter-group-name $1 \
        --parameters "ParameterName=$2,ParameterValue=$3,ApplyMethod=immediate"
}

aws-set-keys() {
    aws-rotate-iam-keys > /dev/null
}

aws-reload-keys() {
    export AWS_ACCESS_KEY_ID=$(cat ~/.aws/credentials | grep aws_access_key_id | awk '{print $3}' | head -n 1)
    export AWS_SECRET_ACCESS_KEY=$(cat ~/.aws/credentials | grep aws_secret_access_key | awk '{print $3}' | head -n 1)
}

aws-get-secret() {
    if [ -z "$1" ]; then
        echo "No argument supplied."
        echo "Usage: aws-get-secret xxx-yyy-project"
        return
    fi

    KEYS=$(
        aws secretsmanager get-secret-value \
            --secret-id $1 \
            --query SecretString \
            --output text | \
        tr -d '\n\t\r ' | \
        jq \
            --compact-output \
            --raw-output \
            --monochrome-output \
             "to_entries|map(\"\(.key)=\(.value|tostring)\") | .[]"
    )

    for KEY in $KEYS; do
        echo "${KEY}"
        eval "export ${KEY}"
    done
}
EOF

    cat > $HOME/.bashrc.d/functions/general.sh << 'EOF'
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

backup-usb() {
    rsync -CPavzt ~/ /run/media/nicola/BACKUP/
}

backup-icloud() {
    icloudpd --username nicola@strappazzon.me --directory /home/nicola/Pictures/iCloud/
}

raspberri-pi-find() {
    sudo nmap -sP 192.168.1.0/24 | awk '/^Nmap/{ip=$NF}/B8:27:EB/{print ip}'
}
EOF

    cat > $HOME/.bashrc.d/functions/k8.sh << 'EOF'
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

    cat > $HOME/.bashrc.d/functions/mysql.sh << 'EOF'
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

    cat > $HOME/.bashrc.d/functions/redpanda.sh << 'EOF'
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
}

configure_wakeup() {
    echo "--> Configure wakeup."

    cat << EOF | sudo tee /usr/local/bin/wakeup-disable.sh &> /dev/null
#!/usr/bin/env sh
# set -eu

/bin/echo XHC0 > /proc/acpi/wakeup
/bin/echo XHC1 > /proc/acpi/wakeup
/bin/echo GPP0 > /proc/acpi/wakeup
EOF

    cat << EOF | sudo tee /etc/systemd/system/wakeup-disable.service &> /dev/null
[Unit]
Description=Fix suspend by disabling XHC0, XHC1 and GPP0 sleepstate thingie
After=systemd-user-sessions.service plymouth-quit-wait.service
After=rc-local.service
Before=getty.target
IgnoreOnIsolate=yes

[Service]
Type=oneshot
ExecStart=/usr/local/bin/wakeup-disable.sh
RemainAfterExit=true

[Install]
WantedBy=basic.target
EOF

    sudo chmod +x /usr/local/bin/wakeup-disable.sh
    sudo systemctl enable wakeup-disable.service &> /dev/null
    sudo systemctl start wakeup-disable.service &> /dev/null
}

configure_git() {
    echo "--> Configure git."

    git config --global init.defaultBranch main
    git config --global pull.rebase true
    git config --global user.email nicola@strappazzon.me
    git config --global user.name "Nicola Strappazzon."
}

configure_login() {
    echo "--> Configure login."
    sudo mkdir -p /etc/sddm.conf.d/
    sudo mkdir -p /usr/share/sddm/themes/luna/

    cat << EOF | sudo tee /etc/sddm.conf.d/settings.conf &> /dev/null
[Debug]
LogLevel=DEBUG

[Autologin]
Relogin=false
Session=i3
User=

[General]
HaltCommand=/usr/bin/systemctl poweroff
RebootCommand=/usr/bin/systemctl reboot

[Users]
MaximumUid=60000
MinimumUid=1000

[Theme]
Current=luna
EOF

    cat << EOF | sudo tee /usr/share/sddm/themes/luna/login.svg &> /dev/null
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" version="1.1">
 <defs>
  <style id="current-color-scheme" type="text/css">
   .ColorScheme-Text { color:#dfdfdf; } .ColorScheme-Highlight { color:#4285f4; } .ColorScheme-NeutralText { color:#ff9800; } .ColorScheme-PositiveText { color:#4caf50; } .ColorScheme-NegativeText { color:#f44336; }
  </style>
 </defs>
 <path style="fill:currentColor" class="ColorScheme-Text" d="M 2,9 H 10 L 6.5,12.5 8,14 14,8 8,2 6.5,3.5 10,7 H 2 Z"/>
</svg>
EOF

    cat << EOF | sudo tee /usr/share/sddm/themes/luna/power.svg &> /dev/null
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" version="1.1">
 <path style="fill:#dfdfdf" d="M 8,1 C 8.554,1 9,1.446 9,2 V 7 C 9,7.554 8.554,8 8,8 7.446,8 7,7.554 7,7 V 2 C 7,1.446 7.446,1 8,1 Z"/>
 <path style="fill:#dfdfdf" d="M 11,3 C 10.448,3 10,3.4477 10,4 10,4.2839 10.102,4.5767 10.329,4.748 11.358,5.525 11.998,6.7108 12,8 12,10.209 10.209,12 8,12 5.7909,12 4,10.209 4,8 4.0024,6.7105 4.644,5.5253 5.6719,4.7471 5.8981,4.5759 5.9994,4.2833 6,4 6,3.4477 5.5523,3 5,3 4.7151,3 4.4724,3.1511 4.2539,3.334 2.8611,4.4998 2.0063,6.1837 2,8 2,11.314 4.6863,14 8,14 11.314,14 14,11.314 14,8 13.996,6.1678 13.137,4.4602 11.714,3.2998 11.504,3.1282 11.267,3 11,3 Z"/>
</svg>
EOF

    cat << EOF | sudo tee /usr/share/sddm/themes/luna/reboot.svg &> /dev/null
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" version="1.1">
 <path style="fill:#dfdfdf" d="M 8,2 A 1,1 0 0 0 7,3 1,1 0 0 0 8,4 4,4 0 0 1 12,8 H 10 L 13,12 16,8 H 14 A 6,6 0 0 0 8,2 Z M 3,4 0,8 H 2 A 6,6 0 0 0 8,14 1,1 0 0 0 9,13 1,1 0 0 0 8,12 4,4 0 0 1 4,8 H 6 Z"/>
</svg>
EOF

    cat << EOF | sudo tee /usr/share/sddm/themes/luna/settings.svg &> /dev/null
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" version="1.1">
 <path style="fill:#dfdfdf" d="M 6.25,1 6.09,2.84 A 5.5,5.5 0 0 0 4.49,3.77 L 2.81,2.98 1.06,6.01 2.58,7.07 A 5.5,5.5 0 0 0 2.5,8 5.5,5.5 0 0 0 2.58,8.93 L 1.06,9.98 2.81,13.01 4.48,12.22 A 5.5,5.5 0 0 0 6.09,13.15 L 6.25,15 H 9.75 L 9.9,13.15 A 5.5,5.5 0 0 0 11.51,12.22 L 13.19,13.01 14.94,9.98 13.41,8.92 A 5.5,5.5 0 0 0 13.5,8 5.5,5.5 0 0 0 13.42,7.06 L 14.94,6.01 13.19,2.98 11.51,3.77 A 5.5,5.5 0 0 0 9.9,2.84 L 9.75,1 Z M 8,6 A 2,2 0 0 1 10,8 2,2 0 0 1 8,10 2,2 0 0 1 6,8 2,2 0 0 1 8,6 Z"/>
</svg>
EOF

    cat << EOF | sudo tee /usr/share/sddm/themes/luna/sleep.svg &> /dev/null
<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" version="1.1" viewBox="0 0 16 16">
 <path style="fill:#dfdfdf" d="M 8,2 A 6,6 0 0 0 2,8 6,6 0 0 0 8,14 6,6 0 0 0 14,8 6,6 0 0 0 8,2 Z M 8,4 A 4,4 0 0 1 12,8 4,4 0 0 1 8,12 4,4 0 0 1 4,8 4,4 0 0 1 8,4 Z"/>
 <path style="fill:#dfdfdf" d="M 10,8 A 2,2 0 0 1 8,10 2,2 0 0 1 6,8 2,2 0 0 1 8,6 2,2 0 0 1 10,8 Z"/>
</svg>
EOF

    cat << EOF | sudo tee /usr/share/sddm/themes/luna/metadata.desktop &> /dev/null
[SddmGreeterTheme]
Author      = Nicola Strappazzon
ConfigFile  = theme.conf
Copyright   = (c) 2024, Nicola Strappazzon
Description = Luna theme for SDDM
License     = MIT
MainScript  = Main.qml
Name        = Luna
QtVersion   = 6
Theme-API   = 2.0
Theme-Id    = luna
Type        = sddm-theme
Version     = 20240810
Website     = https://gitlab.com/nstrappazzonc/sddm-theme-luna
EOF

    cat << EOF | sudo tee /usr/share/sddm/themes/luna/theme.conf &> /dev/null
[General]
Font                    = terminus
FontSize                = 10
bgDark                  = "#141416"
bgDefault               = "#1e1e20"
buttonBgFocused0        = "#7a7a7c"
buttonBgFocused1        = "#7a7a7c"
buttonBgHovered0        = "#7a7a7c"
buttonBgHovered1        = "#646466"
buttonBgNormal          = "#1e1e20"
buttonBgPressed         = "#7a7a7c"
buttonBorderFocused     = "#7a7a7c"
buttonBorderHovered     = "#727274"
buttonBorderNormal      = "#5a5a5c"
buttonBorderPressed     = "#7a7a7c"
lineeditBgNormal        = "#1e1e20"
lineeditBorderFocused   = "#7f7f81"
lineeditBorderHovered   = "#7f7f81"
lineeditBorderNormal    = "#5a5a5c"
opacityDefault          = "0.90"
opacityPanel            = "0.95"
textDefault             = "#aaaaac"
textHighlight           = "#dadadc"
textPlaceholder         = "#7f8c8d"
EOF

    cat << EOF | sudo tee /usr/share/sddm/themes/luna/Main.qml &> /dev/null
import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    width: 1920
    height: 1080

    Component {
        id: componentTextField

        TextField {
            property string placeholder: ""
            property int fieldWidth: 200
            property bool isPasswordField: false
            property var onAction: null

            id: componentTextField
            echoMode: isPasswordField ? TextInput.Password : TextInput.Normal
            placeholderText: placeholder
            placeholderTextColor: config.textPlaceholder
            renderType: Text.NativeRendering
            horizontalAlignment: Text.AlignHLeft
            width: fieldWidth
            height: 30
            color: "#AAAAAC"

            font {
                family: config.Font
                pixelSize: config.FontSize
                bold: false
            }

            background: Rectangle {
                id: componentTextFieldBackground
                color: config.lineeditBgNormal
                border.color: config.lineeditBorderNormal
                border.width: 1
                radius: 2
                opacity: config.opacityDefault
            }

            palette {
                highlight: "#dadadc"
                highlightedText: "#7f7f81"
            }

            states: [
                State {
                    name: "hovered"
                    when: componentTextField.hovered
                    PropertyChanges {
                        target: componentTextFieldBackground
                        border.color: config.lineeditBorderHovered
                    }
                },
                State {
                    name: "focused"
                    when: componentTextField.activeFocus
                    PropertyChanges {
                        target: componentTextFieldBackground
                        border.color: config.lineeditBorderFocused
                    }
                }
            ]

            onAccepted: {
                if (onAction) {
                    onAction();
                }
            }
        }
    }

    Component {
        id: componentButton

        Button {
            property string iconSource: ""
            property bool isEnabled: true
            property var onAction: null

            id: componentButton
            width: 30
            height: 30
            enabled: isEnabled
            hoverEnabled: true
            icon {
                source: iconSource
                color: config.textDefault
            }

            background: Rectangle {
                id: componentButtonBackground
                gradient: Gradient {
                    GradientStop { id: componentButtonGradientStop0; position: 0.0; color: config.buttonBgNormal }
                    GradientStop { id: componentButtonGradientStop1; position: 1.0; color: config.buttonBgNormal }
                }
                border.color: config.buttonBorderNormal
                border.width: 1
                radius: 2
                opacity: config.opacityDefault
            }

            states: [
                State {
                    name: "pressed"
                    when: componentButton.down
                    PropertyChanges {
                        target: componentButtonBackground
                        border.color: config.buttonBorderPressed
                        opacity: 1
                    }
                    PropertyChanges {
                        target: componentButtonGradientStop0
                        color: config.buttonBgPressed
                    }
                    PropertyChanges {
                        target: componentButtonGradientStop1
                        color: config.buttonBgPressed
                    }
                },
                State {
                    name: "hovered"
                    when: componentButton.hovered
                    PropertyChanges {
                        target: componentButtonGradientStop0
                        color: config.buttonBgHovered0
                    }
                    PropertyChanges {
                        target: componentButtonGradientStop1
                        color: config.buttonBgHovered1
                    }
                    PropertyChanges {
                        target: componentButtonBackground
                        border.color: config.lineeditBorderHovered
                    }
                },
                State {
                    name: "focused"
                    when: componentButton.activeFocus
                    PropertyChanges {
                        target: componentButtonBackground
                        border.color: config.lineeditBorderFocused
                    }
                },
                State {
                    name: "enabled"
                    when: componentButton.enabled
                    PropertyChanges {
                        target: componentButtonBackground
                    }
                    PropertyChanges {
                        target: componentButtonBackground
                    }
                }
            ]

            onClicked: {
                if (onAction) {
                    onAction();
                }
            }
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height
        color: "#141416"
        anchors.fill: parent
    }

    Rectangle {
        width: 256
        height: 144
        color: config.bgDark
        anchors.centerIn: parent
        opacity: config.opacityPanel

        Column {
            spacing: 8
            anchors {
                verticalCenter: parent.verticalCenter
                horizontalCenter: parent.horizontalCenter
            }

            Loader {
                id: usernameInput
                sourceComponent: componentTextField
                onLoaded: {
                    item.placeholder = "username"
                    item.isPasswordField = false
                    item.forceActiveFocus();
                }
            }

            Row {
                spacing: 8

                Loader {
                    id: passwordInput
                    sourceComponent: componentTextField
                    onLoaded: {
                        item.width = 162
                        item.placeholder = "password"
                        item.isPasswordField = true
                        item.onAction = function() {
                            sddm.login(usernameInput.item.text, passwordInput.item.text, "i3")
                        }
                    }
                }

                Loader {
                    id: loginButton
                    sourceComponent: componentButton
                    onLoaded: {
                        item.iconSource = "login.svg"
                        item.isEnabled = usernameInput.text != "" && passwordInput.text != "" ? true : false
                        item.onAction = function() {
                            sddm.login(usernameInput.item.text, passwordInput.item.text, "i3")
                        }
                    }
                }
            }

            Row {
                spacing: 8
                width: parent.width
                height: 30
            }

            Row {
                spacing: 8
                anchors {
                    horizontalCenter: parent.horizontalCenter
                }

                Loader {
                    id: powerButton
                    sourceComponent: componentButton
                    onLoaded: {
                        item.iconSource = "power.svg"
                        item.isEnabled = true
                        item.onAction = function() {
                            sddm.powerOff()
                        }
                    }
                }

                Loader {
                    id: rebootButton
                    sourceComponent: componentButton
                    onLoaded: {
                        item.iconSource = "reboot.svg"
                        item.isEnabled = true
                        item.onAction = function() {
                            sddm.reboot()
                        }
                    }
                }

                Loader {
                    id: sleepButton
                    sourceComponent: componentButton
                    onLoaded: {
                        item.iconSource = "sleep.svg"
                        item.isEnabled = true
                        item.onAction = function() {
                            sddm.suspend()
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: sddm

        function onLoginFailed() {
            passwordInput.item.text = ""
            passwordInput.item.forceActiveFocus()
        }
    }
}
EOF
}

configure_i3wm() {
    echo "--> Configure desktop."

    mkdir -p /home/nicola/.config/i3/
    cat > /home/nicola/.config/i3/config << 'EOF'
exec --no-startup-id feh --no-fehbg --bg-fill '/home/nicola/.config/feh/01.jpg'
exec --no-startup-id amixer -q set Master 50% unmut
exec --no-startup-id /home/nicola/.config/polybar/launch.sh

set $mod Mod4
set $ws1 "1"
set $ws2 "2"
set $ws3 "3"
set $ws4 "4"
set $ws5 "5"
set $ws6 "6"
set $ws7 "7"
set $ws8 "8"
set $ws9 "9"
set $ws10 "10"

font pango:terminus 8

bindsym $mod+Down focus down
bindsym $mod+Left focus left
bindsym $mod+Return exec --no-startup-id xterm
bindsym $mod+Right focus right
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Right move right
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+c reload
bindsym $mod+Shift+j move left
bindsym $mod+Shift+k move down
bindsym $mod+Shift+l move up
bindsym $mod+Shift+q kill
bindsym $mod+Shift+r restart
bindsym $mod+Shift+semicolon move right
bindsym $mod+Shift+space floating toggle
bindsym $mod+Up focus up
bindsym $mod+a focus parent
bindsym $mod+e layout toggle split
bindsym $mod+f fullscreen toggle
bindsym $mod+h split h
bindsym $mod+j focus left
bindsym $mod+k focus down
bindsym $mod+l focus up
bindsym $mod+s layout stacking
bindsym $mod+semicolon focus right
bindsym $mod+v split v
bindsym $mod+w layout tabbed

bindsym $mod+1 workspace number $ws1
bindsym $mod+2 workspace number $ws2
bindsym $mod+3 workspace number $ws3
bindsym $mod+4 workspace number $ws4
bindsym $mod+5 workspace number $ws5
bindsym $mod+6 workspace number $ws6
bindsym $mod+7 workspace number $ws7
bindsym $mod+8 workspace number $ws8
bindsym $mod+9 workspace number $ws9
bindsym $mod+0 workspace number $ws10

bindsym $mod+Shift+1 move container to workspace number $ws1
bindsym $mod+Shift+2 move container to workspace number $ws2
bindsym $mod+Shift+3 move container to workspace number $ws3
bindsym $mod+Shift+4 move container to workspace number $ws4
bindsym $mod+Shift+5 move container to workspace number $ws5
bindsym $mod+Shift+6 move container to workspace number $ws6
bindsym $mod+Shift+7 move container to workspace number $ws7
bindsym $mod+Shift+8 move container to workspace number $ws8
bindsym $mod+Shift+9 move container to workspace number $ws9
bindsym $mod+Shift+0 move container to workspace number $ws10

bindsym $mod+Tab workspace next
bindsym $mod+Shift+Tab workspace prev

bindsym XF86MonBrightnessUp exec --no-startup-id ddcutil setvcp 10 + 10
bindsym XF86MonBrightnessDown exec --no-startup-id ddcutil setvcp 10 - 10
bindsym XF86AudioRaiseVolume exec --no-startup-id amixer -q set Master 5%+ unmute
bindsym XF86AudioLowerVolume exec --no-startup-id amixer -q set Master 5%- unmute
bindsym XF86AudioMute exec --no-startup-id amixer -q set Master toggle
bindsym XF86AudioPlay exec --no-startup-id playerctl play-pause
bindsym XF86AudioPause exec --no-startup-id playerctl play-pause
bindsym XF86AudioNext exec --no-startup-id playerctl next
bindsym XF86AudioPrev exec --no-startup-id playerctl previous

mode "resize" {
        bindsym j resize shrink width 10 px or 10 ppt
        bindsym k resize grow height 10 px or 10 ppt
        bindsym l resize shrink height 10 px or 10 ppt
        bindsym semicolon resize grow width 10 px or 10 ppt

        bindsym Left resize shrink width 10 px or 10 ppt
        bindsym Down resize grow height 10 px or 10 ppt
        bindsym Up resize shrink height 10 px or 10 ppt
        bindsym Right resize grow width 10 px or 10 ppt

        bindsym Return mode "default"
        bindsym Escape mode "default"
}

bindsym $mod+r mode "resize"

floating_modifier $mod
tiling_drag modifier titlebar

bindsym $mod+space exec --no-startup-id rofi -config /home/nicola/.config/rofi/config.rasi -show drun
bindsym $mod+Shift+p exec --no-startup-id rofi-pass
bindsym $mod+Shift+plus exec --no-startup-id rofi -config /home/nicola/.config/rofi/config.rasi -show calc -modi calc -no-show-match -no-sort
bindsym Print exec --no-startup-id flameshot gui
bindsym $mod+Control+s exec --no-startup-id systemctl suspend

client.focused #373B41 #282A2E #C5C8C6 #AAAAAC
gaps inner 4
gaps outer 2
gaps top -4

for_window [class="^.*"] border pixel 1
for_window [floating] resize set 800 600
for_window [window_role="About"]       floating enable, move position center
for_window [window_role="pop-up"]      floating enable, move position center
for_window [window_role="bubble"]      floating enable, move position center
for_window [window_role="task_dialog"] floating enable, move position center
for_window [window_role="Preferences"] floating enable, move position center
for_window [window_type="dialog"]      floating enable, move position center
for_window [window_type="menu"]        floating enable, move position center
for_window [window_role="Organizer"]   floating enable, move position center
for_window [window_role="toolbox"]     floating enable, move position center
for_window [window_role="page-info"]   floating enable, move position center
for_window [window_role="webconsole"]  floating enable, move position center
for_window [title="Open File"]         floating enable, move position center
for_window [title="gpg2*"]             floating enable, move position center, resize set 600 200

EOF

    i3-msg restart &> /dev/null
}

configure_xterm() {
    echo "--> Configure terminal."

    cat > /home/nicola/.Xdefaults << 'EOF'
XTerm*background: #002B36
XTerm*borderColor: #343434
XTerm*color0: #222222
XTerm*color10: #C4DF90
XTerm*color11: #FFE080
XTerm*color12: #B8DDEA
XTerm*color13: #C18FCB
XTerm*color14: #6bc1d0
XTerm*color15: #cdcdcd
XTerm*color1: #9E5641
XTerm*color2: #6C7E55
XTerm*color3: #CAAF2B
XTerm*color4: #7FB8D8
XTerm*color5: #956D9D
XTerm*color6: #4c8ea1
XTerm*color7: #808080
XTerm*color8: #454545
XTerm*color9: #CC896D
XTerm*cursorBlink: true
XTerm*cursorUnderLine: true
XTerm*faceName: terminus
XTerm*foreground: #D2D2D2
XTerm*scrollBar: off
XTerm*selectToClipboard: true
XTerm*vt100*geometry: 88x24
xterm*eightBitInput: false
xterm*faceSize: 10
EOF
}

configure_polybar() {
    echo "--> Configure bar."

    mkdir -p /home/nicola/.config/polybar/
    touch /home/nicola/.config/polybar/launch.sh
    chmod +x /home/nicola/.config/polybar/launch.sh

    cat > /home/nicola/.config/polybar/launch.sh << 'EOF'
#!/usr/bin/env bash

killall -q polybar
polybar --config=/home/nicola/.config/polybar/config.ini
EOF

    cat > /home/nicola/.config/polybar/config.ini << 'EOF'
[colors]
background = #282A2E
background-alt = #373B41
foreground = #C5C8C6
primary = #AAAAAC
alert = #A54242
disabled = #707880

[bar/main]
width = 100%
height = 18pt
radius = 3
background = ${colors.background}
foreground = ${colors.foreground}
line-size = 3pt
border-size = 4pt
border-color = #00000000
padding-left = 0
padding-right = 1
module-margin = 1
separator = |
separator-foreground = ${colors.disabled}
font-0 = terminus:pixelsize=10;2
font-1 = "Symbols Nerd Font:style=Regular:pixelsize=8"
modules-left = xworkspaces xwindow
modules-right = filesystem pulseaudio xkeyboard memory cpu wlan eth date powermenu
cursor-click = pointer
cursor-scroll = ns-resize
enable-ipc = true

[module/systray]
type = internal/tray
format-margin = 8pt
tray-spacing = 16pt

[module/xworkspaces]
type = internal/xworkspaces
label-active = %name%
label-active-background = ${colors.background-alt}
label-active-underline= ${colors.primary}
label-active-padding = 1
label-occupied = %name%
label-occupied-padding = 1
label-urgent = %name%
label-urgent-background = ${colors.alert}
label-urgent-padding = 1
label-empty = %name%
label-empty-foreground = ${colors.disabled}
label-empty-padding = 1

[module/xwindow]
type = internal/xwindow
label = %title:0:60:...%

[module/filesystem]
type = internal/fs
interval = 25
mount-0 = /
label-mounted = %{F#AAAAAC}%mountpoint%%{F-} %percentage_used%%
label-unmounted = %mountpoint% not mounted
label-unmounted-foreground = ${colors.disabled}

[module/pulseaudio]
type = internal/pulseaudio
format-volume-prefix = "VOL "
format-volume-prefix-foreground = ${colors.primary}
format-volume = <label-volume>
label-volume = %percentage%%
label-muted = muted
label-muted-foreground = ${colors.disabled}

[module/memory]
type = internal/memory
interval = 2
format-prefix = "RAM "
format-prefix-foreground = ${colors.primary}
label = %percentage_used:2%%

[module/cpu]
type = internal/cpu
interval = 2
format-prefix = "CPU "
format-prefix-foreground = ${colors.primary}
label = %percentage:2%%

[module/date]
type = internal/date
interval = 1
date = %H:%M
date-alt = %Y-%m-%d %H:%M:%S
label = %date%
label-foreground = ${colors.primary}

[module/powermenu]
type = custom/menu
expand-right = true
format-spacing = 1

label-open = 
label-open-foreground = ${colors.primary}
label-close = Cancel
label-close-foreground = ${colors.primary}
label-separator = |

menu-0-0 = Reboot
menu-0-0-exec = reboot
menu-0-1 = Power off
menu-0-1-exec = poweroff
menu-0-2 = Suspend
menu-0-2-exec = systemctl hybrid-sleep

[settings]
screenchange-reload = true
pseudo-transparency = true

[global/wm]
margin-top = 5
margin-bottom = 5
EOF
}

configure_notification() {
    echo "--> Configure notification."

    mkdir -p /home/nicola/.config/dunst/

    cat << EOF | sudo tee /home/nicola/.config/dunst/dunstrc &> /dev/null
[global]
    monitor = 0
    follow = none
    width = 300
    height = 145
    origin = top-right
    alignment = "left"
    vertical_alignment = "center"
    ellipsize = "middle"
    offset = "6x34"
    padding = 10
    horizontal_padding = 15
    text_icon_padding = 15
    icon_position = "left"
    min_icon_size = 48
    max_icon_size = 64
    progress_bar = true
    progress_bar_height = 8
    progress_bar_frame_width = 1
    progress_bar_min_width = 150
    progress_bar_max_width = 300
    separator_height = 2
    frame_width = 2
    frame_color = "#C5C8C6" 
    separator_color = "frame" 
    corner_radius = 0
    transparency = 0 
    gap_size = 0
    line_height = 0 
    notification_limit = 0 
    idle_threshold = 120 
    history_length = 20 
    show_age_threshold = 60 
    markup = "full" 
    font = "monospace 10" 
    format = "<b>%s</b>\n%b"
    word_wrap = "yes" 
    sort = "yes" 
    shrink = "no" 
    indicate_hidden = "yes" 
    sticky_history = "yes" 
    ignore_newline = "no" 
    show_indicators = "no" 
    stack_duplicates = true 
    always_run_script = true 
    hide_duplicate_count = false 
    ignore_dbusclose = false 
    force_xwayland = false 
    force_xinerama = false 
    mouse_left_click = "do_action" 
    mouse_middle_click = "close_all" 
    mouse_right_click = "close_current" 
[experimental]
    per_monitor_dpi = false

[urgency_low]
    background = "#282A2E"
    foreground = "#C5C8C6"
    highlight = "#cba6f7"
    timeout = 4

[urgency_normal]
    background = "#282A2E"
    foreground = "#C5C8C6"
    highlight = "#cba6f7"
    timeout = 6

[urgency_critical]
    background = "#282A2E"
    foreground = "#cdd6f4"
    highlight = "#cba6f7"
    timeout = 0
EOF

    systemctl --user restart dunst.service &> /dev/null
}

configure_rofi() {
    echo "--> Configure launcher."

    mkdir -p /home/nicola/.config/rofi/

    cat > /home/nicola/.config/rofi/config.rasi << 'EOF'
configuration {
  font: "terminus 10";
  combi-modes: "window,drun,ssh,pass,calc";

  drun {
    display-name: "";
  }

  run {
    display-name: "";
  }

  window {
    display-name: "";
  }

  ssh {
    display-name: "";
  }

  pass {
    display-name: "󰷡";
  }

  calc {
    display-name: "";
  }

  timeout {
    delay: 60;
    action: "kb-cancel";
  }
}

* {
    border: 0px;
    margin: 0px;
    padding: 0px;
    spacing: 0px;

    background-color: transparent;
}

window {
    border: 1px;
    padding: 0px;
    location: center;
    width: 480px;
    border-color: #373B41;
    background-color: #282A2E;
}

inputbar {
    children: [prompt, entry];
}

entry {
    placeholder: "";
    text-color: #C5C8C6;
    padding: 12px 3px;
}

prompt {
    background-color: #282A2E;
    text-color: #C5C8C6;
    padding: 12px 16px 12px 12px;
}

listview {
    lines: 8;
}

scrollbar {
    width:        0px;
    border:       0px;
    handle-width: 0px;
    padding:      0px;
}

element {
    padding:    1px;
    spacing:    4px;
    orientation: horizontal;
}

element normal.normal, element.alternate.normal  {
    background-color: #282A2E;
    text-color:       #C5C8C6;
}

element.selected.normal, element.selected.active {
    background-color: #373B41;
    text-color: #C5C8C6;
}

element.normal.active {
    background-color: #282A2E;
    text-color:       #707880;
}

EOF
}

configure_screenshot() {
    echo "--> Configure screenshot."

    mkdir -p /home/nicola/.config/flameshot/

    cat > /home/nicola/.config/flameshot/flameshot.ini << 'EOF'
[General]
buttons=@Variant(\0\0\0\x7f\0\0\0\vQList<int>\0\0\0\0\x14\0\0\0\0\0\0\0\x1\0\0\0\x2\0\0\0\x3\0\0\0\x4\0\0\0\x5\0\0\0\x6\0\0\0\x12\0\0\0\xf\0\0\0\x16\0\0\0\x13\0\0\0\a\0\0\0\b\0\0\0\t\0\0\0\x10\0\0\0\n\0\0\0\v\0\0\0\x17\0\0\0\f\0\0\0\x11)
contrastOpacity=188
contrastUiColor=#707880
disabledTrayIcon=true
drawColor=#c4df90
savePath=/home/nicola/Pictures/Screenshots
savePathFixed=false
showDesktopNotification=false
showHelp=false
showSidePanelButton=false
showStartupLaunchMessage=true
startupLaunch=true
uiColor=#282A2E
EOF

}

configure_feh() {
    echo "--> Configure desktop wallpaper."

    mkdir -p /home/nicola/.config/feh/
    cp wallpaper/wallpaper.jpg /home/nicola/.config/feh/01.jpg
}

configure_vim() {
    echo "--> Configure vim."

    cat > /home/nicola/.vimrc << 'EOF'
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

configure_applications_desktop() {
    echo "--> Configure applications desktop."

    sudo rm -f /usr/share/applications/*

    cat << EOF | sudo tee /usr/share/applications/sublime_text.desktop &> /dev/null
[Desktop Entry]
Actions=new-window;new-file;
Categories=TextEditor;Development;
Exec=/usr/bin/subl %F
Icon=sublime-text
Keywords=text;editor;ide;dev;
MimeType=text/plain;
Name=Sublime Text
StartupNotify=true
StartupWMClass=subl
Terminal=false
Type=Application

[Desktop Action new-window]
Name=New Window
Exec=/usr/bin/subl --launch-or-new-window
OnlyShowIn=Unity;

[Desktop Action new-file]
Name=New File
Exec=/usr/bin/subl --command new_file
OnlyShowIn=Unity;
EOF

    cat << EOF | sudo tee /usr/share/applications/firefox.desktop &> /dev/null
[Desktop Entry]
Actions=new-window;new-private-window;profile-manager-window;
Categories=Network;WebBrowser;
Exec=/usr/lib/firefox/firefox %u
Icon=firefox
Keywords=web;browser;
MimeType=text/html;text/xml;application/xhtml+xml;application/vnd.mozilla.xul+xml;text/mml;x-scheme-handler/http;x-scheme-handler/https;application/x-xpinstall;application/pdf;application/json;
Name=Firefox
StartupNotify=true
StartupWMClass=firefox
Terminal=false
Type=Application

[Desktop Action new-window]
Name=Open a New Window
Exec=/usr/lib/firefox/firefox --new-window %u

[Desktop Action new-private-window]
Name=Open a New Private Window
Exec=/usr/lib/firefox/firefox --private-window %u

[Desktop Action profile-manager-window]
Name=Open the Profile Manager
Exec=/usr/lib/firefox/firefox --ProfileManager
EOF

    cat << EOF | sudo tee /usr/share/applications/nemo.desktop &> /dev/null
[Desktop Entry]
Actions=open-home;open-computer;open-trash;
Categories=GNOME;GTK;Utility;Core;
Exec=nemo %U
Icon=system-file-manager
Keywords=folders;filesystem;explorer;
MimeType=inode/directory;application/x-gnome-saved-search;
Name=File Manager
StartupNotify=false
Terminal=false
Type=Application

[Desktop Action open-home]
Name=Home
Exec=nemo %U

[Desktop Action open-computer]
Name=Computer
Exec=nemo computer:///

[Desktop Action open-trash]
Name=Trash
Exec=nemo trash:///
EOF

    cat << EOF | sudo tee /usr/share/applications/lxappearance.desktop &> /dev/null
[Desktop Entry]
Categories=GTK;Settings;DesktopSettings;X-LXDE-Settings;
Exec=lxappearance
Icon=preferences-desktop-theme
Keywords=windows;preferences;settings;theme;style;appearance;
Name=Look and Feel
StartupNotify=true
Type=Application
EOF

    cat << EOF | sudo tee /usr/share/applications/mpv.desktop &> /dev/null
[Desktop Entry]
Categories=AudioVideo;Audio;Video;Player;TV;
Exec=mpv --player-operation-mode=pseudo-gui -- %U
Icon=mpv
Keywords=mpv;media;player;video;audio;tv;
MimeType=application/ogg;application/x-ogg;application/mxf;application/sdp;application/smil;application/x-smil;application/streamingmedia;application/x-streamingmedia;application/vnd.rn-realmedia;application/vnd.rn-realmedia-vbr;audio/aac;audio/x-aac;audio/vnd.dolby.heaac.1;audio/vnd.dolby.heaac.2;audio/aiff;audio/x-aiff;audio/m4a;audio/x-m4a;application/x-extension-m4a;audio/mp1;audio/x-mp1;audio/mp2;audio/x-mp2;audio/mp3;audio/x-mp3;audio/mpeg;audio/mpeg2;audio/mpeg3;audio/mpegurl;audio/x-mpegurl;audio/mpg;audio/x-mpg;audio/rn-mpeg;audio/musepack;audio/x-musepack;audio/ogg;audio/scpls;audio/x-scpls;audio/vnd.rn-realaudio;audio/wav;audio/x-pn-wav;audio/x-pn-windows-pcm;audio/x-realaudio;audio/x-pn-realaudio;audio/x-ms-wma;audio/x-pls;audio/x-wav;video/mpeg;video/x-mpeg2;video/x-mpeg3;video/mp4v-es;video/x-m4v;video/mp4;application/x-extension-mp4;video/divx;video/vnd.divx;video/msvideo;video/x-msvideo;video/ogg;video/quicktime;video/vnd.rn-realvideo;video/x-ms-afs;video/x-ms-asf;audio/x-ms-asf;application/vnd.ms-asf;video/x-ms-wmv;video/x-ms-wmx;video/x-ms-wvxvideo;video/x-avi;video/avi;video/x-flic;video/fli;video/x-flc;video/flv;video/x-flv;video/x-theora;video/x-theora+ogg;video/x-matroska;video/mkv;audio/x-matroska;application/x-matroska;video/webm;audio/webm;audio/vorbis;audio/x-vorbis;audio/x-vorbis+ogg;video/x-ogm;video/x-ogm+ogg;application/x-ogm;application/x-ogm-audio;application/x-ogm-video;application/x-shorten;audio/x-shorten;audio/x-ape;audio/x-wavpack;audio/x-tta;audio/AMR;audio/ac3;audio/eac3;audio/amr-wb;video/mp2t;audio/flac;audio/mp4;application/x-mpegurl;video/vnd.mpegurl;application/vnd.apple.mpegurl;audio/x-pn-au;video/3gp;video/3gpp;video/3gpp2;audio/3gpp;audio/3gpp2;video/dv;audio/dv;audio/opus;audio/vnd.dts;audio/vnd.dts.hd;audio/x-adpcm;application/x-cue;audio/m3u;audio/vnd.wave;video/vnd.avi;
Name=Media Player
StartupWMClass=mpv
Terminal=false
Type=Application
EOF

    cat << EOF | sudo tee /usr/share/applications/pragha.desktop &> /dev/null
[Desktop Entry]
Categories=GTK;AudioVideo;Player;
Exec=pragha %F
Icon=pragha
MimeType=application/x-ape;audio/ape;audio/x-ape;audio/x-m4a;video/x-ms-asf;audio/x-ms-wma;audio/x-mp3;audio/mpeg;audio/x-mpeg;audio/mpeg3;audio/mp3;application/ogg;application/x-ogg;audio/vorbis;audio/x-vorbis;audio/ogg;audio/x-ogg;audio/x-flac;application/x-flac;audio/flac;audio/x-wav;audio/mpegurl;audio/x-mpegurl;audio/x-scpls;application/xspf+xml;audio/x-ms-wax;
Name=Music Player
StartupNotify=true
Terminal=false
Type=Application
EOF

    cat << EOF | sudo tee /usr/share/applications/kicad.desktop &> /dev/null
[Desktop Entry]
Categories=Science;Electronics;
Exec=kicad %f
Icon=kicad
MimeType=application/x-kicad-project;
Name=KiCad
StartupWMClass=kicad
Terminal=false
Type=Application
EOF

    cat << EOF | sudo tee /usr/share/applications/nicotine.desktop &> /dev/null
[Desktop Entry]
Categories=Network;FileTransfer;InstantMessaging;Chat;P2P;GTK;
Exec=nicotine
Icon=org.nicotine_plus.Nicotine
Keywords=Soulseek;Nicotine;sharing;chat;messaging;P2P;peer-to-peer;GTK;
Name=Music Sharing
StartupNotify=true
Terminal=false
Type=Application
EOF

    cat << EOF | sudo tee /usr/share/applications/texmaker.desktop &> /dev/null
[Desktop Entry]
Categories=Office;Publishing;Qt;X-SuSE-Core-Office;X-Mandriva-Office-Publishing;X-Misc;
Exec=texmaker %F
Icon=texmaker
MimeType=text/x-tex;
Name=LaTeX Editor
StartupNotify=false
Terminal=false
Type=Application
EOF

    cat << EOF | sudo tee /usr/share/applications/arduino-ide.desktop &> /dev/null
[Desktop Entry]
Categories=Development;IDE;Electronics;
Exec=arduino-ide %U
Icon=arduino-ide
Keywords=embedded electronics;avr;microcontroller;
MimeType=text/x-arduino;
Name=Arduino IDE v2
StartupWMClass=Arduino IDE
Terminal=false
Type=Application
EOF

    cat << EOF | sudo tee /usr/share/applications/qimgv.desktop &> /dev/null
[Desktop Entry]
Categories=Qt;Graphics;Viewer;
Exec=qimgv %f
Icon=qimgv
Keywords=image;view;qimgv;picture;gif;jpeg;webm;
MimeType=video/webm;image/jpeg;image/gif;image/png;image/bmp;image/webp;
Name=Image Viewer
Terminal=false
Type=Application
EOF

    cat << EOF | sudo tee /usr/share/applications/system-config-printer.desktop &> /dev/null
[Desktop Entry]
Exec=system-config-printer
Icon=printer
Name=Print Settings
StartupNotify=true
Terminal=false
Type=Application
EOF

cat << EOF | sudo tee /usr/share/applications/evince.desktop &> /dev/null
[Desktop Entry]
Name=Document Viewer
Keywords=pdf;ps;postscript;dvi;xps;djvu;tiff;document;presentation;viewer;evince;
TryExec=evince
Exec=evince %U
StartupNotify=true
Terminal=false
Type=Application
Icon=@app_id@
Categories=GNOME;GTK;Office;Viewer;Graphics;2DGraphics;VectorGraphics;
MimeType=@EVINCE_MIME_TYPES@;
Actions=new-window;

[Desktop Action new-window]
Name=New Window
Exec=evince --new-window
EOF

}

configure_playerctl() {
    echo "--> Configure playerctld."

    mkdir -p /home/nicola/.config/systemd/user

    cat > /home/nicola/.config/systemd/user/playerctld.service << 'EOF'
[Unit]
Description=Keep track of media player activity

[Service]
Type=oneshot
ExecStart=/usr/bin/playerctld daemon

[Install]
WantedBy=default.target
EOF

    systemctl enable playerctld.service --user &> /dev/null
    systemctl start playerctld.service --user &> /dev/null
}

configure_mocp() {
    echo "--> Configure moc themme."

    mkdir -p /home/nicola/.moc/themes

    cat > /home/nicola/.moc/themes/main << 'EOF'
background           = default default
frame                = default default
window_title         = default default
directory            = cyan    default
selected_directory   = cyan    default reverse
playlist             = default default
selected_playlist    = default default reverse
file                 = default default
selected_file        = default default reverse
marked_file          = cyan    default bold
marked_selected_file = cyan    default reverse
info                 = default default
selected_info        = default default
marked_info          = cyan    default bold
marked_selected_info = cyan    default bold
status               = default default
title                = cyan    default bold
state                = default default
current_time         = default default
time_left            = default default
total_time           = default default
time_total_frames    = default default
sound_parameters     = default default
legend               = default default
disabled             = default default
enabled              = cyan    default bold
empty_mixer_bar      = default default
filled_mixer_bar     = default default reverse
empty_time_bar       = default default
filled_time_bar      = default default reverse
entry                = default default
entry_title          = default default
error                = default default bold
message              = default default bold
plist_time           = default default
EOF
}

main "$@"

#!/usr/bin/env bash
# set -eu

main() {
    configure_profile
    configure_git
    configure_gpg
    configure_udev
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
alias ll="ls -laS"
alias r="source ~/.bashrc.d/*.sh"
alias f="fzf -i --print0 | xclip -selection clipboard"
alias h="history"
alias o="dolphin ."
EOF

    cat > $HOME/.bashrc.d/alias/git.sh << 'EOF'
alias ga="git add ."
alias gcane="git commit --amend --no-edit"
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

aws-ssm-login() {
    if [ -z "$1" ]; then
        echo "No argument supplied."
        echo "Usage: aws-ssm-login profile-stg"
        return
    fi

    aws sso login --profile $1 --no-browser
    eval "$(aws configure export-credentials --profile $1 --format env)"
}

aws-ec2-list() {
    if [ $# -lt 2 ]; then
        echo "No argument supplied."
        echo "Usage: aws-ec2-list profile-stg instance_name"
        return
    fi

    aws ec2 describe-instances --profile $1 --filters "Name=tag:Name,Values=${2}" | jq -c '.Reservations[].Instances[] | [.State.Name,.InstanceId,.InstanceType,.PrivateIpAddress,.PublicIp]'
}

aws-ec2-ssm-connect() {
    if [ $# -lt 2 ]; then
        echo "No argument supplied."
        echo "Usage: aws-ec2-ssm-connect profile-stg instance_id"
        return
    fi

    aws ssm start-session \
        --document-name AWS-StartInteractiveCommand \
        --profile=$1 \
        --target=$2 \
        --parameters command="bash -l"
}

aws-ec2-ssm-port-forward() {
    if [ $# -lt 3 ]; then
        echo "No argument supplied."
        echo "Usage: aws-ec2-ssm-port-forward profile-stg instance_id 3000"
        return
    fi

    aws ssm start-session \
        --profile=$1 \
        --target=$2 \
        --document-name AWS-StartPortForwardingSession \
        --parameters "{\"portNumber\":[\"$3\"],\"localPortNumber\":[\"$3\"]}"

}

aws-databases-list () {
    if [ -z "$1" ]; then
        echo "No argument supplied."
        echo "Usage: aws-databases-list  profile-stg"
        return
    fi

    aws rds describe-db-instances \
        --profile=$1 \
        --query 'DBInstances[].DBInstanceIdentifier[]'
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

backup-synology() {
    /usr/bin/rsync -CPavzt --rsync-path=/bin/rsync -e ssh /home/nicola/Music/ nicola@192.168.1.100:/volume1/music/
    /usr/bin/rsync -CPavzt --rsync-path=/bin/rsync -e ssh /home/nicola/Pictures/ nicola@192.168.1.100:/var/services/homes/nicola/Photos/
}

backup-icloud() {
    icloudpd --username nicola@strappazzon.me --directory /home/nicola/Pictures/iCloud/
}

raspberri-pi-find() {
    sudo nmap -sP 192.168.1.0/24 | awk '/^Nmap/{ip=$NF}/B8:27:EB/{print ip}'
}
EOF

    cat > $HOME/.bashrc.d/env/gpg.sh << 'EOF'
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
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

configure_git() {
    echo "--> Configure git."

    git config --global init.defaultBranch main
    git config --global commit.gpgsign true
    git config --global tag.gpgSign true
    git config --global pull.rebase true
    git config --global user.email nicola@strappazzon.me
    git config --global user.name "Nicola Strappazzon."
    git config --global user.signingkey 9186C4129FFD3D2500B35FA18E97CAEEEE861364
}

configure_gpg() {
    echo "--> Configure GPG."

    echo "DA0D2EC084DA5974997B8F5D3BAB49A94D82E715" > ~/.gnupg/sshcontrol
    export GPG_TTY=$(tty)
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent
}

configure_udev() {
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

main "$@"

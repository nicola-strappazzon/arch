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
    rsync -CPavzt ~/ /run/media/nsc/DATA/
}

backup-icloud() {
    icloudpd --username nicola@strappazzon.me --directory ~/Pictures/iCloud/
}

raspberri-pi-find() {
    sudo nmap -sP 192.168.1.0/24 | awk '/^Nmap/{ip=$NF}/B8:27:EB/{print ip}'
}

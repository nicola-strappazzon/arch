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

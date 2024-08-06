aws-instances () {
    aws ec2 describe-instances | jq -c '.Reservations[].Instances[] | { instanceid:.InstanceId, name:(.Tags[]? | select(.Key=="Name") | .Value), type:.InstanceType, private_ip:.PrivateIpAddress, public_ip: .PublicIp}'
}

aws-databases-list () {
    aws-reload-keys
    aws rds describe-db-instances --query 'DBInstances[].DBInstanceIdentifier[]'
}

aws-database-describe () {
    if [ -z "$1" ]; then
        echo "No argument supplied."
        echo "Usage: aws-database-describe xxx-yyy-mysql-zzz-node01"
        return
    fi

    aws-reload-keys
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

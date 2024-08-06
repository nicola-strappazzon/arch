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

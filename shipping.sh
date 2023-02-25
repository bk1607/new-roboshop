source common.sh

mysql_root_password=$1
if [ -z "${mysql_root_password}" ];then
  echo -e "\e[31myou didn't provided mysql password\e[0m"
  exit 1
fi

component='shipping'
schema='mysql'
maven
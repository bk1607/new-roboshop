source common.sh

rabbitmq_password=$1
if [ -z "${rabbitmq_password}" ];then
  echo -e "\e[31mMissing rabbitmq password\e[0m"
  exit 1
fi
print_head "configuring yum repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>"${log_file}"
error_check $?

print_head "installing erlang"
yum install erlang -y &>>"${log_file}"
error_check $?

print_head "configuring yum repos for rabbitmq"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>"${log_file}"
error_check $?

print_head "Installing Rabbitmq"
yum install rabbitmq-server -y &>>"${log_file}"
error_check $?

print_head "enabling and starting rabbitmq service"
systemctl enable rabbitmq-server &>>"${log_file}"
systemctl start rabbitmq-server &>>"${log_file}"

print_head "add application user"
rabbitmqctl list_users | grep roboshop &>>"${log_file}"
if [ $? -ne 0 ];then
  rabbitmqctl add_user roboshop "${rabbitmq_password}" &>>"${log_file}"
fi

print_head "configure permission for app user"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>"${log_file}"
error_check $?

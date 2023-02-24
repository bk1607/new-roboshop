source common.sh
print_head "setup mongodb repo file"
cp "${code_dir}"/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>"${log_file}"
error_check $?

print_head "Installing mongodb"
yum install mongodb-org -y &>>"${log_file}"
error_check $?

print_head "change the default ip address"
sed -e -i "s/127.0.0.1/0.0.0.0" /etc/mongod.conf
error_check $?

print_head "enable and restart the service"
systemctl enable mongod &>>"${log_file}"
systemctl restart mongod &>>"${log_file}"
error_check $?



source common.sh
print_head "installing repo file"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>"${log_file}"
error_check $?

print_head "enabling redis 6.2"
dnf module enable redis:remi-6.2 -y &>>"${log_file}"
error_check $?

print_head "installing redis"
yum install redis -y &>>"${log_file}"
error_check $?

print_head "allowing all the incoming traffic"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>"${log_file}"
error_check $?

print_head "enabling and restarting the service"
systemctl enable redis &>>"${log_file}"
systemctl restart redis &>>"${log_file}"
error_check $?
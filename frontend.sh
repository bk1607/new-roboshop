source common.sh
print_head "installing nginx"
yum install nginx -y &>>${log_file}
error_check $?

print_head "removing the old content"
rm -rf /usr/share/nginx/html/* &>>"${log_file}"
error_check $?

print_head "download frontend content"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>"${log_file}"
error_check $?

print_head "extracting front end content"
cd /usr/share/nginx/html
error_check $?
unzip /tmp/frontend.zip &>>"${log_file}"
error_check $?

print_head "setup reverse proxy configuration"
cp ${code_dir}/configs/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>"${log_file}"
error_check $?

print_head "enable and restart the service"
systemctl enable nginx &>>${log_file}
systemctl restart nginx &>>${log_file}
error_check $?
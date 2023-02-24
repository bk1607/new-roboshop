print_head(){
  echo -e "\e[35m$1 \e[0m"
}
log_file=/tmp/roboshop.org

code_dir=$(pwd)

error_check() {
  if [ "$1" -eq 0 ];then
    echo "SUCCESS"
  else
    echo "Failure"
    echo "something went wrong check ${log_file} for error"
    exit 1
  fi
}

systemd_setup(){
  print_head "setting up system files"
  cp "${code_dir}"/configs/"${component}".service /etc/systemd/system/"${component}".service &>>"${log_file}"
  error_check $?

  print_head "loading service"
  systemctl daemon-reload &>>"${log_file}"
  error_check $?

  print_head "starting catalogue service"
  systemctl enable "${component}" &>>"${log_file}"
  systemctl restart "${component}" &>>"${log_file}"

}

app_setup(){

  print_head "creating an application user"
  id roboshop &>>"${log_file}"
  if [ $? -ne 0 ];then
    useradd roboshop &>>"${log_file}"
  fi
  error_check $?

  print_head "creating app directory"
  if [ ! -d /app ];then
    mkdir /app &>>"${log_file}"
  elif [ -d /app ];then
    rm -rf /app &>>"${log_file}"
  fi
  error_check $?

  print_head "downloading application content to app directory"
  curl -L -o /tmp/"${component}".zip https://roboshop-artifacts.s3.amazonaws.com/"${component}".zip &>>"${log_file}"
  error_check $?
  cd /app

  print_head "extracting content"
  unzip /tmp/"${component}".zip &>>"${log_file}"
  error_check $?
}

node_js(){
  print_head "setup nodejs repo file"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>"${log_file}"
  error_check $?

  print_head "installing nodejs"
  yum install nodejs -y &>>"${log_file}"
  error_check $?

  app_setup

  print_head "installing dependencies"
  npm install &>>"${log_file}"
  error_check $?
  schema_setup

  systemd_setup


}

schema_setup(){
  if [ "${schema}"=='mongo' ];then
    print_head "creating mongodb repo file"
    cp "${code_dir}"/configs/mongodb.repo /etc/yum.repos.d/mongo.repo &>>"${log_file}"
    error_check $?

    print_head "installing mongodb"
    yum install mongodb-org-shell -y &>>"${log_file}"
    error_check $?

    print_head "loading schema"
    mongo --host mongodb.devops2023.online </app/schema/catalogue.js &>>"${log_file}"
    error_check $?
  fi

}
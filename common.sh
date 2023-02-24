print_head(){
  echo -e "\e[35m$1 \e[0m"
}
log_file=/tmp/roboshop.org

code_dir=$(pwd)

error_check() {
  if [ $1 -eq 0 ];then
    echo "SUCCESS"
  else
    echo "Failure"
    echo "something went wrong check ${log_file} for error"
    exit 1
  fi
}
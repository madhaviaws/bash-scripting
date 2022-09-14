#!/bin/bash
set -e   # ensure your script will stop if any of the instruction fails


source components/common.sh 

COMPONENT=rabbitmq

echo -n "Installing  ${COMPONENT} dependency Erlang: "
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm -y &>>/tmp/${COMPONENT}.log
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>/tmp/${COMPONENT}.log
stat $?

echo -n "Installing   ${COMPONENT}: "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | sudo bash &>>/tmp/${COMPONENT}.log
stat $?

echo -n "Starting the Service: "
systemctl enable rabbitmq-server &>>/tmp/${COMPONENT}.log
systemctl start rabbitmq-server &>>/tmp/${COMPONENT}.log
stat $?

rabbitmqctl list_users | grep roboshop  2>> ${LOGFILE} 
if [ $? -ne 0 ]; then
echo -n "Adding ${COMPONENT} user: "
rabbitmqctl add_user roboshop roboshop123 &>>/tmp/${COMPONENT}.log
fi
stat $?

echo -n "Configuring the $COMPONENT $FUSER permissions: "
rabbitmqctl set_user_tags roboshop administrator &>>/tmp/${COMPONENT}.log
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>/tmp/${COMPONENT}.log
stat $?


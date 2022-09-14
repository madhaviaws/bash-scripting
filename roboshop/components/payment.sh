#!/bin/bash
set -e   # ensure your script will stop if any of the instruction fails


source components/common.sh 

COMPONENT=payment

echo -n "Installing Python for ${COMPONENT} : "
yum install python36 gcc python3-devel -y &>> /tmp/${COMPONENT}.log
stat $?


USER_SETUP

DOWNLOD_AND_EXTRACT

echo -n "Installing Python Dependencies : "
cd /home/${FUSER}/${COMPONENT} && pip3 install -r requirements.txt  &>> /tmp/${COMPONENT}.log
stat $?

USERID=$(id -u ${FUSER})
GROUPID=$(id -g ${FUSER})

echo -n "Updating the ${COMPONENT}.ini file"

sed -i -e "/^uid/ c uid=${USERID}" -e "/^gid/ c gid=${GROUPID}" ${COMPONENT}.ini

CONFIG_SVC
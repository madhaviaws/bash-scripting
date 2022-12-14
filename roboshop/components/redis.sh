set -e   # ensure your script will stop if any of the instruction fails


source components/common.sh 

COMPONENT=redis

echo -n "Configuring the $COMPONENT repo: "
curl -L https://raw.githubusercontent.com/stans-robot-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo  &>> /tmp/${COMPONENT}.log 
stat $?

echo -n "Installing $COMPONENT :"
yum install redis-6.2.7 -y  &>> /tmp/${COMPONENT}.log 
stat $?

echo -n "Updating the $COMPONENT Config: "
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf
sed -i -e 's/127.0.0.1/0.0.0.0/g' /etc/redis/redis.conf
stat $?

echo -n "Starting the $COMPONENT :"
systemctl enable redis &>> /tmp/${COMPONENT}.log
systemctl start redis &>> /tmp/${COMPONENT}.log
stat $?
# this is a placeholder to put the scripts required to bootstrap the compute
useradd oracle
yum install -y docker
yum install -y docker-compose
yum install -y git
firewall-cmd --permanent --add-port=2377/tcp
firewall-cmd --permanent --add-port=7946/tcp
firewall-cmd --permanent --add-port=4789/udp
firewall-cmd --permanent --add-port=7946/udp
firewall-cmd --reload
service docker start
SWARM_TOKEN=`cat /tmp/swarm_token.txt`
docker swarm join --token $SWARM_TOKEN 10.0.0.3:2377
usermod -a -G docker oracle

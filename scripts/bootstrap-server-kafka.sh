# this is a placeholder to put the scripts required to bootstrap the compute
useradd -m -s /bin/bash oracle
apt-get update
apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release zip
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod 755 /usr/local/bin/docker-compose
apt-get -y install git
iptables -I INPUT 6 -m state --state NEW -p tcp --dport 2377 -j ACCEPT
iptables -I INPUT 6 -m state --state NEW -p tcp --dport 7946 -j ACCEPT
iptables -I INPUT 6 -m state --state NEW -p udp --dport 7946 -j ACCEPT
iptables -I INPUT 6 -m state --state NEW -p udp --dport 4789 -j ACCEPT
netfilter-persistent save
service docker start
SWARM_TOKEN=`cat /tmp/swarm_token.txt`
docker swarm join --token $SWARM_TOKEN 10.0.0.3:2377
usermod -a -G docker oracle

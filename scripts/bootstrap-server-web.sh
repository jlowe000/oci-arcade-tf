# this is a placeholder to put the scripts required to bootstrap the compute
# this is a placeholder to put the scripts required to bootstrap the compute
useradd -m -s /bin/bash oracle
apt-get update
apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release zip
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io
apt-get -y install git
apt-get -y install python3-pip
apt-get -y install zip
pip3 install oci-cli
mkdir /opt/oracle
cd /opt/oracle
wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-basiclite-linux.x64-21.1.0.0.0.zip
unzip instantclient-basiclite-linux.x64-21.1.0.0.0.zip
wget https://download.oracle.com/otn_software/linux/instantclient/211000/instantclient-sqlplus-linux.x64-21.1.0.0.0.zip
unzip instantclient-sqlplus-linux.x64-21.1.0.0.0.zip
iptables -I INPUT 6 -m state --state NEW -p tcp --dport 8080 -j ACCEPT
iptables -I INPUT 6 -m state --state NEW -p tcp --dport 8081 -j ACCEPT
iptables -I INPUT 6 -m state --state NEW -p tcp --dport 2377 -j ACCEPT
iptables -I INPUT 6 -m state --state NEW -p tcp --dport 7946 -j ACCEPT
iptables -I INPUT 6 -m state --state NEW -p udp --dport 7946 -j ACCEPT
iptables -I INPUT 6 -m state --state NEW -p udp --dport 4789 -j ACCEPT
netfilter-persistent save
service docker start
docker swarm init --advertise-addr 10.0.0.3
docker swarm join-token -q worker > /tmp/swarm_token.txt
docker network create -d overlay arcade_network --attachable
usermod -a -G docker oracle
mkdir /home/oracle/.oci
mv /tmp/terraform_api_public_key.pem /home/oracle/.oci
mv /tmp/terraform_api_key.pem /home/oracle/.oci
mv /tmp/config /home/oracle/.oci
chown -R oracle:oracle /home/oracle/.oci
chmod 600 /home/oracle/.oci/terraform_api_key.pem
mkdir /home/oracle/wallet
mv /tmp/arcade-wallet.zip /home/oracle/wallet
chown -R oracle:oracle /home/oracle/wallet
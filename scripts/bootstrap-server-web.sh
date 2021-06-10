# this is a placeholder to put the scripts required to bootstrap the compute

useradd -m -s /bin/bash oracle
apt-get update
apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release zip
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo   "deb [arch=arm64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get -y install docker-ce docker-ce-cli containerd.io
apt-get -y install git
apt-get -y install python3-pip
apt-get -y install zip
python3 -m pip install -IU docker-compose
pip3 install oci-cli
service docker start
docker network create arcade_network
iptables -I INPUT 6 -m state --state NEW -p tcp --dport 8080 -j ACCEPT
iptables -I INPUT 6 -m state --state NEW -p tcp --dport 8081 -j ACCEPT
netfilter-persistent save
usermod -a -G docker oracle
mkdir /home/oracle/.oci
mv /tmp/terraform_api_public_key.pem /home/oracle/.oci
mv /tmp/terraform_api_key.pem /home/oracle/.oci
mv /tmp/config /home/oracle/.oci
chown -R oracle:oracle /home/oracle/.oci
chmod 600 /home/oracle/.oci/terraform_api_key.pem
mkdir /opt/oracle
cd /opt/oracle
wget https://download.oracle.com/otn_software/linux/instantclient/191000/instantclient-basic-linux.arm64-19.10.0.0.0dbru.zip
unzip instantclient-basic-linux.arm64-19.10.0.0.0dbru.zip
wget https://download.oracle.com/otn_software/linux/instantclient/191000/instantclient-sqlplus-linux.arm64-19.10.0.0.0dbru.zip
unzip instantclient-sqlplus-linux.arm64-19.10.0.0.0dbru.zip
mkdir /home/oracle/wallet
mv /tmp/arcade-wallet.zip /home/oracle/wallet
chown -R oracle:oracle /home/oracle/wallet
apt-get -y install go
apt-get -y install golang
apt-get -y install net-tools
apt-get -y install openjdk-8-jdk

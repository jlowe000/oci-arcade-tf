# this is a placeholder to put the scripts required to bootstrap the compute

useradd oracle
yum update -y
yum install -y yum-utils
# yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
python3 -m pip install --upgrade pip
# yum install -y docker-ce python3-devel
yum install -y podman podman-docker
yum install -y dnsmasq
yum install -y python3-devel
yum install -y git
yum install -y zip
python3 -m pip install -IU docker-compose
pip3 install oci-cli
# service docker start
firewall-cmd --add-port 8080/tcp --permanent --zone=public
firewall-cmd --add-port 8081/tcp --permanent --zone=public
firewall-cmd --reload
# usermod -a -G docker oracle
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
yum install -y libaio
yum install -y go
yum install -y golang
yum install -y net-tools
yum install -y java-1.8.0-openjdk-devel
echo "  \"golang\" = \"docker.io/library/golang\"" >> /etc/containers/registries.conf.d/000-shortnames.conf
echo "  \"arm64v8/openjdk\" = \"docker.io/arm64v8/openjdk\"" >> /etc/containers/registries.conf.d/000-shortnames.conf
echo "  \"oraclecoherence/coherence-ce\" = \"docker.io/oraclecoherence/coherence-ce\"" >> /etc/containers/registries.conf.d/000-shortnames.conf
mkdir /root/repos
cd /root/repos
git clone https://github.com/containers/dnsname
cd dnsname
make all install PREFIX=/usr/local

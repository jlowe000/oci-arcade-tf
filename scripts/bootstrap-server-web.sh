# this is a placeholder to put the scripts required to bootstrap the compute
useradd oracle
yum install -y docker
yum install -y git
yum install -y python3-pip
yum install -y python36-oci-cli
yum install -y oracle-instantclient18.3-sqlplus
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --permanent --add-port=8081/tcp
firewall-cmd --permanent --add-port=2377/tcp
firewall-cmd --permanent --add-port=7946/tcp
firewall-cmd --permanent --add-port=4789/udp
firewall-cmd --permanent --add-port=7946/udp
firewall-cmd --reload
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
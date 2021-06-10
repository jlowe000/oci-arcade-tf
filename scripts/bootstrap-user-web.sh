export USER_PWD=$1
shift
export ORDS_HOSTNAME=`echo $1 | cut -d "/" -f 3`
shift
export APIGW_NAME=$1
shift
if [ "${APIGW_NAME}" != "" ]; then
  export API_HOSTNAME=$APIGW_NAME
else
  export API_HOSTNAME=$1:8081
fi
shift
export BOOTSTRAP_SERVER=$1
shift
export API_USER=$1
shift
export API_PASSWORD=$1
shift
export TOPIC=$1
shift
export API_KEY_ENABLED=$1
shift
export BUCKET_NS=$1
shift
export GIT_REPO=$1
mkdir /home/oracle/bin
echo 'export PATH=${PATH}:/home/oracle/bin' >> ~/.profile
mkdir /home/oracle/repos
cd /home/oracle/repos/
git clone https://github.com/jlowe000/fn --branch arm64-oci-build
git clone https://github.com/jlowe000/cli --branch arm64-oci-build
git clone https://github.com/jlowe000/fdk-go --branch arm64-oci-build
git clone https://github.com/jlowe000/fdk-python --branch arm64-oci-build
git clone https://github.com/jlowe000/fdk-java --branch arm64-oci-build
git clone https://github.com/jlowe000/fdk-node --branch arm64-oci-build
git clone https://github.com/jlowe000/dockers --branch arm64-oci-build
git clone https://github.com/jlowe000/zookeeper-docker --branch arm64-oci-build
git clone ${GIT_REPO}
cd /home/oracle/repos/cli/
export GOARCH=arm64
make build
cp fn /home/oracle/bin
cd /home/oracle/repos/fn
export GOARCH=arm64
make build
make build-dind
make docker-build
cp fnserver /home/oracle/bin
cd /home/oracle/repos/fdk-go/
./build-images.sh 1.15
docker tag fnproject/go:1.15 fnproject/go:latest
docker tag fnproject/go:1.15-dev fnproject/go:dev
cd /home/oracle/repos/fdk-python/
./build-images.sh 3.6
./build-images.sh 3.7
./build-images.sh 3.7.1
./build-images.sh 3.8
./build-images.sh 3.8.5
cd /home/oracle/repos/fdk-node/
./build-images.sh 11
./build-images.sh 14
docker tag fnproject/node:11 fnproject/node:latest
docker tag fnproject/node:11-dev fnproject/node:dev
cd /home/oracle/repos/zookeeper-docker/
docker build -t wurstmeister/zookeeper .
cd /home/oracle/wallet/
unzip /home/oracle/wallet/arcade-wallet.zip
echo "WALLET_LOCATION = (SOURCE = (METHOD = file) (METHOD_DATA = (DIRECTORY=\"/home/oracle/wallet\")))" > /home/oracle/wallet/sqlnet.ora
echo "SSL_SERVER_DN_MATCH=yes" >> /home/oracle/wallet/sqlnet.ora
echo "create user ociarcade identified by ${USER_PWD};" > /home/oracle/repos/oci-arcade/infra/db/schema.sql
echo "grant resource, connect, unlimited tablespace to ociarcade;" >> /home/oracle/repos/oci-arcade/infra/db/schema.sql
echo "export BUCKET_NS=${BUCKET_NS}" >> ~/.profile
echo 'export TNS_ADMIN=/home/oracle/wallet' >> ~/.profile
echo 'export ORACLE_HOME=/opt/oracle/instantclient_19_10' >> ~/.profile
echo 'export PATH=${PATH}:${ORACLE_HOME}' >> ~/.profile
echo 'export LD_LIBRARY_PATH=${ORACLE_HOME}' >> ~/.profile
cd /home/oracle/repos/oci-arcade
. ~/.profile
echo "#!/bin/sh" > /home/oracle/repos/oci-arcade/infra/db/run.sh
echo ". /home/oracle/.profile" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
echo "yum install -y libaio" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
echo "cd /home/oracle/repos/oci-arcade" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
echo "exit | sqlplus admin/${USER_PWD}@arcade_low @ infra/db/schema.sql" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
echo "exit | sqlplus ociarcade/${USER_PWD}@arcade_low @ infra/db/init.sql" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
echo "exit | sqlplus ociarcade/${USER_PWD}@arcade_low @ apis/score/db/init.sql" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
echo "exit | sqlplus ociarcade/${USER_PWD}@arcade_low @ apis/events/db/init.sql" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
chmod 755 /home/oracle/repos/oci-arcade/infra/db/run.sh
docker run --rm -it -v /opt/oracle:/opt/oracle -v /home/oracle:/home/oracle oraclelinux:7 /home/oracle/repos/oci-arcade/infra/db/run.sh
cat containers/kafka/oci-kafka-compose.yml.template | envsubst > containers/kafka/oci-kafka-compose.yml
bin/oci-kafka-cluster-build.sh
cp containers/kafka/oci-kafka-events.Dockerfile.template containers/kafka/oci-kafka-events.Dockerfile
bin/oci-kafka-cluster-run.sh
bin/oci-kafka-event-build.sh ${ORDS_HOSTNAME} ${BOOTSTRAP_SERVER} ${TOPIC}
bin/oci-kafka-event-run.sh
cp containers/web/api-score.Dockerfile.template containers/web/api-score.Dockerfile
chmod 755 bin/*.sh
bin/oci-fn-run.sh
bin/oci-fn-build.sh
bin/api-events-serverless-deploy.sh ${ORDS_HOSTNAME}
cat apis/events/kafka/event-producer/python/func.yaml.template | envsubst > apis/events/kafka/event-producer/python/func.yaml
bin/api-events-kafka-deploy.sh
bin/api-score-docker-build.sh ${ORDS_HOSTNAME} ${USER_PWD}
bin/api-score-docker-run.sh
pip3 install oci --user
if [ "${API_KEY_ENABLED}" == "true" ]; then
  bin/oci-arcade-storage-build.sh ${API_HOSTNAME} ${BUCKET_NS}
fi
docker network inspect arcade_network

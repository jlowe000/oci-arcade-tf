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
mkdir /home/oracle/repos
cd /home/oracle/repos/
git clone https://github.com/jlowe000/fn --branch arm64-oci-build
git clone https://github.com/jlowe000/cli --branch arm64-oci-build
git clone https://github.com/jlowe000/fdk-go --branch arm64-oci-build
git clone https://github.com/jlowe000/fdk-python --branch arm64-oci-build
git clone https://github.com/jlowe000/fdk-java --branch arm64-oci-build
git clone https://github.com/jlowe000/fdk-node --branch arm64-oci-build
git clone https://github.com/jlowe000/fdk-dockers --branch arm64-oci-build
git clone https://github.com/jlowe000/dockers --branch arm64-oci-build
cd cli/
export GOARCH=arm64
make build
cd ..
cd fn
export GOARCH=arm64
make build
make build-dind
make docker-build
cd ..
cd fdk-go/
./build-images.sh 1.15
docker tag fnproject/go:1.15 fnproject/go:latest
docker tag fnproject/go:1.15-dev fnproject/go:dev
cd ..
cd fdk-python/
./build-images.sh 3.6
./build-images.sh 3.7
./build-images.sh 3.7.1
./build-images.sh 3.8
./build-images.sh 3.8.5
cd ..
cd fdk-node/
./build-images.sh 11
./build-images.sh 14
docker tag fnproject/node:11 fnproject/node:latest
docker tag fnproject/node:11-dev fnproject/node:dev
git clone ${GIT_REPO}
pip3 install oci --user
cd /home/oracle/wallet/
unzip /home/oracle/wallet/arcade-wallet.zip
echo "WALLET_LOCATION = (SOURCE = (METHOD = file) (METHOD_DATA = (DIRECTORY=\"/home/oracle/wallet\")))" > /home/oracle/wallet/sqlnet.ora
echo "SSL_SERVER_DN_MATCH=yes" >> /home/oracle/wallet/sqlnet.ora
echo "create user ociarcade identified by ${USER_PWD};" > /home/oracle/repos/oci-arcade/infra/db/schema.sql
echo "grant resource, connect, unlimited tablespace to ociarcade;" >> /home/oracle/repos/oci-arcade/infra/db/schema.sql
cd /home/oracle/repos/oci-arcade
echo 'export BUCKET_NS=${BUCKET_NS}' >> ~/.bash_profile
echo 'export TNS_ADMIN=/home/oracle/wallet' >> ~/.bash_profile
echo 'export ORACLE_HOME=/opt/oracle/instantclient_19_10' >> ~/.bash_profile
echo 'export PATH=${PATH}:${ORACLE_HOME}' >> ~/.bash_profile
echo 'export LD_LIBRARY_PATH=${ORACLE_HOME}' >> ~/.bash_profile
. ~/.bash_profile
# exit | sqlplus admin/${USER_PWD}@arcade_low @ infra/db/schema.sql
# exit | sqlplus ociarcade/${USER_PWD}@arcade_low @ infra/db/init.sql
# exit | sqlplus ociarcade/${USER_PWD}@arcade_low @ apis/score/db/init.sql
# exit | sqlplus ociarcade/${USER_PWD}@arcade_low @ apis/events/db/init.sql
cp containers/web/api-score.Dockerfile.template containers/web/api-score.Dockerfile
chmod 755 bin/*.sh
bin/oci-fn-run.sh
bin/oci-fn-build.sh
bin/api-events-serverless-deploy.sh ${ORDS_HOSTNAME}
cat apis/events/kafka/event-producer/python/func.yaml.template | envsubst > apis/events/kafka/event-producer/python/func.yaml
bin/api-events-kafka-deploy.sh
bin/api-score-docker-build.sh ${ORDS_HOSTNAME} ${USER_PWD}
bin/api-score-docker-run.sh
cp containers/kafka/oci-kafka-events.Dockerfile.template containers/kafka/oci-kafka-events.Dockerfile
bin/oci-kafka-event-build.sh ${ORDS_HOSTNAME} ${BOOTSTRAP_SERVER} ${TOPIC}
bin/oci-kafka-event-run.sh
docker network inspect arcade_network
if [ "${API_KEY_ENABLED}" == "true" ]; then
  bin/oci-arcade-storage-build.sh ${API_HOSTNAME} ${BUCKET_NS}
fiexport GIT_REPO=$1
export TOPIC=$2
shift
mkdir /home/oracle/repos
cd /home/oracle/repos/
git clone ${GIT_REPO}
cd /home/oracle/repos/oci-arcade
chmod 755 bin/*.sh
cat containers/kafka/oci-kafka-compose.yml.template | envsubst > containers/kafka/oci-kafka-compose.yml
bin/oci-kafka-cluster-build.sh
bin/oci-kafka-cluster-run.sh
docker network inspect arcade_network

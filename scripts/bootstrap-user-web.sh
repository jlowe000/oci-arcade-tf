export USER_PWD=$1
echo "export USER_PWD=\"$USER_PWD\"" > ~/arcade.env.sh
shift
export ORDS_HOSTNAME=`echo $1 | cut -d "/" -f 3`
echo "export ORDS_HOSTNAME=\"$ORDS_HOSTNAME\"" >> ~/arcade.env.sh
shift
export APIGW_NAME=$1
echo "export APIGW_NAME=\"$APIGW_NAME\"" >> ~/arcade.env.sh
shift
if [ "${APIGW_NAME}" != "" ]; then
  export API_HOSTNAME=$APIGW_NAME
else
  export API_HOSTNAME=$1:8081
fi
echo "export API_HOSTNAME=\"$API_HOSTNAME\"" >> ~/arcade.env.sh
shift
export BOOTSTRAP_SERVER=$1
echo "export BOOTSTRAP_SERVER=\"$BOOTSTRAP_SERVER\"" >> ~/arcade.env.sh
shift
export API_USER=$1
echo "export API_USER=\"$API_USER\"" >> ~/arcade.env.sh
shift
export API_PASSWORD=$1
echo "export API_PASSWORD=\"$API_PASSWORD\"" >> ~/arcade.env.sh
shift
export TOPIC=$1
echo "export TOPIC=\"$TOPIC\"" >> ~/arcade.env.sh
shift
export API_KEY_ENABLED=$1
echo "export API_KEY_ENABLED=\"$API_KEY_ENABLED\"" >> ~/arcade.env.sh
shift
export BUCKET_NS=$1
echo "export BUCKET_NS=\"$BUCKET_NS\"" >> ~/arcade.env.sh
shift
export GIT_REPO=$1
echo "export GIT_REPO=\"$GIT_REPO\"" >> ~/arcade.env.sh
mkdir /home/oracle/bin
echo 'export PATH=${PATH}:/home/oracle/bin' >> ~/.profile
mkdir /home/oracle/repos
cd /home/oracle/repos/
# git clone https://github.com/fnproject/fn --branch master
# git clone https://github.com/fnproject/cli --branch master
# git clone https://github.com/fnproject/fdk-go --branch master
# git clone https://github.com/fnproject/fdk-python --branch master
# git clone https://github.com/fnproject/fdk-java --branch master
# git clone https://github.com/fnproject/fdk-node --branch master
# git clone https://github.com/fnproject/dockers --branch master
git clone https://github.com/jlowe000/zookeeper-docker --branch arm64-oci-build
git clone ${GIT_REPO}
# cd /home/oracle/repos/cli/
# export GOARCH=arm64
# make build
# cp fn /home/oracle/bin
# cd /home/oracle/repos/fn
# export GOARCH=arm64
# make build
# make build-dind
# make docker-build
# cp fnserver /home/oracle/bin
# cd /home/oracle/repos/fdk-go/
# ./build-images.sh 1.15
# docker tag fnproject/go:1.15 fnproject/go:latest
# docker tag fnproject/go:1.15-dev fnproject/go:dev
# cd /home/oracle/repos/fdk-python/
# ./build-images.sh 3.6
# ./build-images.sh 3.7
# ./build-images.sh 3.7.1
# ./build-images.sh 3.8
# ./build-images.sh 3.8.5
# cd /home/oracle/repos/fdk-node/
# ./build-images.sh 11
# ./build-images.sh 14
# docker tag fnproject/node:11 fnproject/node:latest
# docker tag fnproject/node:11-dev fnproject/node:dev
cd /home/oracle/repos/zookeeper-docker/
docker build -t wurstmeister/zookeeper .
cd /home/oracle/wallet/
unzip /home/oracle/wallet/arcade-wallet.zip
echo "WALLET_LOCATION = (SOURCE = (METHOD = file) (METHOD_DATA = (DIRECTORY=\"/home/oracle/wallet\")))" > /home/oracle/wallet/sqlnet.ora
echo "SSL_SERVER_DN_MATCH=yes" >> /home/oracle/wallet/sqlnet.ora
echo "create user ociarcade identified by ${USER_PWD};" > /home/oracle/repos/oci-arcade/infra/db/schema.sql
echo "grant DWROLE, unlimited tablespace to ociarcade;" >> /home/oracle/repos/oci-arcade/infra/db/schema.sql
echo "exec apex_instance_admin.add_workspace(p_workspace => 'OCIARCADE', p_primary_schema => 'OCIARCADE');" >> /home/oracle/repos/oci-arcade/infra/db/schema.sql
echo "begin" >> /home/oracle/repos/oci-arcade/infra/db/apex.sql
echo "apex_util.set_workspace(p_workspace => 'OCIARCADE');" >> /home/oracle/repos/oci-arcade/infra/db/apex.sql
echo "apex_util.create_user(" >> /home/oracle/repos/oci-arcade/infra/db/apex.sql
echo "  p_user_name => 'ociarcade'," >> /home/oracle/repos/oci-arcade/infra/db/apex.sql
echo "  p_web_password => '${USER_PWD}'," >> /home/oracle/repos/oci-arcade/infra/db/apex.sql
echo "  p_developer_privs => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL'," >> /home/oracle/repos/oci-arcade/infra/db/apex.sql
echo "  p_email_address => 'ociarcade@withoracle.com'," >> /home/oracle/repos/oci-arcade/infra/db/apex.sql
echo "  p_default_schema => 'OCIARCADE'," >> /home/oracle/repos/oci-arcade/infra/db/apex.sql
echo "  p_change_password_on_first_use => 'N');" >> /home/oracle/repos/oci-arcade/infra/db/apex.sql
echo "end;" >> /home/oracle/repos/oci-arcade/infra/db/apex.sql
echo "/" >> /home/oracle/repos/oci-arcade/infra/db/apex.sql
echo "commit;" >> /home/oracle/repos/oci-arcade/infra/db/apex.sql
echo "export BUCKET_NS=${BUCKET_NS}" >> ~/.profile
echo 'export TNS_ADMIN=/home/oracle/wallet' >> ~/.profile
echo 'export ORACLE_HOME=/opt/oracle/instantclient_19_10' >> ~/.profile
echo 'export PATH=${PATH}:${ORACLE_HOME}' >> ~/.profile
echo 'export LD_LIBRARY_PATH=${ORACLE_HOME}' >> ~/.profile
cd /home/oracle/repos/oci-arcade
. ~/.profile
echo "#!/bin/sh" > /home/oracle/repos/oci-arcade/infra/db/run.sh
echo ". /home/oracle/.profile" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
# echo "yum install -y libaio" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
echo "cd /home/oracle/repos/oci-arcade" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
echo "exit | sqlplus admin/${USER_PWD}@arcade_low @ infra/db/schema.sql" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
echo "exit | sqlplus ociarcade/${USER_PWD}@arcade_low @ infra/db/init.sql" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
echo "exit | sqlplus ociarcade/${USER_PWD}@arcade_low @ infra/db/apex.sql" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
echo "exit | sqlplus ociarcade/${USER_PWD}@arcade_low @ apis/score/db/init.sql" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
echo "exit | sqlplus ociarcade/${USER_PWD}@arcade_low @ apis/events/db/init.sql" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
echo "exit | sqlplus ociarcade/${USER_PWD}@arcade_low @ apis/user/db/init-crm-app.sql" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
echo "exit | sqlplus ociarcade/${USER_PWD}@arcade_low @ apis/user/db/init-crm-config.sql" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
echo "exit | sqlplus ociarcade/${USER_PWD}@arcade_low @ apis/user/db/init-crm-ociarcade.sql" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
echo "exit | sqlplus ociarcade/${USER_PWD}@arcade_low @ apis/user/db/init.sql" >> /home/oracle/repos/oci-arcade/infra/db/run.sh
chmod 755 /home/oracle/repos/oci-arcade/infra/db/run.sh
# docker run --rm -it -v /opt/oracle:/opt/oracle -v /home/oracle:/home/oracle oraclelinux:7 /home/oracle/repos/oci-arcade/infra/db/run.sh
/home/oracle/repos/oci-arcade/infra/db/run.sh
docker network create arcade_network
cat .config/cni/net.d/arcade_network.conflist | jq '.plugins += [{ "type": "dnsname", "domainName": "arcade.withoracle.cloud", "capabilities": { "aliases": true } }]'
bin/oci-cache-docker-run.sh
cat containers/kafka/oci-kafka-compose.yml.template | envsubst > containers/kafka/oci-kafka-compose.yml
bin/oci-kafka-cluster-build.sh
cp containers/kafka/oci-kafka-events.Dockerfile.template containers/kafka/oci-kafka-events.Dockerfile
bin/oci-kafka-cluster-run.sh
bin/oci-kafka-event-build.sh ${ORDS_HOSTNAME} ${BOOTSTRAP_SERVER} ${TOPIC}
bin/oci-kafka-event-run.sh
cp containers/web/api-score.Dockerfile.template containers/web/api-score.Dockerfile
chmod 755 bin/*.sh
# bin/oci-fn-run.sh
# bin/oci-fn-build.sh
# bin/api-events-serverless-deploy.sh ${ORDS_HOSTNAME}
# cat apis/events/kafka/event-producer/python/func.yaml.template | envsubst > apis/events/kafka/event-producer/python/func.yaml
# bin/api-events-kafka-deploy.sh
bin/api-score-docker-build.sh ${ORDS_HOSTNAME} ${USER_PWD} ${BOOTSTRAP_SERVER} ${TOPIC}
bin/api-score-docker-run.sh
pip3 install oci --user
if [ "${API_KEY_ENABLED}" == "true" ]; then
  bin/oci-arcade-storage-build.sh ${API_HOSTNAME} ${BUCKET_NS}
fi
docker network inspect arcade_network

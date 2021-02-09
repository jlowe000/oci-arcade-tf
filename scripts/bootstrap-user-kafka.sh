export GIT_REPO=$1
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
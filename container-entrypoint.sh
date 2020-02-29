#/bin/sh

set -e
if [ "${1#-}" != "$1" ]
then
  echo "[INFO] Set value into /opt/CMAK/conf/application.conf"

  echo "application.home=/opt/CMAK" >> /opt/CMAK/conf/application.conf

  echo "kafka-manager.offset-cache-thread-pool-size=$((2+nproc))"  >> /opt/CMAK/conf/application.conf
  echo "kafka-manager.offset-cache-thread-pool-size=$((10+nproc))"  >> /opt/CMAK/conf/application.conf
  echo "kafka-manager.kafka-admin-client-thread-pool-size=$((2+nproc))" >> /opt/CMAK/conf/application.conf
  echo "kafka-manager.logkafka-update-period-seconds=$(( (10+nproc) % 1000 ))" >> /opt/CMAK/conf/application.conf
  echo "kafka-manager.broker-view-thread-pool-size=$(( ${KAFKA_NUMBER_OF_BROKERS} * 3))" >> /opt/CMAK/conf/application.conf
  echo "kafka-manager.broker-view-thread-pool-size=$(( ${KAFKA_NUMBER_OF_BROKERS} * 3))" >> /opt/CMAK/conf/application.conf
  echo "kafka-manager.broker-view-max-queue-size=$(( ${KAFKA_TOTAL_PARTITIONS_NUMBER} * ${KAFKA_NUMBER_OF_BROKERS} ))" >> /opt/CMAK/conf/application.conf
  echo "kafka-manager.broker-view-update-seconds=$(( (${KAFKA_TOTAL_PARTITIONS_NUMBER} * ${KAFKA_NUMBER_OF_BROKERS} / 10 * ${KAFKA_NUMBER_OF_BROKERS}) % 1000))" >> /opt/CMAK/conf/application.conf

  if [ ! -z $KM_USERNAME ] && [ ! -z $KM_PASSWORD ]; then
    sed -i.bak '/^basicAuthentication/d' /opt/CMAK/conf/application.conf
    echo 'basicAuthentication.enabled=true' >> /opt/CMAK/conf/application.conf
    echo "basicAuthentication.username=${KM_USERNAME}" >> /opt/CMAK/conf/application.conf
    echo "basicAuthentication.password=${KM_PASSWORD}" >> /opt/CMAK/conf/application.conf
    echo 'basicAuthentication.realm="Kafka-Manager"' >> /opt/CMAK/conf/application.conf
  fi

  echo "[INFO] Start kafka-manager"
  /opt/CMAK/bin/kafka-manager -Dconfig.file=/opt/CMAK/conf/application.conf $@
else
  $@
fi

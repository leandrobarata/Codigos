#!/bin/bash

WAR=epp-3.3.0-SNAPSHOT.war
LIQ=liquibase-epp-3.3.0-SNAPSHOT.tar.gz

SCRIPTS="$(pwd)"

if [ ! -d /opt/liquibase-3.5.1 ]; then
  echo "Instalando liquibase ..."
  wget https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.5.1/liquibase-3.5.1-bin.tar.gz
  mkdir /opt/liquibase-3.5.1
  tar xf liquibase-3.5.1-bin.tar.gz -C /opt/liquibase-3.5.1/
fi

echo "Instalando scripts liquibase da versao ${LIQ} ..."

if [ -d /opt/liquibase-epp ]; then
  rm -rf /opt/liquibase-epp
fi

mkdir /opt/liquibase-epp 
tar xf "${LIQ}" -C /opt/liquibase-epp

#sed -i 's/\\/\//g' /opt/liquibase-epp/config/sqlserver.properties 
#sed -i 's/\;/\:/g' /opt/liquibase-epp/config/sqlserver.properties 
#sed -i 's/\\/\//g' /opt/liquibase-epp/config/sqlserver-bin.properties 
#sed -i 's/\;/\:/g' /opt/liquibase-epp/config/sqlserver-bin.properties

/etc/init.d/jboss stop

echo "Executando update na base principal ..."
cd /opt/liquibase-epp
/opt/liquibase-3.5.1/liquibase --defaultsFile=config/sqlserver.properties --url="jdbc:sqlserver://IPDOBANCO\\MSSQLSERVER:1433;databaseName=NOMEDABASE;SelectMethod=cursor" --username=USUARIO --password=SENHA update

echo "Executando update na base de binarios ..."
/opt/liquibase-3.5.1/liquibase --defaultsFile=config/sqlserver-bin.properties --url="jdbc:sqlserver://IPDOBANCO\\MSSQLSERVER:1433;databaseName=NOMEDABASE;SelectMethod=cursor" --username=USUARIO --password=SENHA update #clearchecksums

echo "Fazendo deploy do projeto ${WAR} ..."
cd "${SCRIPTS}"
if [ -d /opt/jboss6/standalone/deployments/epp.war ]; then
  rm -rf /opt/jboss6/standalone/deployments/epp.war*
  rm -rf /opt/jboss6/standalone/data/*
  rm -rf /opt/jboss6/standalone/tmp/*
fi

unzip "${WAR}" -d /opt/jboss6/standalone/deployments/epp.war
chown -RH jboss:jboss /opt/jboss6

sudo -u jboss touch /opt/jboss6/standalone/deployments/epp.war.dodeploy

/etc/init.d/jboss start


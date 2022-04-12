#!/bin/bash
# Instalacao do JBoss EAP a partir dos fontes.
# Deve ser aplicado nos servidores jboss.
# O codigo compilado nesse procedimento nao retira as logomarcas de Red Hat, pode isso nao pode ser distribuido,
# sempre que precisar, deve ser feito o build local.
#
# 
#

# echo "Ajustes de firewall ..."
# firewall-cmd --permanent --zone=public --add-port=8009/tcp
# firewall-cmd --reload

# echo "Instalando pacotes necessarios para o jboss ..."
# yum -y install java-1.8.0-openjdk-devel fontpackages-filesystem dejavu-fonts-common dejavu-sans-fonts libfontenc libXfont xorg-x11-font-utils ttmkfdir xorg-x11-fonts-Type1 libhugetlbfs libhugetlbfs-utils patch

#mkdir /usr/java
#ln -s /usr/lib/jvm/java-1.8.0-openjdk /usr/java/jdk

#echo "Criando usuario sem privilegios para o jboss ..."
#groupadd jboss ; useradd -g jboss jboss

#echo "Instalando servico para o jboss ..."
#cp -a jboss /etc/init.d
#chmod 755 /etc/init.d/jboss
#chkconfig --add jboss
#chkconfig --level 345 jboss on

echo "Instalando jboss a partir dos fontes... Esse processo demora entre 30m e 1h."
wget https://github.com/hasalex/eap-build/archive/master.zip
unzip master.zip
cd eap-build-master
./build-eap6.sh

EAP="$(find dist/ -name 'jboss-eap-6*.zip' | sort -n | tail -1)"
unzip "${EAP}" -d /opt/
ln -s /opt/jboss-eap-6.4 /opt/jboss6
cd ..

#echo "Instalando jdbc ..."
#mkdir -p /opt/jboss6/modules/com/microsoft/sqlserver/main/
#wget https://download.microsoft.com/download/6/9/9/699205CA-F1F1-4DE9-9335-18546C5C8CBD/sqljdbc_7.4.1.0_enu.tar.gz
#tar xf sqljdbc_7.4.1.0_enu.tar.gz sqljdbc_7.4/enu/mssql-jdbc-7.4.1.jre8.jar -C /opt/jboss6/modules/com/microsoft/sqlserver/main/ --strip-components 2
#cp mssql-jdbc-7.4.1.jre8.jar /opt/jboss6/modules/com/microsoft/sqlserver/main/
#cp sqlserver-module.xml /opt/jboss6/modules/com/microsoft/sqlserver/main/module.xml

#echo "Aplicando configuracoes ..."
#cp standalone.xml /opt/jboss6/standalone/configuration/standalone.xml
#cp standalone.conf /opt/jboss6/bin/standalone.conf
#chown -RH jboss:jboss /opt/jboss6

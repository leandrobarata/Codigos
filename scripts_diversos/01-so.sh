#!/bin/bash
# Configuracoes basicas para o RHEL/CentOS 7.x
# Deve ser aplicado em todos os servidores (apache/jboss/banco)
#
# 
#

echo "Instalando pacotes que estam fora da instalacao minima ..."
yum -y install acpid mc vim-enhanced nano iptraf tcpdump links screen ntp nmap ftp psacct wget unzip mailx lsof openssh-clients cronie chrony sysstat dos2unix zip pciutils bind-utils yum-utils bc iotop tuned xauth xhost xterm dejavu-lgc-sans-fonts dejavu-lgc-sans-mono-fonts rsync net-tools bzip2 setroubleshoot firewalld

#Opcional - ajustar timezone
#echo "Ajustando timezone"
#timedatectl set-timezone America/Cuiaba

#Opcional - desativar SELinux
#echo "Desativando SELinux. Ative depois da instalacao."
#sed -i 's/SELINUX\=\(.*\)/SELINUX=disabled/g' /etc/sysconfig/selinux
#sed -i 's/SELINUX\=\(.*\)/SELINUX=disabled/g' /etc/selinux/config
#setenforce 0

echo "Ajustes de firewall ..."
firewall-cmd --permanent --zone=public --add-service=ssh
#firewall-cmd --permanent --zone=public --add-service=http
#firewall-cmd --permanent --zone=public --add-service=https
#firewall-cmd --permanent --zone=public --add-service=postgresql
#firewall-cmd --permanent --zone=public --add-port=8009/tcp
firewall-cmd --reload

echo "Desativando ipv6 ..."
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf

echo "Ativando servicos adicionais ..."
for nome in psacct sshd chronyd acpid ; do systemctl enable $nome ; done

echo "Ajustes de parametros de kernel ..."
echo '
# Ajustes
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
net.core.rmem_default = 262144
net.core.wmem_default = 262144
net.core.rmem_max = 8388608
net.core.wmem_max = 8388608
net.core.netdev_max_backlog = 10000
net.ipv4.tcp_rmem = 8192 87380 8388608
net.ipv4.tcp_wmem = 8192 65536 8388608
net.ipv4.udp_rmem_min = 16384
net.ipv4.udp_wmem_min = 16384
net.ipv4.tcp_mem = 8388608 12582912 16777216
net.ipv4.udp_mem = 8388608 12582912 16777216
vm.overcommit_memory=2
vm.swappiness = 20
vm.dirty_ratio = 50
fs.file-max = 100000
fs.inotify.max_user_instances = 2048
' >> /etc/sysctl.conf
sed -i 's/^net.bridge/#net.bridge/g' /etc/sysctl.conf

echo '
# Numero de arquivos abertos por usuario (qualquer)
* soft nofile 16384
* hard nofile 32768

# No servidor PostgreSQL
postgres         soft    nofile          65536
postgres         hard    nofile         131072

# No servidor Jboss ou Apache, aumentar o numero de processos por usuario
jboss soft nproc 4096
jboss hard nproc 8192
apache soft nproc 4096
apache hard nproc 8192
' >> /etc/security/limits.conf

RAM=$(grep ^MemTotal /proc/meminfo | awk '{print $2}')
SWP=$(grep ^SwapTotal /proc/meminfo | awk '{print $2}')
RATIO=$(echo $(bc <<< "scale=5; (((${RAM} - ${SWP}) / ${RAM} * 100) + 1.5)") | cut -d '.' -f 1)
echo "vm.overcommit_ratio = ${RATIO}" > /etc/sysctl.d/98-infox_sysctl.conf
echo "vm.overcommit_memory = 0" >> /etc/sysctl.d/98-infox_sysctl.conf

sysctl --system

echo "Aplicando atualizacoes disponiveis ..."
yum -y upgrade

#echo "Adicionando hosts no /etc/hosts para nao depender de dns reverso ..."
#echo '192.168.0.202 banco
#192.168.0.200 jboss
#' >> /etc/hosts

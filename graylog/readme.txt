





#### Criar serviço glassfish###

vi /etc/init.d/glassfish


#!bin/bash
 
# description: glassfish start stop restart
# processname: glassfish
# chkconfig: 2345 20 80
 
GLASSFISH_HOME=/u01/app/glassfish3
GLASSFISH_USER=oracle
RETVAL=0
 
case "$1" in
start)
su - $GLASSFISH_USER -c "$GLASSFISH_HOME/bin/asadmin start-domain domain1"
su - $GLASSFISH_USER -c "$GLASSFISH_HOME/bin/asadmin start-local-instance instance1"
;;
stop)
su - $GLASSFISH_USER -c "$GLASSFISH_HOME/bin/asadmin stop-local-instance instance1"
su - $GLASSFISH_USER -c "$GLASSFISH_HOME/bin/asadmin stop-domain domain1"
;;
restart)
su - $GLASSFISH_USER -c "$GLASSFISH_HOME/bin/asadmin restart-local-instance instance1"
su - $GLASSFISH_USER -c "$GLASSFISH_HOME/bin/asadmin restart-domain domain1"
;;
*)
echo $"Usage: $0 {start|stop|restart}"
RETVAL=1
esac
exit $RETVAL



## DEFINIR PERMISSOES ####

 chmod 755 /etc/init.d/glassfish
sh /etc/init.d/glassfish start
 chkconfig –add glassfish

## VALIDAR SERVIÇO ##

chkconfig|grep glassfish

glassfish 0:off 1:off 2:on 3:on 4:on 5:on 6:off





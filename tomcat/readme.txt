## INSTALAR JAVA ##

# CRIAR USUARIO E GRUPO ##

sudo groupadd --system tomcat
sudo useradd -d /usr/share/tomcat -r -s /bin/false -g tomcat tomcat



## BAIXAR O TOMCAT##

sudo tar xvf apache-tomcat-${VER}.tar.gz -C /usr/share/


sudo chown -R tomcat:tomcat /usr/share/tomcat
sudo chown -R tomcat:tomcat /usr/share/apache-tomcat-$VER/




## CRIAR SERVIÇO ##

sudo vim /etc/systemd/system/tomcat.service



[Unit]
Description=Tomcat Server
After=syslog.target network.target

[Service]
Type=forking
User=tomcat
Group=tomcat

Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment='JAVA_OPTS=-Djava.awt.headless=true'
Environment=CATALINA_HOME=/usr/share/tomcat
Environment=CATALINA_BASE=/usr/share/tomcat
Environment=CATALINA_PID=/usr/share/tomcat/temp/tomcat.pid
Environment='CATALINA_OPTS=-Xms512M -Xmx1024M'
ExecStart=/usr/share/tomcat/bin/catalina.sh start
ExecStop=/usr/share/tomcat/bin/catalina.sh stop

[Install]
WantedBy=multi-user.target




#### HABILITAR , RESTART SERVIÇO ###

sudo systemctl daemon-reload
sudo systemctl start tomcat
sudo systemctl enable tomcat



## LIBERAR FIREWALL ###

sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --reload



## ALTERAR SENHA ###

sudo vi /usr/share/tomcat/conf/tomcat-users.xml

<role rolename="admin-gui"/>
<role rolename="manager-gui"/>
<user username="admin" password="admin" fullName="Administrator" roles="admin-gui,manager-gui"/>





## INSTALAR PROXY REVERSO


yum -y install httpd 


/etc/httpd/conf.d/tomcat_manager.conf


<VirtualHost *:80>
    ServerAdmin root@localhost
    ServerName tomcat.example.com
    DefaultType text/html
    ProxyRequests off
    ProxyPreserveHost On
    ProxyPass / http://localhost:8080/
    ProxyPassReverse / http://localhost:8080/
</VirtualHost>



## CONFIGURAR SELINUX APACHE ACESSAR TOMCAT


sudo setsebool -P httpd_can_network_connect 1
sudo setsebool -P httpd_can_network_relay 1
sudo setsebool -P httpd_graceful_shutdown 1
sudo setsebool -P nis_enabled 1



## RESTART SERVIÇO##

sudo systemctl restart httpd && sudo systemctl enable httpd




#Permir faixa de IP a conectar no manager http://IP:8080/manager/html/#


nano /usr/share/apache-tomcat-9.0.59/webapps/manager/META-INF/context.xml


 <Valve className="org.apache.catalina.valves.RemoteAddrValve"
         allow="IP.*" />



#Trabalhar tomcat com dominio#

<Host name="dominio.com.br" appBase="webapps/aplicacao" autoDeploy="true">
<Alias>dominio.com.br</Alias>
<Context path="" docBase="${catalina.base}/webapps/aplicacao"/>
</Host>


## Remover informações de versão#

Dentro do <Host name=

<Valve className="org.apache.catalina.valves.ErrorReportValve" showReport="false" showServerInfo="false" />





## personalizar tela de erro #


Editar nano /usr/share/apache-tomcat-9.0.59/conf/web.xml  e inserir entre </web-app>

<error-page>
<error-code>404</error-code>
<location>/error.jsp</location>
</error-page>
<error-page>
<error-code>403</error-code>
<location>/error.jsp</location>
</error-page>
<error-page>
<error-code>500</error-code>
<location>/error.jsp</location>
</error-page>


#!/bin/bash
# Configuracoes do Apache 2.4 para o RHEL/CentOS 7.x
# Deve ser aplicado somente no servidor apache
#
# 
#
echo "Ajustes de firewall ..."
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --permanent --zone=public --add-service=https
firewall-cmd --reload

echo "Instaladon pacote do apache ..."
yum -y install httpd
systemctl enable httpd
systemctl stop httpd

echo "Configurando apache ..."
sed -i 's/^LoadModule/#LoadModule/g' /etc/httpd/conf.modules.d/00-mpm.conf
sed -i 's/^#LoadModule mpm_worker/LoadModule mpm_worker/g' /etc/httpd/conf.modules.d/00-mpm.conf
# Alterar o ServerAdmin
sed -i 's/root@localhost/admin@.com.br/g' /etc/httpd/conf/httpd.conf
# Alterar o ServerName USAR FQDN CORRETO
#read -p "Qual o FQDN do Servidor?" fqdn
fqdn=".com.br"
sed -i "/#ServerName/ a ServerName $fqdn:80" /etc/httpd/conf/httpd.conf
# Reduzir detalhamento de versão em páginas de erro
sed -i '/^ServerName/ a ServerTokens Prod' /etc/httpd/conf/httpd.conf
# Retirar a diretiva Indexes do Options
sed -i '/Options Indexes FollowSymLinks/ c #Options Indexes FollowSymLinks' /etc/httpd/conf/httpd.conf
sed -i '/#Options Indexes FollowSymLinks/ a Options FollowSymLinks' /etc/httpd/conf/httpd.conf
# Desativar o ServerSignature
sed -i '/^ServerTokens/ a ServerSignature off' /etc/httpd/conf/httpd.conf
# Comentar todas as linhas do autoindex.conf
sed -i 's/^/#/g' /etc/httpd/conf.d/autoindex.conf
# Comentar todos os modulos
sed -i 's/^LoadModule/#LoadModule/g' /etc/httpd/conf.modules.d/00-base.conf
# Descomentar modulos necessarios
for module in access_compat_module alias_module authz_core_module authz_host_module dir_module filter_module log_config_module mime_module negotiation_module setenvif_module slotmem_shm_module unixd_module socache_shmcb_module status_module deflate_module reqtimeout_module ;do sed -i "/\ $module\ / s/#//g"  /etc/httpd/conf.modules.d/00-base.conf; done
# Comentar todo o arquivo welcome.conf
sed -i 's/^/#/g' /etc/httpd/conf.d/welcome.conf

sed -i '/delaycompress/ a\\tcompress' /etc/logrotate.d/httpd

cat <<'EOF' > /var/www/html/index.html
<html>
  <head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
 </head>
  <body onload="javascript: this.location='/epp/'">
Ser&aacute; redirecionado para a aplica&ccedil;&atilde;o em segundos. Se n&atilde;o ocorrer de forma autom&aacute;tica, <a href="/epp/">clique aqui</a>
</body>
</html>
EOF
restorecon /var/www/html/index.html

echo '# Descomentar a linha do "LoadModule deflate_module" no /etc/httpd/conf/httpd.conf
# Se quiser aplicar compressão somente para um projeto, usar o Location
# Se quiser aplicar para todo o trafego do apache, usar somente a linha do AddOutputFilterByType
#<Location /epp>
 AddOutputFilterByType DEFLATE text/html text/plain text/css text/javascript text/xml
#</Location>' > /etc/httpd/conf.d/mod_deflate.conf

chcon --reference=/etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/mod_deflate.conf

echo '#Mantem o hostname de origem quando requisicoes sao repassadas entre servidores apache:
ProxyPreserveHost on

#Define virtualhost para o hostname da maquina para evitar abuso do proxy:
ProxyRequests Off
<VirtualHost *:80>
ServerAdmin admin@.com.br
ServerName 10.10.100.34
</VirtualHost>' > /etc/httpd/conf.d/mod_proxy.conf

chcon --reference=/etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/mod_proxy.conf

echo '
ProxyPass /epp  ajp://127.0.0.1:8009/epp  timeout=1800
ProxyPassReverse /epp ajp://127.0.0.1:8009/epp timeout=1800

ProxyIOBufferSize 65536
' > /etc/httpd/conf.d/proxy_ajp.conf

chcon --reference=/etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/proxy_ajp.conf

echo "Instalando modulo SSL ..."
yum -y install mod_ssl

echo '#### Force HTTPS for all inbound HTTP requests ####
<IfModule !mod_rewrite.c>
  LoadModule rewrite_module modules/mod_rewrite.so
</IfModule>

#<IfModule mod_rewrite.c>
#  RewriteEngine On
#  RewriteCond %{HTTPS} off
#  RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI}
#</IfModule>
' > /etc/httpd/conf.d/mod_rewrite.conf
chcon --reference=/etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/mod_rewrite.conf

#echo "Instalando Letsencrypt ..."
#yum -y install epel-release
#yum -y install certbot python2-certbot-apache
#certbot --apache --agree-tos -n -d epp.codego.com.br 

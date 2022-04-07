Tuning no kernel
# echo "vm.swappiness=10" >> /etc/sysctl.conf
# echo "vm.max_map_count=262144" > /etc/sysctl.d/70-elasticsearch.conf
# cat <<EOF >/etc/sysctl.d/60-net.conf
net.core.netdev_max_backlog=4096
net.core.rmem_default=262144
net.core.rmem_max=67108864
net.ipv4.udp_rmem_min=131072
net.ipv4.udp_mem=2097152 4194304 8388608
EOF

# sysctl -w vm.max_map_count=262144 && \
sysctl -w net.core.netdev_max_backlog=4096 && \
sysctl -w net.core.rmem_default=262144 && \
sysctl -w net.core.rmem_max=67108864 && \
sysctl -w net.ipv4.udp_rmem_min=131072 && \
sysctl -w net.ipv4.udp_mem='2097152 4194304 8388608'


	
# echo "vm.swappiness=10" >> /etc/sysctl.conf
# echo "vm.max_map_count=262144" > /etc/sysctl.d/70-elasticsearch.conf
# cat <<EOF >/etc/sysctl.d/60-net.conf
net.core.netdev_max_backlog=4096
net.core.rmem_default=262144
net.core.rmem_max=67108864
net.ipv4.udp_rmem_min=131072
net.ipv4.udp_mem=2097152 4194304 8388608
EOF
 
# sysctl -w vm.max_map_count=262144 && \
sysctl -w net.core.netdev_max_backlog=4096 && \
sysctl -w net.core.rmem_default=262144 && \
sysctl -w net.core.rmem_max=67108864 && \
sysctl -w net.ipv4.udp_rmem_min=131072 && \
sysctl -w net.ipv4.udp_mem='2097152 4194304 8388608'





Adicione o arquivo e defina e heap.optionsa cerca de um terço da memória do sistema, mas não exceda . Para este exemplo, usaremos 12 GB dos 32 GB de memória disponíveis para heap da JVM.

# echo -e "-Xms12g\n-Xmx12g" > /etc/elasticsearch/jvm.options.d/heap.options
1
	
# echo -e "-Xms12g\n-Xmx12g" > /etc/elasticsearch/jvm.options.d/heap.options

Os limites do sistema aumentados devem ser especificados em um systemd.

# mkdir /etc/systemd/system/elasticsearch.service.d
# cat <<EOF >/etc/systemd/system/elasticsearch.service.d/elasticsearch.conf
[Service]
LimitNOFILE=131072
LimitNPROC=8192
LimitMEMLOCK=infinity
LimitFSIZE=infinity
LimitAS=infinity
EOF

	
# mkdir /etc/systemd/system/elasticsearch.service.d
# cat <<EOF >/etc/systemd/system/elasticsearch.service.d/elasticsearch.conf
[Service]
LimitNOFILE=131072
LimitNPROC=8192
LimitMEMLOCK=infinity
LimitFSIZE=infinity
LimitAS=infinity
EOF

Após instalação vamos alterar network.host para ouvir apenas localhost, em seguida ativar o serviço e inicia-lo.
# sed -i 's/#cluster.name: my-application/cluster.name: elastiflow/' /etc/elasticsearch/elasticsearch.yml
# sed -i 's/#network.host: 192.168.0.1/network.host: 127.0.0.1/' /etc/elasticsearch/elasticsearch.yml
# echo "discovery.type: 'single-node'" >> /etc/elasticsearch/elasticsearch.yml
# echo "indices.query.bool.max_clause_count: 8192" >> /etc/elasticsearch/elasticsearch.yml
# echo "search.max_buckets: 250000" >> /etc/elasticsearch/elasticsearch.yml

# systemctl daemon-reload
# systemctl enable elasticsearch
# systemctl start elasticsearch
# systemctl status elasticsearch

	
# sed -i 's/#cluster.name: my-application/cluster.name: elastiflow/' /etc/elasticsearch/elasticsearch.yml
# sed -i 's/#network.host: 192.168.0.1/network.host: 127.0.0.1/' /etc/elasticsearch/elasticsearch.yml
# echo "discovery.type: 'single-node'" >> /etc/elasticsearch/elasticsearch.yml
# echo "indices.query.bool.max_clause_count: 8192" >> /etc/elasticsearch/elasticsearch.yml
# echo "search.max_buckets: 250000" >> /etc/elasticsearch/elasticsearch.yml
 
# systemctl daemon-reload
# systemctl enable elasticsearch
# systemctl start elasticsearch
# systemctl status elasticsearch




mais em : https://blog.remontti.com.br/6255

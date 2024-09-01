#!/bin/bash
###container kill by systemd###
container_ids=$(podman ps -qaf "name=bl-mybl-idp")

if [ -n "$container_ids" ]; then
    systemctl --user stop bl-mybl-idp
    echo "Container with id:$container_ids stopped successfully! "

    container_ids=$(podman ps -qaf "name=bl-mybl-idp")
    if [ -n "$container_ids" ]; then
        podman kill $container_ids
    fi
fi

# Stop and remove existing containers
container_ids=$(podman ps -qaf "name=bl-mybl-idp")
if [ -n "$container_ids" ]; then
    podman stop $container_ids
    sleep 10s
    podman rm $container_ids
fi


##start container ###
podman run --name bl-mybl-idp \
--restart unless-stopped \
--network=host \
-p 8443:8443 \
-p 8448:8448 \
-v "/app/mybl/bliam/bl_idp_container/idp_container_logs/":"/var/www/html/storage/logs/" \
-v "/app/mybl/bliam/bl_idp_container/nginx_logs/":"/var/log/nginx/" \
--env-file /app/mybl/bliam/bl_idp_container/app.env \
-d localhost/mybl-idp:v1

# Persistent Configuration IDP Application
echo "Generating systemd configuration for bl-mybl-idp...."
podman generate systemd --new --name bl-mybl-idp > ~/.config/systemd/user/bl-mybl-idp.service
# now remove running container application using "podman rm name"

sleep 5

container_ids=$(podman ps -qf "name=bl-mybl-idp")
if [ -n "$container_ids" ]; then
    podman kill $container_ids
    echo "Container with id:$container_ids stopped successfully! "
fi


echo "starting container with systemd......."

systemctl --user daemon-reload
systemctl --user enable bl-mybl-idp.service
systemctl --user start bl-mybl-idp.service
sleep 10s
systemctl --user status bl-mybl-idp.service

#####promethus monitor#####
nohup /app/mybl/bliam/php-fpm-exporter.linux.amd64 --addr 172.16.191.31:9000  --endpoint http://172.16.191.31:8448/php-fpm-status &

###nginx monitor in promethus####

nohup /app/mybl/bliam/nginx-prometheus-exporter -nginx.scrape-uri=http://172.16.191.31:8448/nginx_status &

####system_level_monitor########
nohup /app/mybl/bliam/node_exporter-1.6.1.linux-amd64/node_exporter &
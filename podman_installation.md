# podman installation

```bash
yum install -y podman

```
# rpm check

```bash
[root@gzvmiam01 ~]# rpm -qa | grep podman
podman-4.6.1-8.el9_3.x86_64
[root@gzvmiam01 ~]#
```

# podman custom configuration

setfacl for /app if non-root user does not have rwx permission. You need to have root privilege for setfacl
```bash
[root@gzvmiam01 ~]# setfacl -Rm u:appadmin:rwx /app
[root@gzvmiam01 ~]# getfacl /app
getfacl: Removing leading '/' from absolute path names
# file: app
# owner: root
# group: root
user::rwx
user:monitor:rwx
user:appadmin:rwx
group::r-x
group:monitor:rwx
mask::rwx
other::r-x
[root@gzvmiam01 ~]#
```
setfacl for non root user home directory rwx permission
```bash
[appadmin@gzvmiam01 ~]$ getfacl /home/appadmin
getfacl: Removing leading '/' from absolute path names
# file: home/appadmin
# owner: appadmin
# group: appadmin
user::rwx
group::---
other::---

[appadmin@gzvmiam01 ~]$ setfacl -Rm u:appadmin:rwx /home/appadmin
[appadmin@gzvmiam01 ~]$ getfacl /home/appadmin
getfacl: Removing leading '/' from absolute path names
# file: home/appadmin
# owner: appadmin
# group: appadmin
user::rwx
user:appadmin:rwx
group::---
mask::rwx
other::---

[appadmin@gzvmiam01 ~]$
```

# check SELINUX if enabled disbled it using root user and reboot the system

```bash
[root@gzvmiam01 ~]# sestatus
[root@gzvmiam01 ~]# vi /etc/selinux/config
SELINUX=disabled
[root@gzvmiam01 ~]# reboot
[root@gzvmiam01 ~]# sestatus

```
# create storage directory at /app/mybl/containers/storage at non-root user level
```bash
[appadmin@gzvmiam01 /]$
[appadmin@gzvmiam01 /]$ mkdir -p /app/mybl/containers/storage
```
# D-Bus connection error while starting podman
```bash
[usrdev@gzvmyblastcms01 containers]$ systemctl --user start podman
Failed to get D-Bus connection: No such file or directory

export XDG_RUNTIME_DIR="/run/user/$UID"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
export XDG_RUNTIME_DIR=/run/user/$(id -u)
loginctl enable-linger usrdev
loginctl show-user usrdev | grep ^Linger
systemctl --user start podman.socket
systemctl --user enable podman.socket
chmod 777 /run/user/<user-id>/podman/podman.sock
systemctl --user start podman.service
systemctl --user enable podman.service

loginctl enable-linger bs23
export XDG_RUNTIME_DIR=/run/user/$(id -u)
```

# start podman service in non-root user level
```bash

[appadmin@gzvmiam01 ~]$ systemctl --user start podman
[appadmin@gzvmiam01 ~]$ systemctl --user status podman
○ podman.service - Podman API Service
     Loaded: loaded (/usr/lib/systemd/user/podman.service; disabled; preset: disabled)
     Active: inactive (dead) since Tue 2024-05-21 16:07:36 +06; 8s ago
   Duration: 5.230s
TriggeredBy: ● podman.socket
       Docs: man:podman-system-service(1)
    Process: 31268 ExecStart=/usr/bin/podman $LOGGING system service (code=exited, status=0/SUCCESS)
   Main PID: 31268 (code=exited, status=0/SUCCESS)
        CPU: 241ms

May 21 16:07:31 gzvmiam01.banglalink.net systemd[18293]: Starting Podman API Service...
May 21 16:07:31 gzvmiam01.banglalink.net systemd[18293]: Started Podman API Service.
May 21 16:07:31 gzvmiam01.banglalink.net podman[31268]: time="2024-05-21T16:07:31+06:00" level=info msg="/usr/bin/podman filtering at log level info"
May 21 16:07:31 gzvmiam01.banglalink.net podman[31286]: time="2024-05-21T16:07:31+06:00" level=info msg="/usr/bin/podman filtering at log level info"
May 21 16:07:31 gzvmiam01.banglalink.net podman[31286]: 2024-05-21 16:07:31.708496362 +0600 +06 m=+0.101149551 system refresh
May 21 16:07:31 gzvmiam01.banglalink.net podman[31286]: time="2024-05-21T16:07:31+06:00" level=info msg="Setting parallel job count to 37"
May 21 16:07:31 gzvmiam01.banglalink.net podman[31286]: time="2024-05-21T16:07:31+06:00" level=info msg="Using systemd socket activation to determine API endpoint"
May 21 16:07:31 gzvmiam01.banglalink.net podman[31286]: time="2024-05-21T16:07:31+06:00" level=info msg="API service listening on \"/run/user/1004/podman/podman.sock\". URI: \"/run/user/1004/podman/podman.>
[appadmin@gzvmiam01 ~]$

```
# enable podman service for non-root user level
```bash
[appadmin@gzvmiam01 ~]$ systemctl --user status podman
○ podman.service - Podman API Service
     Loaded: loaded (/usr/lib/systemd/user/podman.service; enabled; preset: disabled)
     Active: inactive (dead) since Tue 2024-05-21 16:07:36 +06; 1min 44s ago
   Duration: 5.230s
TriggeredBy: ● podman.socket
       Docs: man:podman-system-service(1)
   Main PID: 31268 (code=exited, status=0/SUCCESS)
        CPU: 241ms

May 21 16:07:31 gzvmiam01.banglalink.net systemd[18293]: Starting Podman API Service...
May 21 16:07:31 gzvmiam01.banglalink.net systemd[18293]: Started Podman API Service.
May 21 16:07:31 gzvmiam01.banglalink.net podman[31268]: time="2024-05-21T16:07:31+06:00" level=info msg="/usr/bin/podman filtering at log level info"
May 21 16:07:31 gzvmiam01.banglalink.net podman[31286]: time="2024-05-21T16:07:31+06:00" level=info msg="/usr/bin/podman filtering at log level info"
May 21 16:07:31 gzvmiam01.banglalink.net podman[31286]: 2024-05-21 16:07:31.708496362 +0600 +06 m=+0.101149551 system refresh
May 21 16:07:31 gzvmiam01.banglalink.net podman[31286]: time="2024-05-21T16:07:31+06:00" level=info msg="Setting parallel job count to 37"
May 21 16:07:31 gzvmiam01.banglalink.net podman[31286]: time="2024-05-21T16:07:31+06:00" level=info msg="Using systemd socket activation to determine API endpoint"
May 21 16:07:31 gzvmiam01.banglalink.net podman[31286]: time="2024-05-21T16:07:31+06:00" level=info msg="API serv
```

# enable podman socket for non-root user level
```bash
[appadmin@gzvmiam01 ~]$ systemctl --user status podman.socket
● podman.socket - Podman API Socket
     Loaded: loaded (/usr/lib/systemd/user/podman.socket; disabled; preset: disabled)
     Active: active (listening) since Tue 2024-05-21 16:07:31 +06; 3min 57s ago
      Until: Tue 2024-05-21 16:07:31 +06; 3min 57s ago
   Triggers: ● podman.service
       Docs: man:podman-system-service(1)
     Listen: /run/user/1004/podman/podman.sock (Stream)
     CGroup: /user.slice/user-1004.slice/user@1004.service/app.slice/podman.socket

May 21 16:07:31 gzvmiam01.banglalink.net systemd[18293]: Listening on Podman API Socket.
[appadmin@gzvmiam01 ~]$
[appadmin@gzvmiam01 ~]$
[appadmin@gzvmiam01 ~]$ systemctl --user enable podman.socket
Created symlink /home/appadmin/.config/systemd/user/sockets.target.wants/podman.socket → /usr/lib/systemd/user/podman.socket.
[appadmin@gzvmiam01 ~]$
[appadmin@gzvmiam01 ~]$
[appadmin@gzvmiam01 ~]$
[appadmin@gzvmiam01 ~]$ systemctl --user status podman.socket
● podman.socket - Podman API Socket
     Loaded: loaded (/usr/lib/systemd/user/podman.socket; enabled; preset: disabled)
     Active: active (listening) since Tue 2024-05-21 16:07:31 +06; 4min 33s ago
      Until: Tue 2024-05-21 16:07:31 +06; 4min 33s ago
   Triggers: ● podman.service
       Docs: man:podman-system-service(1)
     Listen: /run/user/1004/podman/podman.sock (Stream)
     CGroup: /user.slice/user-1004.slice/user@1004.service/app.slice/podman.socket

May 21 16:07:31 gzvmiam01.banglalink.net systemd[18293]: Listening on Podman API Socket.
```

# Change podman storage location for non-root user
after start podman at non root user level you should see a .config file at user home directory.

```bash
[appadmin@gzvmiam01 ~]$ pwd
/home/appadmin
[appadmin@gzvmiam01 ~]$
[appadmin@gzvmiam01 ~]$ ls -la
total 24
drwx------. 5 appadmin appadmin  156 May 21 16:12 .
drwxr-xr-x. 7 root     root       82 May 14 22:56 ..
-rw-------. 1 appadmin appadmin  769 May 21 15:37 .bash_history
-rw-r--r--. 1 appadmin appadmin   18 Nov 24  2022 .bash_logout
-rw-r--r--. 1 appadmin appadmin  141 Nov 24  2022 .bash_profile
-rw-r--r--. 1 appadmin appadmin  492 Nov 24  2022 .bashrc
drwx------. 4 appadmin appadmin   32 May 21 16:09 .config
-rw-------. 1 appadmin appadmin   20 May 21 16:12 .lesshst
drwx------. 3 appadmin appadmin   19 May 21 16:07 .local
drwx------. 2 appadmin appadmin   29 May 21 14:48 .ssh
-rw-------. 1 appadmin appadmin 2544 May 21 16:04 .viminfo
[appadmin@gzvmiam01 ~]$
[appadmin@gzvmiam01 ~]$
```

Create a custom storage.conf file at '~/.config/containers/storage.conf'
```bash
[appadmin@gzvmiam01 ~]$ id
uid=1004(appadmin) gid=1004(appadmin) groups=1004(appadmin) context=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023

[appadmin@gzvmiam01 containers]$ cat storage.conf
[storage]
driver = "overlay"
runroot = "/run/user/1004"
graphroot = "/app/mybl/containers/storage"
[appadmin@gzvmiam01 containers]$

```
# Allow loginctl for appadmin
Allow "appadmin" account to start a service at system start that persists over logouts. Use the `loginctl` command to configure the systemd user service to persist after the last user session of the configured service closes.
```bash
loginctl show-user appadmin | grep ^Linger
loginctl enable-linger appadmin
loginctl show-user appadmin | grep ^Linger
```
# podman blidp container run

```bash
podman run --name bl-mybl-idp \
--restart unless-stopped \
--network=host \
-p 8443:8443 \
-p 8448:8448 \
-v "/app/mybl/bliam/bl_idp_container/idp_container_logs/":"/var/www/html/storage/logs/" \
-v "/app/mybl/bliam/bl_idp_container/nginx_logs/":"/var/log/nginx/" \
--env-file /app/mybl/bliam/bl_idp_container/app.env \
-d localhost/mybl-idp:v1
```
# change ownership and permission inside container for logs folder
```bash
podman exec -it fdc58500a1a4 /bin/bash
cd storage/
chown -R www-data:www-data logs
chmod -R 775 logs
```
# check nginx and php status
```bash
curl -v http://172.16.191.32:8448/php-fpm-status
curl -v http://172.16.191.32:8448/nginx_status

```

# check port status

```bash
ss -tulnp 
netstat -tulnp
```
```bash
rasel$Nopass@204!
```
# Image repository
```bash
docker pull mybl-registry.banglalink.net/exporter/prometheus-podman-exporter:latest
docker pull mybl-registry.banglalink.net/exporter/cadvisor:latest
```
# Run Prometheus-podman-exporter for rootless
```bash
podman run -d -e CONTAINER_HOST=unix:///usr/bin/podman/podman.sock -v $XDG_RUNTIME_DIR/podman/podman.sock:/usr/bin/podman/podman.sock -p 9882:9882 --userns=keep-id --security-opt label=disable quay.io/navidys/prometheus-podman-exporter:latest
```
# Run Prometheus-podman-exporter for root
```bash
podman run -e CONTAINER_HOST=unix:///run/podman/podman.sock -v /run/podman/podman.sock:/run/podman/podman.sock -u root -p 9882:9882 --security-opt label=disable quay.io/navidys/prometheus-podman-exporter:latest
```
1. Installation
# yum install -y podman


2. Update the ca cert 
#cp -r /app/myblapi/opt/intermediate.crt /etc/pki/ca-trust/source/anchors/
#update-ca-trust

3. update insecure registry
# For adding registries in podman
sudo vi /etc/containers/registries.conf

[[registry]]
location = "mybl-registry.banglalink.net"
insecure = true


[usrdev@gzvlmyblastcms02 storage]$ cat /etc/containers/registries.conf | grep -v ^# | grep .
unqualified-search-registries = ["mybl-registry.banglalink.net", "registry.access.redhat.com", "registry.redhat.io", "docker.io"]
[[registry]]
location = "mybl-registry.banglalink.net"
insecure = true
short-name-mode = "enforcing"


4. Update storage location
###############################################################################
For user(usrdev) specific podman storage configuration
========================================================
[usrdev@gzvlmyblastcms02 storage]$ cat ~/.config/containers/storage.conf
[storage]
driver = "overlay"
runroot = "/run/user/1002"
graphroot = "/app/mybl/containers/storage"

For root user podman storage configuration
======================================================

[root@gzvlmyblastcms02 ~]# cat /etc/containers/storage.conf | grep -v ^# | grep .
[storage]
driver = "overlay"
runroot = "/run/containers/storage"
graphroot = "/app/mybl/containers/storage"
[storage.options]
additionalimagestores = [
]
pull_options = {enable_partial_images = "false", use_hard_links = "false", ostree_repos=""}
[storage.options.overlay]
mountopt = "nodev,metacopy=on"
[storage.options.thinpool]

5. Update Selinux permission for storage location
========================================================================================================================
If selinux enabled below error will be thrown while running containers. Need to provide permission for storge location

[usrdev@gzvlmyblastcms02 storage]$ podman run -it --rm --name cms-fe -p 8443:8443 mybl-registry.banglalink.net/bl-cms-fe/blcmsfe:latest
Error relocating /lib/ld-musl-x86_64.so.1: RELRO protection failed: No error information
Error relocating /usr/local/bin/docker-entrypoint.sh: RELRO protection failed: No error information


# semanage fcontext -a -e /var/lib/containers/storage /app/mybl/containers/storage
# restorecon -R -v /app/mybl/containers/storage

==========================================================================================================================
After giving storage permission output will be like this

[root@gzvlmyblastcms02 storage]# ls -laZ
total 16
drwxr-xr-x.  8 usrdev usrdev unconfined_u:object_r:container_var_lib_t:s0  189 Dec 13 18:07 .
drwxr-xr-x.  3 usrdev usrdev unconfined_u:object_r:unlabeled_t:s0           21 Dec 13 18:07 ..
-rw-r--r--.  1 usrdev usrdev unconfined_u:object_r:container_var_lib_t:s0    8 Dec 13 18:07 defaultNetworkBackend
drwx------.  2 usrdev usrdev unconfined_u:object_r:container_var_lib_t:s0   27 Dec 13 18:07 libpod
drwx------.  2 usrdev usrdev unconfined_u:object_r:container_var_lib_t:s0   27 Dec 13 18:07 networks
drwx------. 26 usrdev usrdev unconfined_u:object_r:container_ro_file_t:s0 4096 Dec 13 18:29 overlay
drwx------.  2 usrdev usrdev unconfined_u:object_r:container_var_lib_t:s0   61 Dec 13 18:29 overlay-containers
drwx------.  4 usrdev usrdev unconfined_u:object_r:container_ro_file_t:s0  188 Dec 13 18:17 overlay-images
drwx------.  2 usrdev usrdev unconfined_u:object_r:container_ro_file_t:s0 4096 Dec 13 18:29 overlay-layers
-rw-r--r--.  1 usrdev usrdev unconfined_u:object_r:container_var_lib_t:s0   64 Dec 13 18:29 storage.lock
-rw-r--r--.  1 usrdev usrdev unconfined_u:object_r:container_var_lib_t:s0    0 Dec 13 18:07 userns.lock
[root@gzvlmyblastcms02 storage]#


# chcon -R -t container_file_t .env
# restorecon -R -v .env


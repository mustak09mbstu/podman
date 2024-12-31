# No Space left of device
Error
```bash
Error: writing blob: adding layer with blob "sha256:38a8310d387e375e0ec6fabe047a9149e8eb214073db9f461fee6251fd936a75"/""/"sha256:3e01818d79cd3467f1d60e54224f3f6ce5170eceb54e265d96bb82344b8c24e7": open /run/user/1003/overlay-layers/.tmp-mountpoints.json37228660: no space left on device
```
# check usage of /run/user/$id
```bash
[appusr@GZCNONBLMS02 ~]$ df -i
Filesystem                           Inodes  IUsed     IFree IUse% Mounted on
devtmpfs                            1483347    504   1482843    1% /dev
tmpfs                               1488728      4   1488724    1% /dev/shm
tmpfs                                819200    873    818327    1% /run
/dev/mapper/root_vg-root           10485760   1866  10483894    1% /
/dev/mapper/root_vg-usr             5242880  54736   5188144    2% /usr
/dev/mapper/vg_data-lv_data       104855552 292004 104563548    1% /app
/dev/vda1                            524288    375    523913    1% /boot
/dev/mapper/root_vg-tmp             2621440     19   2621421    1% /tmp
/dev/mapper/root_vg-home            5242880    128   5242752    1% /home
/dev/mapper/root_vg-opt             2621440   3279   2618161    1% /opt
/dev/mapper/root_vg-var             4980736   2194   4978542    1% /var
/dev/mapper/root_vg-var_log         5242880    153   5242727    1% /var/log
/dev/mapper/root_vg-var_log_audit   2621440      4   2621436    1% /var/log/audit
tmpfs                                297745   1460    296285    1% /run/user/1003
tmpfs                                297745     15    297730    1% /run/user/1002
[appusr@GZCNONBLMS02 ~]$ 
```
# check usage of /run
```bash
[appusr@GZCNONBLMS02 ~]$ df -h /run/
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           2.3G  824K  2.3G   1% /run
```
# Clear /tmp
```bash
rm -rf /run/user/1003/libpod/tmp/*
```
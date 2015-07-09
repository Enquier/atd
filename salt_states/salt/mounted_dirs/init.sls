install_nfstools:
  pkg.installed:
    - names:
      - nfs-utils
      - nfs-utils-lib

enable_nfslock:
  pkg: 
   - installed
   - name: nfs-utils
  service:
   - name: nfslock
   - running
   - enable: True
   - reload: True

enable_netfs:
  pkg: 
   - installed
   - name: nfs-utils
  service:
   - name: netfs
   - running
   - enable: True
   - reload: True

enable_rpcbind:
  pkg: 
   - installed
   - name: rpcbind
  service:
   - name: rpcbind
   - running
   - enable: True
   - reload: True


enable_rpcidservice:
  pkg:
   - installed
   - name: rpcbind
  service:
   - name: rpcidmapd
   - running
   - enable: True
   - reload: True

/etc/idmapd.conf:
  file.managed:
    - source: salt://mounted_dirs/files/idmapd.conf.default
    - user: root  
    - group: root


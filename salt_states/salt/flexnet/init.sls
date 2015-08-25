flexlm:
  group:
    - present
    - gid: 505
  user:
    - present
    - uid: 505
    - groups: 
      - flexlm
      - wheel
    - require:
      - group: flexlm
    - shell: /sbin/nologin
    - createhome: False
  

{#
lmadmin_copy:
  file.managed:
    - name: /opt/src/lmadmin-i86_lsb-11_12_1_1.bin
    - source: salt://flexnet/files/lmadmin-i86_lsb-11_12_1_1.bin
    - mode: 755
    - user: root
    - group: root
    
lmadmin_sym:
  file.symlink:
    - name: /opt/local/lmgrd
    - target: /opt/local/lmgrd-x64_lsb-11.12.1.0_v6
    - user: flexlm
    - group: flexlm
    - recurse:
      - user
      - group
    
 #}
    


lmgrd_unpack:
  archive.extracted:
    - name: /opt/local/
    - source: salt://flexnet/files/lmgrd-x64_lsb-11.12.1.0_v6.tar.gz
    - archive_format: tar
    - tar_options: z
    - if_missing: /opt/local/lmgrd/lmgrd
    
    
lmgrd_sym:
  file.symlink:
    - name: /opt/local/lmgrd
    - target: /opt/local/lmgrd-x64_lsb-11.12.1.0_v6
    - user: flexlm
    - group: flexlm
    - recurse:
      - user
      - group

lmgrd_bin:
  file.symlink:
    - name: /usr/bin/lmgrd
    - target: /opt/local/lmgrd/lmgrd
    - user: root
    - group: root
      
lmgrd_execute:
  file.managed:
    - name: /opt/local/lmgrd/lmgrd
    - mode: 755
    - user: flexlm
    - group: flexlm
 
    
lmutil_unpack:
  archive.extracted:
    - name: /opt/local/
    - source: salt://flexnet/files/lmutil-x64-lsb-11.12.1.0_v6.tar.gz
    - archive_format: tar
    - tar_options: z
    - if_missing: /opt/local/lmutil/lmutil
    
    
lmutil_sym:
  file.symlink:
    - name: /opt/local/lmutil
    - target: /opt/local/lmutil-x64_lsb-11.12.1.0_v6
    - user: flexlm
    - group: flexlm
    - recurse:
      - user
      - group
      
lmutil_bin:
  file.symlink:
    - name: /usr/bin/lmutil
    - target: /opt/local/lmutil/lmutil
    - user: root
    - group: root
      
lmutil_execute:
  file.managed:
    - name: /opt/local/lmutil/lmutil
    - mode: 755
    - user: flexlm
    - group: flexlm
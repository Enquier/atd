flexlm:
  group:
    - present
    - gid: 5000
  user:
    - present
    - uid: 5000
    - groups: 
      - flexlm
      - wheel
    - require:
      - group: flexlm
    - shell: /sbin/nologin
    - createhome: False
 
redhat-lsb-core:
  pkg:
    - installed

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
    - name: /opt/local/lmgrd-x64_lsb-11.12.1.0_v6
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
    - require:
      - archive: lmgrd_unpack

lmgrd_bin:
  file.symlink:
    - name: /usr/bin/lmgrd
    - target: /opt/local/lmgrd/lmgrd
    - user: root
    - group: root
    - require:
      - archive: lmgrd_unpack
      - file: lmgrd_sym
      - file: lmgrd_execute
      
lmgrd_execute:
  file.managed:
    - name: /opt/local/lmgrd/lmgrd
    - mode: 755
    - user: flexlm
    - group: flexlm
    - require:
      - archive: lmgrd_unpack
      - file: lmgrd_sym
 
    
lmutil_unpack:
  archive.extracted:
    - name: /opt/local/lmutil-x64_lsb-11.12.1.0v6
    - source: salt://flexnet/files/lmutil-x64_lsb-11.12.1.0v6.tar.gz
    - archive_format: tar
    - tar_options: z
    - if_missing: /opt/local/lmutil/lmutil
    
    
    
lmutil_sym:
  file.symlink:
    - name: /opt/local/lmutil
    - target: /opt/local/lmutil-x64_lsb-11.12.1.0v6
    - user: flexlm
    - group: flexlm
    - recurse:
      - user
      - group
    - require:
      - archive: lmutil_unpack
      
lmutil_bin:
  file.symlink:
    - name: /usr/bin/lmutil
    - target: /opt/local/lmutil/lmutil
    - user: root
    - group: root
    - require:
      - archive: lmutil_unpack
      - file: lmutil_sym
      - file: lmutil_execute
      
lmutil_execute:
  file.managed:
    - name: /opt/local/lmutil/lmutil
    - mode: 755
    - user: flexlm
    - group: flexlm
    - require:
      - archive: lmutil_unpack
      - file: lmutil_sym
copy_key:
  file.managed:
    - name: /home/centos/.ssh/{{ pillar['git_key'] }}
	- source: salt://git/files/{{ pillar['git_key'] }}
	- mode: 600
	- user: centos
	- group: wheel
	

"ssh-add ~/.ssh/{{ pillar['git_key'] }}"
  cmd.run:
    - cwd: /home/centos
    - user: centos
	- group: wheel
	- require:
	  - file: copy_key
	  
  
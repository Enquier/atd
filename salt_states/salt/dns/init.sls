{#
Salt Formula by Charles Galey cgaley@nomagic.com
Developed for NMInc
#}

include:
  - grains
  
set_grains:
  module.run:
    - name: saltutil.sync_grains
	- require:
	  - sls: grains


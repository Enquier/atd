adt/salt_states/srv/salt/engineer/eclipse
==========

Install eclipse Luna and required plugins. 

init.sls
===

Download and install eclipse luna from the web. 

Decompress to /opt/local/eclipse

Add /usr/bin/eclipse to path. 

freemaker_ide_plugin.sls
===

Uses nodeclipse to install the freemakerIDE plugin for eclipse. 

jadclipse_plugin.sls
===

Uses nodeclipse to install the jadclipse plugin for eclipse. 

jrebel_plugin.sls
===

Uses nodeclipse to install the jrebel plugin for eclipse. 

pydev_plugin.sls
===

Uses nodeclipse to install the pydev plugin for eclipse. 

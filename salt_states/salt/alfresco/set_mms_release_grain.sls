{#
This state sets the MMS_RELEASE_INSTALLED grain to true. Execute this state
after alfresco is installed.

The top.sls file checks for this grain. If it is set to False, then alfresco
will be installed.

#}
include:
  - alfresco.amps_deploy
  - tomcat

MMS_INSTALLED:
  grains.present:
    - value: True
    - require:
      - sls: alfresco.amps_deploy
      - sls: tomcat

MMS_RELEASE_INSTALLED:
  grains.present:
    - value: {{ grains['MMS_RELEASE_VERSION'] }}
    - require:
      - sls: alfresco.amps_deploy
      - sls: tomcat
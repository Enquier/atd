{#
This state sets the MMS_RELEASE_INSTALLED grain to true. Execute this state
after alfresco is installed.

The top.sls file checks for this grain. If it is set to False, then alfresco
will be installed.

#}

MMS_RELEASE_INSTALLED:
  grains.present:
    - value: True

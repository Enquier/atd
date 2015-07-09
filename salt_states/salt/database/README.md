adt/salt_states/srv/salt/database
==========

Installs and configures the postgresql database either as a stand alone host or as a "all in one" host. 

init.sls
===

Sets up the repository gpg key for installing postgresql 9x.

postgresqlREPO.sls
===

Installs the postgresql 9.3 repository to download postgresql 9x packages. 

installPostgresql.sls
===

Installs postgresql93 server and libs. 

Runs the initdb command if it has not yet been ran

Sets the postgresql server to start at boot and starts the service. 

Sets the "pg_hba.conf" and "postgresql.conf" files as "watch" files. 

Installs the default pg_hba.conf and postgresql.conf files. 

postgresqlAlfDBcreate.sls
===

Updates the salt-minion with information to connect to the database server locally. 

Creates a database called "alfresco". 

Assigns a user to the "alfresco" database and sets the password "alfresco". 

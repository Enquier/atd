{#
Salt Formula by Ian Weaklim weaklim@jpl.nasa.gov ianw@uwyo.edu
Developed for JPL/NASA Summer 2014
#}
include: 
  - database

configure_minion_postgresql:
  file.append:
    - name: /etc/salt/minion
    - text:
      - "postgres.host: 'localhost'"
      - "postgres.port: '5432'"
      - "postgres.user: 'postgres'"
      - "postgres.pass: ''"
      - "postgres.maintenance_db: 'postgres'"
{#
create_alfresco_db:
  module.run:
    - name: postgres.db_create
    - m_name: alfresco
    - template: template1
#}

create_alfresco_db:
  postgres_database.present:
    - name: alfresco
    - template: template1

create_alfresco_user:
  postgres_user.present:
    - name: alfresco
    - createdb: alfresco
    - user: postgres
    - password: alfresco


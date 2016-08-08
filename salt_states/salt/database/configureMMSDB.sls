
include:
  - database.installPostgresql

create_mms_db:
  postgres_database.present:
    - name: mms
    - template: template1

create_mms_user:
  postgres_user.present:
    - name: mmsuser
    - createdb: mms
    - user: postgres
    - password: mmspassword
    - require:
      - sls: database.installPostgresql



{% if grains['MMS_DB_INSTALLED'] == False %}
copy_sql_template:
  file.managed:
    - name: /usr/tmp/mms.sql
    - source: salt://database/files/mms.sql
    - user: postgres
    - require:
      - sls: database.installPostgresql

configure_mms_database:
  cmd.run:
    - name: "psql -U mmsuser -f /usr/tmp/mms.sql mms"
    - user: postgres
    - require:
      - file: copy_sql_template

remove_sql_template:
  file.absent:
    - name: /usr/tmp/mms.sql
    - user: postgres
    - require:
      - cmd: configure_mms_database

MMS_DB_INSTALLED:
  grain.present:
    - value: True
    - require: 
      - cmd: configure_mms_database
{% endif %}
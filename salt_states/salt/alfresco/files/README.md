HINTS:
=======

To reset the alfresco administrator password:

[-]# python
Python 2.6.6 (r266:84292, Jan 22 2014, 09:42:36) 
[GCC 4.4.7 20120313 (Red Hat 4.4.7-4)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import hashlib
>>> passwd = 'your new password'
>>> passwd.encode('utf-16le')
'y\x00e\x001\x001\x00o\x00w\x00b\x00e\x00l\x00l\x00'
>>> print hashlib.new('md4', passwd.encode('utf-16le')).hexdigest()
527742bbd82baf1aeec828468d288bdf
>>> quit()

Put the above md4 hash in the alfresco-global.properties file

Version Mismatch causing Alfresco not to start up properly
==========================================================
```
psql -p 5432 -U alfresco

alfresco=>  SELECT * FROM alf_qname WHERE alf_qname.local_name IN ( 'currentVersion' );
 id  | version | ns_id |   local_name   
-----+---------+-------+----------------
 223 |       0 |    18 | currentVersion
(1 row)

alfresco=> SELECT node_id, qname_id, locale_id, string_value FROM alf_node_properties WHERE qname_id IN (223) ORDER BY node_id;
 node_id | qname_id | locale_id |  string_value  
---------+----------+-----------+----------------
     713 |      223 |         1 | 480.1410011139
  474500 |      223 |         1 | 2.0.1411200951
  847490 |      223 |         1 | 2.1.1504021424
(3 rows)

alfresco=> SELECT node_id, qname_id, locale_id, string_value FROM alf_node_properties WHERE node_id IN (847490);
 node_id | qname_id | locale_id |  string_value  
---------+----------+-----------+----------------
  847490 |      223 |         1 | 2.2.1504021424
  847490 |      222 |         1 | 2.1.1503251916
  847490 |       29 |         1 | mms-repo-ent
(3 rows)

alfresco=> UPDATE alf_node_properties SET string_value = '2.1.1504021424' WHERE node_id = 847490 AND qname_id IN (223);
UPDATE 1
```

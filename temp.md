```
ls -l etc/catalog/*.properties
-rw-r--r-- 1 naeel naeel 581 Sep 20 08:51 etc/catalog/minio_catalog.properties
-rw-r--r-- 1 naeel naeel 144 Sep 20 13:58 etc/catalog/postgres_metastore_catalog.properties
-rw-r--r-- 1 naeel naeel  44 Sep 11 09:37 etc/catalog/tpcds.properties
-rw-r--r-- 1 naeel naeel  42 Sep 11 09:37 etc/catalog/tpch.properties
```

```
trino> show catalogs;
```
```
          Catalog           
----------------------------
 minio_catalog              
 postgres_metastore_catalog 
 system                     
 tpcds                      
 tpch                       
(5 rows)
```


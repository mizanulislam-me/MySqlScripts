SELECT 
    lower( owner )      AS owner
    ,lower(table_name)  AS table_name
    ,tablespace_name
    ,num_rows
    ,blocks*8/1024      AS size_mb
    ,pct_free
    ,compression 
    ,logging
FROM    all_tables 
WHERE   owner           LIKE UPPER('ifsapp')
AND table_name LIKE UPPER('%customer_order%') OR table_name LIKE UPPER('%customer_info%')
--OR  owner           = USER
ORDER BY 1,2;

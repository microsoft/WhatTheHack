--Script generates all the DROP statements for user statistics
--Share this with students if they need to rollback any changes and start from scratch

SELECT DISTINCT 'DROP STATISTICS '
+ SCHEMA_NAME(ob.Schema_id) + '.['
+ OBJECT_NAME(s.object_id) + '].[' +
s.name + ']' DropStatisticsName
FROM sys.stats s
INNER JOIN sys.Objects ob ON ob.Object_id = s.object_id
WHERE SCHEMA_NAME(ob.Schema_id) <> 'sys'
AND Auto_Created = 0 AND User_Created = 1
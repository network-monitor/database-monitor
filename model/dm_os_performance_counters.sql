
select perfCount.object_name, perfCount.counter_name,

CASE WHEN perfBase.cntr_value = 0

THEN 0

ELSE (CAST(perfCount.cntr_value AS FLOAT) / perfBase.cntr_value) * 100

END AS cntr_Value

from

(select * from sys.dm_os_performance_counters

where object_Name = 'SQLServer:Resource Pool Stats'

and counter_name = 'CPU usage %' ) perfCount

inner join

(select * from sys.dm_os_performance_counters

where object_Name = 'SQLServer:Resource Pool Stats'

and counter_name = 'CPU usage % base') perfBase

on perfCount.Object_name = perfBase.object_name
SELECT CntrVal.object_name, CntrVal.counter_name, CntrVal.instance_name,
       CASE WHEN CntrBase.cntr_value = 0
            THEN 0
            ELSE CAST(CntrVal.cntr_value AS FLOAT) / CntrBase.cntr_value
       END AS CounterValueRatio
FROM sys.dm_os_performance_counters CntrVal
  JOIN sys.dm_os_performance_counters CntrBase
    ON CntrVal.object_name = CntrBase.object_name
      AND CntrVal.instance_name = CntrBase.instance_name
      AND (
           RTRIM(CntrVal.counter_name) + N' Base' = CntrBase.counter_name
           OR (
               CntrVal.counter_name = N'Worktables From Cache Ratio'
               AND CntrBase.counter_name = N'Worktables From Cache Base'
              )
          )
WHERE CntrVal.cntr_type = 537003264

SELECT CntrVal.object_name, CntrVal.counter_name, CntrVal.instance_name,
       CASE WHEN CntrBase.cntr_value = 0
            THEN 0
            ELSE CAST(CntrVal.cntr_value AS FLOAT) / CntrBase.cntr_value
       END AS CounterValueRatio
FROM sys.dm_os_performance_counters CntrVal
  JOIN sys.dm_os_performance_counters CntrBase
    ON CntrVal.object_name = CntrBase.object_name
      AND CntrVal.instance_name = CntrBase.instance_name
      AND (
           RTRIM(CntrVal.counter_name) + N' Base' = CntrBase.counter_name
           OR (
               CntrVal.counter_name = N'Worktables From Cache Ratio'
               AND CntrBase.counter_name = N'Worktables From Cache Base'
              )
          )
WHERE CntrVal.cntr_type = 537003264
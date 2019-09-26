-- Copyright (c) eBridge 2019
-- MS SQL Server. 
-- prior Version 2017

select perfCount.object_name, 
       perfCount.counter_name,
	   CASE WHEN perfBase.cntr_value = 0
       THEN 0
	   ELSE (CAST(perfCount.cntr_value AS FLOAT) / perfBase.cntr_value) * 100
       END AS cntr_Value
from
      ( select * from sys.dm_os_performance_counters
         where object_Name = 'SQLServer:Resource Pool Stats'
           and counter_name = 'CPU usage %' ) perfCount
         inner join
      ( select * from sys.dm_os_performance_counters
         where object_Name = 'SQLServer:Resource Pool Stats'
           and counter_name = 'CPU usage % base') perfBase
            on perfCount.Object_name = perfBase.object_name
			
-- 1. Instances
SHOW TAG VALUES WITH KEY = \"servername\""

-- 2. Database Properties

-- 2.1 Database Health
-- front-end
SELECT mean("total") FROM "State OFFLINE" WHERE ("servername" =~ /$/ AND "type" = 'Database properties') AND time >= now() - 1h GROUP BY time(30s) fill(null)
-- backend
-- https://docs.microsoft.com/en-us/sql/relational-databases/databases/file-states?view=sql-server-2017
-- https://docs.microsoft.com/en-us/sql/relational-databases/system-catalog-views/sys-master-files-transact-sql?view=sql-server-2017
SELECT state, state_desc FROM sys.master_files
 -- 0 = ONLINE, 1 = RESTORING, 2 = RECOVERING, 3 = RECOVERY_PENDING, 4 = SUSPECT, 5 = Identified for informational purposes only. Not supported. Future compatibility is not guaranteed., 
 -- 6 = OFFLINE, 7 = DEFUNCT

 -- 2.2. Online
SELECT "total" FROM "State ONLINE" WHERE ("servername" =~ /$/ AND "type" = 'Database properties') AND time >= now() - 1h

-- 2.3. Offline
SELECT "total" FROM "State OFFLINE" WHERE ("servername" =~ /$/ AND "type" = 'Database properties') AND time >= now() - 1h

-- 2.4. Suspect
SELECT "total" FROM "State SUSPECT" WHERE ("servername" =~ /$/ AND "type" = 'Database properties') AND time >= now() - 1h

-- 2.5. Recovering
SELECT "total" FROM "State RECOVERING" WHERE ("servername" =~ /$/ AND "type" = 'Database properties') AND time >= now() - 1h

-- 2.6. Pending
SELECT "total" FROM "State RECOVERY_PENDING" WHERE ("servername" =~ /$/ AND "type" = 'Database properties') AND time >= now() - 1h

-- 2.7. Restoring
SELECT "total" FROM "State RESTORING" WHERE ("servername" =~ /$/ AND "type" = 'Database properties') AND time >= now() - 1h

-- 2.8. RPO
-- Front End
SELECT "Point In Time Recovery" FROM "Performance metrics" WHERE ("servername" =~ /$/ AND "type" = 'Performance metrics') AND time >= now() - 1h
-- Backend
-- https://www.datadoghq.com/blog/sql-server-monitoring/

-- https://docs.microsoft.com/en-us/sql/relational-databases/performance/monitoring-performance-by-using-the-query-store?view=sql-server-2017

-- https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/restore-a-sql-server-database-to-a-point-in-time-full-recovery-model?view=sql-server-2017

-- https://docs.microsoft.com/en-us/sql/relational-databases/backup-restore/view-or-change-the-recovery-model-of-a-database-sql-server?view=sql-server-2017#TsqlProcedure

SELECT name, recovery_model_desc  
   FROM sys.databases  
      WHERE name = 'model' ; 

"SELECT name, recovery_model_desc FROM sys.databases" 
-- name : master,          		recovery_model_desc : SIMPLE,
-- name : tempdb,          		recovery_model_desc : SIMPLE,
-- name : model,           		recovery_model_desc : FULL,
-- name : msdb,            		recovery_model_desc : SIMPLE,
-- name : ReportServer,         recovery_model_desc : FULL,
-- name : ReportServerTempDB,   recovery_model_desc : SIMPLE,
-- name : IDMS,            		recovery_model_desc : SIMPLE,

   
-- 2.9. Full
SELECT "total" FROM "Recovery Model FULL" WHERE ("servername" =~ /$/ AND "type" = 'Database properties') AND time >= now() - 1h

-- 2.10. Bulk Logged
SELECT "total" FROM "Recovery Model BULK_LOGGED" WHERE ("servername" =~ /$/ AND "type" = 'Database properties') AND time >= now() - 1h

-- 2.11. Simple
SELECT "total" FROM "Recovery Model SIMPLE" WHERE ("servername" =~ /$/ AND "type" = 'Database properties') AND time >= now() - 1h

-- 3. KPI

-- 3.1. KPI | CPU

-- 3.1.1. System Idle
SELECT mean("SystemIdle") FROM "CPU (%)" WHERE ("servername" =~ /^$/ AND "type" = 'CPU usage') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.1.2. SQL CPU%
SELECT mean("SQL process") FROM "CPU (%)" WHERE ("servername" =~ /^$/ AND "type" = 'CPU usage') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.1.3. External CPU% 
SELECT mean("External process") FROM "CPU (%)" WHERE ("servername" =~ /^$/ AND "type" = 'CPU usage') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.1.4. Signal Wait%
SELECT mean("Signal wait (%)") FROM "Performance metrics" WHERE "servername" =~ /$Instance$/ AND "type" = 'Performance metrics' AND $timeFilter GROUP BY time($interval) fill(null)

-- 3.1.5. Average Tasks
SELECT mean("Average tasks") FROM "Performance metrics" WHERE "servername" =~ /$Instance$/ AND "type" = 'Performance metrics' AND $timeFilter GROUP BY time($interval) fill(null)

-- 3.1.6. Runnage Tasks
SELECT mean("Average runnable tasks") FROM "Performance metrics" WHERE "servername" =~ /$/ AND "type" = 'Performance metrics' AND time >= now() - 1h GROUP BY time(30s) fill(null)
 
-- 3.2. KPI | Memory

-- https://www.sqlshack.com/sql-server-memory-performance-metrics-part-2-available-bytes-total-server-target-server-memory/
-- https://rtpsqlguy.wordpress.com/2009/08/11/sys-dm_os_performance_counters-explained/

-- -- SELECT object_name ,counter_name, cntr_value
-- -- FROM sys.dm_os_performance_counters
-- -- WHERE counter_name = 'Total Server Memory (KB)'
 
-- 3.2.1. Target Memory
SELECT mean("value") FROM "Target Server Memory (KB) | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.2.2. Used Memory
SELECT mean("value") FROM "Total Server Memory (KB) | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.2.3. Used/Target Memory
SELECT mean("Total target memory ratio") FROM "Performance metrics" WHERE ("type" = 'Performance metrics' AND "servername" =~ /$/) AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.2.4. Page File
SELECT mean("Page File Usage (%)") FROM "Performance metrics" WHERE ("servername" =~ /$/) AND time >= now() - 1h GROUP BY time(30s) fill(null)
-- --- https://www.sqlshack.com/sql-server-memory-performance-metrics-part-6-memory-metrics/

-- 3.4
SELECT mean("value")
FROM "Total Server Memory (KB) | Memory Manager"
WHERE ("servername" =~ /IDMS$/ AND "type" = 'Performance counters') AND time >= now() - 3h GROUP BY time(2m) fill(null)"
-- "SELECT total_page_file_kb, available_page_file_kb, system_memory_state_desc FROM sys.dm_os_sys_memory"
-- total_page_file_kb : 8385796, available_page_file_kb : 6842652, system_memory_state_desc : Available physical memory is high,
-- total_physical_memory_kb : 4193848, available_physical_memory_kb : 2776496, total_page_file_kb : 8385796, available_page_file_kb : 6672252, system_cache_kb : 2770856, kernel_paged_pool_kb : 283320, kernel_nonpaged_pool_kb : 90916, system_high_memory_signal_state : 1, system_low_memory_signal_state : 0, system_memory_state_desc : Available physical memory is high,

SELECT total_page_file_kb, available_page_file_kb, 
system_memory_state_desc
FROM sys.dm_os_sys_memory 

SELECT total_page_file_kb, available_page_file_kb, system_memory_state_desc FROM sys.dm_os_sys_memory 
"SELECT total_page_file_kb, available_page_file_kb, system_memory_state_desc FROM sys.dm_os_sys_memory "
connected
total_page_file_kb : 8385796, available_page_file_kb : 6672056, system_memory_state_desc : Available physical memory is high,

-- 3.2.5. Page Life Expectancy
SELECT mean("value") FROM "Page life expectancy | Buffer Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(30s) fill(null)

--  cat sys.dm_os_performance_counters.sql | grep "Page life expectancy"
-- object_name : SQLServer:Buffer Manager, counter_name : Page life expectancy    , instance_name :                         , cntr_value : 11675, cntr_type : 65792,
-- object_name : SQLServer:Buffer Node   , counter_name : Page life expectancy    , instance_name : 000                     , cntr_value : 11675, cntr_type : 65792,
-- https://dba.stackexchange.com/questions/203784/page-life-expectancy-ple-where-to-start

SELECT [object_name],
[counter_name],
[cntr_value] FROM sys.dm_os_performance_counters -- https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-performance-counters-transact-sql
WHERE [counter_name] = 'Page life expectancy' --if multiple NUMA on a server should return multiple Nodes, 
OR [counter_name] = 'Free list stalls/sec'  -- Number of requests per second that had to wait for a free page https://docs.microsoft.com/en-us/sql/relational-databases/performance-monitor/sql-server-buffer-manager-object
OR [counter_name] = 'Lazy writes/sec' --Flushes of dirty pages before a checkpoint runs.  
OR [counter_name] = 'Buffer cache hit ratio' --percentage of pages found in the buffer cache without having to read from disk you want this ratio to be high
Order by [counter_name] DESC, [object_name];

-- 3.2.6. Buffer Pool Rate
SELECT mean("Buffer pool rate (bytes/sec)") FROM "Performance metrics" WHERE ("servername" =~ /$/ AND "type" = 'Performance metrics') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- https://logicalread.com/sql-server-memory-buffer-pools-pd01/#.XYIOtCgzaUk

SELECT (CASE 
           WHEN ( [database_id] = 32767 ) THEN 'Resource Database' 
           ELSE Db_name (database_id) 
         END )  AS 'Database Name', 
       Sum(CASE 
             WHEN ( [is_modified] = 1 ) THEN 0 
             ELSE 1 
           END) AS 'Clean Page Count',
		Sum(CASE 
             WHEN ( [is_modified] = 1 ) THEN 1 
             ELSE 0 
           END) AS 'Dirty Page Count'
FROM   sys.dm_os_buffer_descriptors 
GROUP  BY database_id 
ORDER  BY DB_NAME(database_id);

-- https://www.sqlshack.com/sql-server-memory-performance-metrics-part-6-memory-metrics/

object_name : SQLServer:General Statistics                                                                                                    , counter_name : User Connections        , instance_name :                         , cntr_value : 3, cntr_type : 65792,



-- 3.2.7. Free List Stalls
SELECT "value" FROM "Free list stalls/sec | Buffer Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h

cat sys.dm_os_performance_counters.sql | grep "Free list stalls"
object_name : SQLServer:Buffer Manager, counter_name : Free list stalls/sec    , instance_name :                         , cntr_value : 0, cntr_type : 272696576,


-- 3.2.8. Memory Grants Pending
SELECT mean("value") FROM "Memory Grants Pending | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- cat sys.dm_os_performance_counters.sql | grep "Memory Grants Pending"
-- object_name : SQLServer:Memory Manager, counter_name : Memory Grants Pending   , instance_name :                         , cntr_value : 0, cntr_type : 65792,


-- 3.3. KPI | 1/O

-- https://sqlperformance.com/2015/03/io-subsystem/monitoring-read-write-latency
database_id : 2, 
file_id : 1, 
sample_ms : 26904603, 
num_of_reads : 68, 
num_of_bytes_read : 557056, 
io_stall_read_ms : 818, 
num_of_writes : 3, 
num_of_bytes_written : 24576, 
io_stall_write_ms : 41, 
io_stall : 859, 
size_on_disk_bytes : 8388608, 
file_handle : 0000000000000484,

database_id : 2, 
file_id : 2, 
sample_ms : 26904603, 
num_of_reads : 6, 
num_of_bytes_read : 385024, 
io_stall_read_ms : 242, 
num_of_writes : 14, 

-- https://www.brentozar.com/blitz/slow-storage-reads-writes/

--- 3.3.1. Row Reads
SELECT mean("Total") FROM "Rows reads (bytes/sec)" WHERE ("servername" =~ /$/ AND "type" = 'Database IO') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.3.2. Log Reads
SELECT mean("Total") FROM "Log reads (bytes/sec)" WHERE ("servername" =~ /$/ AND "type" = 'Database IO') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.3.3. Rows Writes
SELECT mean("Total") FROM "Rows writes (bytes/sec)" WHERE ("servername" =~ /$/ AND "type" = 'Database IO') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.3.4. Log Writes
SELECT mean("Total") FROM "Log writes (bytes/sec)" WHERE ("servername" =~ /$/ AND "type" = 'Database IO') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.3.5. Pending I/O
SELECT mean("Average pending disk IO") FROM "Performance metrics" WHERE ("servername" =~ /$/ AND "type" = 'Performance metrics') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.3.6. Network I/O
SELECT "value" FROM "Network IO waits | Average wait time (ms) | Wait Statistics" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h

-- 3.4. KPI | Others
-- =================
-- https://www.datadoghq.com/blog/sql-server-monitoring-tools/#dynamic-management-views
-- "SELECT @@connections AS "Total Connections""
-- Total : 8410,

-- 
SELECT object_name, counter_name, cntr_value 
FROM sys.dm_os_performance_counters 
WHERE object_name="SQLServer:Buffer Manager" AND cntr_value != 0;

SELECT object_name, counter_name, cntr_value FROM sys.dm_os_performance_counters WHERE object_name="SQLServer:Buffer Manager" AND cntr_value != 0;

"SELECT object_name, counter_name, cntr_value FROM sys.dm_os_performance_counters WHERE object_name='SQLServer:Buffer Manager' AND cntr_value != 0;"
object_name : SQLServer:Buffer Manager, counter_name : Buffer cache hit ratio  , cntr_value : 16,
object_name : SQLServer:Buffer Manager, counter_name : Buffer cache hit ratio base                                                                                                     , cntr_value : 16,
object_name : SQLServer:Buffer Manager, counter_name : Page lookups/sec        , cntr_value : 4148642,
object_name : SQLServer:Buffer Manager, counter_name : Free pages              , cntr_value : 225,
object_name : SQLServer:Buffer Manager, counter_name : Total pages             , cntr_value : 11920,
object_name : SQLServer:Buffer Manager, counter_name : Target pages            , cntr_value : 303237,
object_name : SQLServer:Buffer Manager, counter_name : Database pages          , cntr_value : 4081,
object_name : SQLServer:Buffer Manager, counter_name : Stolen pages            , cntr_value : 7614,
object_name : SQLServer:Buffer Manager, counter_name : Readahead pages/sec     , cntr_value : 2007,
object_name : SQLServer:Buffer Manager, counter_name : Page reads/sec          , cntr_value : 4026,
object_name : SQLServer:Buffer Manager, counter_name : Page writes/sec         , cntr_value : 127,
object_name : SQLServer:Buffer Manager, counter_name : Checkpoint pages/sec    , cntr_value : 93,
object_name : SQLServer:Buffer Manager, counter_name : Page life expectancy    , cntr_value : 30372,

-- 3.4.1. User Connections
SELECT mean("value") FROM "User Connections | General Statistics" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.4.2. Bytes Per Connection
SELECT mean("Connection memory per connection (bytes)") FROM "Performance metrics" WHERE ("servername" =~ /$/ AND "type" = 'Performance metrics') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.4.3. Data File Size
SELECT "value" FROM "Data File(s) Size (KB) | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h
-- "EXEC sp_spaceused;"
-- database_name : IDMS, database_size : 19129.63 MB, unallocated space : 0.00 MB,

-- 3.4.4. System Data File Size
SELECT "value" FROM "Data File(s) Size (KB) | mssqlsystemresource | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h
 
-- 3.4.5. Log Used
==================
SELECT mean("value") FROM "Percent Log Used | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- https://www.mssqltips.com/sqlservertip/1225/how-to-determine-sql-server-database-transaction-log-usage/
"DBCC SQLPERF(logspace)"
Database Name : master, Log Size (MB) : 0.9921875, Log Space Used (%) : 35.82677, Status : 0,
Database Name : tempdb, Log Size (MB) : 0.4921875, Log Space Used (%) : 81.74603, Status : 0,
Database Name : model, Log Size (MB) : 0.4921875, Log Space Used (%) : 46.825397, Status : 0,
Database Name : msdb, Log Size (MB) : 0.7421875, Log Space Used (%) : 41.57895, Status : 0,
Database Name : ReportServer, Log Size (MB) : 6.1171875, Log Space Used (%) : 15.557152, Status : 0,
Database Name : ReportServerTempDB, Log Size (MB) : 0.7421875, Log Space Used (%) : 51.644737, Status : 0,
Database Name : IDMS, Log Size (MB) : 0.9921875, Log Space Used (%) : 37.795277, Status : 0,

"DBCC LOGINFO"
FileId : 2, FileSize : 253952, StartOffset : 8192, FSeqNo : 606209, Status : 0, Parity : 64, CreateLSN : 0,
FileId : 2, FileSize : 253952, StartOffset : 262144, FSeqNo : 606210, Status : 0, Parity : 64, CreateLSN : 0,
FileId : 2, FileSize : 253952, StartOffset : 516096, FSeqNo : 606208, Status : 0, Parity : 128, CreateLSN : 0,
FileId : 2, FileSize : 278528, StartOffset : 770048, FSeqNo : 606211, Status : 2, Parity : 128, CreateLSN : 0,

https://www.mssqltips.com/sqlservertip/1178/monitoring-sql-server-database-transaction-log-space/


-- 3.4.6. System Log Used
SELECT mean("value") FROM "Percent Log Used | mssqlsystemresource | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.4.7. Backup/Restore Throughput
SELECT mean("value") FROM "Backup/Restore Throughput/sec | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 4. Performance Counters

"select * from sys.dm_exec_query_stats" > /tmp/sys.dm_exec_query_stats4.sql
grep 'SQL Compilations/sec' sys.dm_os_performance_counters4.sql
object_name : SQLServer:SQL Statistics                                                                                                        , counter_name : SQL Compilations/sec                                                                                                            , cntr_value : 644,

--- DEFINITIONS
https://docs.microsoft.com/en-us/sql/relational-databases/performance-monitor/sql-server-databases-object?view=sql-server-2017

-- 4.1. SQL Server Activity
SELECT mean("value") FROM "Batch Requests/sec | SQL Statistics" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "User Connections | General Statistics" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Logins/sec | General Statistics" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Logouts/sec | General Statistics" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "SQL Compilations/sec | SQL Statistics" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "SQL Re-Compilations/sec | SQL Statistics" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Processes blocked | General Statistics" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null)

-- 4.2. Databases Activity
SELECT mean("value") FROM "Transactions/sec | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Write Transactions/sec | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Log Flushes/sec | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Log Flush Wait Time | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Lock Timeouts/sec | _Total | Locks" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Number of Deadlocks/sec | _Total | Locks" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Lock Waits/sec | _Total | Locks" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Latch Waits/sec | Latches" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null)

-- 4.3. Buffer Cache Disk
SELECT mean("value") FROM "Full Scans/sec | Access Methods" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Index Searches/sec | Access Methods" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Page Splits/sec | Access Methods" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Page lookups/sec | Buffer Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Page reads/sec | Buffer Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Page writes/sec | Buffer Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Readahead pages/sec | Buffer Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Lazy writes/sec | Buffer Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Checkpoint pages/sec | Buffer Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null)

-- 4.4. Memory Manager
SELECT "value" FROM "SQL Cache Memory (KB) | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h;SELECT "value" FROM "Optimizer Memory (KB) | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h;SELECT "value" FROM "Log Pool Memory (KB) | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h;SELECT "value" FROM "Lock Memory (KB) | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h;SELECT "value" FROM "Database Cache Memory (KB) | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h;SELECT "value" FROM "Connection Memory (KB) | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h

--
 grep 'SQL Cache Memory' sys.dm_os_performance_counters4.sql
object_name : SQLServer:Memory Manager                                                                                                        , counter_name : SQL Cache Memory (KB)                                                                                                           , cntr_value : 1744,

-- 4.5. Log Activities
SELECT mean("value") FROM "Log Flushes/sec | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(2s) fill(null);SELECT mean("value") FROM "Log Pool Cache Misses/sec | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(2s) fill(null);SELECT mean("value") FROM "Log Pool Disk Reads/sec | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(2s) fill(null);SELECT mean("value") FROM "Log Pool Requests/sec | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(2s) fill(null)

-- 5. Waits Statistics

https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-wait-stats-transact-sql?view=sql-server-2017
/tmp/sys.dm_os_wait_stats.sql

-- 5.1. Wait Time
SELECT "Buffer", "CLR", "I/O", "Latch", "Lock", "Memory", "Network", "Service broker", "Other", "SQLOS", "XEvent" FROM "Wait time (ms)" WHERE ("type" = 'Wait stats' AND "servername" =~ /$/) AND time >= now() - 1h

-- 5.2. Wait Tasks
SELECT "Buffer", "CLR", "I/O", "Latch", "Lock", "Memory", "Network", "Service broker", "Other", "SQLOS", "XEvent" FROM "Wait tasks" WHERE ("type" = 'Wait stats' AND "servername" =~ /$/) AND time >= now() - 1h

-- 6. Memory Breakdown

-- 
https://docs.microsoft.com/en-us/sql/relational-databases/in-memory-oltp/monitor-and-troubleshoot-memory-usage?view=sql-server-2017

SELECT memory_object_address  
     , pages_in_bytes  
     , bytes_used  
     , type  
   FROM sys.dm_os_memory_objects WHERE type LIKE '%xtp%'  

   /tmp/sys.dm_os_memory_objects.sql
  
-- 6.1. Memory %
SELECT * FROM "Memory breakdown (%)" WHERE ("servername" =~ /$/ AND "type" = 'Memory clerk') AND time >= now() - 1h

-- 6.2. Memory Bytes
SELECT * FROM "Memory breakdown (bytes)" WHERE ("servername" =~ /$/) AND time >= now() - 1h

-- 7. Database Size Trend

-- 7.1. Database | Row Size
SELECT * FROM "Rows size (bytes)" WHERE ("servername" =~ /$/ AND "type" = 'Database size') AND time >= now() - 1h

-- 7.2. Data | Log Size
SELECT * FROM "Log size (bytes)" WHERE ("servername" =~ /$/ AND "type" = 'Database size') AND time >= now() - 1h

-- 8. Database 1/0 | Read

-- 8.1. Reads | Row Bytes
SELECT * FROM "Rows reads (bytes/sec)" WHERE ("servername" =~ /$/ AND "type" = 'Database IO') AND time >= now() - 1h

-- 8.2. Reads | Log Bytes
SELECT * FROM "Log reads (bytes/sec)" WHERE ("servername" =~ /$/ AND "type" = 'Database IO') AND time >= now() - 1h

-- 9. Database 1/0 | Write

-- 9.1. Writes | Rows Bytes
SELECT * FROM "Rows writes (bytes/sec)" WHERE ("servername" =~ /$/ AND "type" = 'Database IO') AND time >= now() - 1h

-- 9.2. Writes | Log Bytes
SELECT * FROM "Log writes (bytes/sec)" WHERE ("servername" =~ /$/ AND "type" = 'Database IO') AND time >= now() - 1h

-- 10. Database Latency | Read

-- 10.1. Reads | Rows ms
SELECT * FROM "Rows read latency (ms)" WHERE ("servername" =~ /$/ AND "type" = 'Database stats') AND time >= now() - 1h

-- 10.2. Reads | Log ms
SELECT * FROM "Log read latency (ms)" WHERE ("servername" =~ /$/ AND "type" = 'Database stats') AND time >= now() - 1h

-- 11. Database Latency | Write

-- 11.1. Writes | Rows ms
SELECT * FROM "Rows write latency (ms)" WHERE ("servername" =~ /$/ AND "type" = 'Database stats') AND time >= now() - 1h

-- 11.2. Writes | log ms
SELECT * FROM "Log write latency (ms)" WHERE ("servername" =~ /$/ AND "type" = 'Database stats') AND time >= now() - 1h

https://www.sqlskills.com/blogs/paul/wait-statistics-or-please-tell-me-where-it-hurts/


-- 12. OS Volume

https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-volume-stats-transact-sql?view=sql-server-2017

SELECT f.database_id, f.file_id, volume_mount_point, total_bytes, available_bytes FROM sys.master_files
/tmp/sys.master_files5.sql
SELECT * FROM sys.master_files

-- 12.1 Used Bytes
SELECT * FROM "Volume used space (bytes)" WHERE ("servername" =~ /$/ AND "type" = 'OS Volume space') AND time >= now() - 1h

-- 12.2. Available Bytes
SELECT * FROM "Volume available space (bytes)" WHERE ("servername" =~ /$/ AND "type" = 'OS Volume space') AND time >= now() - 1h

-- 12.3. Used %
SELECT * FROM "Volume used space (%)" WHERE ("servername" =~ /$/ AND "type" = 'OS Volume space') AND time >= now() - 1h

--12.4. Used
SELECT "D: (DATA)", "L: (LOGS)", "T: (TEMPDB)" FROM "Volume used space (%)" WHERE ("servername" =~ /$/) AND time >= now() - 1h

-- 13. Others

-- 13.1. Ratios
SELECT mean("Page split per batch request") FROM "Performance metrics" WHERE ("servername" =~ /$/ AND "type" = 'Performance metrics') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("Sql compilation per batch request") FROM "Performance metrics" WHERE ("servername" =~ /$/ AND "type" = 'Performance metrics') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("Sql recompilation per batch request") FROM "Performance metrics" WHERE ("servername" =~ /$/ AND "type" = 'Performance metrics') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("Readahead per page read") FROM "Performance metrics" WHERE ("servername" =~ /$/ AND "type" = 'Performance metrics') AND time >= now() - 1h GROUP BY time(5s) fill(null)

-- 13.2 CPU
SELECT mean("SQL process") FROM "CPU (%)" WHERE ("servername" =~ /$/) AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("External process") FROM "CPU (%)" WHERE ("servername" =~ /$/) AND time >= now() - 1h GROUP BY time(5s) fill(null)

https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-exec-sessions-transact-sql?view=sql-server-2017

"select * from sys.dm_exec_connections"
connected
session_id : 51, most_recent_session_id : 51, connect_time : 2019-09-18 08:29:27.257, net_transport : Shared memory, protocol_type : TSQL, protocol_version : 1930100739, endpoint_id : 2, encrypt_option : FALSE, auth_scheme : NTLM, node_affinity : 0, num_reads : 24, num_writes : 25, last_read : 2019-09-18 08:29:29.1, last_write : 2019-09-18 08:29:29.96, net_packet_size : 4096, client_net_address : <local machine>, client_tcp_port : null, local_net_address : null, local_tcp_port : null, connection_id : D187147C-41DB-477D-87C5-0AA78EE68C4B, parent_connection_id : null, most_recent_sql_handle : 01000400628D381580AFC280000000000000000000000000,
session_id : 52, most_recent_session_id : 52, connect_time : 2019-09-18 16:37:24.1, net_transport : TCP, protocol_type : TSQL, protocol_version : 1930035203, endpoint_id : 4, encrypt_option : FALSE, auth_scheme : SQL, node_affinity : 0, num_reads : 22, num_writes : 20, last_read : 2019-09-18 16:37:30.183, last_write : 2019-09-18 16:37:30.197, net_packet_size : 4096, client_net_address : 195.1.1.102, client_tcp_port : 52698, local_net_address : 195.1.1.102, local_tcp_port : 1433, connection_id : 0F43E86A-CBE3-44C7-A6FE-0B18AE8B3A36, parent_connection_id : null, most_recent_sql_handle : 01000100AAF1D52250247F85000000000000000000000000,
session_id : 53, most_recent_session_id : 53, connect_time : 2019-09-18 17:47:39.623, net_transport : TCP, protocol_type : TSQL, protocol_version : 117440512, endpoint_id : 4, encrypt_option : FALSE, auth_scheme : SQL, node_affinity : 0, num_reads : 3, num_writes : 2, last_read : 2019-09-18 17:47:39.7, last_write : 2019-09-18 17:47:39.673, net_packet_size : 4096, client_net_address : 195.1.1.6, client_tcp_port : 38224, local_net_address : 195.1.1.102, local_tcp_port : 1433, connection_id : 6C9095CA-56D9-4C74-9C1F-F976C7AEDD92, parent_connection_id : null, most_recent_sql_handle : 02000000E1EA2813444061F7ECDD57037B8D10735F11E265,
session_id : 54, most_recent_session_id : 54, connect_time : 2019-09-18 17:41:31.523, net_transport : Shared memory, protocol_type : TSQL, protocol_version : 1930035203, endpoint_id : 2, encrypt_option : FALSE, auth_scheme : NTLM, node_affinity : 0, num_reads : 225, num_writes : 225, last_read : 2019-09-18 17:47:39.37, last_write : 2019-09-18 17:47:39.37, net_packet_size : 8000, client_net_address : <local machine>, client_tcp_port : null, local_net_address : null, local_tcp_port : null, connection_id : C0D84DB4-BE96-4B06-B6D9-671DDA8F88FD, parent_connection_id : null, most_recent_sql_handle : 010005007D09C820109D0580000000000000000000000000,
session_id : 55, most_recent_session_id : 55, connect_time : 2019-09-18 16:37:40.49, net_transport : TCP, protocol_type : TSQL, protocol_version : 1930035203, endpoint_id : 4, encrypt_option : FALSE, auth_scheme : SQL, node_affinity : 0, num_reads : 36, num_writes : 112, last_read : 2019-09-18 16:38:31.18, last_write : 2019-09-18 16:42:48.49, net_packet_size : 4096, client_net_address : 195.1.1.102, client_tcp_port : 52703, local_net_address : 195.1.1.102, local_tcp_port : 1433, connection_id : B27A42A0-3129-452D-A099-E3153AF740FF, parent_connection_id : null, most_recent_sql_handle : 010001004484291CE0DAAB85000000000000000000000000,


-- 14. Availabitity Replica

-- 14.1. Out | Bytes Sent To Replica/sec
SELECT mean("value") FROM "Bytes Sent to Replica/sec | _Total | Availability Replica" WHERE ("type" = 'Performance counters' AND "servername" =~ /^$/) AND time >= now() - 1h GROUP BY time(5s) fill(null)

-- 14.2. IN | Bytes received from Replica / sec
SELECT mean("value") FROM "Bytes Received from Replica/sec | _Total | Availability Replica" WHERE ("type" = 'Performance counters' AND "servername" =~ /^$/) AND time >= now() - 1h GROUP BY time(5s) fill(null)

-- 14.3. Transaction Delay
SELECT mean("value") FROM "Transaction Delay | _Total | Database Replica" WHERE ("type" = 'Performance counters' AND "servername" =~ /^$/) AND time >= now() - 1h GROUP BY time(5s) fill(null)

-- 14.4. Mirrored Write Transaction/sec
SELECT mean("value") FROM "Transaction Delay | _Total | Database Replica" WHERE ("type" = 'Performance counters' AND "servername" =~ /^$/) AND time >= now() - 1h GROUP BY time(5s) fill(null)








			
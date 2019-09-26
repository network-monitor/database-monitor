-- Copyright (c) eBridge 2019
-- InfluxDB

-- 1. Instances
SHOW TAG VALUES WITH KEY = \"servername\""

-- 2. Database Properties

-- 2.1 Database Health
SELECT mean("total") FROM "State OFFLINE" WHERE ("servername" =~ /$/ AND "type" = 'Database properties') AND time >= now() - 1h GROUP BY time(30s) fill(null)

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
SELECT "Point In Time Recovery" FROM "Performance metrics" WHERE ("servername" =~ /$/ AND "type" = 'Performance metrics') AND time >= now() - 1h

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

-- 3.2.1. Target Memory
SELECT mean("value") FROM "Target Server Memory (KB) | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.2.2. Used Memory
SELECT mean("value") FROM "Total Server Memory (KB) | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.2.3. Used/Target Memory
SELECT mean("Total target memory ratio") FROM "Performance metrics" WHERE ("type" = 'Performance metrics' AND "servername" =~ /$/) AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.2.4. Page File
SELECT mean("Page File Usage (%)") FROM "Performance metrics" WHERE ("servername" =~ /$/) AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.2.5. Page Life Expectancy
SELECT mean("value") FROM "Page life expectancy | Buffer Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.2.6. Buffer Pool Rate
SELECT mean("Buffer pool rate (bytes/sec)") FROM "Performance metrics" WHERE ("servername" =~ /$/ AND "type" = 'Performance metrics') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.2.7. Free List Stalls
SELECT "value" FROM "Free list stalls/sec | Buffer Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h

-- 3.2.8. Memory Grants Pending
SELECT mean("value") FROM "Memory Grants Pending | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.3. KPI | 1/O

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

-- 3.4.1. User Connections
SELECT mean("value") FROM "User Connections | General Statistics" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.4.2. Bytes Per Connection
SELECT mean("Connection memory per connection (bytes)") FROM "Performance metrics" WHERE ("servername" =~ /$/ AND "type" = 'Performance metrics') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.4.3. Data File Size
SELECT "value" FROM "Data File(s) Size (KB) | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h

-- 3.4.4. System Data File Size
SELECT "value" FROM "Data File(s) Size (KB) | mssqlsystemresource | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h
 
-- 3.4.5. Log Used
SELECT mean("value") FROM "Percent Log Used | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.4.6. System Log Used
SELECT mean("value") FROM "Percent Log Used | mssqlsystemresource | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 3.4.7. Backup/Restore Throughput
SELECT mean("value") FROM "Backup/Restore Throughput/sec | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(30s) fill(null)

-- 4. Performance Counters

-- 4.1. SQL Server Activity
SELECT mean("value") FROM "Batch Requests/sec | SQL Statistics" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "User Connections | General Statistics" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Logins/sec | General Statistics" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Logouts/sec | General Statistics" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "SQL Compilations/sec | SQL Statistics" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "SQL Re-Compilations/sec | SQL Statistics" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Processes blocked | General Statistics" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null)

-- 4.2. Databases Activity
SELECT mean("value") FROM "Transactions/sec | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Write Transactions/sec | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Log Flushes/sec | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Log Flush Wait Time | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Lock Timeouts/sec | _Total | Locks" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Number of Deadlocks/sec | _Total | Locks" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Lock Waits/sec | _Total | Locks" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Latch Waits/sec | Latches" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null)

-- 4.3. Buffer Cache Disk
SELECT mean("value") FROM "Full Scans/sec | Access Methods" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Index Searches/sec | Access Methods" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Page Splits/sec | Access Methods" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Page lookups/sec | Buffer Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Page reads/sec | Buffer Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Page writes/sec | Buffer Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Readahead pages/sec | Buffer Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Lazy writes/sec | Buffer Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null);SELECT mean("value") FROM "Checkpoint pages/sec | Buffer Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(5s) fill(null)

-- 4.4. Memory Manager
SELECT "value" FROM "SQL Cache Memory (KB) | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h;SELECT "value" FROM "Optimizer Memory (KB) | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h;SELECT "value" FROM "Log Pool Memory (KB) | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h;SELECT "value" FROM "Lock Memory (KB) | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h;SELECT "value" FROM "Database Cache Memory (KB) | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h;SELECT "value" FROM "Connection Memory (KB) | Memory Manager" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h

-- 4.5. Log Activities
SELECT mean("value") FROM "Log Flushes/sec | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(2s) fill(null);SELECT mean("value") FROM "Log Pool Cache Misses/sec | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(2s) fill(null);SELECT mean("value") FROM "Log Pool Disk Reads/sec | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(2s) fill(null);SELECT mean("value") FROM "Log Pool Requests/sec | _Total | Databases" WHERE ("servername" =~ /$/ AND "type" = 'Performance counters') AND time >= now() - 1h GROUP BY time(2s) fill(null)

-- 5. Waits Statistics

-- 5.1. Wait Time
SELECT "Buffer", "CLR", "I/O", "Latch", "Lock", "Memory", "Network", "Service broker", "Other", "SQLOS", "XEvent" FROM "Wait time (ms)" WHERE ("type" = 'Wait stats' AND "servername" =~ /$/) AND time >= now() - 1h

-- 5.2. Wait Tasks
SELECT "Buffer", "CLR", "I/O", "Latch", "Lock", "Memory", "Network", "Service broker", "Other", "SQLOS", "XEvent" FROM "Wait tasks" WHERE ("type" = 'Wait stats' AND "servername" =~ /$/) AND time >= now() - 1h

-- 6. Memory Breakdown

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

-- 12. OS Volume

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

-- 14. Availabitity Replica

-- 14.1. Out | Bytes Sent To Replica/sec
SELECT mean("value") FROM "Bytes Sent to Replica/sec | _Total | Availability Replica" WHERE ("type" = 'Performance counters' AND "servername" =~ /^$/) AND time >= now() - 1h GROUP BY time(5s) fill(null)

-- 14.2. IN | Bytes received from Replica / sec
SELECT mean("value") FROM "Bytes Received from Replica/sec | _Total | Availability Replica" WHERE ("type" = 'Performance counters' AND "servername" =~ /^$/) AND time >= now() - 1h GROUP BY time(5s) fill(null)

-- 14.3. Transaction Delay
SELECT mean("value") FROM "Transaction Delay | _Total | Database Replica" WHERE ("type" = 'Performance counters' AND "servername" =~ /^$/) AND time >= now() - 1h GROUP BY time(5s) fill(null)

-- 14.4. Mirrored Write Transaction/sec
SELECT mean("value") FROM "Transaction Delay | _Total | Database Replica" WHERE ("type" = 'Performance counters' AND "servername" =~ /^$/) AND time >= now() - 1h GROUP BY time(5s) fill(null)









SELECT total_page_file_kb, available_page_file_kb, 
system_memory_state_desc
FROM sys.dm_os_sys_memory 

"SELECT total_page_file_kb, available_page_file_kb, system_memory_state_desc FROM sys.dm_os_sys_memory" 

"SELECT total_page_file_kb, available_page_file_kb, system_memory_state_desc FROM sys.dm_os_sys_memory"
connected
total_page_file_kb : 8385796, available_page_file_kb : 6842652, system_memory_state_desc : Available physical memory is high,

-- KPI / I/O 

select * from sys.dm_io_virtual_file_stats(NULL, NULL)
database_id : 1, file_id : 1, sample_ms : 26904603, num_of_reads : 86, num_of_bytes_read : 704512, io_stall_read_ms : 2616, num_of_writes : 2, num_of_bytes_written : 16384, io_stall_write_ms : 47, io_stall : 2663, size_on_disk_bytes : 4194304, file_handle : 00000000000003BC,
database_id : 1, file_id : 2, sample_ms : 26904603, num_of_reads : 11, num_of_bytes_read : 442368, io_stall_read_ms : 323, num_of_writes : 11, num_of_bytes_written : 57344, io_stall_write_ms : 161, io_stall : 484, size_on_disk_bytes : 1048576, file_handle : 00000000000003C0,
database_id : 2, file_id : 1, sample_ms : 26904603, num_of_reads : 68, num_of_bytes_read : 557056, io_stall_read_ms : 818, num_of_writes : 3, num_of_bytes_written : 24576, io_stall_write_ms : 41, io_stall : 859, size_on_disk_bytes : 8388608, file_handle : 0000000000000484,
database_id : 2, file_id : 2, sample_ms : 26904603, num_of_reads : 6, num_of_bytes_read : 385024, io_stall_read_ms : 242, num_of_writes : 14, num_of_bytes_written : 331776, io_stall_write_ms : 81, io_stall : 323, size_on_disk_bytes : 524288, file_handle : 00000000000003C8,
database_id : 3, file_id : 1, sample_ms : 26904603, num_of_reads : 41, num_of_bytes_read : 1482752, io_stall_read_ms : 1083, num_of_writes : 1, num_of_bytes_written : 8192, io_stall_write_ms : 0, io_stall : 1083, size_on_disk_bytes : 1310720, file_handle : 0000000000000458,
database_id : 3, file_id : 2, sample_ms : 26904603, num_of_reads : 6, num_of_bytes_read : 385024, io_stall_read_ms : 112, num_of_writes : 3, num_of_bytes_written : 16384, io_stall_write_ms : 0, io_stall : 112, size_on_disk_bytes : 524288, file_handle : 000000000000045C,
database_id : 4, file_id : 1, sample_ms : 26904603, num_of_reads : 231, num_of_bytes_read : 2007040, io_stall_read_ms : 4774, num_of_writes : 10, num_of_bytes_written : 81920, io_stall_write_ms : 70, io_stall : 4844, size_on_disk_bytes : 15466496, file_handle : 000000000000061C,
database_id : 4, file_id : 2, sample_ms : 26904603, num_of_reads : 10, num_of_bytes_read : 487424, io_stall_read_ms : 623, num_of_writes : 13, num_of_bytes_written : 61440, io_stall_write_ms : 65, io_stall : 688, size_on_disk_bytes : 786432, file_handle : 0000000000000630,
database_id : 5, file_id : 1, sample_ms : 26904603, num_of_reads : 121, num_of_bytes_read : 991232, io_stall_read_ms : 4017, num_of_writes : 0, num_of_bytes_written : 0, io_stall_write_ms : 0, io_stall : 4017, size_on_disk_bytes : 3407872, file_handle : 0000000000000620,
database_id : 5, file_id : 2, sample_ms : 26904603, num_of_reads : 26, num_of_bytes_read : 466944, io_stall_read_ms : 1018, num_of_writes : 1, num_of_bytes_written : 5632, io_stall_write_ms : 6, io_stall : 1024, size_on_disk_bytes : 6422528, file_handle : 000000000000062C,
database_id : 6, file_id : 1, sample_ms : 26904603, num_of_reads : 55, num_of_bytes_read : 450560, io_stall_read_ms : 1394, num_of_writes : 0, num_of_bytes_written : 0, io_stall_write_ms : 0, io_stall : 1394, size_on_disk_bytes : 2359296, file_handle : 0000000000000624,
database_id : 6, file_id : 2, sample_ms : 26904603, num_of_reads : 7, num_of_bytes_read : 327168, io_stall_read_ms : 199, num_of_writes : 1, num_of_bytes_written : 3584, io_stall_write_ms : 65, io_stall : 264, size_on_disk_bytes : 786432, file_handle : 0000000000000634,
database_id : 7, file_id : 1, sample_ms : 26904603, num_of_reads : 1370, num_of_bytes_read : 22667264, io_stall_read_ms : 25068, num_of_writes : 10, num_of_bytes_written : 90112, io_stall_write_ms : 27, io_stall : 25095, size_on_disk_bytes : 20057817088, file_handle : 0000000000000618,
database_id : 7, file_id : 2, sample_ms : 26904603, num_of_reads : 9, num_of_bytes_read : 432640, io_stall_read_ms : 351, num_of_writes : 112, num_of_bytes_written : 153088, io_stall_write_ms : 148, io_stall : 499, size_on_disk_bytes : 1048576, file_handle : 0000000000000628,

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

database_id : 2, file_id : 2, sample_ms : 26904603, num_of_reads : 6, num_of_bytes_read : 385024, io_stall_read_ms : 242, num_of_writes : 14, 

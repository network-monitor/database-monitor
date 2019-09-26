package com.ebridgeai.networkmonitor.collector;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.HashMap;
import java.util.Map;

public class DatabaseCollector {

    private static void collect(String connString, String databaseName)
            throws FileNotFoundException, SQLException {

        System.out.println("COLLECTING METRICS FOR:: : " +
                "connString : " + connString + ", databaseName : " + databaseName);

        Map<String, String> result1 = new HashMap<>();
        Map<String, String> result2 = new HashMap<>();
        Map<String, String> result3 = new HashMap<>();

        PrintWriter out = null;
        Connection conn = null;

        try {

            conn = DriverManager.getConnection(connString);
            String sql;

            // Test 1. sys.master_files
            sql = "SELECT state, state_desc FROM sys.master_files WHERE name = '" + databaseName + "_Data'";
            System.out.println("SQL:: : " + sql);
            read(conn, sql, result1);

            // Test 2 - sys.databases
            sql = "SELECT name, recovery_model_desc FROM sys.databases WHERE name = 'model'";
            System.out.println("SQL:: : " + sql);
            read(conn, sql, result2);

            // Test 3 - sys.dm_os_performance_counters
            sql = " SELECT counter_name, cntr_value " +
                  "   FROM sys.dm_os_performance_counters " +
                  "  WHERE object_name = 'SQLServer:Resource Pool Stats'" +
                  "    AND counter_name IN (" +
                  "          'CPU usage %','CPU usage % base', 'CPU usage target %', " +
                  "          'Target memory (KB)')";
            System.out.println("SQL:: : " + sql);
            read(conn, sql, result3);
        } finally {

            System.out.println("Writing to /var/spool/ebridge/database-metrics.txt ... ");
            out = new PrintWriter(new File("/var/spool/ebridge/database-metrics.txt"));

            System.out.println("Writing header lines ");
            out.println("# DML");
            out.println("# CONTEXT-DATABASE: ebridge");

            // Test 1 - sys.master_files
            String result = null;
            for (String value : result1.values()  ) {
                result = value;
            }
            System.out.println("Writing result1 : " + result1);
            out.println("State\\ ONLINE,servername=" + databaseName + ",type=Database\\ properties total=" +
                    ("ONLINE".equals(result) ? "1" : "0"));
            out.println("State\\ OFFLINE,servername=" + databaseName + ",type=Database\\ properties total=" +
                    ("OFFLINE".equals(result) ? "1" : "0"));
            out.println("State\\ SUSPECT,servername=" + databaseName + ",type=Database\\ properties total=" +
                    ("SUSPECT".equals(result) ? "1" : "0"));
            out.println("State\\ RECOVERING,servername=" + databaseName + ",type=Database\\ properties total=" +
                    ("RECOVERING".equals(result) ? "1" : "0"));
            out.println("State\\ RECOVERING_PENDING,servername=" + databaseName +",type=Database\\ properties total=" +
                    ("RECOVERING_PENDING".equals(result) ? "1" : "0"));
            out.println("State\\ RESTORING,servername=" + databaseName + ",type=Database\\ properties total=" +
                    ("RESTORING".equals(result) ? "1" : "0"));

            // Test 2 - sys.databases
            System.out.println("Writing result1 : " + result2);
            // TODO process database call results
            out.println("Recovery\\ Model\\ FULL,servername=" + databaseName +
                    ",type=Database\\ properties total=0");
            out.println("Recovery\\ Model\\ BULK_LOGGED,servername=" + databaseName +
                    ",type=Database\\ properties total=0");
            out.println("Recovery\\ Model\\ SIMPLE,servername=" + databaseName +
                    ",type=Database\\ properties total=0");

            // Test 3 - sys.dm_os_performance_counters
            System.out.println("Writing result1 : " + result3);
            out.println("CPU\\ (%),servername=" + databaseName +
                    ",type=CPU\\ usage SystemIdle=" + result3.get("CPU usage target %"));
            out.println("CPU\\ (%),servername=" + databaseName +
                    ",type=CPU\\ usage SQL\\ process=" + result3.get("CPU usage %"));
            out.println("CPU\\ (%),servername=" + databaseName +
                    ",type=CPU\\ usage External\\ process=" + result3.get("CPU usage % base"));
            // TODO update dashboard sql
            out.println("Target\\ memory\\ (KB),servername=" + databaseName +
                            "type=Performance\\ counters value=" + result3.get("Target memory (KB)"));
            out.println("Used\\ memory\\ (KB),servername=" + databaseName +
                            ",type=Performance\\ counters value=" + result3.get("Used memory (KB)"));
            out.println("Performance\\ metrics,servername=" + databaseName +
                            ",type=Performance\\ metrics Total\\ target\\ memory\\ ratio=" +
                            percentage(result3.get("Target memory (KB)"), result3.get("Used memory (KB)")));
            out.println("Performance\\ metrics,servername=" + databaseName +
                            " Page\\ File\\ Usage\\ (%)=0.01");

            // TODO gradually create sql, execute and process the following metrics
            System.out.println("TODO gradually create sql, execute and process the following metrics");
            out.println("Performance\\ metrics,servername=" + databaseName +
                    ",type=Performance\\ metrics Signal\\ wait\\ (%)=23");
            out.println("Performance\\ metrics,servername=" + databaseName +
                    ",type=Performance\\ metrics Average\\ tasks=33");
            out.println("Performance\\ metrics,servername=" + databaseName +
                    ",type=Performance\\ metrics Average\\ runnable\\ tasks=43");
            out.println("Page\\ life\\ expectancy\\ |\\ Buffer\\ Manager,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Performance\\ metrics,servername=" + databaseName +
                    ",type=Performance\\ metrics Buffer\\ pool\\ rate\\ (bytes/sec)=4000");
            out.println("Free\\ list\\ stalls/sec\\ |\\ Buffer\\ Manager,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Memory\\ Grants\\ Pending\\ |\\ Memory\\ Manager,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Rows\\ reads\\ (bytes/sec),servername=" + databaseName +
                    ",type=Database\\ IO value=4000");
            out.println("Log\\ reads\\ (bytes/sec),servername=" + databaseName +
                    ",type=Database\\ IO Total=4000");
            out.println("Rows\\ writes\\ (bytes/sec),servername=" + databaseName +
                    ",type=Database\\ IO Total=4000");
            out.println("Log\\ writes\\ (bytes/sec),servername=" + databaseName +
                    ",type=Database\\ IO Total=4000");
            out.println("Performance\\ metrics,servername=" + databaseName +
                    ",type=Performance\\ metrics Average\\ pending\\ disk\\ IO=4000");
            out.println("Network\\ IO\\ waits\\ |\\ Average\\ wait\\ time\\ (ms)\\ |\\ Wait\\ Statistics" +
                    ",servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("User\\ Connections\\ |\\ General\\ Statistics,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Performance\\ metrics,servername=" + databaseName +
                    ",type=Performance\\ metrics Connection\\ memory\\ per\\ connection\\ (bytes)=4000");
            out.println("Data\\ File(s)\\ Size\\ (KB)\\ |\\ _Total\\ |\\ Databases,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Data\\ File(s)\\ Size\\ (KB)\\ |\\ mssqlsystemresource\\ |\\ Databases" +
                    ",servername=" + databaseName + ",type=Performance\\ counters value=4000");
            out.println("Percent\\ Log\\ Used\\ |\\ _Total\\ |\\ Databases,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Percent\\ Log\\ Used\\ |\\ mssqlsystemresource\\ |\\ Databases,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Backup/Restore\\ Throughput/sec\\ |\\ _Total\\ |\\ Databases,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Batch\\ Requests/sec\\ |\\ SQL\\ Statistics,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Transactions/sec\\ |\\ _Total\\ |\\ Databases,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Full\\ Scans/sec\\ |\\ Access\\ Methods,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("SQL\\ Cache\\ Memory\\ (KB)\\ |\\ Memory\\ Manager,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Optimizer\\ Memory\\ (KB)\\ |\\ Memory\\ Manager,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Log\\ Pool\\ Memory\\ (KB)\\ |\\ Memory\\ Manager,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Lock\\ Memory\\ (KB)\\ |\\ Memory\\ Manager,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Database\\ Cache\\ Memory\\ (KB)\\ |\\ Memory\\ Manager,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Connection\\ Memory\\ (KB)\\ |\\ Memory\\ Manager,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Log\\ Flushes/sec\\ |\\ _Total\\ |\\ Databases,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Log\\ Pool\\ Cache\\ Misses/sec\\ |\\ _Total\\ |\\ Databases,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Log\\ Pool\\ Disk\\ Reads/sec\\ |\\ _Total\\ |\\ Databases,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Log\\ Pool\\ Requests/sec\\ |\\ _Total\\ |\\ Databases,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Wait\\ time\\ (ms),servername=" + databaseName +
                    ",type=Wait\\ stats Buffer=100,CLR=100,I/O=100,Latch=100,Lock=100,Memory=100,Network=100" +
                    ",Service\\ broker=100,Other=100,SQLOS=100,XEvent=100");
            out.println("Wait\\ tasks,servername=" + databaseName +
                    ",type=Wait\\ stats Buffer=100,CLR=100,I/O=100,Latch=100,Lock=100,Memory=100,Network=100," +
                    "Service\\ broker=100,Other=100,SQLOS=100,XEvent=100");
            out.println("Performance\\ metrics,servername=" + databaseName +
                    ",type=Performance\\ metrics Page\\ split\\ per\\ batch\\ request=4000");
            out.println("Performance\\ metrics,servername=" + databaseName +
                    ",type=Performance\\ metrics Sql\\ compilation\\ per\\ batch\\ request=4000");
            out.println("Performance\\ metrics,servername=" + databaseName +
                    ",type=Performance\\ metrics Sql\\ recompilation\\ per\\ batch\\ request=4000");
            out.println("Performance\\ metrics,servername=" + databaseName +
                    ",type=Performance\\ metrics Readahead\\ per\\ page\\ read=4000");
            out.println("CPU\\ (%),servername=" + databaseName +
                    " SQL\\ process=4000");
            out.println("CPU\\ (%),servername=" + databaseName +
                    " External\\ process=4000");
            out.println("Bytes\\ Sent\\ to\\ Replica/sec\\ |\\ _Total\\ |\\ Availability\\ Replica" +
                    ",servername=" + databaseName + ",type=Performance\\ counters value=4000");
            out.println("Bytes\\ Received\\ from\\ Replica/sec\\ |\\ _Total\\ |\\ Availability\\ Replica" +
                    ",servername=" + databaseName + ",type=Performance\\ counters value=4000");
            out.println("Transaction\\ Delay\\ |\\ _Total\\ |\\ Database\\ Replica,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");
            out.println("Transaction\\ Delay\\ |\\ _Total\\ |\\ Database\\ Replica,servername=" + databaseName +
                    ",type=Performance\\ counters value=4000");

            // Flush & Close File
            try { out.flush(); } catch (Exception e){}
            try { out.close(); } catch (Exception e){}
        }

    }

    private static void read(Connection conn, String sql, Map<String, String> result)
            throws SQLException {

        Statement stmt = null;
        ResultSet rs = null;
        try {
            stmt = conn.createStatement();
            rs = stmt.executeQuery(sql);
            while (rs.next()) {
                result.put( rs.getString(1), rs.getString(2) );
            }
        } finally {
            try { rs.close(); } catch (Exception e){}
            try { stmt.close(); } catch (Exception e){}
        }
    }

    private static double percentage(String targetMemory, String usedMemory) {
        try {
            return (Double.parseDouble(usedMemory) / Double.parseDouble(targetMemory));
        } catch (Exception e) {
            e.printStackTrace();
            return 0.00;
        }
    }
    public static void main(String[] args) {
        try {
            String connString = args[0];
            String databaseName = args[1];
            collect(connString, databaseName);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

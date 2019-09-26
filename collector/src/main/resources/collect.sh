
# to install
# */5 * * * * /home/ebridge/github.com/network-monitor/database-monitor/collector/collect.sh
java com.ebridgeai.networkmonitor.collector.DatabaseCollector url IDMS
java com.ebridgeai.networkmonitor.collector.DatabaseCollector url SUNSYS
java com.ebridgeai.networkmonitor.collector.DatabaseCollector url BOABAB
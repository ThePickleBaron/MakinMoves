#!/bin/bash
# System monitoring daemon for MakinMoves

while true; do
  # Get CPU usage (Windows)
  cpu=$(powershell -Command "Get-WmiObject win32_processor | Measure-Object -Property LoadPercentage -Average | Select -ExpandProperty Average" 2>/dev/null || echo "0")
  
  # Get RAM
  ram=$(powershell -Command "$ram = Get-WmiObject win32_operatingsystem; [math]::Round((\$ram.TotalVisibleMemorySize - \$ram.FreePhysicalMemory) / \$ram.TotalVisibleMemorySize * 100, 1)" 2>/dev/null || echo "0")
  
  # Timestamp and log
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo "[$timestamp] CPU: ${cpu}% | RAM: ${ram}%" >> "C:\Users\jsmcl\Documents\MakinMoves\logs\resource_usage.log"
  
  # Sleep 5 minutes
  sleep 300
done

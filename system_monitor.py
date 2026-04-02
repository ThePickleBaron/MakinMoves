#!/usr/bin/env python3
"""
System Resource Monitor for MakinMoves
Tracks CPU, RAM, GPU usage and logs alerts
"""

import psutil
import json
import datetime
import subprocess
from pathlib import Path

# Alert thresholds
THRESHOLDS = {
    "cpu_percent": 75,
    "ram_percent": 80,
    "gpu_percent": 90,
    "disk_percent": 85
}

LOG_FILE = Path("C:\Users\jsmcl\Documents\MakinMoves\logs\resource_usage.json")
STATUS_FILE = Path("C:\Users\jsmcl\Documents\MakinMoves\SYSTEM_STATUS.md")

def get_gpu_usage():
    """Get GPU usage via nvidia-smi"""
    try:
        result = subprocess.run(
            ["nvidia-smi", "--query-gpu=utilization.gpu,utilization.memory", 
             "--format=csv,noheader,nounits"],
            capture_output=True,
            text=True,
            timeout=5
        )
        if result.returncode == 0:
            gpu_util, mem_util = result.stdout.strip().split(", ")
            return float(gpu_util.strip()), float(mem_util.strip())
    except:
        pass
    return None, None

def get_system_stats():
    """Get current system resource stats"""
    cpu_percent = psutil.cpu_percent(interval=1)
    ram = psutil.virtual_memory()
    disk = psutil.disk_usage("C:\\")
    gpu_util, gpu_mem = get_gpu_usage()
    
    return {
        "timestamp": datetime.datetime.now().isoformat(),
        "cpu_percent": cpu_percent,
        "ram_percent": ram.percent,
        "ram_used_gb": ram.used / (1024**3),
        "ram_available_gb": ram.available / (1024**3),
        "disk_percent": disk.percent,
        "gpu_percent": gpu_util,
        "gpu_memory_percent": gpu_mem,
        "process_count": len(psutil.pids())
    }

def check_alerts(stats):
    """Check if any thresholds exceeded"""
    alerts = []
    
    if stats["cpu_percent"] > THRESHOLDS["cpu_percent"]:
        alerts.append(f"⚠️ CPU HIGH: {stats['cpu_percent']:.1f}% (threshold: {THRESHOLDS['cpu_percent']}%)")
    
    if stats["ram_percent"] > THRESHOLDS["ram_percent"]:
        alerts.append(f"⚠️ RAM HIGH: {stats['ram_percent']:.1f}% ({stats['ram_used_gb']:.1f}GB / 128GB used)")
    
    if stats["gpu_percent"] and stats["gpu_percent"] > THRESHOLDS["gpu_percent"]:
        alerts.append(f"⚠️ GPU HIGH: {stats['gpu_percent']:.1f}% (threshold: {THRESHOLDS['gpu_percent']}%)")
    
    if stats["disk_percent"] > THRESHOLDS["disk_percent"]:
        alerts.append(f"⚠️ DISK HIGH: {stats['disk_percent']:.1f}% (threshold: {THRESHOLDS['disk_percent']}%)")
    
    return alerts

def log_stats(stats):
    """Log stats to JSON file"""
    LOG_FILE.parent.mkdir(parents=True, exist_ok=True)
    
    # Load existing logs
    logs = []
    if LOG_FILE.exists():
        try:
            logs = json.loads(LOG_FILE.read_text())
        except:
            logs = []
    
    # Append new stats
    logs.append(stats)
    
    # Keep last 1000 entries
    logs = logs[-1000:]
    
    # Write back
    LOG_FILE.write_text(json.dumps(logs, indent=2))

def update_status_file(stats, alerts):
    """Update human-readable status file"""
    status_lines = [
        "# System Resource Status",
        "",
        f"**Last Updated:** {datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')}",
        "",
        "## Current Usage",
        "",
        f"- **CPU:** {stats['cpu_percent']:.1f}% (threshold: {THRESHOLDS['cpu_percent']}%)",
        f"- **RAM:** {stats['ram_percent']:.1f}% ({stats['ram_used_gb']:.1f}GB / 128GB)",
        f"- **GPU:** {stats['gpu_percent']:.1f if stats['gpu_percent'] else 'N/A'}% (threshold: {THRESHOLDS['gpu_percent']}%)",
        f"- **Disk:** {stats['disk_percent']:.1f}% (threshold: {THRESHOLDS['disk_percent']}%)",
        f"- **Processes:** {stats['process_count']}",
    ]
    
    if alerts:
        status_lines.append("")
        status_lines.append("## 🚨 ALERTS")
        status_lines.append("")
        for alert in alerts:
            status_lines.append(f"- {alert}")
    else:
        status_lines.append("")
        status_lines.append("## ✅ All Systems Normal")
    
    STATUS_FILE.parent.mkdir(parents=True, exist_ok=True)
    STATUS_FILE.write_text("\n".join(status_lines))

if __name__ == "__main__":
    stats = get_system_stats()
    alerts = check_alerts(stats)
    log_stats(stats)
    update_status_file(stats, alerts)
    
    # Print to stdout
    if alerts:
        for alert in alerts:
            print(alert)
    else:
        print(f"✅ System normal - CPU: {stats['cpu_percent']:.1f}%, RAM: {stats['ram_percent']:.1f}%")

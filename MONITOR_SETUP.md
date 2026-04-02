# System Monitoring Active

**Status:** ✅ Live

**Current Thresholds:**
- CPU: Alert at >75%
- RAM: Alert at >80% (>102 GB)
- Disk: Alert at >85%

**Monitoring Method:**
- PowerShell script runs checks periodically
- Logs to: `logs/resource_usage.log`
- Status dashboard: `SYSTEM_STATUS.md` (updated continuously)

**What I'll Do:**
1. Run system check every 5 minutes
2. Log all readings
3. Flag alerts immediately if thresholds exceeded
4. Recommend instance offload if sustained high usage detected
5. Report resource usage at each standup

**Current System State:**
- CPU: 0% (idle)
- RAM: 14.6% (18.7 GB / 128 GB used)
- Disk: 75.8%

---

**Next Actions:**
- Monitor as agents launch
- Flag if CPU/RAM exceeds safe operating range
- Recommend spinning up secondary instance if needed
- Track which roles consuming most resources


# Challenge 06 - Process management - Coach's Guide 

[< Previous Solution](./Solution-05.md) - **[Home](./README.md)** - [Next Solution >](./Solution-07.md)

## Notes & Guidance
1. View the list of your server processes

`student@vm01:~$ ps -ef`

```bash
UID          PID    PPID  C STIME TTY          TIME CMD
root           1       0  0 Apr07 ?        00:00:07 /sbin/init
root           2       0  0 Apr07 ?        00:00:01 [kthreadd]
root           3       2  0 Apr07 ?        00:00:00 [rcu_gp]
root           4       2  0 Apr07 ?        00:00:00 [rcu_par_gp]
root           6       2  0 Apr07 ?        00:00:00 [kworker/0:0H-events_highpri]
root           7       2  0 Apr07 ?        00:00:00 [kworker/0:1-events]
root           9       2  0 Apr07 ?        00:00:00 [mm_percpu_wq]
root          10       2  0 Apr07 ?        00:00:00 [rcu_tasks_rude_]
root          11       2  0 Apr07 ?        00:00:00 [rcu_tasks_trace]
root          12       2  0 Apr07 ?        00:00:07 [ksoftirqd/0]
root          13       2  0 Apr07 ?        00:00:16 [rcu_sched]
root          14       2  0 Apr07 ?        00:00:00 [migration/0]
root          15       2  0 Apr07 ?        00:00:00 [cpuhp/0]
root          16       2  0 Apr07 ?        00:00:00 [kdevtmpfs]
root          17       2  0 Apr07 ?        00:00:00 [netns]
root          18       2  0 Apr07 ?        00:00:00 [inet_frag_wq]
root          19       2  0 Apr07 ?        00:00:06 [kauditd]
root          20       2  0 Apr07 ?        00:00:00 [khungtaskd]
root          21       2  0 Apr07 ?        00:00:00 [oom_reaper]
root          22       2  0 Apr07 ?        00:00:00 [writeback]
root          23       2  0 Apr07 ?        00:00:03 [kcompactd0]
root          24       2  0 Apr07 ?        00:00:00 [ksmd]
root          25       2  0 Apr07 ?        00:00:01 [khugepaged]
root          71       2  0 Apr07 ?        00:00:00 [kintegrityd]
root          72       2  0 Apr07 ?        00:00:00 [kblockd]
...
```

2. How many processes are running on your server

`student@vm01:~$ ps -ef | wc -l`

```bash
121
```

3. View the list of processes in tree format

`student@vm01:~$ pstree`

```bash
systemd─┬─ModemManager───2*[{ModemManager}]
        ├─accounts-daemon───2*[{accounts-daemon}]
        ├─2*[agetty]
        ├─atd
        ├─auoms─┬─auomscollect───14*[{auomscollect}]
        │       └─21*[{auoms}]
        ├─chronyd───chronyd
        ├─cron
        ├─dbus-daemon
        ├─hv_kvp_daemon
        ├─multipathd───6*[{multipathd}]
        ├─networkd-dispat
        ├─omiserver─┬─2*[omiagent───2*[{omiagent}]]
        │           └─omiengine
        ├─omsagent───37*[{omsagent}]
        ├─polkitd───2*[{polkitd}]
        ├─python3───python3───5*[{python3}]
        ├─rsyslogd───3*[{rsyslogd}]
        ├─snapd───8*[{snapd}]
        ├─sshd───sshd───sshd───bash───pstree
        ├─systemd───(sd-pam)
        ├─systemd-journal
        ├─systemd-logind
        ├─systemd-network
        ├─systemd-resolve
        ├─systemd-udevd
        ├─udisksd───4*[{udisksd}]
        └─unattended-upgr───{unattended-upgr}
```

4. Identify if the syslog process is running

`student@vm01:~$ ps -ef | grep syslog`

```bash
message+  1045     1  0 02:17 ?        00:00:00 /usr/bin/dbus-daemon --system --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
syslog    1072     1  0 02:17 ?        00:00:00 /usr/sbin/rsyslogd -n
student   2300  1829  0 02:49 pts/0    00:00:00 grep --color=auto syslog
```

5. Identify the process id (pid) of the syslog

`student@vm01:~$ pgrep syslog`

```bash
1072
```

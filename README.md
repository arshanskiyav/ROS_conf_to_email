Add to scripts named Send_Backup and add to scheduler (every day):

```
/system scheduler add interval=1d name=Send_backup on-event="/system script run Send_Backup" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=apr/14/2025 start-time=01:00:00
```

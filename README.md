Create new script named send_backup and add to scheduler (every day):

```
/system scheduleradd interval=1d name=Send_backup on-event="/system script run Send_Backup" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=apr/14/2025 start-time=01:00:00
```

Don't forget to change your email settings

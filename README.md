Create a new script named send_backup (System->Script) 
Copy the contents from send_backup.rsc to new script 
Change email settings 

Add to scheduler (every day):

```
/system scheduleradd interval=1d name=Send_backup on-event="/system script run Send_Backup" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=apr/14/2025 start-time=01:00:00
```

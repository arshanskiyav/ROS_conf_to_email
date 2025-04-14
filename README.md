Download the script and add to scheduler (every day):

```
/tool fetch url="https://raw.githubusercontent.com/arshanskiyav/ROS_conf_to_email/main/send_backup.rsc" mode=https
/system scheduleradd interval=1d name=Send_backup on-event="/import file-name=send_backup.rsc" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=apr/14/2025 start-time=01:00:00
```

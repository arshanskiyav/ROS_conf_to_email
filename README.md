- Create a new script named send_backup (System->Script)
- Copy the contents from send_backup.rsc to new script
- Change email settings
- Add to scheduler (every day):

```
/system scheduler add interval=1d name=Send_backup on-event="/system script run Send_Backup" policy=ftp,reboot,read,write,policy,test,password,sniff,sensitive,romon start-date=apr/14/2025 start-time=01:00:00
```

Update

Now the script gets the configuration size and writes it to a file. This size will be used for comparison, so as not to save the RSC file in memory. And a block has been added to check the result of sending an email, if sending an email fails, the configuration size will not be updated.

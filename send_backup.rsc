:local smtpServer "smtp.domain.com"
:local smtpPort 587
:local smtpFrom "srvc@domain.com"
:local smtpUser "srvc@domain.com"
:local smtpPassword "SuperSecret"
:local smtpTo "it@domain.com"

:local currentDate ( [:pick [/system clock get date] 4 6] ."_". [:pick [/system clock get date] 0 3] ."_". [:pick [/system clock get date] 7 11])
:local hostname [/system identity get name]
:local newName ("config_" .$currentDate. ".rsc")
:local oldName "config_old.rsc"
:local fBackupName ("backup_" . $currentDate . "_" . $hostname .".backup")
/export file=$newName
:delay 5

:local newSize [/file get $newName size]
:local oldSize 0
:if ([:len [/file find name=$oldName]] > 0) do={
  :set oldSize [/file get $oldName size]
}

:if ($newSize != $oldSize) do={
  /system backup save name=$fBackupName encryption=aes-sha256
  :delay 10
  /tool e-mail send to=$smtpTo subject=("ROS new config: " . $hostname) body="Configuration is changed" file=$fBackupName server=$smtpServer port=$smtpPort from=$smtpFrom user=$smtpUser password=$smtpPassword start-tls=yes
  /export file=$oldName
  :delay 5
}

/file remove [find name~$newName]
/file remove [find name~$fBackupName]

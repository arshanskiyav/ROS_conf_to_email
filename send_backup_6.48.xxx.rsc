:local smtpServer "smtp.domain.com"
:local smtpPort 587
:local smtpFrom "srvc@domain.com"
:local smtpUser "srvc@domain.com"
:local smtpPassword "SuperSecret"
:local smtpTo "it@domain.com"

:local scriptStartTime [/system clock get time]
:local currentDate ( [:pick [/system clock get date] 4 6] ."_". [:pick [/system clock get date] 0 3] ."_". [:pick [/system clock get date] 7 11])
:local hostname [/system identity get name]
:local mailSubject ("ROS new config: " . $hostname)

:local exportFileName ("config_export_" . $currentDate . ".rsc")
:local sizeRecordFile "config_size.txt"
:local ExportBackupName ("backup_" . $currentDate . "_" . $hostname . ".backup")

/export file=$exportFileName
:put ("Exported configuration to file: " . $exportFileName)
:delay 5

:local newSize [/file get $exportFileName size]
:put ("Current config size: " . $newSize)
:local oldSize 0
:if ([:len [/file find name=$sizeRecordFile]] > 0) do={
  :put ("Previous config size: " . [/file get $sizeRecordFile contents])
  :set oldSize [:tonum [/file get $sizeRecordFile contents]]
} else {
  /file print file=$sizeRecordFile
  :delay 3
  /file set $sizeRecordFile contents=$oldSize
  :put "Created new size record file"
}
:put ("Old config size: " . $oldSize)

:if ($newSize != $oldSize) do={
  :put "Configuration size changed, proceeding with backup and email."
  /system backup save name=$ExportBackupName encryption=aes-sha256
  :put ("Backup created: " . $ExportBackupName)
  :delay 10
  :local rosVersion [/system package get number=0 value-name=version]
  :local ipList ""
  :foreach i in=[/ip address print as-value] do={
    :local ip ($i->"address")
    :local comma ", "
    :if ($ipList = "") do={
      :set comma ""
    }
    :set ipList ($ipList . $comma . $ip)
  }
  /tool e-mail send \
    to=$smtpTo \
    subject=$mailSubject \
    body=("Configuration is changed\nVersion: " . $rosVersion . "\nIPs: " . $ipList) \
    file=$ExportBackupName \
    server=$smtpServer port=$smtpPort from=$smtpFrom user=$smtpUser password=$smtpPassword start-tls=yes
  :delay 5
  :local errorCount [:len [/log find where (time > $scriptStartTime and message~$mailSubject and topics~"error")]]
  :if ($errorCount = 0) do={
    :put "Log confirms success. Updating size record."
    /file set $sizeRecordFile contents=$newSize
  } else={
    :put "No log confirmation. Size record not updated."
  }
} else={
  :put "Configuration size unchanged. No action taken."
}

/file remove [find name~$exportFileName]
/file remove [find name~$ExportBackupName]

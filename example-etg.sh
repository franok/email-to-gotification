#!/bin/bash

mailFile=current-mail.txt
absolutePath=/home/path-to-dir
currentMail=$absolutePath/$mailFile

#create and clear file
touch $currentMail
> $currentMail

#read piped data
while read pipedInput ;
  do echo $pipedInput >> $currentMail
done

#grepOutput=$absolutePath/example-notifications/output.txt
#touch $grepOutput

# grep and sed operations
#cat $currentMail | grep -oP 'Subject\:.*Packstation.\d{3}|Sendung.*\d{20}' > $grepOutput



# provide stdout for xfilter, cleanup temp file 'current-mail.txt' and exit 0
cat $currentMail
rm $currentMail
exit 0

#!/bin/bash

mailFile=current-dhl-mail.txt
absolutePath=/home/path-to-dir
currentMail=$absolutePath/$mailFile

#create and clear file
touch $currentMail
> $currentMail

#read piped data
while read pipedInput ;
  do echo $pipedInput >> $currentMail
done

#deliveryId=`cat $currentMail | grep -oP 'Sendung.*\d{20}' | sed 's/Sendung *//g'`
deliveryId=`cat $currentMail | grep -oP 'Sendung.*!*(\d!*){16,}' | sed 's/Sendung\s*//g'`

dhlNotifications=dhl-notifications
if [ ! -d "$dhlNotifications" ]; then
  mkdir $dhlNotifications
fi

#grepOutputFilePath=dhl-notifications/$deliveryId
# if deliveryId is empty use current timeStamp as fileName?
grepOutputFilePath=$dhlNotifications/output.txt
grepOutput=$absolutePath/$grepOutputFilePath
touch $grepOutput
#ToDo: remove this testing code to prevent deletion of existing notification data!!!
echo "resetted output.txt!" > $grepOutput

# grep Packstation Nr.
packstation=`cat $currentMail | grep -oP 'Subject\:.*Packstation.\d{3}' | sed 's/[a-zA-Z: *]//g'`

# grep mTAN
#cat $currentMail | grep -oP 'Subject:.*mTAN.*Packstation_Sendung|mTAN.*lautet.*\d{4}' >> $grepOutput
# https://askubuntu.com/a/538766 for regex '(?<!\d)\d{4}(?!\d)'
mTAN=`cat $currentMail | grep -oP 'mTAN.*lautet.*\d{4}' | grep -oP '(?<!\d)\d{4}(?!\d)'`

# Todo: if packstation not empty printf, >>
if [[ ! -z "$packstation" ]]; then
  printf "Packstation: $packstation\n" >> $grepOutput
  #>> $grepOutput
fi

if [[ ! -z "$mTAN" ]]; then
  printf "mTAN: $mTAN\n" >> $grepOutput
fi



messageBody=`cat $grepOutput`
# ToDo: replace test-app with real one and remove token (do not commit in git!)
curl -X POST "https://my.gotify.server/message?token=<gotify_app_token>" -F "title=dhl-mTAN-etg" -F "message=${messageBody}"

#echo "hi ${messageBody}"


# provide stdout and exit 0 to ensure maildrop xfilter delivers the email!
cat $currentMail
rm $currentMail
exit 0

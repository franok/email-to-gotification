# email-to-gotification (etg)

etg is a service that works like an email-to-sms gateway but instead of sms a gotify notification is received

## Setup

### Gotify Server on U7
Works only on Uberspace 7:
https://sebastian-doering.net/linux/gotify-server-auf-uberspace/

https://gotify.net/docs/

### Install Gotify for Android

...and connect to https://my.gotify.server


### call etg in maildrop

use maildrop xfilter
https://www.courier-mta.org/maildropfilter.html#xfilter


```
# To mail@mydomain.de
if (/^To:.*mail@mydomain\.de>*/:h || /^X-RECIPIENT:.*mail@mydomain\.de/:h)
{
  xfilter "/home/path-to-dir/example-etg.sh"
  #system `curl -X POST "https://my.gotify.server/message?token=xxxxxxxx" -F "title=new mail received" -F "message=message from test-app"`

  DESTDIR="$MAILDIR"
}
```


## Testing

### grep/sed regex test statements

Sendungsnummer
```
echo "some Sendung   0034123456789123456 has arrived" | grep -oP 'Sendung.*!*(\d!*){16,}' | sed 's/Sendung\s*//g'
```

Packstation
```
echo "Subject: Ihre Sendung liegt in Packstation 801 (WDF)" | grep -oP 'Subject\:.*Packstation.\d{3}' | sed 's/[a-zA-Z: *]//g'
```

mTAN
```
echo "die mTAN (Abholcode) f&#252;r Ihre Sendung 00340434137892583363 lautet <b>1234</b>" | grep -oP 'mTAN.*lautet.*\d{4}' | grep -oP '(?<!\d)\d{4}(?!\d)'
```


### integration test
```
cat mail-examples/mailbody | ./dhl-mTAN-etg.sh > /dev/null
```

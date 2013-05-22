#!/bin/bash
. ../source_all


send_mail "This is the subject" amnon@flowsoft.co.il << EOF
This is a test message

Bla Bla
EOF

set_mailfrom blabla@flowsoft.co.il

send_mail "This is the subjecs" amnon@flowsoft.co.il << EOF
This is a test message from blabla!

Bla Bla
EOF

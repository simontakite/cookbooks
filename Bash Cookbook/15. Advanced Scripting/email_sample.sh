# cookbook filename: email_sample

# Define some mail settings. Use a case statement with uname or hostname
# to tweak settings as required for your environment.
case $HOSTNAME in
    *.company.com     ) MAILER='mail'   ;;  # Linux and BSD
    host1.*           ) MAILER='mailx'  ;;  # Solaris, BSD and some Linux
    host2.*           ) MAILER='mailto' ;;  # Handy, if installed
esac
RECIPIENTS='recipient1@example.com recipient2@example.com'
SUBJECT="Data from $0"

[...]
# Create the body as a file or variable using echo, printf, or a here-document
# Create or modify $SUBJECT and/or $RECIPIENTS as needed
[...]

( echo $email_body ; uuencode $attachment $(basename $attachment) ) \
  | $MAILER -s "$SUBJECT" "$RECIPIENTS"

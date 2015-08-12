import mail

## It is important to fill in the following
## information about the account you want the
## emails to be sent from.

mail.gmail_user = ""
mail.gmail_pwd = ""

## Choose a subject

subject = "this is the subject!"

## Choose the content of the email

content = \
"""Hi,

How are you?
"""

def send_mail():
      
    f = open("email_addresses.txt", "r")

    for address in f:
        address = address.replace("\n","")   
        mail.mail(address, subject, content)       

    f.close()
    
def main():
    ## Call the send mail function
    send_mail()

if __name__ == "__main__":
    main()
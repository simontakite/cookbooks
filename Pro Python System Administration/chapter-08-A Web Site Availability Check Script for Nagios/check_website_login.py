#!/usr/bin/env python

import sys
import urllib2, urllib
import time
from BeautifulSoup import BeautifulSoup
from optparse import OptionParser

NAGIOS_OK = 0
NAGIOS_WARNING = 1
NAGIOS_CRITICAL = 2
WEBSITE_LOGON  = 'https://auth.telegraph.co.uk/sam-ui/login.htm'
WEBSITE_LOGOFF = 'https://auth.telegraph.co.uk/sam-ui/logoff.htm'
WEBSITE_USER = '****@****'
WEBSITE_PASS = '****'

def test_logon_logoff():
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor())
    urllib2.install_opener(opener)
    data = urllib.urlencode({'email': WEBSITE_USER, 'password': WEBSITE_PASS})
    status = []
    try:
        result = opener.open(WEBSITE_LOGON, data)
        html_logon = result.read()
        result.close()
        result = opener.open(WEBSITE_LOGOFF)
        html_logoff = result.read()
        result.close()
        soup_logon = BeautifulSoup(html_logon)
        soup_logoff = BeautifulSoup(html_logoff)
        if len(soup_logon.findAll('span', 'subText')) == 1 and len(soup_logoff.findAll('span', 'subText')) == 0:
            status = [NAGIOS_OK, 'Logon/logoff operation']
        else:
            status = [NAGIOS_CRITICAL, 'ERROR: Failed to logon and then logoff to the web site']
    except:
        status = [NAGIOS_CRITICAL, 'ERROR: Failure in the logon/logoff test']
    return status


def main():
    parser = OptionParser()
    parser.add_option('-w', dest='time_warn', default=3.8, help="Warning threshold in seconds, defaul: %default")
    parser.add_option('-c', dest='time_crit', default=5.8, help="Critical threshold in seconds, default: %default")
    (options, args) = parser.parse_args()
    if float(options.time_crit) < float(options.time_warn):
        options.time_warn = options.time_crit
    start = time.time()
    code, message = test_logon_logoff()
    elapsed = time.time() - start
    if code != 0:
        print message
        sys.exit(code)
    else:
        if elapsed < float(options.time_warn):
            print "OK: Performed %s sucessfully in %f seconds" % (message, elapsed)
            sys.exit(NAGIOS_OK)
        elif elapsed < float(options.time_crit):
            print "WARNING: Performed %s sucessfully in %f seconds" % (message, elapsed)
            sys.exit(NAGIOS_WARNING)
        else:
            print "CRITICAL: Performed %s sucessfully in %f seconds" % (message, elapsed)
            sys.exit(NAGIOS_CRITICAL)


if __name__ == '__main__':
    main()

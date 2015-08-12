import sys, urllib

to_search_list = []
searched_list = []
email_list = []

def download(max_iterations):

    iteration = 1
    while iteration <= int(max_iterations):

        print iteration

        ## We reached a dead end if there are no
        ## more sites in our to_search_list

        if len(to_search_list) == 0:
            print "dead url end"
            break

        ## Get the first URL from the list of the URLs
        ## we need to crawl over, and place it in the list
        ## of URLs that we already crawled.

        first_url = to_search_list[0]
        to_search_list.remove(first_url)
        searched_list.append(first_url)

        ## A simple function using urllib to download
        ## a URL

        def download_url(url):
            return urllib.urlopen(url)

        ## Try to download the URL. In case of an error,
        ## forget about it and move on to the next URL.

        try:
            content = download_url(first_url)
        except:
            try:
                content = download_url(first_url)
            except:
                iteration += 1
                continue

        for line in content:

            ## Find more URLs
            import re
            
            ## The regular expression we will use to search for URLs:
            url_expression= r"http://+[\w\d:#@%/;$()~_?\+-=\\\.&]*"
            regex = re.compile(url_expression)
            
            ## Find all the URLs and 
            
            results = regex.findall(line)
            if results:
                for result in results:

            ## If the URL is new, add it to the list
            ## of URLs we need to crawl over.
                    if result not in searched_list:
                        to_search_list.append(result)
            
            ## Find email addresses
            
            ## The regular expression we will use to search for email 
            ## addresses. For more information on this, have a look at
            ## the "validating-email" example.
            
            email_expression = r"\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,6}"
            eregex = re.compile(email_expression)
            
            ## Find all the email addresses
            e_results = eregex.findall(line)
            if e_results:
                for e_result in e_results:
                    
            ## If the email address is new, add it to
            ## our email list.
                    if e_result not in email_list:
                        email_list.append(e_result)
                    
        iteration += 1


def output_results():

    ## This function will print the following information: 
    ## number of sites in our sites to crawl list, the number
    ## of sites we actually crawled, and the total number of
    ## emails collected.

    print "number of sites to search: %s" % len(to_search_list)
    print "number of sites searched: %s" % len(searched_list)
    print "number of emails collected: %s" % len(email_list)

def write_results():

    ## Write all the information that the 
    ## output_results() function prints out (see above)
    ## into a file called "info.txt"

    info_file_name = "info.txt"
    i = open("info.txt", "w")     ## create the file
    i.write("number of sites to search: %s \n" % len(to_search_list))
    i.write("number of sites searched: %s \n" % len(searched_list))
    i.write("number of emails collected: %s \n" % len(email_list))
    i.close()

    ## Write down all the emails collected into a file called
    ## "email_addresses.txt". We will use this file in the next
    ## part of this example.

    file_name = "email_addresses.txt"
    n = open(file_name, "w")
 
    for email in email_list:
        entry = email + "\n"
        n.write(entry)

    n.close()

def get_input():

    ## Gather input from the user using sys.argv

    try:
        start_url = sys.argv[1]
        iterations = sys.argv[2]
    except:
        raise Exception("\n\nSorry, invalid input. Please enter two arguments: the website URL to start from, and the number of sites to crawl.\n")

    return start_url, iterations

def main():

    start_url, iterations = get_input()
    to_search_list.append(start_url)

    download(iterations)
    output_results()
    write_results()

    
if __name__ == "__main__":
    main()

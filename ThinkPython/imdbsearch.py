# Importing the modules
from BeautifulSoup import BeautifulSoup
import sys
import urllib2
import re
import json

def search_movie(title): #, year):
        
    # Search for spaces in the title string
    raw_string = re.compile(r' ')
      
    # Replace spaces with a plus sign
    searchstring = raw_string.sub('+', title)
      
    # Prints the search string
    print searchstring
      
    # The actual query
    url = "http://www.imdbapi.com/?t=" + searchstring #+ "&y=" + year
    request = urllib2.Request(url)
    response = json.load(urllib2.urlopen(request))
    movie = []
    movie = json.dumps(response, indent=2)
    print movie.index('Plot')
    
#===============================================================================
#    {
#  "Plot": "A seventeen-year-old aristocrat, expecting to be married to a rich claimant by her mother, falls in love with a kind but poor artist aboard the luxurious, ill-fated R.M.S. Titanic.", 
#  "Rated": "PG-13", 
#  "Title": "Titanic", 
#  "Poster": "http://ia.media-imdb.com/images/M/MV5BMjExNzM0NDM0N15BMl5BanBnXkFtZTcwMzkxOTUwNw@@._V1_SX300.jpg", 
#  "Writer": "James Cameron", 
#  "Response": "True", 
#  "Director": "James Cameron", 
#  "Released": "19 Dec 1997", 
#  "Actors": "Leonardo DiCaprio, Kate Winslet, Billy Zane, Kathy Bates", 
#  "Year": "1997", 
#  "Genre": "Drama, Romance", 
#  "Runtime": "3 h 14 min", 
#  "Type": "movie", 
#  "imdbRating": "7.6", 
#  "imdbVotes": "449,162", 
#  "imdbID": "tt0120338"
# }
#===============================================================================
    

    
def get_movie():
    # Ask for movie title
    title = raw_input("Please enter a movie title: ")
      
    # Ask for which year
    # year = raw_input("which year? ")
    search_movie(title) #, year)

get_movie()
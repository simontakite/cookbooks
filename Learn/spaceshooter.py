import pygame
import random
 
# Initialize the game engine
pygame.init()
 
black = [ 0, 0, 0]
white = [255, 255, 255]
 
# Set the height and width of the screen
size = [400, 400]
screen = pygame.display.set_mode(size)
pygame.display.set_caption("Space Shooter 1.0")
 
# Create an empty array
star_list = []
 
# Loop 50 times and add a star in a random x,y position    
for i in range(80):
    x = random.randrange(0, 400)
    y = random.randrange(0, 400)
    star_list.append([x, y])
 
clock = pygame.time.Clock()
 
# Loop until the user clicks the close button.
done = False
while done == False:
 
    for event in pygame.event.get():  # User did something
        if event.type == pygame.QUIT:  # If user clicked close
            done = True  # Flag that we are done so we exit this loop
 
    # Set the screen background
    screen.fill(black)
 
    # Process each star in the list
    for i in range(len(star_list)):
        # Draw the star
        pygame.draw.circle(screen, white, star_list[i], 2)
         
        # Move the star down one pixel
        star_list[i][1] += 1
         
        # If the star has moved off the bottom of the screen
        if star_list[i][1] > 400:
            # Reset it just above the top
            y = random.randrange(-50, -10)
            star_list[i][1] = y
            # Give it a new x position
            x = random.randrange(0, 400)
            star_list[i][0] = x
             
    # Go ahead and update the screen with what we've drawn.
    pygame.display.flip()
    clock.tick(20)
             
# Be IDLE friendly. If you forget this line, the program will 'hang'
# on exit.
pygame.quit ()

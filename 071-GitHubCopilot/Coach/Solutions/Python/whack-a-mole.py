# You need to install pygame to run this code. You can install it using pip install pygame
import pygame
import random
import time

pygame.init()

# Screen dimensions and colors (assuming these are defined)
screen_width = 800
screen_height = 600
screen = pygame.display.set_mode((screen_width, screen_height))
black = (0, 0, 0)
red = (255, 0, 0)
white = (255, 255, 255)

# Mole and game settings
mole_width = 100
mole_height = 100
border_thickness = 2
score = 0
font = pygame.font.SysFont(None, 55)
score_height = 100  # Space at the top for the score
grid_rows = 4
grid_columns = 4
mole_visible_duration = 5  # Duration in seconds for how long the mole should be visible

# Calculate total grid size and starting positions
total_grid_width = grid_columns * mole_width
total_grid_height = grid_rows * mole_height
start_x = (screen_width - total_grid_width) // 2
start_y = ((screen_height - total_grid_height) // 2) 

# Generate centered mole hole positions with space for the score
mole_holes = []
for row in range(grid_rows):
    for col in range(grid_columns):
        x = start_x + col * mole_width
        y = start_y + row * mole_height
        mole_holes.append((x, y))

# Randomly select a mole position
mole_position = random.choice(mole_holes)
mole_visible_start = pygame.time.get_ticks()  # Record the current time in milliseconds

def show_score(x, y):
    score_display = font.render(f"Score: {score}", True, black)
    screen.blit(score_display, (x, y))

def draw_mole_hole_borders():
    for position in mole_holes:
        pygame.draw.rect(screen, black, (position[0] - border_thickness, position[1] - border_thickness, mole_width + 2 * border_thickness, mole_height + 2 * border_thickness), 1)

def draw_mole(position):
    if position is not None:
        pygame.draw.ellipse(screen, red, (position[0], position[1], mole_width, mole_height))

def game_over_text():
    over_text = font.render("GAME OVER", True, black)
    screen.blit(over_text, (screen_width / 2 - 100, screen_height / 2))

# Main game loop
running = True
last_mole_time = pygame.time.get_ticks()  # Initialize last_mole_time to start the game
game_over = False

while running:
    screen.fill(white)
    current_time = pygame.time.get_ticks()
    
    if not game_over:
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False
            elif event.type == pygame.MOUSEBUTTONDOWN:
                x, y = event.pos
                if mole_position[0] <= x <= mole_position[0] + mole_width and mole_position[1] <= y <= mole_position[1] + mole_height:
                    score += 1
                    mole_position = random.choice(mole_holes)
                    last_mole_time = pygame.time.get_ticks()

        # Check if the mole has been visible for longer than the duration and hide it
        if mole_visible_start is not None and (current_time - mole_visible_start) > mole_visible_duration * 1000:
            mole_position = random.choice(mole_holes)  # Choose a new mole position
            mole_visible_start = pygame.time.get_ticks()  # Reset the timer

        draw_mole_hole_borders()
        draw_mole(mole_position)
        show_score(10, 10)  # Adjust score position as needed

        # Check for game over condition
        if current_time - last_mole_time > 10000:
            game_over = True
    else:
        # Display game over message
        game_over_text = font.render("GAME OVER", True, black)
        screen.blit(game_over_text, (screen_width / 2 - 100, screen_height / 2))
        for event in pygame.event.get():
            if event.type == pygame.QUIT:
                running = False

    pygame.display.update()

pygame.quit()
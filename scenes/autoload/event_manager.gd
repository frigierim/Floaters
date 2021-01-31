extends Node

# Game flow events ################################################################################################

signal new_game()
signal continue_game()

signal abandon_game()

# After you won
signal round_complete()

# After you lost
signal round_restart()

signal game_complete()

signal game_over()

signal pause_game()
signal resume_game()

signal change_volume(volume)
signal volume_slider_released()

# In Game events #################################################################################################

# Ship changed speed (Vector2)
signal changed_speed(newSpeed)

signal changed_position(newOffset)

# Spaceship confirmed collected floater
signal floater_collected()

# floater indicates it's been hit by area with id
signal floater_hit(id, floater) 

# rock hit item with id
signal rock_hit(id)

# energy level reached 0
signal energy_exhausted()

# HUD  events ###################################################################################

# A new floater was added to the game, or one was collected
signal floater_num_changed()

signal energy_changed()

# Scene changer events - unused ###################################################################################

# Emitted when a scene loses control
signal scene_left()

# Emitted by the entering scene when it is ready to display - this is required or SceneChanger will wait forever
signal scene_ready()

# Emitted after scene is ready to configure scene parameters
signal scene_setup(params)

# Emitted when a scene gets control
signal scene_entered()


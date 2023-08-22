extends Node

@onready var first_jam_info = true
@onready var first_custscene = true

@onready var IN_MENU = true

@onready var restart_game = false

# player_life_count is used when shooting body parts out, max_life_count goes up with books collected and down with damage
@onready var player_life_count = 2 # 0 is final life
@onready var max_life_count = 2 
@onready var PLAYER_RIGID_BOODY = false # true when player is a rigid body (when right-click)

@onready var player_node
@onready var main_node 

@onready var need_to_reload_player = false

## Camera shakes ##
@onready var hit_camera_shake_intensity = 40
@onready var player_impact_camera_shake_intensity = 10

@onready var freeze_frame_delay = 20

## Settings ##
@onready var freeze_frame_enabled = true

@onready var volume = 0
@onready var music_volume = 0

@onready var mute_music = false
@onready var mute_sfx = false

@onready var enemies_in_play = 0
@onready var buildings_till_life = 10


## Levels ##
@onready var current_level = 0


func _ready():
	pass


###############################################

## Saves ##
@onready var save_player_pos

func save_position(pos):
	save_player_pos = pos
func get_saved_position():
	if save_player_pos == null: return Vector2.ZERO
	return save_player_pos


###############################################

## Score ##
@onready var buildings_destroyed = 1
@onready var enemies_killed = 0
@onready var king_alive = true
@onready var all_score = 0


func get_score():
	all_score = buildings_destroyed + enemies_killed
	return all_score

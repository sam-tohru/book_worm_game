extends Node

signal menu_screen
signal spawn_king_cutscene
signal remove_king_cutscene
signal remove_king_cutscene_main
signal music_volume_changed

signal sfx_woosh
signal sfx_collapse
signal sfx_punch
signal sfx_grunt
signal sfx_battle_done
signal sfx_firework
signal fight_animation

signal screen_shake
signal hit_effect

signal spawn_head_shot
signal spawn_body_shot
signal shoot_behind
signal new_head_chain

signal block_player_body

signal remove_current_player
signal find_player
signal enemy_attack_timer
signal enemy_state_change
signal player_hit_enemy
signal hit_player
signal player_death
signal leader_board_scene
signal remove_menu
signal player_won_animation

signal spawn_enemy
signal spawn_book
signal kill_rigids

signal animation_hit_marker
signal damaged_player_body

signal explode_body
signal explosion
signal player_explosion_mechanic
signal king_death
signal king_death_cutscene_done
signal remove_win_cutscene
signal king_death_cutscene_over
signal king_awoken
signal building_random_frame

signal rigid_to_character
signal face_open
signal face_eat
signal face_eat_book

signal new_life
signal debug_teleport
signal change_level

signal oof_play

func _ready():
	pass
	

func get_player(caller):
	pass
	
	globs.emit_signal('find_player', caller)
	
	# Signal to
	# how to get back then?
	# get_player -> signal player [with node that called?] -> signal back to node that called [with player node now] 

func calculateAngle(previous_segment: Node2D, current_segment: Node2D) -> float:
	var previous_global = previous_segment.get_global_transform()
	var current_global = current_segment.get_global_transform()
	
	# Calculate the vector between the two segments
	var vector = (previous_global.origin - current_global.origin).normalized()
	
	# Calculate the angle of the vector
	var angle = atan2(vector.y, vector.x)
	
	return angle


func restart_game():
	
	globvars.buildings_destroyed = 0
	globvars.enemies_killed = 0
	globvars.all_score = 0 
	globvars.enemies_in_play = 0
	
	
	globvars.IN_MENU = true
	globvars.player_life_count = 0
	globvars.restart_game = false
	
	emit_signal('change_level', 0)
	
	await get_tree().create_timer(0.4).timeout
	get_tree().reload_current_scene()

func freeze_frame():
	if globvars.freeze_frame_enabled == false: return
	OS.delay_msec(globvars.freeze_frame_delay)

func slow_time(slow, time):
	Engine.time_scale = slow
	await get_tree().create_timer(time * slow).timeout
	Engine.time_scale = 1
func set_slo_mo(go_to: bool, slow):
	if go_to: Engine.time_scale = slow
	else: Engine.time_scale = 1


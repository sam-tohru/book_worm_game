extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group('enemy') and !get_parent().is_in_group('player_body'):
		globs.emit_signal('player_hit_enemy', body)
		
	
	if get_parent().is_in_group('character_player'): # Player Controlling can pick-up lives
		if body.is_in_group('block_player_body'): globs.emit_signal('block_player_body')
		
		globs.emit_signal('screen_shake', globvars.player_impact_camera_shake_intensity)
		if body.is_in_group('player'): return
		
		
		if body.is_in_group('enemy'):
			globs.emit_signal('player_hit_enemy', body)
			globs.emit_signal('face_eat')
		
		if body.is_in_group('body'):
			
			if body.cant_pickup or globvars.player_life_count >= 2: return
			# Remove
			body.queue_free()
			# Add 
			globs.emit_signal('new_head_chain', true, get_parent())


func _on_area_entered(area):
	if get_parent().is_in_group('character_player'): # Player Controlling can pick-up lives
		globs.emit_signal('screen_shake', globvars.player_impact_camera_shake_intensity)

func check_if_in_main_area():
	var found = false
	if !self.has_overlapping_areas(): globs.emit_signal('debug_teleport')
	for area in self.get_overlapping_areas():
		if area.is_in_group('debug_area'): found = true ; return
	
	if found == false: globs.emit_signal('debug_teleport')

func _on_bug_area_timer_timeout():
	check_if_in_main_area()

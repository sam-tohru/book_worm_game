extends CharacterBody2D

@onready var min_speed = 10
@onready var max_speed = 350
@onready var deceleration = 250

@onready var sprite_2d = $Sprite2D # Main Head Sprite
@onready var aim_arrow = $Sprite2D/aim_arrow

@onready var pin_joint_2d = $PinJoint2D
@onready var shoot_marker = $shoot_marker

@onready var head2_bodies = [$pivot_1/player_body]
@onready var head3_bodies = [$pivot_1/player_body, $pivot_1/player_body/pivot_2/player_body2]
@onready var tweens = []

@onready var pivot_points = [$pivot_1, $pivot_1/player_body/pivot_2]

@onready var invulnerable = true # can't die when spawned in, on inv_timer
@onready var button_held = false

# Called when the node enters the scene tree for the first time.
func _ready():
	globvars.player_node = self
	globs.remove_current_player.connect(destroy_self)
	globs.hit_player.connect(hit_player)
	globs.explode_body.connect(explode_body)
	


func destroy_self():
	globvars.player_node = null
	self.queue_free()

@onready var tail_clamp_reverse = false
func mouse_pos_comapre():
	if get_global_mouse_position().x < position.x: tail_clamp_reverse = true
	else: tail_clamp_reverse = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if globvars.IN_MENU: return
	
	mouse_pos_comapre()
	
	## Clicks -> Attacks ##
	## Just pressed -> slow mo to aim? | Released -> shoot 
	## Hold Click
	if Input.is_action_just_pressed("click_left") or Input.is_action_just_pressed("click_right"): 
		aim_tween(true)
		button_held = true 
		globs.set_slo_mo(true, 0.3) 
		return
	elif Input.is_action_just_released("click_left") and button_held: # left_click Shoots body
		aim_tween(false)
		shoot_body()
		globs.set_slo_mo(false, 1.0) 
		button_held = false
		if globvars.player_life_count > 0: globs.emit_signal('sfx_woosh')
		return
	elif Input.is_action_just_released("click_right") and button_held: # rich_click Shoots head
		aim_tween(false)
		shoot_head()
		button_held = false  
		globs.set_slo_mo(false, 1.0)
		globs.emit_signal('sfx_woosh')
		return
	
	
	## Movement ##
	var direction = (get_global_mouse_position() - self.global_position).normalized()
	self.rotation = direction.angle()
	
	if Input.is_action_pressed('skip'):
		velocity = velocity.lerp((direction * max_speed), deceleration * delta)
	else:
		velocity = velocity.lerp((direction * min_speed), deceleration * delta)
		
	move_and_collide(velocity * delta)
	# if collision_info: velocity = velocity.bounce(collision_info.get_normal())

func snake_movement(): # Slight delay with rotation using tweens
	var body_list = head3_bodies
	
	match globvars.player_life_count:
		2: body_list = head3_bodies
		1: body_list = head2_bodies
		0: return
	
	if !is_instance_valid(body_list[0]) or body_list[0] == null: return
	
	var target_rotation = rotation_degrees
	var previous_rotation = body_list[0].rotation_degrees
	var i = 0
	for body in body_list:
		# Random offset pos
		
		
		var tween = create_tween()
		var current_rotation = body.rotation_degrees
		target_rotation = lerp_angle(target_rotation, previous_rotation, 0.2)
		if tail_clamp_reverse && body.is_in_group('pivot_1'): target_rotation = clampf(target_rotation, 0, 0)
		else: target_rotation = clampf(target_rotation, -60, 60)
		
		tween.tween_property(pivot_points[i], "rotation_degrees", target_rotation, 0.2)
		previous_rotation = current_rotation
		
		i += 1

func shoot_body():
	if globvars.player_life_count <= 0: return
	## Shoots the last body out in direction of mouth
	
	## New body and impulse
	globs.emit_signal('spawn_body_shot', self.rotation, shoot_marker.global_position, self)

func shoot_head():
	
	## What does it do to connected bodies?
	
	## Goes to main & original head
	globs.emit_signal('spawn_head_shot', self)


func _on_snake_timer_timeout():
	snake_movement()


##########################################################

### HEALTH ###
func hit_player(caller):
	if !invulnerable: 
		if globvars.player_life_count == 0: player_death()
		else: 
			globs.freeze_frame()
			globs.emit_signal('screen_shake', globvars.hit_camera_shake_intensity)
			globs.emit_signal('new_head_chain', false, self)
			globs.emit_signal('damaged_player_body', head2_bodies[globvars.player_life_count-1])

func player_death():
	# Animation
	globs.emit_signal('player_death', self)

func _on_inv_timer_timeout():
	invulnerable = false

func explode_body(body, pos):
	if body != self: return
	
	if !invulnerable: 
		if globvars.player_life_count == 0: player_death()
		else: 
			globs.freeze_frame()
			globs.emit_signal('screen_shake', 75)
			# globs.emit_signal('new_head_chain', false, self)
			#globs.emit_signal('damaged_player_body', head2_bodies[globvars.player_life_count-1])
			globs.emit_signal('player_explosion_mechanic', self, pos)
	

#########################################################
@onready var aim_tween_playing = false

func aim_tween(turn_on):
	
	# aim_arrow
	var tween = create_tween()
	if turn_on && aim_tween_playing != true:
		aim_tween_playing = true
		tween.tween_property(aim_arrow, "visible", true, 0.0)
		tween.tween_property(aim_arrow, "skew", 0, 0.05)
	else: 
		aim_tween_playing = false
		aim_arrow.visible = false
		aim_arrow.skew = -89.9

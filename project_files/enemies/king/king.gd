extends CharacterBody2D


@onready var SPEED = 300.0

@onready var player

@onready var randomnum
@onready var target
@onready var attack_timer = $attack_timer
@onready var special_cooldown = $special_cooldown
@onready var sword_body = $sword_body

@onready var attack_animation_playing = false
@onready var special_attack_playing = false
@onready var spec_attack_on_cooldown = false

@onready var special_attack_chance = 1

@onready var particles_swing = $sword_body/particles_swing

@onready var blood = preload("res://resources/particles/parts_blood.tscn")

@onready var lives = 2
@onready var invulnerable = false
@onready var inv_timer = $inv_timer



enum {
	SURROUND,
	ATTACK,
	HIT,
}

@onready var state = SURROUND
@export var FROZEN: bool = true
func _ready():
	globs.explode_body.connect(explode_body)
	globs.enemy_attack_timer.connect(enemy_attack_timer)
	globs.enemy_state_change.connect(enemy_state_change)
	globs.player_hit_enemy.connect(player_hit_enemy)
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()
	target = get_circle_position(randomnum)
	special_attack_chance = randi_range(1, 25)

func explode_body(body, pos):
	if body != self: return
	
	damage_enemy()

func _physics_process(delta):
	if globvars.main_node == null: return
	if FROZEN: return
	player = globvars.player_node
	if !is_instance_valid(player) or player == null: return
	
	var direction = player.global_position - global_position
	look_at(global_position + direction)
	
	if special_attack_playing: # How to move during spec?
		move(player.global_position, delta * 1.2)
		return
	if spec_attack_on_cooldown: # Can't move after [Melee]
		return
	
	match state:
		SURROUND: 
			move(get_circle_position(randomnum), delta)
		
		ATTACK: # Move toward player to Hit or Special
			if !attack_animation_playing and !special_attack_playing:
				if !spec_attack_on_cooldown: special_attack()
				else: normal_attack()
		
		HIT: # Normal Hit Animation
			# move(player.global_position, delta)
			## Attack animation
			if !attack_animation_playing and !special_attack_playing:
				if !spec_attack_on_cooldown: special_attack()
				else: normal_attack()


func move(target, delta):
	var direction = (target - global_position).normalized()
	var desired_velocity = direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	move_and_slide()

func get_circle_position(random):
	if player == null: return
	var kill_circle_centre = player.global_position
	var radius = 50
	var angle = random * PI * 2
	var x = kill_circle_centre.x + cos(angle) * radius
	var y = kill_circle_centre.y + sin(angle) * radius
	
	return Vector2(x, y)

func enemy_state_change(caller, go_to):
	if caller != self: return
	
	match go_to:
		'SURROUND': state = SURROUND
		'ATTACK': state = ATTACK
		'HIT': state = HIT

func enemy_attack_timer(caller, turn_on):
	if caller != self: return
	
	if turn_on: attack_timer.start()
	else: attack_timer.stop()
func _on_attack_timer_timeout():
	state = ATTACK


##############################################################################

func player_hit_enemy(caller): # Spawns blood here & dies
	if caller != self: return
	
	if invulnerable: return
	
	var blood_instance = blood.instantiate()
	get_tree().current_scene.add_child(blood_instance)
	blood_instance.global_position = global_position
	globs.emit_signal('sfx_grunt')
	globs.slow_time(0.3, 0.1)
	
	if lives >= 0:
		if invulnerable: return
		lives -= 1
		invulnerable = true
		inv_timer.start()
		return
	
	globvars.king_alive = false
	if is_instance_valid(sword_body): sword_body.queue_free()
	globs.emit_signal('oof_play')
	await get_tree().create_timer(1.6).timeout
	globs.emit_signal('king_death')
	self.queue_free()

func damage_enemy():
	var blood_instance = blood.instantiate()
	get_tree().current_scene.add_child(blood_instance)
	blood_instance.global_position = global_position
	globs.emit_signal('sfx_grunt')
	
	if lives >= 0:
		if invulnerable: return
		lives -= 1
		invulnerable = true
		inv_timer.start()
		return
	
	globvars.king_alive = false
	
	
	await get_tree().create_timer(1.0).timeout
	globs.emit_signal('king_death')
	self.queue_free()

func _on_sword_body_body_entered(body):
	if body.is_in_group('player'):
		globs.emit_signal('sfx_punch')
		globs.emit_signal('hit_player', self)
		globs.emit_signal('animation_hit_marker', $sword_body/hit_marker.global_position)
		

##############################################################################

### Abilities ###

func special_attack():
	var rot_orig = 44
	# Spin 
	change_special_attack_playing(true)
	var tween = create_tween()
	# Pull / Setup
	tween.tween_property(sword_body, 'rotation_degrees', 0, 0.1)
	
	# Spin
	tween.tween_property(particles_swing, 'visible', true, 0.0)
	tween.tween_property(self, 'rotation_degrees', self.rotation_degrees+5000, 4.0)
	tween.tween_property(particles_swing, 'visible', false, 0.0)
	tween.parallel().tween_property(sword_body, 'rotation_degrees', rot_orig, 0.1)
	tween.tween_callback(change_special_attack_playing.bind(false))
	tween.tween_callback(spec_cooldown)
func spec_cooldown():
	spec_attack_on_cooldown = true
	special_cooldown.start()

func normal_attack():
	
	var rot_orig = 44
	var rot_pull = 66
	var rot_swing = -62
	
	change_attack_animation_playing(true)
	
	var tween = create_tween()
	# Pull
	tween.tween_property(self, 'rotation_degrees', self.rotation_degrees+15, 0.1)
	tween.parallel().tween_property(sword_body, 'rotation_degrees', rot_pull, 0.1)
	tween.tween_property(particles_swing, 'visible', true, 0.0)
	
	# Swing
	tween.tween_property(sword_body, 'rotation_degrees', rot_swing, 0.1)
	tween.parallel().tween_property(self, 'rotation_degrees', self.rotation_degrees-25, 0.1)
	
	# Back
	tween.tween_property(particles_swing, 'visible', false, 0.0)
	tween.tween_property(self, 'rotation_degrees', self.rotation_degrees+25, 0.4)
	tween.parallel().tween_property(sword_body, 'rotation_degrees', rot_orig, 0.4)
	tween.tween_callback(change_attack_animation_playing.bind(false))

func change_attack_animation_playing(go_to:bool):
	attack_animation_playing = go_to
func change_special_attack_playing(go_to:bool):
	special_attack_playing = go_to


func _on_special_cooldown_timeout():
	spec_attack_on_cooldown = false


func _on_ani_timer_timeout():
	pass # Replace with function body.


func _on_inv_timer_timeout():
	invulnerable = false


func _on_area_2d_body_entered(body):
	if body.is_in_group('character_player'):
		print('KING HAS BEEN AWOKEN')
		globs.emit_signal('king_awoken')
		FROZEN = false

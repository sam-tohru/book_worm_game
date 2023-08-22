extends CharacterBody2D


@onready var SPEED = 300.0

@onready var player

@onready var randomnum
@onready var target
@onready var attack_timer = $attack_timer
@onready var special_cooldown = $special_cooldown
@onready var sword_body = $sword_body
@onready var walkthrough_timer = $walkthrough_timer


@onready var attack_animation_playing = false
@onready var special_attack_playing = false
@onready var spec_attack_on_cooldown = false

@onready var special_attack_chance = 1

@onready var particles_swing = $sword_body/particles_swing

@onready var blood = preload("res://resources/particles/parts_blood.tscn")


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
	
	walkthrough_timer.start()

func explode_body(body, pos):
	if body != self: return
	
	damage_enemy()

func _physics_process(delta):
	if globvars.main_node == null: return
	if FROZEN: return
	player = globvars.player_node
	if !is_instance_valid(player) or player == null: return
	
	var direction = global_position - player.global_position
	var angle = atan2(direction.y, direction.x)
	rotation_degrees = rad_to_deg(angle)
	
	
	if special_attack_playing: # How to move during spec?
		move(player.global_position, delta * 1.2)
		return
	if spec_attack_on_cooldown: # Can't move after [Melee]
		return
	
	match state:
		SURROUND: 
			move(get_circle_position(randomnum), delta)
		
		ATTACK: # Move toward player to Hit or Special
			move(get_circle_position(randomnum), delta)
		
		HIT: # Normal Hit Animation
			move(get_circle_position(randomnum), delta)


func move(target, delta):
	var direction = (target - global_position).normalized()
	var desired_velocity = direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	move_and_slide()

func get_circle_position(random): ## Edited to run away for children
	if player == null: return
	var run_away_distance = 1000
	
	var direction = player.global_position - global_position
	direction = direction.normalized()
	
	var kill_circle_centre = direction * -run_away_distance
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
	
	globvars.enemies_killed += 1
	var blood_instance = blood.instantiate()
	get_tree().current_scene.add_child(blood_instance)
	blood_instance.global_position = global_position
	globs.emit_signal('sfx_grunt')
	globs.slow_time(0.3, 0.1)
	
	self.queue_free()

func damage_enemy():
	var blood_instance = blood.instantiate()
	get_tree().current_scene.add_child(blood_instance)
	blood_instance.global_position = global_position
	globs.emit_signal('sfx_grunt')
	
	self.queue_free()

#############################################################################


func _on_walkthrough_timer_timeout():
	pass


func _on_area_2d_body_entered(body):
	FROZEN = false

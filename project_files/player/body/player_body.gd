extends CharacterBody2D

@onready var cant_pickup = true

@onready var blood = preload("res://resources/particles/parts_blood.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	globs.block_player_body.connect(block_player_body)
	
	globs.damaged_player_body.connect(damaged_player_body)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func shoot_impulse():
	pass


func block_player_body():
	pass


func _on_timer_timeout():
	cant_pickup = false

func damaged_player_body(body):
	if body != self: return
	
	var blood_instance = blood.instantiate()
	get_tree().current_scene.add_child(blood_instance)
	blood_instance.global_position = global_position
	

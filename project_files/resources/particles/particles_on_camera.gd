extends Node2D

@onready var sword_hit = $sword_hit

@onready var king_awoken_bg = $king_awoken_bg
@onready var king_awoken_timer = $king_awoken_timer


# Called when the node enters the scene tree for the first time.
func _ready():
	globs.king_awoken.connect(king_awoken)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Hit Markers

func animation_hit_marker(pos):
	sword_hit.global_position = pos
	sword_hit.emitting = true


func king_awoken():
	king_awoken_bg.emitting = true
	king_awoken_timer.start()
	await king_awoken_timer.timeout
	king_awoken_bg.emitting = false

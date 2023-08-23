extends Node2D

@onready var sword_hit = $sword_hit


# Called when the node enters the scene tree for the first time.
func _ready():
	globs.animation_hit_marker.connect(animation_hit_marker)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


# Hit Markers

func animation_hit_marker(pos):
	sword_hit.global_position = pos
	sword_hit.emitting = true



extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	globs.change_level.connect(change_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_level(level_to):
	pass

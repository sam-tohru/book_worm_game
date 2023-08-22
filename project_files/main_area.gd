extends Area2D

@onready var marker_2d = $Marker2D

# Called when the node enters the scene tree for the first time.
func _ready():
	globs.debug_teleport.connect(debug_teleport)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_exited(body):
	return
	if body.is_in_group('player'):
		body.global_position = marker_2d.global_position

func debug_teleport():
	pass

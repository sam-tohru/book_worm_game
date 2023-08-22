extends Area2D

@onready var tween_timer = $tween_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	shake_tween()
	tween_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.is_in_group('player'): 
		globs.emit_signal('face_eat_book')
		globvars.buildings_destroyed += 1
		self.queue_free()

func shake_tween():
	var tween = create_tween()
	tween.tween_property(self, 'rotation_degrees', randi_range(15, 25), 0.1)
	tween.tween_property(self, 'rotation_degrees', 0, 0.1)
	tween.tween_property(self, 'rotation_degrees', randi_range(-15, -25), 0.1)
	tween.tween_property(self, 'rotation_degrees', 0, 0.1)

func _on_tween_timer_timeout():
	shake_tween()

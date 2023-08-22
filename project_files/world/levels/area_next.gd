extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_level():
	if self.is_in_group('0-1'): globs.emit_signal('change_level', 1)
	
	if self.is_in_group('1-0'): globs.emit_signal('change_level', 0)
	elif self.is_in_group('1-2'): globs.emit_signal('change_level', 2)
	
	if self.is_in_group('2-1'): globs.emit_signal('change_level', 1)
	elif self.is_in_group('2-3'): 
		## King Cutscene
		## Wait
		## Change_level
		globs.emit_signal('spawn_king_cutscene')
	
	if self.is_in_group('3-2'): globs.emit_signal('change_level', 2)
func _on_body_entered(body):
	if body.is_in_group('player'):
		change_level()

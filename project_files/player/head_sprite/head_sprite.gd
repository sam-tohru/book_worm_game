extends Node2D

@onready var face = $face
@onready var face_is_eating = false
@onready var paper_parts = $paper_parts


# Called when the node enters the scene tree for the first time.
func _ready():
	globs.face_open.connect(face_open)
	globs.face_eat.connect(face_eat)
	globs.face_eat_book.connect(face_eat_book)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_global_mouse_position().x < position.x: face.flip_v = true
	else: face.flip_v = false

func face_open(to_open: bool):
	if face_is_eating: return
	
	if to_open: face.frame = 1 
	else: face.frame = 0

func face_eat():
	if face_is_eating == false:
		face_is_eating = true
		face.frame = 2
		
		var tween = create_tween()
		tween.tween_property(self, 'rotation_degrees', -45, 0.05)
		tween.tween_property(self, 'rotation_degrees', 0, 0.05)
		tween.tween_property(self, 'rotation_degrees', -35, 0.05)
		tween.tween_property(self, 'rotation_degrees', 0, 0.05)
		tween.tween_property(self, 'rotation_degrees', 55, 0.05)
		tween.tween_property(self, 'rotation_degrees', 0, 0.05)
		tween.tween_property(face, 'frame', 0, 0.0)
		tween.tween_callback(face_is_eating_change.bind(false))
func face_is_eating_change(go_to: bool):
	face_is_eating = go_to

func face_eat_book():
	# needs to spawn book in main if face_is_eating
	if face_is_eating: return 
	elif face_is_eating == false:
		face_is_eating = true
		face.frame = 3
		paper_parts.emitting = true
		var tween = create_tween()
		tween.tween_property(self, 'rotation_degrees', -45, 0.05)
		tween.tween_property(self, 'rotation_degrees', 0, 0.05)
		tween.tween_property(self, 'rotation_degrees', -35, 0.05)
		tween.tween_property(self, 'rotation_degrees', 0, 0.05)
		tween.tween_property(paper_parts, 'emitting', false, 0.00)
		tween.tween_property(self, 'rotation_degrees', 55, 0.05)
		tween.tween_property(self, 'rotation_degrees', 0, 0.05)
		tween.tween_property(face, 'frame', 0, 0.0)
		tween.tween_callback(face_is_eating_change.bind(false))

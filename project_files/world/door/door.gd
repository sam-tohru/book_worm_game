extends Area2D

@onready var collision_door = $collision_door

@onready var closed_static = $closed_static
@onready var collision_static = $closed_static/collision_static

@onready var rubble = preload("res://resources/particles/parts_door_rubble.tscn")

@onready var door_is_closed = true

@onready var closed_door = $closed_door
@onready var open_door = $open_door


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_body_entered(body):
	if body.is_in_group('player') or body.is_in_group('body'):
		if !door_is_closed: print()
		if self.is_in_group('door_back'): return
		
		var rubble_instance = rubble.instantiate()
		get_tree().current_scene.add_child(rubble_instance)
		globs.emit_signal('sfx_collapse')
		rubble_instance.global_position = global_position
		
		var tween = create_tween()
		tween.tween_property(self, 'rotation_degrees', 5, 0.05)
		tween.tween_callback(break_door)
		tween.tween_property(self, 'rotation_degrees', 0, 0.05)

func break_door():
	if door_is_closed && !get_parent().is_in_group('final_level'):
		door_is_closed = false
		closed_static.queue_free()
		closed_door.visible = false
		open_door.visible = true

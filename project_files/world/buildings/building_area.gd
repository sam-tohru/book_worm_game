extends Area2D

@onready var rubble = load("res://resources/particles/parts_rubble.tscn")
@onready var rubble_new = load("res://resources/particles/parts_rubble_NEW.tscn")
@onready var book_marker = $book_marker

@onready var hit_already = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_to_half():
	hit_already = true
	var rubble_instance = rubble.instantiate()
	get_tree().current_scene.add_child(rubble_instance)
	rubble_instance.global_position = global_position
	globs.emit_signal('sfx_collapse')
	get_parent().half_sprite()
	

## Bookshelf hit by body: if rigid, spawns book in main - elif just player, eats book instantly?
func _on_body_entered(body):
	if body.is_in_group('player') or body.is_in_group('body'):
		if body.is_in_group('rigid') && !hit_already: 
			globs.emit_signal('spawn_book', book_marker.global_position) 
			change_to_half()
			return
		elif !body.is_in_group('rigid'): 
			globs.emit_signal('face_eat_book')
		
		
		if !hit_already: # Limits to 2 rubble instances if hit_already
			globvars.buildings_destroyed += 1
			var rubble_instance = rubble.instantiate()
			get_tree().current_scene.add_child(rubble_instance)
			rubble_instance.global_position = global_position
		
		var rubble_new_instance = rubble_new.instantiate()
		get_tree().current_scene.add_child(rubble_new_instance)
		globs.emit_signal('sfx_collapse')
		rubble_new_instance.global_position = global_position
		
		await get_tree().create_timer(0.1).timeout
		get_parent().queue_free()

extends Area2D

@onready var rubble = load("res://resources/particles/parts_rubble_OLD.tscn")
@onready var pizza = load("res://resources/particles/parts_rubble_pizza.tscn")
@onready var book_marker = $book_marker

@onready var hit_already = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

## Bookshelf hit by body: if rigid, spawns book in main - elif just player, eats book instantly?
func _on_body_entered(body):
	if body.is_in_group('player') or body.is_in_group('body'):
		var rubble_instance = rubble.instantiate()
		get_tree().current_scene.add_child(rubble_instance)
		rubble_instance.global_position = global_position
		
		var pizza_instance = pizza.instantiate()
		get_tree().current_scene.add_child(pizza_instance)
		pizza_instance.global_position = global_position
		
		globs.emit_signal('sfx_collapse')
		
		await get_tree().create_timer(0.1).timeout
		get_parent().queue_free()

extends Node2D

@onready var marker_2d = $Marker2D
@onready var spawn_area = $spawn_area

@onready var can_spawn = true
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if spawn_area.has_overlapping_areas():
		for bodies in spawn_area.get_overlapping_bodies():
			if bodies.is_in_group('character_player'):
				
				if can_spawn: spawn_enemy() ; can_spawn = false ; timer.start()

func spawn_enemy():
	
	globs.emit_signal('spawn_enemy', marker_2d.global_position, marker_2d.rotation)


func _on_timer_timeout():
	can_spawn = true


func _on_destroy_area_body_entered(body): # Destroys self
	if body.is_in_group('player'):
		self.queue_free()

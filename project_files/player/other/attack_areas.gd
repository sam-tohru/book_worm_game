extends Node2D

@onready var attack_area = $attract_area
@onready var face_opened = false
@onready var eating_face = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if attack_area.has_overlapping_bodies() && !face_opened:
		for bodies in attack_area.get_overlapping_bodies():
			if bodies.is_in_group('enemy'): globs.emit_signal('face_open', true) ; face_opened = true ; return
	elif face_opened && attack_area.has_overlapping_bodies() == false:
		globs.emit_signal('face_open', false)
		face_opened = false
		return


func _on_attract_area_body_entered(body):
	if body.is_in_group('enemy'): 
		globs.emit_signal('enemy_attack_timer', body, true)

func _on_attract_area_body_exited(body):
	if body.is_in_group('enemy'): 
		globs.emit_signal('enemy_attack_timer', body, true)
		globs.emit_signal('enemy_state_change', body, 'SURROUND')


func _on_attack_area_body_entered(body):
	if body.is_in_group('enemy'): 
		globs.emit_signal('enemy_state_change', body, 'HIT')
		


func _on_attack_area_body_exited(body):
	if body.is_in_group('enemy'): 
		globs.emit_signal('enemy_state_change', body, 'SURROUND')

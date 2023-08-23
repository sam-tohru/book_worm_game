extends RigidBody2D

@onready var rigid_timer = $rigid_timer
@onready var timer_done = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed('skip') && timer_done: globs.emit_signal('rigid_to_character', self) ; print('pressed stop') ; return
	
	
	var speed = linear_velocity.length()
	var threshold = 250
	if speed < threshold && timer_done: globs.emit_signal('rigid_to_character', self) ; print('speedthreshold') ; return


func _on_body_entered(body):
	pass

func handle_explosion():
	return





func _on_rigid_timer_timeout():
	timer_done = true

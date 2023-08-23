extends RigidBody2D

@onready var cant_pickup = true

# Called when the node enters the scene tree for the first time.
func _ready():
	globs.kill_rigids.connect(kill_rigids)

func kill_rigids():
	self.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func shoot_impulse():
	pass


func _on_timer_timeout():
	cant_pickup = false


func _on_life_timer_timeout():
	self.sleeping = true

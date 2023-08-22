extends Node2D
@onready var warning_timer = $warning_timer
@onready var sprite_2d = $Sprite2D
@onready var explosion_particles = $explosion_particles
@onready var explosion_area = $explosion_area
@onready var explosion_timer = $explosion_timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func warning_shake():
	var shake_ani_time = 0.15
	
	var tween = create_tween()
	tween.tween_property(self, 'rotation_degrees', randi_range(10,25), shake_ani_time)
	tween.tween_property(self, 'rotation_degrees', randi_range(-10,-25), shake_ani_time)
	tween.tween_property(self, 'rotation_degrees', randi_range(10,25), shake_ani_time)
	tween.tween_property(self, 'rotation_degrees', randi_range(-10,-25), shake_ani_time)
	tween.tween_property(self, 'rotation_degrees', randi_range(10,25), shake_ani_time)
	tween.tween_property(self, 'rotation_degrees', randi_range(-10,-25), shake_ani_time)
	tween.tween_property(self, 'rotation_degrees', randi_range(10,25), shake_ani_time)
	tween.tween_property(self, 'rotation_degrees', randi_range(-10,-25), shake_ani_time)
	tween.tween_property(self, 'rotation_degrees', randi_range(10,25), shake_ani_time)
	tween.tween_property(self, 'rotation_degrees', randi_range(-10,-25), shake_ani_time)
	tween.tween_property(self, 'rotation_degrees', randi_range(10,25), shake_ani_time)
	tween.tween_property(self, 'rotation_degrees', randi_range(-10,-25), shake_ani_time)
	
	tween.tween_callback(explosion)
	tween.parallel().tween_property(self, 'scale', Vector2(1.2, 1.2), 0.05)
	tween.parallel().tween_property(self, 'rotation_degrees', randi_range(-60,-75), 0.05)
	tween.tween_property(sprite_2d, 'visible', false, shake_ani_time)

func explosion():
	globs.emit_signal('explosion')
	explosion_timer.start()
	explosion_particles.emitting = true
	if explosion_area.has_overlapping_bodies() == false: return
	
	for bodies in explosion_area.get_overlapping_bodies():
		if !bodies.is_in_group('player_body'): globs.emit_signal('explode_body', bodies, self.global_position)
	


func _on_explosion_area_body_entered(body):
	if body.is_in_group('player'):
		warning_shake()


func _on_explosion_timer_timeout():
	self.queue_free()

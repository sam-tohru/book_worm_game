extends Node2D

@onready var lines_sprites = $sprite_king/lines_sprites

@onready var life_timer = $life_timer

@onready var sprite_king = $sprite_king
@onready var line = $line

@onready var can_skip = false

# Called when the node enters the scene tree for the first time.
func _ready():
	globs.remove_king_cutscene.connect(remove_king_cutscene)
	globs.emit_signal('kill_rigids')
	king_tween()
	line.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('skip') && can_skip:
		
		globs.emit_signal('remove_king_cutscene_main')

func remove_king_cutscene():
	self.queue_free()

func _on_timer_timeout():
	if lines_sprites.frame == 0: lines_sprites.frame = 1
	else: lines_sprites.frame = 0


func _on_life_timer_timeout():
	
	globs.emit_signal('remove_king_cutscene_main')

func king_tween():
	var orig_pos = sprite_king.global_position
	var tween = create_tween()
	tween.tween_property(sprite_king, 'rotation_degrees', -15, 0.2)
	tween.parallel().tween_property(sprite_king, 'position', Vector2(orig_pos[0]-15, orig_pos[1] - 15), 0.2)
	
	tween.tween_property(sprite_king, 'rotation_degrees', -5, 0.2)
	tween.parallel().tween_property(sprite_king, 'position', Vector2(orig_pos[0]-10, orig_pos[1]), 0.2)
	
	tween.tween_property(sprite_king, 'rotation_degrees', 10, 0.2)
	tween.parallel().tween_property(sprite_king, 'position', Vector2(orig_pos[0]+5, orig_pos[1]+5), 0.2)
	
	tween.tween_property(sprite_king, 'rotation_degrees', -5, 0.2)
	tween.parallel().tween_property(sprite_king, 'position', Vector2(orig_pos[0], orig_pos[1]-15), 0.2)
	
	tween.tween_property(sprite_king, 'rotation_degrees', 0, 0.2)
	tween.parallel().tween_property(sprite_king, 'position', orig_pos, 0.2)


func _on_tween_timer_timeout():
	king_tween()


func _on_skip_timer_timeout():
	can_skip = true

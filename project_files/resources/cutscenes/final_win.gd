extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var __darkage = $"lines/0_darkage"
@onready var __kid = $"lines/1_kid"
@onready var __urbanmyth = $"lines/2_urbanmyth"

@onready var subs = $subs


@onready var can_skip = false
# Called when the node enters the scene tree for the first time.
func _ready():
	globs.remove_win_cutscene.connect(remove_win_cutscene)
	globs.emit_signal('kill_rigids')
	await get_tree().create_timer(0.5).timeout
	__darkage.play()
	tween_00()
	subs.text = 'King Charles was no match'
	await get_tree().create_timer(3).timeout
	subs.text = 'Humanity lost all its knowledge that day, to the book-worm...'
	await get_tree().create_timer(7).timeout
	subs.text = 'Plunging us into a dark age, that we just recovered from'


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('skip') and can_skip:
		globs.emit_signal('king_death_cutscene_done')

func remove_win_cutscene():
	self.queue_free()

func tween_00():
	var tween = create_tween()
	tween.tween_property(animated_sprite_2d, 'scale', Vector2(0.7, 0.7), 15)



func _on_0_darkage_finished():
	__kid.play()
	globs.emit_signal('screen_shake', 2, 7)
	animated_sprite_2d.scale = Vector2(0.5, 0.5)
	animated_sprite_2d.frame = 5
	subs.text = 'Gran-pa, do you ever think the worm will return one day'
	await get_tree().create_timer(5.2).timeout
	subs.text = 'and, and kill us all?'

func _on_1_kid_finished():
	__urbanmyth.play()
	animated_sprite_2d.frame = 7
	subs.text = 'I wouldnt worry about it, its just an urban myth'

func _on_2_urbanmyth_finished():
	await get_tree().create_timer(1.0).timeout
	globs.emit_signal('king_death_cutscene_done')


func _on_skip_timer_timeout():
	can_skip = true

extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D


@onready var head_sprite = $head_sprite
@onready var body_array = [$head_sprite/Sprite2D, $head_sprite/Sprite2D2]
@onready var curr_body_amount = 0
@onready var grows = false

@onready var eat_timer = $timers/eat_timer
@onready var eat_animation_timer = $timers/eat_animation_timer

@onready var rubble = preload("res://resources/particles/parts_rubble.tscn")
@onready var rubble_new = preload("res://resources/particles/parts_rubble_NEW.tscn")

@onready var subs = $subs

@onready var line_00 = 'Long ago in this very library...'
@onready var line_01 = 'A worm the size of a man burst through the floor'
@onready var line_02 = 'It started devouring all the books'
@onready var line_03 = 'The worm grew in-size which each book it consumed'
@onready var line_04 = 'And on that day kids, humanity lost all our knowledge'
@onready var line_04_2 = 'to the book-worm...'
@onready var line_05 = 'Gran-pa do you ever think the worm will return one day?'
@onready var line_06 = 'Oh no, its just an ancient myth, i wouldnt worry about it'

@onready var sfx_crash = $lines/sfx_crash

@onready var _0_long_ago = $"lines/00_long-ago"
@onready var _1_burst = $"lines/01_burst"
@onready var _2_devvouring_books = $"lines/02_devvouring-books"
@onready var _3_growing = $"lines/03_growing"
@onready var _4_grandpa_talking = $"lines/04_grandpa-talking"
@onready var _5_kid_responds = $"lines/05_kid-responds"
@onready var _6_dont_worry = $"lines/06_dont-worry"

@onready var _7_death_1 = $"lines/07_death-1"
@onready var _7_kid_1 = $"lines/07_kid-1"
@onready var _7_kid_2 = $"lines/07_kid-2"
@onready var _7_kid_3 = $"lines/07_kid-3"

@onready var shelves = $shelves
@onready var shelf_full_2 = $shelves/ShelfFull2
@onready var marker_2d = $shelves/Marker2D


# Called when the node enters the scene tree for the first time.
func _ready():
	subs.text = line_00
	animated_sprite_2d.frame = 1
	head_sprite.visible = false
	shelves.visible = false
	_0_long_ago.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed('skip'):
		globs.emit_signal('menu_screen')
		self.queue_free()



func _on_eat_timer_timeout():
	head_sprite.face_eat_book()
	spawn_books()
	if curr_body_amount < body_array.size() && grows:
		eat_animation_timer.start()
		await eat_animation_timer.timeout
		body_array[curr_body_amount].visible = true
		curr_body_amount += 1


func spawn_books():
	var rubble_instance = rubble.instantiate()
	var rubble_new_instance = rubble_new.instantiate()
	get_tree().current_scene.add_child(rubble_instance)
	get_tree().current_scene.add_child(rubble_new_instance)
	globs.emit_signal('sfx_collapse')
	rubble_instance.global_position = global_position
	rubble_new_instance.global_position = global_position

func shelf_fling():
	var tween = create_tween()
	tween.tween_property(shelf_full_2, 'position', marker_2d.global_position, 0.15)
	tween.parallel().tween_property(shelf_full_2, 'rotation_degrees', 720, 0.15)

func _on_00_longago_finished():
	# Scene 00 -> 01
	subs.text = line_01
	animated_sprite_2d.frame = 3
	shelves.visible = true
	_1_burst.play()
	await get_tree().create_timer(2.5).timeout
	sfx_crash.play()
	globs.emit_signal('screen_shake', 10, 0.4)
	animated_sprite_2d.frame = 4
	shelf_fling()

func _on_01_burst_finished():
	subs.text = line_02
	_2_devvouring_books.play()
	await get_tree().create_timer(1.5)
	animated_sprite_2d.frame = 0
	head_sprite.visible = true
	eat_timer.start()

func _on_02_devvouringbooks_finished():
	subs.text = line_03
	grows = true
	_3_growing.play()

func _on_03_growing_finished():
	subs.text = line_04
	_4_grandpa_talking.play()
	head_sprite.visible = false
	shelves.visible = false
	eat_timer.stop()
	animated_sprite_2d.frame = 1
	await get_tree().create_timer(6).timeout
	subs.text = line_04_2
	animated_sprite_2d.frame = 6

func _on_04_grandpatalking_finished():
	subs.text = line_05
	_5_kid_responds.play()
	globs.emit_signal('screen_shake', 2, 7)
	animated_sprite_2d.frame = 5

func _on_05_kidresponds_finished():
	subs.text = line_06
	_6_dont_worry.play()
	animated_sprite_2d.frame = 1

func _on_06_dontworry_finished():
	sfx_crash.play()
	_7_death_1.play()
	globs.emit_signal('screen_shake', 15, 4)
	await get_tree().create_timer(1.0)
	animated_sprite_2d.frame = 2
	
	## Kids Screaming
	await get_tree().create_timer(0.05)
	_7_kid_1.play()
	await get_tree().create_timer(0.05)
	_7_kid_2.play()
	await get_tree().create_timer(0.05)
	_7_kid_3.play()
	
	await get_tree().create_timer(3).timeout
	globs.emit_signal('menu_screen')
	self.queue_free()

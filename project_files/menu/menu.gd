extends Node2D

@onready var word_areas = [$letter_areas/mark_0, $letter_areas/mark_1, $letter_areas/mark_2]
@onready var word_letters = [$letter_areas/mark_0/menu_letter, $letter_areas/mark_1/menu_letter, $letter_areas/mark_2/menu_letter]

@onready var reroll_num = 9
@onready var refresh_stats = $refresh_menu/refresh_stats

@onready var firework_1 = $firework_1
@onready var firework_2 = $firework_2
@onready var firework_3 = $firework_3
@onready var firework_4 = $firework_4


# Called when the node enters the scene tree for the first time.
func _ready():
	globs.leader_board_scene.connect(leader_board_scene)
	globs.remove_menu.connect(remove_menu)
	if globvars.first_jam_info: 
		globvars.first_jam_info = false
		# var info_page = load("res://menu/info_page.tscn")
		# var info_instance = info_page.instantiate()
		# call_deferred('add_child', info_instance)
	

func remove_menu():
	self.queue_free()

func _on_menu_button_up():
	globs.emit_signal('menu_screen')

func _on_settings_pressed():
	var setting_page = load("res://menu/settings_bg.tscn")
	var setting_instance = setting_page.instantiate()
	call_deferred('add_child', setting_instance)


func _on_menu_2_pressed():
	var setting_page = load("res://menu/info_page.tscn")
	var setting_instance = setting_page.instantiate()
	call_deferred('add_child', setting_instance)


###############################################################################

### Leaderboard & Death Scene ###

func player_death():
	leader_board_scene()
func player_won():
	leader_board_scene(true)

func leader_board_scene(player_won: bool = false):
	var board_page = load("res://menu/leaderboard/leaderboard.tscn")
	var board_instance = board_page.instantiate()
	await call_deferred('add_child', board_instance)
	if player_won: board_instance.player_win()
	else: board_instance.player_lost()

func _on_board_pressed():
	leader_board_scene()

func player_won_animation():
	return
	var timer = $Timer
	timer.start()
	await timer.timeout
	globs.emit_signal('sfx_firework')
	firework_1.emitting = true
	await get_tree().create_timer(0.8).timeout
	globs.emit_signal('sfx_firework')
	firework_2.emitting = true
	await get_tree().create_timer(0.8).timeout
	globs.emit_signal('sfx_firework')
	firework_3.emitting = true
	await get_tree().create_timer(0.8).timeout
	globs.emit_signal('sfx_firework')
	firework_4.emitting = true
	await get_tree().create_timer(0.8).timeout



func _on_timer_timeout():
	print('ahhh')

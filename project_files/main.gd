extends Node2D

@onready var start_timer = $timers/start_timer
@onready var new_life_timer = $timers/new_life_timer


@onready var player_rigid_timer = $timers/player_rigid_timer
@onready var head_arrays = ["res://player/player_head.tscn", "res://player/chains/player_head2.tscn", "res://player/chains/player_head3.tscn"]

@onready var level_array = ["res://world/levels/01_start/level_01.tscn", "res://world/levels/02_enemy/level_02.tscn", "res://world/levels/03_cube/level_03.tscn"]
@onready var main_array = ["res://main.tscn", "res://main2.tscn", "res://main3.tscn", "res://mainFinal.tscn"]
@onready var curr_level = $level_01
func change_level(num):
	get_tree().change_scene_to_file(main_array[num])
	

func get_player():
	
	for child in get_children():
		if child.is_in_group('player'): 
			print('player: ', child)
			return child
	
	if is_instance_valid($player_head): return $player_head 
	else: return null

# Called when the node enters the scene tree for the first time.
func _ready():
	globs.remove_king_cutscene_main.connect(remove_king_cutscene_main)
	globs.spawn_king_cutscene.connect(spawn_king_cutscene)
	globs.change_level.connect(change_level)
	globs.new_life.connect(new_life)
	globs.debug_teleport.connect(debug_teleport)
	globs.shoot_behind.connect(shoot_behind)
	globs.spawn_body_shot.connect(spawn_body_shot)
	globs.new_head_chain.connect(new_head_chain)
	globs.spawn_head_shot.connect(spawn_head_shot)
	globs.menu_screen.connect(menu_screen)
	globs.player_death.connect(player_death)
	globs.king_death.connect(king_death)
	globs.king_death_cutscene_done.connect(king_death_cutscene_done)
	globs.player_explosion_mechanic.connect(player_explosion_mechanic)
	globs.spawn_enemy.connect(spawn_enemy)
	globs.spawn_book.connect(spawn_book)
	globs.rigid_to_character.connect(rigid_to_character)
	
	
	globvars.main_node = self
	
	if !globvars.IN_MENU: 
		globvars.IN_MENU = true
		globs.emit_signal('remove_menu')
		
		if globvars.need_to_reload_player: 
			make_new_head(globvars.get_saved_position())
			globvars.need_to_reload_player = false
		else: make_new_head(Vector2.ZERO)
		
		start_timer.start()
		await start_timer.timeout
		globvars.IN_MENU = false

func debug_teleport():
	var player = get_player()
	if player == null: return
	
	player.global_position = $main_area/Marker2D.global_position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(globvars.player_life_count)
	if Input.is_action_just_pressed('menu'): 
		globs.emit_signal('menu_screen')
	
	if Input.is_action_just_pressed('new_order'): globs.restart_game()

func new_life():
	
	if globvars.player_life_count < globvars.max_life_count && new_life_timer.is_stopped(): # Adds a life if less
		
#		for child in get_children():
#			if child.is_in_group('player'): new_head_chain(true, get_player())
		
		if get_player() != null: 
			new_head_chain(true, get_player())
			new_life_timer.start()
	elif new_life_timer.is_stopped(): # Just shoots one out if max
		# just_shoot_one_out()
		pass

func shoot_behind(rot, pos):
	## Projectile Body into main ##
	var new_body_load = load("res://player/body/rigid_body.tscn")
	var new_body = new_body_load.instantiate()
	new_body.global_position = pos
	call_deferred('add_child', new_body)
	
	var impulse = Vector2(cos(rot), sin(rot)) * 900
	impulse = -impulse
	new_body.apply_central_impulse(impulse)
func spawn_body_shot(rot, pos, head_node):
	
	## New Head Chain ##
	new_head_chain(false, head_node) 
	
	## Projectile Body into main ##
	var new_body_load = load("res://player/body/rigid_body.tscn")
	var new_body = new_body_load.instantiate()
	new_body.global_position = pos
	call_deferred('add_child', new_body)
	
	var impulse = Vector2(cos(rot), sin(rot)) * 900
	new_body.apply_central_impulse(impulse)
func just_shoot_one_out():
	var pos = Vector2.ZERO
	var rot = 0
	var player = get_player()
	if player != null: pos = player.global_position ; rot = player.rotation
	
	var new_body_load = load("res://player/body/rigid_body.tscn")
	var new_body = new_body_load.instantiate()
	new_body.global_position = pos
	call_deferred('add_child', new_body)
	
	var impulse = Vector2(cos(rot), sin(rot)) * 900
	new_body.apply_central_impulse(impulse)

func new_head_chain(GOING_UP: bool, head_node):
	
	if GOING_UP: ## Up
		if globvars.player_life_count < 2: globvars.player_life_count += 1
		else: return
	
	else:
		if globvars.player_life_count > 0: globvars.player_life_count -= 1
		else: return
		
		
	
	var head_pos = head_node.global_position
	## Removing ## praying this fix works??
	if is_instance_valid(head_node): 
		globvars.player_node = null
		head_node.queue_free()
	
	## Spawning ##
	var new_head_load = load(head_arrays[globvars.player_life_count])
	var new_head = new_head_load.instantiate()
	new_head.global_position = head_pos
	call_deferred('add_child', new_head)

func spawn_head_shot(head_node):
	
	var head_pos = head_node.global_position
	var rot = head_node.rotation
	var old_life = globvars.player_life_count
	var can_shoot = false
	if globvars.player_life_count != 0: can_shoot = true
	
	## Removing ##
	head_node.destroy_self()
	
	# globvars.player_life_count = 0
	globvars.PLAYER_RIGID_BOODY = true
	globvars.player_life_count -= 1
	globvars.player_life_count = clamp(globvars.player_life_count, 0, 2)
	
	## New Rigid Head and Impulse
	var head_load = load("res://player/rigid_player.tscn")
	if globvars.player_life_count == 1: head_load = load("res://player/chains/rigid_head2.tscn") # 3 Lives -> 2 heads
	
	var new_head = head_load.instantiate()
	new_head.global_position = head_pos
	new_head.rotation = rot
	call_deferred('add_child', new_head)
	
	var impulse = Vector2(cos(rot), sin(rot)) * 900
	new_head.apply_central_impulse(impulse)
	
	await get_tree().create_timer(0.2).timeout
	if can_shoot: shoot_behind(rot, head_pos)

func rigid_to_character(rigid_head):
	var head_pos = rigid_head.global_position
	var rot = rigid_head.rotation
	## Removing ##
	rigid_head.queue_free()
	
	## Spawning ##
	var new_head_load = load("res://player/player_head.tscn")
	if globvars.player_life_count == 1: new_head_load = load("res://player/chains/player_head2.tscn") 
	
	
	var new_head = new_head_load.instantiate()
	new_head.global_position = head_pos
	call_deferred('add_child', new_head)
	
	globvars.PLAYER_RIGID_BOODY = false

func make_new_head(pos):
	
		## New Rigid Head and Impulse
	var head_load = load(head_arrays[globvars.player_life_count])
	var new_head = head_load.instantiate()
	new_head.global_position = pos
	call_deferred('add_child', new_head)

## Explosion -> makes player rigid and boosts? need character_to_rigid?
func player_explosion_mechanic(head_node, pos):
	globvars.PLAYER_RIGID_BOODY = true
	globvars.player_life_count -= 1
	globvars.player_life_count = clamp(globvars.player_life_count, 0, 2)
	
	var head_load = load("res://player/rigid_player.tscn")
	if globvars.player_life_count == 1: head_load = load("res://player/chains/rigid_head2.tscn") # 3 Lives -> 2 heads
	
	var head_pos = head_node.global_position
	var rot = head_node.rotation
	
	## Removing character ##
	globs.emit_signal('remove_current_player')
	
	## Spawning Rigid ##
	var new_head = head_load.instantiate()
	new_head.global_position = head_pos
	new_head.rotation = rot
	call_deferred('add_child', new_head)
	
	# Explosion force
	var explosionForce = 2000  # Adjust the force as needed
	var direction = (new_head.position - pos).normalized()
#	new_head.apply_impulse(Vector2.ZERO, direction * explosionForce)
	var impulse = -direction * explosionForce
	new_head.apply_central_impulse(-impulse)
	
	player_rigid_timer.start()
	await player_rigid_timer.timeout
	
	if is_instance_valid(new_head): rigid_to_character(new_head)

#### Timers ####

func _on_player_rigid_timer_timeout():
	pass # Replace with function body.


func _on_start_timer_timeout():
	pass


##########################################################################

func spawn_enemy(pos, rot):
	if globvars.enemies_in_play > 12: return
	globvars.enemies_in_play += 1
	
	var enemy_load = load("res://enemies/melee/enemy_melee.tscn")
	var new_enemy = enemy_load.instantiate()
	new_enemy.global_position = pos
	new_enemy.rotation = rot
	call_deferred('add_child', new_enemy)

# Spawns a book into main tha player can eat (if hit bookshelf with rigid)
func spawn_book(pos):
	var book_load = load("res://world/book_pickup/book_pickup.tscn")
	var new_book = book_load.instantiate()
	new_book.global_position = pos
	call_deferred('add_child', new_book)

##########################################################################

## Menu ##
func menu_screen():
	
	if globvars.IN_MENU == false: # Spawn menu
		var pla = get_player()
		
		if pla != null: 
			# Save & Remove
			globvars.save_position(pla.global_position)
			pla.queue_free()
			globvars.need_to_reload_player = true
		
		spawn_menu()
		globvars.IN_MENU = true
	elif globvars.IN_MENU: # Removes & play?
		# Loads [if-so] & Plays
		globs.emit_signal('remove_menu')
		if globvars.first_custscene:
			globvars.first_custscene = false
			spawn_cutscene()
			return
			
		
		if globvars.need_to_reload_player: 
			make_new_head(globvars.get_saved_position())
			globvars.need_to_reload_player = false
		else: make_new_head(Vector2.ZERO)
		
		start_timer.start()
		await start_timer.timeout
		globvars.IN_MENU = false

func spawn_king_cutscene():
		var pla = get_player()
		if pla != null: 
			# Save & Remove
			globvars.save_position(pla.global_position)
			pla.queue_free()
			globvars.need_to_reload_player = true
		
		var cutscne_page = load("res://resources/cutscenes/king_cutscene/king_cutscene.tscn")
		var cutscne_instance = cutscne_page.instantiate()
		call_deferred('add_child', cutscne_instance)
		
		globvars.IN_MENU = true
func remove_king_cutscene_main(): 
	globs.emit_signal('remove_king_cutscene')
	
	print('remove_king_cutscene')
	if globvars.need_to_reload_player: 
		make_new_head(globvars.get_saved_position())
		globvars.need_to_reload_player = false
	else: make_new_head(Vector2.ZERO)
	globvars.IN_MENU = false
	globs.emit_signal('change_level', 3)
	
	start_timer.start()
	await start_timer.timeout
	globvars.IN_MENU = false


func spawn_menu():
	var menu_page = load("res://menu/menu.tscn")
	var menu_instance = menu_page.instantiate()
	call_deferred('add_child', menu_instance)
func spawn_cutscene():
	var page = load("res://resources/cutscenes/intro.tscn")
	var instance = page.instantiate()
	call_deferred('add_child', instance)
####################################################

## Player Death (into menu)
func player_death(head_node):
	# Animation
	
	# Remove
	head_node.queue_free()
	
	# Menu & leaderboard
	spawn_death_menu()
	globvars.restart_game = true

func spawn_death_menu():
	var menu_page = load("res://menu/menu.tscn")
	var menu_instance = menu_page.instantiate()
	call_deferred('add_child', menu_instance)
	menu_instance.player_death()

func spawn_win_menu():
	var menu_page = load("res://menu/menu.tscn")
	var menu_instance = menu_page.instantiate()
	call_deferred('add_child', menu_instance)
	menu_instance.player_won()

func king_death():
		var pla = get_player()
		print("CUTSCNE")
		if pla != null: 
			# Save & Remove
			globvars.save_position(pla.global_position)
			pla.queue_free()
			globvars.need_to_reload_player = true
		
		var cutscne_page = load("res://resources/cutscenes/final_win.tscn")
		var cutscne_instance = cutscne_page.instantiate()
		call_deferred('add_child', cutscne_instance)
		
		globvars.IN_MENU = true

func king_death_cutscene_done():
	globs.emit_signal('remove_win_cutscene')
	await get_tree().create_timer(1).timeout
	globs.emit_signal('remove_current_player')
	spawn_win_menu()
	globvars.restart_game = true
	await get_tree().create_timer(0.6).timeout
	globs.emit_signal('player_won_animation')


func _on_building_ani_timer_timeout():
	pass
	# globs.emit_signal('building_random_frame')

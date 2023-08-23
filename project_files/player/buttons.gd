extends Node2D

## Buttons themselves ##
@onready var menu = $menu


## Sprites ##
@onready var menu_sprites = [preload("res://resources/buttons/menu/menu_1.png"), preload("res://resources/buttons/menu/menu_2.png"), preload("res://resources/buttons/menu/menu_3.png"), preload("res://resources/buttons/menu/menu_4.png"), preload("res://resources/buttons/menu/menu_5.png")]
@onready var menuPressed_sprites = [preload("res://resources/buttons/menu/menuPressed_1.png"), preload("res://resources/buttons/menu/menuPressed_2.png"), preload("res://resources/buttons/menu/menuPressed_3.png"), preload("res://resources/buttons/menu/menuPressed_4.png"), preload("res://resources/buttons/menu/menuPressed_5.png")]

## Old frame ##
@onready var menu_old = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_ani_timer_timeout():
	var menu_rand = randi_range(0,4)
	while menu_rand == menu_old: menu_rand = randi_range(0, 4)
	menu_old = menu_rand
	
	## Changes sprites ##
	menu.set_texture_normal(menu_sprites[menu_rand])
	menu.set_texture_pressed(menuPressed_sprites[menu_rand])


func _on_menu_pressed():
	globs.emit_signal('menu_screen')

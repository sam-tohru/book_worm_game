extends StaticBody2D

@onready var building_sprite_1 = $building_sprite1
@onready var building_sprite_2 = $building_sprite2
@onready var corner_sprite = $corner_sprite


# Called when the node enters the scene tree for the first time.
func _ready():
	globs.building_random_frame.connect(random_frame)
	# building_sprite_1.frame = randi_range(0,4)
	# building_sprite_2.frame = randi_range(0,4)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func random_frame():
	pass

func half_sprite():
	print('changing!')
	var shelf_empty_array = ["res://world/sprites/shelves_new/shelfEmp_1.png", "res://world/sprites/shelves_new/shelfEmp_2.png", "res://world/sprites/shelves_new/shelfEmp_3.png", "res://world/sprites/shelves_new/shelfEmp_4.png", "res://world/sprites/shelves_new/shelfEmp_5.png"]
	
	if building_sprite_1.is_in_group('half_change'): building_sprite_1.texture = load(shelf_empty_array[randi_range(0, shelf_empty_array.size()-1)])
	
	if building_sprite_2.is_in_group('half_change'): building_sprite_2.texture = load(shelf_empty_array[randi_range(0, shelf_empty_array.size()-1)])
	

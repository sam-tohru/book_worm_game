extends TextureProgressBar

@onready var NEW_LIFE_GIVEN = false

# Called when the node enters the scene tree for the first time.
func _ready():
	max_value = globvars.buildings_till_life
	
	if globvars.buildings_destroyed < max_value: value = max_value - globvars.buildings_destroyed
	else: value = globvars.buildings_destroyed % globvars.buildings_till_life


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if globvars.buildings_destroyed < max_value: value = globvars.buildings_destroyed
	else: value = globvars.buildings_destroyed % globvars.buildings_till_life
	
	if value == 0 && !NEW_LIFE_GIVEN:
		print(value)
		NEW_LIFE_GIVEN = true
		globs.emit_signal('new_life')
	elif value != 0 && NEW_LIFE_GIVEN:
		NEW_LIFE_GIVEN = false

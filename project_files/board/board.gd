extends Node2D

@onready var background = $background



# Called when the node enters the scene tree for the first time.
func _ready():
	globs.menu_screen.connect(menu_screen)
	

func menu_screen():
	self.visible = !self.visible

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# globvars.FOCUSED_LETTER = focused_letter
	pass

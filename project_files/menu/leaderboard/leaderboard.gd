extends Node2D

@onready var score_label = $score_label
@onready var death_label = $death_label
@onready var win_label = $win_label
@onready var final_score = $"score_label/final score"



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	score_label.text = str('You Killed: ', globvars.enemies_killed, ' people & You ate ', globvars.buildings_destroyed, ' Books')
	final_score.text = str('Full Score: ', globvars.get_score())


func _on_menu_pressed(): # Right now just removes (as opened menu before if died)
	if globvars.restart_game: globs.restart_game()
	else: self.queue_free()


func _on_replay_pressed():
	globs.restart_game()


func player_win():
	$death_label.visible = false
	$win_label.visible = true
func player_lost():
	$death_label.visible = true
	$win_label.visible = false

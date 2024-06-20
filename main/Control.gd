extends Control

func _ready():
	pass

func _process(delta):
	get_tree().change_scene_to_file("res://level.tscn")

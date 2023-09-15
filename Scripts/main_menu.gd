extends Control

@onready var btnContaner : VBoxContainer = $VBoxContainer


func _ready() -> void:
	for i in range(0, btnContaner.get_child_count(), 1):
		btnContaner.get_child(i).pressed.connect(OnBtnPressed.bind(i))


func OnBtnPressed(i : int) -> void:
	match i:
		0:
			get_tree().change_scene_to_file("res://Scenes/level_1.tscn")
		1:
			get_tree().quit()

extends CanvasLayer


@onready var window : Window = $Window
@onready var gameOverWindow : Window = $GameOverWindow
@onready var resultLabel : Label = $GameOverWindow/Panel/VBoxContainer/Label
@onready var scoreLabel : Label = $GameOverWindow/Panel/VBoxContainer/Label2
@onready var btnContainer : VBoxContainer = $Window/Panel/VBoxContainer
@onready var gameOverBtnContainer : VBoxContainer = $GameOverWindow/Panel/VBoxContainer
@onready var flowersLeftLabel : Label = $Control/TextureRect/FlowersLeftLabel
@onready var timeLabel : Label = $Control/TextureRect2/TimeLabel
@onready var flowersPickedLabel : Label = $Control/TextureRect3/FlowersPickedLabel
@onready var HPLabel : Label = $Control/TextureRect4/LivesLabel


func _ready() -> void:
	window.hide()
	gameOverWindow.hide()
	
	for i in range(0, btnContainer.get_child_count(), 1):
		btnContainer.get_child(i).pressed.connect(OnBtnPressed.bind(i))
	
	for i in range(2, gameOverBtnContainer.get_child_count(), 1):
		gameOverBtnContainer.get_child(i).pressed.connect(OnGameOverBtnPressed.bind(i-2))
	


func _unhandled_key_input(event):
	if event.is_action_released("esc"):
		window.popup_centered()
		get_tree().paused = true


func InitUIText(fl : int, t : int, l : int) -> void:
	flowersLeftLabel.text = str(fl)
	timeLabel.text = str(t)
	flowersPickedLabel.text = "0"
	HPLabel.text = str(l)


func UpdateHP(i : int) -> void:
	HPLabel.text = str(i)


func UpdateFlowers(fp : int, fl : int) -> void:
	flowersPickedLabel.text = str(fp)
	flowersLeftLabel.text = str(fl)


func UpdateTime(t : int) -> void:
	timeLabel.text = str(t)


func SetScore(value : int, hasWon : bool) -> void:
	if hasWon:
		resultLabel.text = "Level Completed"
	else:
		resultLabel.text = "Game Over"
		
	if value < 0:
		value = 0
	
	scoreLabel.text = "Score: " + str(value)
	gameOverWindow.popup_centered()
	get_tree().paused = true


func OnBtnPressed(i : int) -> void:
	match i:
		0:
			window.hide()
			get_tree().paused = false
		1:
			get_tree().paused = false
			get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
		2:
			get_tree().quit()
		_:
			pass


func OnGameOverBtnPressed(i : int) -> void:
	match i:
		0:
			get_tree().paused = false
			get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
		1:
			get_tree().quit()
		_:
			pass



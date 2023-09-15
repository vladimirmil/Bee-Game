extends "res://Scripts/level.gd"


var levelTime : int = 30
var levelHP : int = 4

func _ready():
	super._ready()
	SetBeeHP(levelHP)
	UI.InitUIText(flowerCount, levelTime, levelHP)
	StartLevel(levelTime)
	

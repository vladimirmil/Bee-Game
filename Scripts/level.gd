extends Node2D

@onready var UI: CanvasLayer = $UI
@onready var timer : Timer = $Timer
@onready var bee : CharacterBody2D = $Node2D/Bee
@onready var leavesNode : Node2D = $Node2D/LeavesNode


var flowerCount : int = 0
var flowersPicked : int = 0


func _ready() -> void:
	timer.timeout.connect(OnTimeout)
	bee.hurt.connect(OnHurt)
	bee.died.connect(OnDied)
	
	flowerCount = leavesNode.get_child_count()
	for i in range(0, flowerCount, 1):
		leavesNode.get_child(i).flowerPicked.connect(OnFlowerPicked)


func _process(_delta) -> void:
	UI.UpdateTime(int(timer.time_left))


func StartLevel(i : int) -> void:
	timer.start(i)


func SetBeeHP(i : int) -> void:
	bee.SetHP(i)


func GetBeeHP() -> int:
	return bee.GetHP()


func OnTimeout() -> void:
	OnDied()


# Finds the closest leaf to the bee
func OnHurt(currentHP : int) -> void:
	var closestChild : Object = null
	var distance : float = 0.0
	
	UI.UpdateHP(currentHP)
	
	for i in range(0, leavesNode.get_child_count(), 1):
		if i == 0:
			distance = bee.position.distance_to(leavesNode.get_child(i).position)
			closestChild = leavesNode.get_child(i)
		else:
			if distance > bee.position.distance_to(leavesNode.get_child(i).position):
				distance = bee.position.distance_to(leavesNode.get_child(i).position)
				closestChild = leavesNode.get_child(i)
	
	bee.setHurtMovePosition( bee.position, Vector2(closestChild.position.x, closestChild.position.y - 50.0) )


func OnFlowerPicked() -> void:
	flowersPicked += 1
	UI.UpdateFlowers(flowersPicked, flowerCount - flowersPicked)
	if flowersPicked == flowerCount:
		var score : int = flowersPicked * 100 + int(timer.time_left) * 50
		UI.SetScore(score, true)


func OnDied() -> void:
	var score : int = flowersPicked * 100 - (flowerCount - flowersPicked) * 100
	UI.SetScore(score, false)

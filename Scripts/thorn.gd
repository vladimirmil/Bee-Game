extends StaticBody2D

@onready var area2d : Area2D = $Area2D


var damage : int = 1


func _ready() -> void:
	area2d.body_entered.connect(OnBodyEntered)


func OnBodyEntered(body : Object) -> void:
	body.OnDamage(damage)

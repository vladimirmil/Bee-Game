extends StaticBody2D

signal flowerPicked

@onready var flowerArea : Area2D = $Area2D
@onready var flowerSprite : Sprite2D = $Sprite2D2


func _ready() -> void:
	flowerArea.body_entered.connect(OnBodyEntered)


func OnBodyEntered(_body : Object) -> void:
	flowerArea.call_deferred("set_monitoring", false)
	flowerSprite.set_deferred("visible", false)
	emit_signal("flowerPicked")

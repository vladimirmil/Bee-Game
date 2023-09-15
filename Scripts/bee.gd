extends CharacterBody2D

signal hurt
signal died


@onready var animation : AnimationPlayer = $AnimationPlayer
@onready var collision : CollisionShape2D = $CollisionShape2D

enum { ALIVE = 0, HURT }
var state : int = ALIVE

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hp : int = 3
var speed : float = 300.0
var maxSpeed : float = 550.0
var flySpeed : float = -35.0
var inertia : float = 0.0
var inertiaGain : float = 0.1
var inertiaDecay : float = 0.01
var spriteRotation : float = 20.0
var hurtMovePosition : Vector2 = Vector2.ZERO
var moveThreshold : int = 15
var screenLimits : Vector2 = Vector2(330.0, 1590.0)

var prevPos
var prevPosFlag : bool = false

#
func _physics_process(delta) -> void:
	match state:
		ALIVE:
			# Add gravity.
			velocity.y += gravity * delta

			# Handle up movement and animation
			if Input.is_action_pressed("ui_up"):
				velocity.y += flySpeed
				animation.play("fly")
			else:
				animation.stop()
			
			# Gain inertia over time
			if Input.is_action_pressed("ui_left"):
				inertia -= inertiaGain
				rotation_degrees = -spriteRotation
			if Input.is_action_pressed("ui_right"):
				inertia += inertiaGain
				rotation_degrees = spriteRotation
			
			# Lose inertia over time
			if !Input.is_action_pressed("ui_left") and !Input.is_action_pressed("ui_right"):
				rotation_degrees = 0
				if inertia > 0:
					inertia -= inertiaDecay
				elif inertia < 0:
					inertia += inertiaDecay
				else: 
					pass
			
			# Speed clamp
			if inertia > 1:
				inertia = 1
			if inertia < -1:
				inertia = -1

			if velocity.y > maxSpeed:
				velocity.y = maxSpeed
			if velocity.y < -maxSpeed:
				velocity.y = -maxSpeed
			
			velocity.x = inertia * speed
			move_and_slide()
			
			# Off screen clamp
			if position.x < screenLimits.x:
				position.x = screenLimits.x
			if position.x > screenLimits.y:
				position.x = screenLimits.y

		HURT:
			# Move the bee to the closest leaf
			if position.distance_to(hurtMovePosition) > moveThreshold and !prevPosFlag:
				move_and_slide()
				# Checks if the bee has moved more than it should have and if so, stop it
				if prevPos > position.distance_to(hurtMovePosition):
					prevPos = position.distance_to(hurtMovePosition)
				else:
					prevPosFlag = true
			else:
				# Bee arrived to the closest leaf, reset everything
				prevPosFlag = false
				position = hurtMovePosition
				velocity = Vector2.ZERO
				inertia = 0.0
				$Sprite2D.frame = 0
				collision.set_deferred("disabled", false)
				state = ALIVE


func SetHP(i : int) -> void:
	hp = i


func GetHP() -> int: return hp


func setHurtMovePosition(from : Vector2, to : Vector2) -> void:
	hurtMovePosition = to
	prevPos = position.distance_to(hurtMovePosition)
	velocity = (to - from).normalized() * speed


func OnDamage(damage : int) -> void:
	collision.set_deferred("disabled", true)
	velocity = Vector2.ZERO
	inertia = 0.0
	animation.stop()
	state = HURT
	
	$Sprite2D.frame = 2
	rotation_degrees = 0
	
	hp -= damage
	emit_signal("hurt", hp)
	
	if hp <= 0:
		emit_signal("died")
	
	




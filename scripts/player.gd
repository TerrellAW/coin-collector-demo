extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

var dead := false

@onready var sprite: AnimatedSprite2D = $AnimatedKnight


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if !dead && Input.is_action_just_pressed("ui_accept") && is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := move()
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

# Animations
	if !dead:
		if !is_on_floor():
			sprite.play("jump")
		# Run right
		elif direction > 0:
			sprite.flip_h = false
			sprite.play("run")
		# Run left
		elif direction < 0:
			sprite.flip_h = true
			sprite.play("run")
		else:
			sprite.play("idle")
	
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Slime" && !dead:
		die()


func die() -> void:
	print("Player killed by slime!")
	dead = true
	sprite.play("die") # Play death animation


func move() -> float:
	if !dead:
		return Input.get_axis("ui_left", "ui_right")
	else:
		return 0

extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0


var dead := false
var timer_started := false
var death_timer: float = 1.0


@onready var sprite: AnimatedSprite2D = $AnimatedKnight
@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !is_on_floor() && !dead:
		velocity += get_gravity() * delta
		
	# Death timer logic
	if timer_started == true:
		death_timer -= delta # Count down using delta time
		
	if death_timer <= 0:
		Globals.game_over = true # Set game over

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
	if body.scene_file_path == "res://scenes/slime.tscn"  && !dead:
		die()


func die() -> void:
	print("Player killed by slime!")
	dead = true
	collision_shape.queue_free()
	sprite.play("die") # Play death animation
	timer_started = true


func move() -> float:
	if !dead:
		return Input.get_axis("ui_left", "ui_right")
	else:
		return 0

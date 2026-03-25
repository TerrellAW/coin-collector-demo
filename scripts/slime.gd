extends CharacterBody2D


const SPEED = 80.0


var direction := 1


var dead := false
var timer_started := false
var death_timer: float = 1.0


@onready var sprite: AnimatedSprite2D = $AnimatedSlime
@onready var ray_cast_down: RayCast2D = $AnimatedSlime/RayCastDown


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if !is_on_floor():
		velocity += get_gravity() * delta
		
	# Death timer logic
	if timer_started == true:
		death_timer -= delta # Count down using delta time
		
	if death_timer <= 0:
		queue_free() # Delete enemy object

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = choose_direction(direction)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
# Animations
	if !dead:
		sprite.play("default")
	
	if direction > 0:
		sprite.scale.x = 1
	elif direction < 0:
		sprite.scale.x = -1

	move_and_slide()


# Enemy AI
func choose_direction(direction) -> int:
	if is_on_wall():
		print("Slime is on wall!")
		if direction > 0:
			return -1
		else:
			return 1 
	elif !ray_cast_down.is_colliding():
		print("Slime is on edge!")
		if direction > 0:
			return -1
		else:
			return 1
	else:
		return direction


func _on_player_detector_body_entered(body: Node2D) -> void:
	if body.scene_file_path == "res://scenes/player.tscn" && !dead:
		die()
	
func die() -> void:
	print("Slime killed by player!")
	direction = 0 # Stop moving
	sprite.play("die") # Play death animation
	dead = true
	timer_started = true
	

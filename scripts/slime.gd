extends CharacterBody2D


const SPEED = 80.0


var direction := 1


@onready var sprite: AnimatedSprite2D = $AnimatedSlime
@onready var ray_cast_down: RayCast2D = $AnimatedSlime/RayCastDown


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = choose_direction(direction)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
# Animations
	sprite.play("default")
	# TODO: If damaged play damage animation and then vanish, else default
	
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


	if !ray_cast_down.is_colliding():
		print("Slime is on edge!")
		if direction > 0:
			return -1
		else:
			return 1
	else:
		return direction

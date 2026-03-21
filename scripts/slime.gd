extends CharacterBody2D


const SPEED = 100.0


@onready var sprite: AnimatedSprite2D = $AnimatedSlime


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := choose_direction()
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
# Animations
	sprite.play("default")
	# TODO: If damaged play damage animation and then vanish, else default
	
	if direction > 0:
		sprite.flip_h = false
	elif direction < 0:
		sprite.flip_h = true

	move_and_slide()


# Enemy AI
func choose_direction() -> float:
	return 1
	

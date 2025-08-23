extends CharacterBody2D

const BASE_SPEED = 150.0  # base speed on flat surface
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get input (left/right)
	var direction := Input.get_axis("ui_left", "ui_right")
	var move_speed = BASE_SPEED

	# Adjust speed smoothly depending on slope
	if is_on_floor():
		var collision = get_last_slide_collision()
		if collision:
			var normal = collision.get_normal()
			# Slope angle in degrees (0 = flat, 90 = vertical)
			var slope_angle = rad_to_deg(acos(normal.dot(Vector2.UP)))

			# Smooth speed adjustment:
			# flat road: slower, steep slope: slowest, moderate slope: normal
			var slope_factor = clamp(1.0 - slope_angle / 90.0, 0.2, 0.8)
			move_speed *= slope_factor

	# Movement
	if direction:
		velocity.x = direction * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, BASE_SPEED)

	move_and_slide()

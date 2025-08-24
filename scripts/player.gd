extends CharacterBody2D
@onready var remote_transform_2d = $RemoteTransform2D


const BASE_SPEED = 200.0  # base speed on flat surface
const JUMP_VELOCITY = -400.0
var carrying := false
var speed_multiplier := 1.0

func _physics_process(delta: float) -> void:
	# Add gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and remote_transform_2d.remote_path:
		put_down_stone()

	# Get input (left/right)
	var direction := Input.get_axis("ui_left", "ui_right")
	var move_speed = BASE_SPEED * speed_multiplier

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

func put_down_stone():
	var stone = get_node(remote_transform_2d.remote_path)
	remote_transform_2d.remote_path = ""
	stone.position += Vector2(0.0, 20.0)
	speed_multiplier = 1.0

func _on_area_2d_area_entered(area):
	if !carrying:
		speed_multiplier = 0.45
		var stone = area.get_parent()
		remote_transform_2d.remote_path = stone.get_path()
		carrying = true


func _on_area_2d_area_exited(area):
	if carrying:
		carrying = !carrying

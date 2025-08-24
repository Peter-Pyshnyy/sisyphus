extends CharacterBody2D

@onready var remote_transform_2d = $RemoteTransform2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var cheat_timer = $"../CheatTimer"

const BASE_SPEED = 180.0  # base speed on flat surface
const JUMP_VELOCITY = -400.0
var carrying := false
var speed_multiplier := 1.0
var move_animation := "walk"
var idle_animation := "idle"
var can_move = false

func _physics_process(delta: float) -> void:
	if !can_move:
		return
		
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
			var slope_factor = clamp(1.0 - slope_angle / 90.0, 0.2, 0.8)
			move_speed *= slope_factor

	# Movement
	if direction:
		velocity.x = direction * move_speed

		if sprite.animation != move_animation:
			sprite.play(move_animation)

		sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, BASE_SPEED)

		if sprite.animation != idle_animation:
			sprite.play(idle_animation)

	move_and_slide()

func put_down_stone():
	move_animation = "walk"
	idle_animation = "idle"
	var stone = get_node(remote_transform_2d.remote_path)
	remote_transform_2d.remote_path = ""
	stone.position += Vector2(0.0, 40.0)
	speed_multiplier = 1.0
	cheat_timer.start(25.0)

func _on_area_2d_area_entered(area):
	if !carrying:
		move_animation = "carry"
		idle_animation = "carry_idle"
		speed_multiplier = 0.45
		var stone = area.get_parent()
		remote_transform_2d.remote_path = stone.get_path()
		carrying = true
		cheat_timer.stop()


func _on_area_2d_area_exited(area):
	if carrying:
		carrying = !carrying

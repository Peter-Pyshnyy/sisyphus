extends Node2D
@onready var stone_position = $stone_position
@onready var player = $Player
@onready var text_anim = $CanvasLayer/TextAnim
@onready var text_anim_timer = $CanvasLayer/TextAnimTimer
@onready var label = $CanvasLayer/Label
@onready var collision_shape_2d = $peak_area/CollisionShape2D
@onready var peak_timer = $peak_area/PeakTimer
@onready var cheat_timer = $CheatTimer

func _ready():
	Global.start_game.connect(start)

func start():
	player.can_move = true

func _on_peak_area_area_entered(area):
	if area.get_parent().name == "stone":
		collision_shape_2d.set_deferred("disabled",true)
		player.put_down_stone()
		cheat_timer.stop()
		area.get_parent().position = stone_position.position
		peak_timer.start()
	else:
		cheat_no_stone_peak()

func _on_left_area_area_entered(area):
	cheat_went_left()

func _on_peak_timer_timeout():
	collision_shape_2d.set_deferred("disabled",false)

func _on_cheat_timer_timeout():
	if text_anim_timer.is_stopped():
		cheat_waited()

func _on_text_anim_timer_timeout():
	text_anim.play_backwards("text_animation")

func print_text(text):
	label.text = text
	text_anim.play("text_animation")
	text_anim_timer.start()

func cheat_no_stone_peak():
	print_text("Ти так нічого і не зрозумів, Сізифе.")
	lightning_reset()

func cheat_went_left():
	print_text("Залиш спроби щось змінити і прийми свою долю!")
	lightning_reset()

func cheat_waited():
	print_text("Не намагайся нас обдурити, Сізифе!")

func lightning_reset():
	print("lightning")

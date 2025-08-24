extends Node2D
@onready var stone_position = $stone_position
@onready var player = $Player
@onready var text_anim = $CanvasLayer/TextAnim
@onready var text_anim_timer = $CanvasLayer/TextAnimTimer
@onready var label = $CanvasLayer/Label
@onready var collision_shape_2d = $peak_area/CollisionShape2D
@onready var peak_timer = $peak_area/PeakTimer
@onready var cheat_timer = $CheatTimer
@onready var start_timer = $StartTimer
@onready var player_position = $player_position
var finished = false
var last_height = 100000.0
var praises = ["Ти на правильному шляху.", "Схоже, ти зрозумів, Сізіфе.", "Альбер Камю, 1942: \n \"Сізіфа потрібно бачити щасливим, адже він зумів залишити ілюзії \n про ціль і сенс, прийнявши абсурд як власну свободу.\""]

func _ready():
	Global.start_game.connect(start)

func start():
	Global.started = true
	start_timer.start()

func _on_start_timer_timeout():
	$CanvasLayer/MainMenu.visible = false
	player.position = player_position.position
	$Player/Camera2D2.enabled = false
	$Player/Camera2D.enabled = true
	last_height = 10000.0
	player.can_move = true
	collision_shape_2d.set_deferred("disabled",false)
	cheat_timer.start()

func _on_peak_area_area_entered(area):
	if area.get_parent().name == "stone":
		collision_shape_2d.set_deferred("disabled",true)
		player.put_down_stone()
		cheat_timer.stop()
		area.get_parent().position = stone_position.position
		peak_timer.start()
		praise()
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
	if !finished:
		text_anim.play_backwards("text_animation")

func _on_height_timer_timeout():
	if player.carrying:
		if (player.position.y > (last_height + 15.0)):
			print(player.position.y)
			print(last_height + 15.0)
			cheat_stay_down()
		else:
			last_height = player.position.y

func print_text(text):
	label.text = text
	text_anim.play("text_animation")
	text_anim_timer.start()

func cheat_no_stone_peak():
	print_text("Ти так нічого і не зрозумів, Сізіфе.")
	lightning_reset()

func cheat_went_left():
	print_text("Залиш спроби щось змінити і прийми свою долю!")
	lightning_reset()

func cheat_waited():
	print_text("Не намагайся нас обдурити, Сізіфе!")
	lightning_reset()

func cheat_leave():
	print_text("Прийми себе, Сізіфе! Залиш ці ідеї.")
	lightning_reset()

func cheat_stay_down():
	print_text("Не потрібен сенс, щоб йти далі.")
	lightning_reset()

func lightning_reset():
	print("lightning")
	player.can_move = false
	player.start_idle_anim()
	reset()

func _on_button_2_pressed():
	$CanvasLayer/VBoxContainer.visible = false
	cheat_leave()

func reset():
	start()
	peak_timer.stop()

func praise():
	Global.correct_runs += 1
	
	if Global.correct_runs == 3:
		finished = true
		peak_timer.stop()
		cheat_timer.stop()
		start_timer.stop()
		$HeightTimer.stop()
		text_anim_timer.stop()
		player.can_move = false
		player.start_idle_anim()
		$CanvasLayer/ButtonExit.disabled = false
		$CanvasLayer/ExitAnim.play("exit_anim")
	print_text(praises[Global.correct_runs - 1])


func _on_button_exit_pressed():
	get_tree().quit()

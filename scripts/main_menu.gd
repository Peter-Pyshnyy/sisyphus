extends Control  

@onready var start_button = $VBoxContainer/Button
@onready var exit_button = $VBoxContainer/Button2
@onready var animation_player = $AnimationPlayer

func _ready():
	
	start_button.pressed.connect(_on_start_pressed)
	exit_button.pressed.connect(_on_exit_pressed)


func _on_start_pressed():
	start_button.disabled = true
	exit_button.disabled = true
	animation_player.play("fade_out")
	Global.start_game.emit()  
	get_tree().paused = false   


func _on_exit_pressed():
	get_tree().quit()

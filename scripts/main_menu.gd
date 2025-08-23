extends Control  

@onready var start_button = $VBoxContainer/Button
@onready var exit_button = $VBoxContainer/Button2

func _ready():
	
	start_button.pressed.connect(_on_start_pressed)
	exit_button.pressed.connect(_on_exit_pressed)


func _on_start_pressed():
	visible = false   
	get_tree().paused = false   


func _on_exit_pressed():
	get_tree().quit()

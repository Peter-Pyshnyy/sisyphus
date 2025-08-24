extends Node2D
@onready var stone_position = $stone_position
@onready var player = $Player


func _on_peak_area_area_entered(area):
	if area.get_parent().name == "stone":
		player.put_down_stone()
		area.get_parent().position = stone_position.position

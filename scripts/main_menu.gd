extends Control

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	pass

func _on_start_pressed() -> void:
	SceneTransition.change_scene("res://scenes/main.tscn")

func _on_settings_pressed() -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()

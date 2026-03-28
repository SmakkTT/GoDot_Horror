extends Area3D

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		
		if GameManager.keys_collected >= GameManager.total_keys:
			print("Player escaped! Loading Main Menu...")
			
			SceneTransition.change_scene("res://scripts/MainMenu.tscn")
			queue_free() 
		else:
			pass

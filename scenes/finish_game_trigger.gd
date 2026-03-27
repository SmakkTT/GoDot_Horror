extends Area3D

func _ready() -> void:
	# Automatically connect the signal via code to be perfectly safe!
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	# Check if the player is the one touching the escape box
	if body.is_in_group("player"):
		
		# Ask the global GameManager if the win condition is met
		if GameManager.keys_collected >= GameManager.total_keys:
			print("Player escaped! Loading Main Menu...")
			
			# Trigger your custom fade transition scene
			SceneTransition.change_scene("res://scripts/MainMenu.tscn")
			
			# Optional: Delete the trigger so it doesn't fire twice during the fade out
			queue_free() 
		else:
			pass

extends Area3D

@onready var audio_player = $AudioStreamPlayer3D

# Kører når spillet starter
func _ready() -> void:
	# Sørger for at koden lytter efter, når noget rører kassen
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

# Denne funktion køres, når noget rører trigger-boksen
func _on_body_entered(body: Node3D) -> void:
	# Tjekker om det faktisk er spilleren (og ikke f.eks. en dør), der rører kassen
	if body.is_in_group("player"):
		
		# Har spilleren fundet alle nøglerne til at kunne flygte?
		if GameManager.keys_collected >= GameManager.total_keys:
			print("Player escaped! Loading Main Menu...")
			
			# Slukker for kassen med det samme, så man ikke kan udløse den to gange
			set_deferred("monitoring", false)
			
			# Afspiller vinder-lyden og venter på, at den er helt færdig
			audio_player.play()
			await audio_player.finished
			
			# Skifter banen til hovedmenuen
			SceneTransition.change_scene("res://scripts/MainMenu.tscn")
			
			# Sletter trigger-boksen bagefter
			queue_free() 
		else:
			# Gør ingenting, hvis spilleren stadig mangler nøgler
			pass

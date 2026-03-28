extends Area3D

# Henter vores lydafspiller fra scenen
@onready var audio_player = $AudioStreamPlayer3D

# Denne funktion køres, når noget går ind i vores usynlige trigger-boks
func _on_body_entered(body: Node3D) -> void:
	# Tjekker om det faktisk er spilleren, der gik ind i boksen
	if body.is_in_group("player"):
		# Slukker for boksen med det samme, så den ikke kan rammes to gange
		set_deferred("monitoring", false)
		
		# Fortæller GameManager at dørene skal låses
		GameManager.trigger_door_lock()
		
		# Afspiller lyden for at døren smækker eller låser
		audio_player.play()
		
		# Venter på at lyden er helt færdig med at spille
		await audio_player.finished
		
		# Sletter trigger-boksen fra spillet
		queue_free()

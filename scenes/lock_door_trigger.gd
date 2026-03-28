extends Area3D

@onready var audio_player = $AudioStreamPlayer3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		set_deferred("monitoring", false)
		GameManager.trigger_door_lock()
		audio_player.play()
		await audio_player.finished
		queue_free()

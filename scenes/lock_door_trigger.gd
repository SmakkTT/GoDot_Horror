extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		# Tell the global manager to broadcast the lock event
		GameManager.trigger_door_lock()
		
		# Delete the trigger box so it never fires again
		queue_free()

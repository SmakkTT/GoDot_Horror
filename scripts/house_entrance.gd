extends Area3D

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		GameManager.update_objective("Find and Collect all keys (0/2)")
		queue_free()

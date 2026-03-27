extends Area3D
func _on_body_entered(body: Node3D):
	if body.is_in_group("Player"):
		# This one line turns off every light in that group instantly
		get_tree().call_group("RoomLights", "hide")
		
		# Or for a flickering effect before they die:
		flicker_and_die()

func flicker_and_die():
	var lights = get_tree().get_nodes_in_group("RoomLights")
	for i in 5:
		for l in lights:
			l.visible = !l.visible
		await get_tree().create_timer(0.1).timeout
	for l in lights:
		l.hide()

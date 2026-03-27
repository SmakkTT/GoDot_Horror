extends Node3D

@export var rotation_speed: float = 2.0
@export var interact_radius: float = 2.0

var player: Node3D = null
# NEW: Track if the player is close enough for the UI prompt
var was_in_range: bool = false 

func _ready() -> void:
	var players_in_scene = get_tree().get_nodes_in_group("player")
	if players_in_scene.size() > 0:
		player = players_in_scene[0]

func _process(delta: float) -> void:
	# Keep the item spinning
	rotate_y(rotation_speed * delta)
	
	# --- NEW: UI PROMPT DISTANCE CHECK ---
	if player != null:
		var distance = global_position.distance_to(player.global_position)
		var is_now_in_range = distance <= interact_radius
		
		# If the player JUST walked into range, show the prompt
		if is_now_in_range and not was_in_range:
			GameManager.show_interact("Press E to grab Key")
			was_in_range = true
			
		# If the player JUST walked out of range, hide the prompt
		elif not is_now_in_range and was_in_range:
			GameManager.hide_interact()
			was_in_range = false

func _input(event: InputEvent) -> void:
	# UPDATED: We don't need to do the math twice! 
	# We just check the boolean we made in the _process function.
	if event.is_action_pressed("interact") and was_in_range:
		collect_item()

func collect_item() -> void:
	print("Item collected!")
	GameManager.add_key()
	
	# --- CRITICAL FIX ---
	# Turn off the HUD text immediately before the object deletes itself!
	GameManager.hide_interact()
	
	queue_free()

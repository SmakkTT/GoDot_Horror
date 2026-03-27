extends Node3D

# You can tweak both the spin speed and the grab distance in the Inspector!
@export var rotation_speed: float = 2.0
@export var interact_radius: float = 2.0

var player: Node3D = null

func _ready() -> void:
	# Instantly find the player using the group you set up earlier
	var players_in_scene = get_tree().get_nodes_in_group("player")
	if players_in_scene.size() > 0:
		player = players_in_scene[0]

func _process(delta: float) -> void:
	# Keep the item spinning smoothly every single frame
	rotate_y(rotation_speed * delta)

func _input(event: InputEvent) -> void:
	# Listen for the 'E' key
	if event.is_action_pressed("interact") and player != null:
		
		# Calculate how far the player is from the item
		var distance = global_position.distance_to(player.global_position)
		
		# If the player is close enough, grab it!
		if distance <= interact_radius:
			collect_item()

func collect_item() -> void:
	print("Item collected!")
	
	# Communicate with our global manager
	GameManager.add_key()
	
	# queue_free() is Godot's built-in command to safely delete the object 
	queue_free()

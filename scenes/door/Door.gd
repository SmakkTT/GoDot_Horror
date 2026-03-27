extends AnimatableBody3D

# You can change this distance for each door in the Inspector!
@export var interact_radius: float = 3.0 
@onready var anim_player = $AnimationPlayer

var is_open: bool = false
var player: Node3D = null

func _ready() -> void:
	# Searches for your exact lowercase "player" group
	var players_in_scene = get_tree().get_nodes_in_group("player")
	if players_in_scene.size() > 0:
		player = players_in_scene[0]

func _input(event: InputEvent) -> void:
	# Listens for your specific "interact" Input Map action
	if event.is_action_pressed("interact") and player != null:
		
		# Calculates the distance
		var distance = global_position.distance_to(player.global_position)
		
		# Triggers if the player is close enough
		if distance <= interact_radius:
			toggle_door()

func toggle_door() -> void:
	if is_open:
		# Uses your exact "toggle_door" animation name
		anim_player.play_backwards("toggle_door")
	else:
		anim_player.play("toggle_door")
		
	is_open = !is_open

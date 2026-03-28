extends AnimatableBody3D

@export var interact_radius: float = 3.0 
@export var locks_from_trigger: bool = false
@export var sound_open_close: AudioStream
@export var sound_locked: AudioStream
@export var sound_slam: AudioStream

@onready var anim_player = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer3D

var is_open: bool = false
var player: Node3D = null
var was_in_range: bool = false 
var interact_key_name: String = "E"
var is_locked: bool = false

func _ready() -> void:
	var players_in_scene = get_tree().get_nodes_in_group("player")
	if players_in_scene.size() > 0:
		player = players_in_scene[0]

	var events = InputMap.action_get_events("interact")
	if events.size() > 0:
		interact_key_name = events[0].as_text().get_slice(" ", 0)
		
	GameManager.lock_doors_event.connect(_on_lock_triggered)

func _on_lock_triggered():
	if locks_from_trigger:
		is_locked = true
		if is_open:
			audio_player.stream = sound_slam
			audio_player.play()
			toggle_door()

func _process(_delta: float) -> void:
	if player != null:
		var distance = global_position.distance_to(player.global_position)
		var is_now_in_range = distance <= interact_radius
		
		if is_now_in_range and not was_in_range:
			was_in_range = true
			
			if is_locked and GameManager.keys_collected < GameManager.total_keys:
				GameManager.show_interact("Locked. Find all keys.")
			else:
				GameManager.show_interact("Press [" + interact_key_name + "] to open door")
				
		elif not is_now_in_range and was_in_range:
			GameManager.hide_interact()
			was_in_range = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and was_in_range:
		if is_locked:
			if GameManager.keys_collected >= GameManager.total_keys:
				is_locked = false
				audio_player.stream = sound_open_close
				audio_player.play()
				toggle_door()
				GameManager.show_interact("Press [" + interact_key_name + "] to close door")
			else:
				audio_player.stream = sound_locked
				audio_player.play()
				print("The door is locked! You need more keys.")
		else:
			audio_player.stream = sound_open_close
			audio_player.play()
			toggle_door()

func toggle_door() -> void:
	if is_open:
		anim_player.play_backwards("toggle_door")
	else:
		anim_player.play("toggle_door")
		
	is_open = !is_open

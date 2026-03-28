extends AnimatableBody3D

# Hvor tæt på man skal være for at åbne døren
@export var interact_radius: float = 3.0 
# Skal denne dør låses af en trigger-boks?
@export var locks_from_trigger: bool = false

@onready var anim_player = $AnimationPlayer
@onready var audio_player = $AudioStreamPlayer3D

var is_open: bool = false
var player: Node3D = null
var was_in_range: bool = false 
var interact_key_name: String = "E"
var is_locked: bool = false

func _ready() -> void:
	# Find spilleren når spillet starter
	var players_in_scene = get_tree().get_nodes_in_group("player")
	if players_in_scene.size() > 0:
		player = players_in_scene[0]

	# Find ud af hvilken knap der bruges til at interagere (f.eks. "E")
	var events = InputMap.action_get_events("interact")
	if events.size() > 0:
		interact_key_name = events[0].as_text().get_slice(" ", 0)
		
	# Lyt efter signalet der låser dørene
	GameManager.lock_doors_event.connect(_on_lock_triggered)

# Denne funktion køres når trigger-boksen låser døren
func _on_lock_triggered():
	if locks_from_trigger:
		is_locked = true
		# Hvis døren står åben, smækker vi den i!
		if is_open:
			audio_player.play()
			toggle_door()

# Kører hele tiden i baggrunden for at tjekke afstanden
func _process(_delta: float) -> void:
	if player != null:
		var distance = global_position.distance_to(player.global_position)
		var is_now_in_range = distance <= interact_radius
		
		# Viser teksten på skærmen, når spilleren kommer tæt nok på
		if is_now_in_range and not was_in_range:
			was_in_range = true
			
			if is_locked and GameManager.keys_collected < GameManager.total_keys:
				GameManager.show_interact("Locked. Find all keys.")
			else:
				GameManager.show_interact("Press [" + interact_key_name + "] to open door")
				
		# Skjuler teksten, når spilleren går væk igen
		elif not is_now_in_range and was_in_range:
			GameManager.hide_interact()
			was_in_range = false

# Lytter efter når spilleren trykker på en knap
func _input(event: InputEvent) -> void:
	# Hvis spilleren trykker på interager-knappen og er tæt på døren
	if event.is_action_pressed("interact") and was_in_range:
		if is_locked:
			# Tjekker om spilleren har fundet alle nøgler
			if GameManager.keys_collected >= GameManager.total_keys:
				is_locked = false
				audio_player.play()
				toggle_door()
				GameManager.show_interact("Press [" + interact_key_name + "] to close door")
			else:
				# Afspiller lyd men åbner ikke (mangler nøgler)
				audio_player.play()
				print("The door is locked! You need more keys.")
		else:
			# Normal dør der bare åbner/lukker
			audio_player.play()
			toggle_door()

# Afspiller animationen til at åbne eller lukke døren
func toggle_door() -> void:
	if is_open:
		anim_player.play_backwards("toggle_door")
	else:
		anim_player.play("toggle_door")
		
	is_open = !is_open

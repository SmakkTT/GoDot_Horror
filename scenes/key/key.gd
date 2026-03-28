extends Node3D

# Hvor hurtigt nøglen skal dreje rundt
@export var rotation_speed: float = 2.0
# Hvor tæt på man skal være for at samle den op
@export var interact_radius: float = 2.0

@onready var audio_player = $AudioStreamPlayer3D

var player: Node3D = null
var was_in_range: bool = false 

# Kører når spillet starter
func _ready() -> void:
	# Finder spilleren i banen og gemmer den
	var players_in_scene = get_tree().get_nodes_in_group("player")
	if players_in_scene.size() > 0:
		player = players_in_scene[0]

# Kører hele tiden i baggrunden
func _process(delta: float) -> void:
	# Får nøglen til at dreje glidende rundt
	rotate_y(rotation_speed * delta)
	
	if player != null:
		# Regner ud hvor langt der er fra nøglen til spilleren
		var distance = global_position.distance_to(player.global_position)
		var is_now_in_range = distance <= interact_radius
		
		# Viser teksten på skærmen, når man kommer tæt nok på
		if is_now_in_range and not was_in_range:
			GameManager.show_interact("Press E to grab Key")
			was_in_range = true
			
		# Skjuler teksten igen, når man går væk
		elif not is_now_in_range and was_in_range:
			GameManager.hide_interact()
			was_in_range = false

# Lytter efter når spilleren trykker på en knap
func _input(event: InputEvent) -> void:
	# Hvis spilleren trykker på interager-knappen (E) og er tæt nok på
	if event.is_action_pressed("interact") and was_in_range:
		collect_item()

# Denne funktion køres, når nøglen bliver samlet op
func collect_item() -> void:
	# Stopper nøglen fra at dreje og lytte efter flere tryk
	set_process_input(false)
	set_process(false)
	# Gør nøglen usynlig med det samme
	visible = false
	
	print("Item collected!")
	# Fortæller GameManager at vi har fået en ekstra nøgle
	GameManager.add_key()
	GameManager.hide_interact()
	
	# Afspiller lyden og venter på, at den er helt færdig
	audio_player.play()
	await audio_player.finished
	
	# Sletter nøglen helt fra spillet
	queue_free()

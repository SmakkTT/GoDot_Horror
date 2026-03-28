extends Area3D

# Henter vores lyde og trigger-bokse fra scenen
@onready var inside_audio = $InsideAudio
@onready var outside_audio = $OutsideAudio
@onready var inside_trigger = $InsideTriggerBox
@onready var outside_trigger = $OutsideTriggerBox

# Kører når spillet starter
func _ready() -> void:
	# Sørger for at vi lytter efter, præcis hvilken boks spilleren rører
	if not body_shape_entered.is_connected(_on_body_shape_entered):
		body_shape_entered.connect(_on_body_shape_entered)

# Denne funktion kører, når noget rører en af vores bokse
func _on_body_shape_entered(body_rid: RID, body: Node3D, body_shape_index: int, local_shape_index: int) -> void:
	# Tjekker om det faktisk er spilleren
	if body.is_in_group("player"):
		
		# Et smart trick til at finde ud af, præcis hvilken af boksene (inde eller ude) der blev ramt
		var shape_owner = shape_find_owner(local_shape_index)
		var shape_node = shape_owner_get_owner(shape_owner)
		
		# Hvis spilleren gik ind i "Indenfor" boksen
		if shape_node == inside_trigger:
			# Stopper lyden udefra og starter lyden indefra (hvis den ikke allerede spiller)
			if not inside_audio.playing:
				outside_audio.stop()
				inside_audio.play()
				
		# Hvis spilleren gik ud i "Udenfor" boksen
		elif shape_node == outside_trigger:
			# Stopper lyden indefra og starter lyden udefra (hvis den ikke allerede spiller)
			if not outside_audio.playing:
				inside_audio.stop()
				outside_audio.play()

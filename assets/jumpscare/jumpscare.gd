extends Area3D

@onready var audio_player = $AudioStreamPlayer3D
@onready var canvas_layer = $CanvasLayer
@onready var scare_image = $CanvasLayer/TextureRect

# Liste med billeder, du kan trække ind i Inspector
@export var scare_textures: Array[Texture2D] = []

@export var cooldown_time: float = 25.0 # Hvor mange sekunder der går, før fælden kan skræmme igen

var is_playing: bool = false 

# Kører når spillet starter
func _ready() -> void:
	# Skjuler skærmen med billedet fra start
	canvas_layer.visible = false
	scare_image.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	scare_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

# Når noget går ind i vores usynlige trigger-boks
func _on_body_entered(body: Node3D) -> void:
	# Tjekker om det er spilleren, og om fælden allerede er i gang
	if body.is_in_group("player") and not is_playing:
		is_playing = true 
		
		var target_scale_vec: Vector2 = Vector2(1.0, 1.0)
		
		# Hvis vi har tilføjet billeder i Inspector
		if scare_textures.size() > 0:
			# Vælger et helt tilfældigt billede fra vores liste
			var random_tex = scare_textures.pick_random()
			scare_image.texture = random_tex
			
			var img_original_size = random_tex.get_size()
			var viewport_size = get_viewport().get_visible_rect().size
			
			scare_image.size = img_original_size
			scare_image.pivot_offset = scare_image.size / 2.0
			
			var screen_center = viewport_size / 2.0
			scare_image.position = screen_center - scare_image.pivot_offset
			
			var scale_ratio_x = viewport_size.x / img_original_size.x
			var scale_ratio_y = viewport_size.y / img_original_size.y
			
			var final_scale_factor = min(scale_ratio_x, scale_ratio_y) * 0.9
			target_scale_vec = Vector2(final_scale_factor, final_scale_factor)
		
		# Gør billedet helt synligt og meget småt til at starte med
		scare_image.modulate.a = 1.0
		scare_image.scale = Vector2(0.1, 0.1) 
		
		# Viser billedet på skærmen og afspiller skriget!
		canvas_layer.visible = true
		audio_player.play()
		
		# Zoomer billedet lynhurtigt ind i hovedet på spilleren
		var tween = create_tween()
		tween.tween_property(scare_image, "scale", target_scale_vec, 0.2)
		
		# Venter 1.2 sekunder mens billedet er på skærmen
		await get_tree().create_timer(1.2).timeout
		
		# Laver en "glitch" effekt ved at blinke billedet 10 gange
		for i in range(10):
			scare_image.modulate.a = randf_range(0.0, 0.8)
			await get_tree().create_timer(0.05).timeout
		
		# Skjuler billedet igen
		canvas_layer.visible = false
		
		# Venter på vores "cooldown" før fælden bliver nulstillet
		await get_tree().create_timer(cooldown_time).timeout
		is_playing = false

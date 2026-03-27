extends Area3D

@onready var audio_player = $AudioStreamPlayer3D
@onready var canvas_layer = $CanvasLayer
@onready var scare_image = $CanvasLayer/TextureRect

@export var scare_textures: Array[Texture2D] = []

var is_playing: bool = false 

func _ready() -> void:
	canvas_layer.visible = false
	scare_image.expand_mode = TextureRect.EXPAND_KEEP_SIZE
	scare_image.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and not is_playing:
		is_playing = true 
		
		var target_scale_vec: Vector2 = Vector2(1.0, 1.0)
		
		if scare_textures.size() > 0:
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
		
		# --- RESET PRE-SCARE ---
		# Make absolutely sure the image is fully visible and small before starting
		scare_image.modulate.a = 1.0
		scare_image.scale = Vector2(0.1, 0.1) 
		
		canvas_layer.visible = true
		audio_player.play()
		
		var tween = create_tween()
		tween.tween_property(scare_image, "scale", target_scale_vec, 0.2)
		
		# Wait for 1.2 seconds for the main scare
		await get_tree().create_timer(1.2).timeout
		
		# --- THE GLITCHY FLICKER EFFECT ---
		# Loop 10 times rapidly
		for i in range(10):
			# Pick a totally random opacity between completely invisible (0.0) and mostly visible (0.8)
			scare_image.modulate.a = randf_range(0.0, 0.8)
			# Wait a tiny fraction of a second before changing it again
			await get_tree().create_timer(0.05).timeout
		
		# --- THE FINAL RESET ---
		canvas_layer.visible = false
		is_playing = false

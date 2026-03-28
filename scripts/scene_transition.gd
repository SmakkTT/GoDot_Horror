extends CanvasLayer

# Henter vores AnimationPlayer, som styrer fade-effekten
@onready var anim = $AnimationPlayer

# Denne funktion kaldes, når vi vil skifte fra én bane/scene til en anden
func change_scene(target: String) -> void:
	# Starter animationen, der fader skærmen (f.eks. til sort)
	anim.play("dissolve")
	
	# Sætter koden på pause og venter på, at skærmen er blevet helt sort
	await anim.animation_finished
	
	# Skifter selve banen i baggrunden, mens spilleren ikke kan se noget
	get_tree().change_scene_to_file(target)
	
	# Spiller animationen baglæns, så skærmen fader tilbage fra sort til det nye level
	anim.play_backwards("dissolve")

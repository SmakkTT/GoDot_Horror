extends CanvasLayer

# Henter vores tekstfelter fra scenen
@onready var label = $Label
@onready var interact_label = $Interact 

# Kører når spillet starter
func _ready():
	# Lytter efter når GameManager siger, at opgaven er ændret
	GameManager.objective_updated.connect(_update_label_text)
	
	# Lytter efter når GameManager siger, at interager-teksten skal vises
	GameManager.interact_updated.connect(_update_interact_prompt)
	
	# Sørger for at skærmen er tom for tekst til at starte med
	label.text = ""
	interact_label.visible = false

# Denne funktion ændrer opgave-teksten (f.eks. "Find alle nøgler")
func _update_label_text(new_text: String):
	label.text = new_text

# Denne funktion viser eller skjuler "Tryk på E..." teksten
func _update_interact_prompt(is_visible: bool, text: String):
	interact_label.visible = is_visible
	interact_label.text = text

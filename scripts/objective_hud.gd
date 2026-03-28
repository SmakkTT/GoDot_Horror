extends CanvasLayer

@onready var label = $Label
@onready var interact_label = $Interact 

func _ready():
	GameManager.objective_updated.connect(_update_label_text)
	
	GameManager.interact_updated.connect(_update_interact_prompt)
	
	label.text = ""
	interact_label.visible = false

func _update_label_text(new_text: String):
	label.text = new_text

func _update_interact_prompt(is_visible: bool, text: String):
	interact_label.visible = is_visible
	interact_label.text = text

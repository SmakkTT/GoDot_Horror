extends CanvasLayer

@onready var label = $Label

func _ready():
	# This connects the UI to the GameManager signal
	# When GameManager.objective_updated.emit() happens, this function runs!
	GameManager.objective_updated.connect(_update_label_text)
	
	# Start with a clear screen
	label.text = ""

func _update_label_text(new_text: String):
	label.text = new_text

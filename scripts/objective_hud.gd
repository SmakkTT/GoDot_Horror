extends CanvasLayer

@onready var label = $Label
# Grab your new Interact label
@onready var interact_label = $Interact 

func _ready():
	# Your existing objective connection
	GameManager.objective_updated.connect(_update_label_text)
	
	# Connect our new interact signal
	GameManager.interact_updated.connect(_update_interact_prompt)
	
	# Hide the interact prompt when the game starts
	label.text = ""
	interact_label.visible = false

func _update_label_text(new_text: String):
	label.text = new_text

# Function to handle turning the prompt on and off
func _update_interact_prompt(is_visible: bool, text: String):
	interact_label.visible = is_visible
	interact_label.text = text
